package com.amarsoft.app.accounting.trans.script.loan.eod;

import java.util.List;

import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.app.base.util.DateHelper;

/**
 * 贷款日终处理：将贷款处理日期切换至下一日
 * 
 * @author Amarsoft核算团队
 * 
 */
public final class LoanEOD_ToNextDate extends TransactionProcedure{

	public int run() throws Exception {
		BusinessObject loan = this.relativeObject;
		String businessDate = loan.getString("BusinessDate");// 贷款处理时间
		String nextBusinessDate = DateHelper.getRelativeDate(businessDate, DateHelper.TERM_UNIT_DAY, 1);// 下一处理日

		loan.setAttributeValue("LockFlag", "2");
		this.bomanager.updateBusinessObject(loan);
		loan.setAttributeValue("BusinessDate", nextBusinessDate);// 换到下一日
		
		//到了下次还款日,如果不存在还款计划，则生成
		List<BusinessObject> rptList = loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment,"Status='1' and NextDueDate=:BusinessDate","BusinessDate",nextBusinessDate);
		for (BusinessObject rptSegment : rptList) {
			List<BusinessObject> psList = loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule, "Status=:Status and PSType in(:PSType) and PayDate=:PayDate", "Status","1","PSType",rptSegment.getString("PSType").split(","),"PayDate",nextBusinessDate);
			if(psList == null || psList.isEmpty())
			{
				rptSegment.setAttributeValue("PSRestructureFlag", "1");
			}
		}
		
		return 1;
	}
}
