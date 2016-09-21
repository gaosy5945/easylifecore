package com.amarsoft.app.accounting.trans.script.loan.eod;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.config.impl.AccountCodeConfig;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.accounting.interest.accrue.InterestAccruer;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

/**
 * 贷款日终处理，贷款相关利息计算
 * @author Amarsoft 核算团队
 */
public final class LoanEOD_Interest extends TransactionProcedure{

	public int run() throws Exception {
		String psType=TransactionConfig.getScriptConfig(transactionCode, scriptID, "psType");
		String amountCode = TransactionConfig.getScriptConfig(transactionCode, scriptID, "AmountCode");
		if(StringX.isEmpty(amountCode)) return 1;
		String[] amountCodes=amountCode.split(",");
		String businessDate = relativeObject.getString("BusinessDate");
		for (String key : amountCodes) {
			String interestType = CashFlowConfig.getAmountCodeAttibute(key, "InterestType");
			String payAttributeID = CashFlowConfig.getAmountCodeAttibute(key, "PS.PayAttributeID");
			String currentAttributeID = CashFlowConfig.getAmountCodeAttibute(key, "CurrentAttributeID");
			if(StringX.isEmpty(interestType)) continue;
			List<InterestAccruer> interestAccruers = InterestAccruer.getInterestAccruer(relativeObject,interestType,null,psType,null);
			for(InterestAccruer interestAccruer:interestAccruers)
			{
				List<BusinessObject> interestObjects=interestAccruer.getInterestObjects();
				for(BusinessObject interestObject:interestObjects)
				{
					interestObject.setAttributeValue(payAttributeID, 0d);
					if(!StringX.isEmpty(currentAttributeID))
					{
						String normalBalanceAccountCodeNo=CashFlowConfig.getAmountCodeAttibute(key, "NormalBalanceAccountCode");
						BusinessObject subledger=relativeObject.getBusinessObjectByAttributes(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger, "AccountCodeNo",normalBalanceAccountCodeNo);
						double normalBalance = subledger == null ? 0d : AccountCodeConfig.getSubledgerBalance(subledger,AccountCodeConfig.Balance_DateFlag_CurrentDay);// 取贷款余额信息
						interestObject.setAttributeValue(currentAttributeID+"_"+psType, -normalBalance);
					}
				}
			}
			String[] rateTypes=CashFlowConfig.getRateTypes(interestType);
			for(String rateType:rateTypes){
				interestAccruers = InterestAccruer.getInterestAccruer(relativeObject,interestType,rateType,psType,bomanager);
				for(InterestAccruer interestAccruer:interestAccruers)
				{
					List<BusinessObject> interestObjects=interestAccruer.getInterestObjects();
					for(BusinessObject interestObject:interestObjects){
						BusinessObject interestLog = interestAccruer.settleInterest(interestObject, businessDate);
						if(interestLog == null){
							continue;
						}
						interestLog.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));
						double interestAmt = interestLog.getDouble("InterestAmt")+interestLog.getDouble("InterestSuspense");
						double interestTotal = interestLog.getDouble("InterestTotal")+interestLog.getDouble("InterestSuspense");
						interestObject.setAttributeValue(payAttributeID, Arith.round(interestObject.getDouble(payAttributeID)+interestTotal,CashFlowHelper.getMoneyPrecision(relativeObject)));
						if(!StringX.isEmpty(currentAttributeID))
							interestObject.setAttributeValue(currentAttributeID+"_"+psType, Arith.round(interestObject.getDouble(currentAttributeID+"_"+psType)+interestAmt,CashFlowHelper.getMoneyPrecision(relativeObject)));
						bomanager.updateBusinessObject(interestObject);
					}
				}
			}
		}
		return 1;
	}

}
