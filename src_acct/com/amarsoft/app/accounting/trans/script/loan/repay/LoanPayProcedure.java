package com.amarsoft.app.accounting.trans.script.loan.repay;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

/**
 * 还款金额拆分
 */
public final class LoanPayProcedure extends PayProcedure {
	
	@Override
	public int run() throws Exception {
		String psType=TransactionConfig.getScriptConfig(transactionCode, scriptID, "PSType");
		List<BusinessObject> pslist = this.relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule,
				"PayDate<=:BusinessDate and (FinishDate=null or FinishDate='') and PSType in(:PSType)", "PSType",psType.split(","),"BusinessDate",relativeObject.getString("BusinessDate"));
		
		String payRuleType = documentObject.getString("PayRuleType");//还款顺序
		double payAmount=documentObject.getDouble("ActualPayAmt");
		double suspenseAmount=0d;
		
		if (!StringX.isEmpty(payRuleType)) {// 为空时默认自定义还款顺序
			suspenseAmount = this.splitPayRule(payAmount, payRuleType, pslist);
			updateTransPayment();
		}
		else{
			suspenseAmount = this.splitManual(pslist); //指定金额还款，只能指定一个还款计划类型，如果存在多个还款计划可能会存在字段冲突
			updateTransPayment2();
		}
		if(suspenseAmount>0d) documentObject.setAttributeValue("SuspenseAmt", suspenseAmount);
		
		this.updatePaymentSchedules();
		relativeObject.appendBusinessObjects(BUSINESSOBJECT_CONSTANTS.payment_log,paymentLogs);
		relativeObject.setAttributeValue("LOCKFLAG", "2");
		bomanager.updateBusinessObjects(paymentLogs);
		return 1;
	}
	
	
	public void updateTransPayment() throws Exception {
		String psType=TransactionConfig.getScriptConfig(transactionCode, scriptID, "PSType");
		String[] amountCodes=CashFlowConfig.getPaymentScheduleAttribute(psType, "AmountCode").split(",");
		for(BusinessObject paymentLog:paymentLogs){
			for (String amountCode : amountCodes) {
				String tp_payAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"TP.PayAttributeID");
				String tp_actualPayAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"TP.ActualPayAttributeID");
				String pl_payAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"PL.PayAttributeID");
				String pl_actualPayAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"PL.ActualPayAttributeID");
				if(StringX.isEmpty(pl_actualPayAttributeID)) pl_actualPayAttributeID=tp_actualPayAttributeID;
				if(StringX.isEmpty(pl_payAttributeID)) pl_payAttributeID=tp_payAttributeID;
				
				double payAmount = paymentLog.getDouble(pl_payAttributeID);
				double amount = paymentLog.getDouble(pl_actualPayAttributeID);
				if (amount <= 0d) continue;
				
				documentObject.setAttributeValue(tp_payAttributeID, Arith.round(documentObject.getDouble(tp_payAttributeID) + payAmount,CashFlowHelper.getMoneyPrecision(relativeObject)));
				documentObject.setAttributeValue(tp_actualPayAttributeID, Arith.round(documentObject.getDouble(tp_actualPayAttributeID) + amount,CashFlowHelper.getMoneyPrecision(relativeObject)));
				
				BusinessObject paymentSchedule=this.relativeObject.getBusinessObjectByKey(paymentLog.getString("ObjectType"),paymentLog.getString("ObjectNo"));
				if(paymentSchedule != null && relativeObject.getString("BusinessDate").equals(paymentSchedule.getString("PayDate")))
				{
					documentObject.setAttributeValue(tp_actualPayAttributeID+"_Current", Arith.round(documentObject.getDouble(tp_actualPayAttributeID+"_Current") + amount,CashFlowHelper.getMoneyPrecision(relativeObject)));
				}
				else
				{
					documentObject.setAttributeValue(tp_actualPayAttributeID+"_Old", Arith.round(documentObject.getDouble(tp_actualPayAttributeID+"_Old") + amount,CashFlowHelper.getMoneyPrecision(relativeObject)));
				}
			}
		}
		
		documentObject.setAttributeValue("ActualPayDate", transaction.getString("TransDate"));
		bomanager.updateBusinessObject(documentObject);
	}
	
	public void updateTransPayment2() throws Exception {
		String psType=TransactionConfig.getScriptConfig(transactionCode, scriptID, "PSType");
		String[] amountCodes=CashFlowConfig.getPaymentScheduleAttribute(psType, "AmountCode").split(",");
		for(BusinessObject paymentLog:paymentLogs){
			for (String amountCode : amountCodes) {
				String tp_payAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"TP.PayAttributeID");
				String tp_actualPayAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"TP.ActualPayAttributeID");
				String pl_payAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"PL.PayAttributeID");
				String pl_actualPayAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"PL.ActualPayAttributeID");
				if(StringX.isEmpty(pl_actualPayAttributeID)) pl_actualPayAttributeID=tp_actualPayAttributeID;
				if(StringX.isEmpty(pl_payAttributeID)) pl_payAttributeID=tp_payAttributeID;
				
				double payAmount = paymentLog.getDouble(pl_payAttributeID);
				double amount = paymentLog.getDouble(pl_actualPayAttributeID);
				if (amount <= 0d) continue;
				
				
				BusinessObject paymentSchedule=this.relativeObject.getBusinessObjectByKey(paymentLog.getString("ObjectType"),paymentLog.getString("ObjectNo"));
				if(paymentSchedule != null && relativeObject.getString("BusinessDate").equals(paymentSchedule.getString("PayDate")))
				{
					documentObject.setAttributeValue(tp_actualPayAttributeID+"_Current", Arith.round(documentObject.getDouble(tp_actualPayAttributeID+"_Current") + amount,CashFlowHelper.getMoneyPrecision(relativeObject)));
				}
				else
				{
					documentObject.setAttributeValue(tp_actualPayAttributeID+"_Old", Arith.round(documentObject.getDouble(tp_actualPayAttributeID+"_Old") + amount,CashFlowHelper.getMoneyPrecision(relativeObject)));
				}
			}
		}
		
		documentObject.setAttributeValue("ActualPayDate", transaction.getString("TransDate"));
		bomanager.updateBusinessObject(documentObject);
	}
}