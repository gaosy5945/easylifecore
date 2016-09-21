package com.amarsoft.app.accounting.trans.script.loan.drawdownreverse;

import java.util.List;

import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.accounting.trans.script.common.executor.BookKeepExecutor;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.exception.ALSException;

/**
 * ִ�г�ſ���߼�
 * 
 */
public final class DrawdownReverseExecutor  extends BookKeepExecutor{
	
	public int run() throws Exception {
		BusinessObject loan = relativeObject;// ȡLoan����
		// ȡ����Ļ���ƻ�
		List<BusinessObject> paymentSchedules = loan.getBusinessObjects(BUSINESSOBJECT_CONSTANTS.payment_schedule);
		for (BusinessObject paymentSchedule : paymentSchedules) {
			String psType = paymentSchedule.getString("PSTYPE");
			String amountCodes=CashFlowConfig.getPaymentScheduleAttribute(psType, "AmountCode");
			String[] amountCodeArray=amountCodes.split(",");
			for(String amountCode:amountCodeArray){
				String actualPayAttributeID=CashFlowConfig.getAmountCodeAttibute(amountCode, "PS.ActualPayAttributeID");
				if(paymentSchedule.getDouble(actualPayAttributeID)>0){
					throw new ALSException("ED2002");
				}
			}
		}
		
		BusinessObject oldTransaction=this.documentObject;
		oldTransaction.setAttributeValue("TransStatus", "2");
		
		loan.setAttributeValue("LoanStatus", "6");
		loan.setAttributeValue("FinishDate", transaction.getString("TransDate"));
		this.bomanager.updateBusinessObject(loan);
		this.bomanager.updateBusinessObject(oldTransaction);
		this.bomanager.deleteBusinessObjects(paymentSchedules);// ɾ������ƻ�
		loan.removeBusinessObjects(BUSINESSOBJECT_CONSTANTS.payment_schedule, paymentSchedules);
		return 1;
	}
}
