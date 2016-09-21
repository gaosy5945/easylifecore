package com.amarsoft.app.accounting.trans.script.loan.repayreverse;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.accounting.trans.script.common.executor.BookKeepExecutor;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

/**
 * 执行冲放款交易逻辑
 * 
 */
public final class PaymentReverseExecutor  extends BookKeepExecutor{
	
	public int run() throws Exception {
		// 取贷款的还款明细
		List<BusinessObject> paymengLogs = relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_log,"TransSerialNo=:TransSerialNo and Status=:Status","TransSerialNo",documentObject.getKeyString(),"Status","1");
		for (BusinessObject paymentLog : paymengLogs) {
			BusinessObject paymentSchedule = relativeObject.getBusinessObjectByKey(paymentLog.getString("ObjectType"), paymentLog.getString("ObjectNo"));
			if(paymentSchedule == null) throw new ALSException("ED2014");
			
			String psType = paymentSchedule.getString("PSType");
			String[] amountCodes=CashFlowConfig.getPaymentScheduleAttribute(psType, "AmountCode").split(",");
			for (String amountCode : amountCodes) {
				String ps_actualPayAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"PS.ActualPayAttributeID");
				String pl_actualPayAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"PL.ActualPayAttributeID");
				if(StringX.isEmpty(pl_actualPayAttributeID)) pl_actualPayAttributeID=ps_actualPayAttributeID;
				double amount = paymentLog.getDouble(pl_actualPayAttributeID);
				if (amount <= 0d) continue;
				paymentSchedule.setAttributeValue(ps_actualPayAttributeID, Arith.round(paymentSchedule.getDouble(ps_actualPayAttributeID) - amount,CashFlowHelper.getMoneyPrecision(relativeObject)));
			}
			bomanager.updateBusinessObject(paymentSchedule);
			paymentLog.setAttributeValue("Status", "2");
			bomanager.updateBusinessObject(paymentLog);
		}
		
		//取计息信息
		List<BusinessObject> interestLogs = relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.interest_log, "TransSerialNo=:TransSerialNo", "TransSerialNo",documentObject.getKeyString());
		for(BusinessObject interestLog:interestLogs)
		{
			String serialNo = interestLog.getString("SerialNo");
			String nextSerialNo = interestLog.getString("NextSerialNo");
			if(!StringX.isEmpty(nextSerialNo) && !nextSerialNo.equals(serialNo))
			{
				throw new ALSException("ED2015");
			}
			else{
				BusinessObject lastInterestLog = relativeObject.getBusinessObjectBySql(BUSINESSOBJECT_CONSTANTS.interest_log, "NextSerialNo=:NextSerialNo", "NextSerialNo",serialNo);
				if(lastInterestLog != null){
					lastInterestLog.setAttributeValue("NextSerialNo", "");
					bomanager.updateBusinessObject(lastInterestLog);
				}
				bomanager.deleteBusinessObject(interestLog);
			}
		}
		
		
		documentObject.setAttributeValue("TransStatus", "2");
		this.bomanager.updateBusinessObject(documentObject);
		return 1;
	}
}
