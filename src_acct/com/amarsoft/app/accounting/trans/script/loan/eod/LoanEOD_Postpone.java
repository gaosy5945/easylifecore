package com.amarsoft.app.accounting.trans.script.loan.eod;

import java.util.List;

import com.amarsoft.app.base.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectHelper;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONDecoder;
import com.amarsoft.are.util.json.JSONObject;

/**
 * 贷款日终处理，处理节假日顺延和宽限期
 * 
 * @author Amarsoft 核算团队
 * 
 */
public final class LoanEOD_Postpone extends TransactionProcedure{

	public int run() throws Exception {
		BusinessObject loan = this.relativeObject;
		String businessDate = loan.getString("BusinessDate");// 贷款处理时间
		String psType=TransactionConfig.getScriptConfig(transactionCode, scriptID, "psType");
		List<BusinessObject> rptList = loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment,"Status=:Status and (SegFromDate=null or SegFromDate='' or SegFromDate<= :BusinessDate) and (SegToDate=null or SegToDate='' or SegToDate > :BusinessDate) and PSType like :PSType","Status","1","BusinessDate",businessDate,"PSType",psType);
		String postponeRuleString=(String)BusinessObjectHelper.getValue(rptList, "PostponeRule");
		Object gv = BusinessObjectHelper.getValue(rptList, "GraceDays");
		int graceDays = gv == null ? 0 : (Integer)gv;
		
		if(StringX.isEmpty(postponeRuleString)) return 1;
		JSONObject rules = JSONDecoder.decode(postponeRuleString);
		for(int jj=0;jj<rules.size();jj++){
			JSONObject rule=(JSONObject)rules.get(jj).getValue();
			String postponePaymentFlag=(String)rule.getValue("PostponeFlag");
			String holidayPaymentFlag=(String)rule.getValue("HolidayFlag");
			JSONObject holidayCalendars=(JSONObject)rule.getValue("HolidayCalendars");
			// 取未结清的正常还款计划，只取PayType=1的记录
			List<BusinessObject> paymentscheduleList = loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule, "PSType=:PSType and PayDate<=:BusinessDate and Status=:Status and (FinishDate=null or FinishDate = '')", "PSType",psType,"Status","1","BusinessDate",businessDate);
			for (BusinessObject a : paymentscheduleList) {// 计算宽限期和节假日顺延后的有效日期
				String payDate = a.getString("PayDate");
				String inteDate = a.getString("InteDate");
				if (!StringX.isEmpty(inteDate))continue;

				if (payDate.compareTo(businessDate) <= 0) {// 标示不是逾期的才计算
					String holidayInteDate = payDate;// 1.处理节假日
					if (!StringX.isEmpty(holidayPaymentFlag)) {
						holidayInteDate = this.getHolidayPostponeDate(payDate, holidayCalendars);
					}

					String graceInteDate = payDate;// 2.宽限期处理
					if (graceDays > 0) {
						graceInteDate = DateHelper.getRelativeDate(payDate, DateHelper.TERM_UNIT_DAY, graceDays);
					}

					// 3.处理总的顺延日期，根据规则处理
					if (postponePaymentFlag == null || postponePaymentFlag.length() == 0
							|| postponePaymentFlag.equals(ACCOUNT_CONSTANTS.POSTPONE_PAYMENT_FLAG_Max)) {
						inteDate = holidayInteDate.compareTo(graceInteDate) < 0 ? graceInteDate : holidayInteDate;
					} else if (postponePaymentFlag.equals(ACCOUNT_CONSTANTS.POSTPONE_PAYMENT_FLAG_Min)) {
						inteDate = holidayInteDate.compareTo(graceInteDate) > 0 ? graceInteDate : holidayInteDate;
					} else if (postponePaymentFlag.equals(ACCOUNT_CONSTANTS.POSTPONE_PAYMENT_FLAG_GRACE_HOLIDAY)) {
						// 如果宽限期后的首个日期是节假日，则自动继续顺延
						if (!StringX.isEmpty(holidayPaymentFlag)) {
							inteDate = this.getHolidayPostponeDate(graceInteDate, holidayCalendars);
						}
					} else if (postponePaymentFlag.equals(ACCOUNT_CONSTANTS.POSTPONE_PAYMENT_FLAG_HOLIDAY_GRACE)) {
						// 节假日后继续固定宽限期
						inteDate = DateHelper.getRelativeDate(holidayInteDate, DateHelper.TERM_UNIT_DAY,graceDays);
					} else if (postponePaymentFlag.equals(ACCOUNT_CONSTANTS.POSTPONE_PAYMENT_FLAG_ANY)) {
						String newHolidayInteDate = DateHelper.getRelativeDate(holidayInteDate,
								DateHelper.TERM_UNIT_DAY, graceDays);
						String newGraceInteDate = graceInteDate;
						if (!StringX.isEmpty(holidayPaymentFlag)) {
							newGraceInteDate = this.getHolidayPostponeDate(graceInteDate, holidayCalendars);
						}
						inteDate = newHolidayInteDate.compareTo(newGraceInteDate) < 0 ? newGraceInteDate : newHolidayInteDate;
					} else {
						throw new ALSException("ED2001");
					}

					a.setAttributeValue("InteDate", inteDate);
					a.setAttributeValue("HolidayInteDate", holidayInteDate);
					a.setAttributeValue("GraceInteDate", graceInteDate);
					this.bomanager.updateBusinessObject(a);
				}
			}
		}
		return 1;
	}
	
	private String getHolidayPostponeDate(String date,JSONObject holidayCalendars){
		return date;
	}
}
