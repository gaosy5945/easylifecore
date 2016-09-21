package com.amarsoft.app.accounting.trans.script.loan.eod;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.config.impl.AccountCodeConfig;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

/**
 * 贷款日终处理，根据已到期还款计划计算逾期本金、利息、罚息、复利、宽限期利息以及逾期费用。
 * 
 * @author Amarsoft核算团队
 */
public final class LoanEOD_Vars extends TransactionProcedure{

	public int run() throws Exception {
		BusinessObject loan = transaction.getBusinessObject(BUSINESSOBJECT_CONSTANTS.loan);
		String psType=TransactionConfig.getScriptConfig(transactionCode, scriptID, "PSType");

		String businessDate = loan.getString("BusinessDate");
		List<BusinessObject> paymentSchedules = loan.getBusinessObjectsByAttributes(BUSINESSOBJECT_CONSTANTS.payment_schedule,"PSType",psType);
		String[] amountCodes=CashFlowConfig.getPaymentScheduleAttribute(psType, "AmountCode").split(",");
		for(String amountCode:amountCodes){
			String payAttributeID= CashFlowConfig.getAmountCodeAttibute(amountCode, "PS.PayAttributeID");
			String actualPayAttributeID= CashFlowConfig.getAmountCodeAttibute(amountCode, "PS.ActualPayAttributeID");
			double overdueAmt=0d,passdueAmt=0d,currentAmt=0d,graceAmt=0d,holidayAmt=0d;
			
			
			double firstPassdueAmt=0d;
			boolean firtPassdueFlag=false;
			for(BusinessObject ps:paymentSchedules){
				String payDate=ps.getString("PayDate");
				String inteDate=ps.getString("InteDate");
				if(StringX.isEmpty(inteDate)) inteDate = payDate;
				String graceInteDate=ps.getString("GraceInteDate");
				if(StringX.isEmpty(graceInteDate)) graceInteDate = payDate;
				String holidayInteDate=ps.getString("HolidayInteDate");
				if(StringX.isEmpty(holidayInteDate)) holidayInteDate = payDate;
				double amt=ps.getDouble(payAttributeID)-ps.getDouble(actualPayAttributeID);
				if(payDate.compareTo(businessDate) < 0){
					passdueAmt+=amt;
					
					if(inteDate.compareTo(businessDate) < 0){
						overdueAmt+=amt;
					}
					if(graceInteDate.compareTo(businessDate) < 0){
						graceAmt+=amt;
					}
					if(holidayInteDate.compareTo(businessDate) < 0){
						holidayAmt+=amt;
					}
				}
				else if(payDate.equals(businessDate)){
					currentAmt+=amt;
				}
				
				if(payDate.compareTo(businessDate)<=0){
					if(StringX.isEmpty(ps.getString("FinishDate"))&&!firtPassdueFlag){
						firtPassdueFlag=true;
						firstPassdueAmt+=amt;
					}
				}
			}
			String attributeID = CashFlowConfig.getAmountCodeAttibute(amountCode, "PS.PassdueAmt");
			if (!StringX.isEmpty(attributeID))
				loan.setAttributeValue(attributeID+"_"+psType, Arith.round(passdueAmt,CashFlowHelper.getMoneyPrecision(relativeObject)));
			attributeID = CashFlowConfig.getAmountCodeAttibute(amountCode, "PS.OverdueAmt");
			if (!StringX.isEmpty(attributeID))
				loan.setAttributeValue(attributeID+"_"+psType, Arith.round(overdueAmt,CashFlowHelper.getMoneyPrecision(relativeObject)));
			attributeID = CashFlowConfig.getAmountCodeAttibute(amountCode, "PS.GraceAmt");
			if (!StringX.isEmpty(attributeID))
				loan.setAttributeValue(attributeID+"_"+psType, Arith.round(graceAmt,CashFlowHelper.getMoneyPrecision(relativeObject)));
			attributeID = CashFlowConfig.getAmountCodeAttibute(amountCode, "PS.HolidayAmt");
			if (!StringX.isEmpty(attributeID))
				loan.setAttributeValue(attributeID+"_"+psType, Arith.round(holidayAmt,CashFlowHelper.getMoneyPrecision(relativeObject)));
			attributeID = CashFlowConfig.getAmountCodeAttibute(amountCode, "PS.CurrentAmt");
			if (!StringX.isEmpty(attributeID))
				loan.setAttributeValue(attributeID+"_"+psType, Arith.round(currentAmt,CashFlowHelper.getMoneyPrecision(relativeObject)));
			attributeID = CashFlowConfig.getAmountCodeAttibute(amountCode, "PS.FirstPassdueAmt");
			if (!StringX.isEmpty(attributeID))
				loan.setAttributeValue(attributeID+"_"+psType,  Arith.round(firstPassdueAmt,CashFlowHelper.getMoneyPrecision(relativeObject)));
			attributeID = CashFlowConfig.getAmountCodeAttibute(amountCode, "PS.DifferencePassdueAmt");
			if (!StringX.isEmpty(attributeID))
			{
				String overdueBalanceAccountCodeNo=CashFlowConfig.getAmountCodeAttibute(amountCode, "OverdueBalanceAccountCode");
				BusinessObject subledger=loan.getBusinessObjectByAttributes(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger, "AccountCodeNo",overdueBalanceAccountCodeNo);
				double overdueBalance = subledger == null ? 0d : AccountCodeConfig.getSubledgerBalance(subledger,AccountCodeConfig.Balance_DateFlag_CurrentDay);// 取贷款余额信息
				loan.setAttributeValue(attributeID+"_"+psType, Arith.round(passdueAmt-overdueBalance,CashFlowHelper.getMoneyPrecision(relativeObject)));
			}
		}

		return 1;
	}

}