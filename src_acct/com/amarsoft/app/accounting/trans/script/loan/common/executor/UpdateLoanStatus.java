package com.amarsoft.app.accounting.trans.script.loan.common.executor;

import java.util.List;

import com.amarsoft.app.accounting.config.impl.AccountCodeConfig;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;

/**
 * 根据余额、还款计划等信息更新贷款状态和终结日期
 */
public final class UpdateLoanStatus extends TransactionProcedure {
	@Override
	public int run() throws Exception {
		BusinessObject loan = this.relativeObject;
		String businessDate = loan.getString("BusinessDate");
		double overdueBalance =0.0d;
		double overdueDays = 0;
		List<BusinessObject> paymentschedules = loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule, "PayDate<=:BusinessDate","BusinessDate",businessDate);
		for (BusinessObject paymentschedule : paymentschedules) {//更新还款计划状态
			String psType=paymentschedule.getString("PSType");
			String payDate = paymentschedule.getString("PayDate");
			String amountCodes=CashFlowConfig.getPaymentScheduleAttribute(psType, "PrincipalAmountCode");
			amountCodes+=","+CashFlowConfig.getPaymentScheduleAttribute(psType, "InterestAmountCode");
			String[] amountCodeArray=amountCodes.split(",");
			
			double balance=0d;
			for(String amountCode:amountCodeArray){
				if(StringX.isEmpty(amountCode)){
					continue;
				}
				String payAmtAttributeID=CashFlowConfig.getAmountCodeAttibute(amountCode, "PS.PayAttributeID");
				String actualPayAmtAttributeID=CashFlowConfig.getAmountCodeAttibute(amountCode, "PS.ActualPayAttributeID");
				String waiveAmtAttributeID=CashFlowConfig.getAmountCodeAttibute(amountCode, "PS.WaiveAttributeID");
				balance+=paymentschedule.getDouble(payAmtAttributeID)- paymentschedule.getDouble(actualPayAmtAttributeID)
						- paymentschedule.getDouble(waiveAmtAttributeID);
			}

			if (balance <= 0d) {
				if (StringX.isEmpty(paymentschedule.getString("FinishDate"))){
					paymentschedule.setAttributeValue("FinishDate", businessDate);
					bomanager.updateBusinessObject(paymentschedule);
				}
			} else {
				if (!StringX.isEmpty(paymentschedule.getString("FinishDate"))){
					paymentschedule.setAttributeValue("FinishDate", "");
					bomanager.updateBusinessObject(paymentschedule);
				}
			}
			if(payDate.compareTo(businessDate)<0){
				overdueBalance+=balance;
			}
			if(payDate.compareTo(businessDate)<0 && balance > 0.0d){
				overdueDays = Math.max(overdueDays,DateHelper.getDays(payDate, businessDate));
			}
		}
		
		List<BusinessObject> subledgers = loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger, "Status=:Status and BookType=:BookType", "Status","1","BookType","C");
		boolean flag = true;//贷款是否已结清
		for(BusinessObject subledger:subledgers)
		{
			double balance = AccountCodeConfig.getSubledgerBalance(subledger, AccountCodeConfig.Balance_DateFlag_CurrentDay);
			if(balance > 0.00000001) flag = flag && false;
		}
		if(flag){
			loan.setAttributeValue("FinishDate", businessDate);
			if(businessDate.compareTo(loan.getString("MaturityDate")) < 0)
				loan.setAttributeValue("LoanStatus", "3");
			else if(businessDate.compareTo(loan.getString("MaturityDate")) == 0)
				loan.setAttributeValue("LoanStatus", "2");
			else
				loan.setAttributeValue("LoanStatus", "4");
			
		}
		else{
			if(overdueBalance > 0.0d)
			{
				loan.setAttributeValue("LoanStatus", "1");
			}
			else{
				loan.setAttributeValue("LoanStatus", "0");
			}
		}
		loan.setAttributeValue("OverdueDays", overdueDays);
		bomanager.updateBusinessObject(loan);
		return 1;
	}

}
