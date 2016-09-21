package com.amarsoft.app.accounting.trans.script.loan.common.executor;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.ps.PaymentScheduleCreator;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;

/**
 * ���ɻ���ƻ�
 */
public final class CreateFeePaymentScheduleExecutor extends TransactionProcedure {
	@Override
	public int run() throws Exception {
		String psType=TransactionConfig.getScriptConfig(transactionCode, scriptID, "PSType");

		List<BusinessObject> rptList = relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment, "Status='1' and PSType like :PSType ","PSType",psType);
		if(rptList.isEmpty()) return 1;
		String rptTermID=rptList.get(0).getString("TermID");
		String rptSegTermID=rptList.get(0).getString("SegTermID");
		
		List<BusinessObject> oldPSList = relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule, "PayDate>:BusinessDate and (FinishDate=null or FinishDate='') and PSType=:PSType", 
				"BusinessDate",relativeObject.getString("BusinessDate"),"PSType",psType);
		relativeObject.removeBusinessObjects(BUSINESSOBJECT_CONSTANTS.payment_schedule, oldPSList);
		this.bomanager.deleteBusinessObjects(oldPSList);
		
		String loanPeriod = relativeObject.getString("LoanPeriod");
		String futurePeriodParam = CashFlowConfig.getPaymentScheduleAttribute(psType, "FuturePeriod");
		
		int futurePeriod = 0;
		if(!StringX.isEmpty(loanPeriod)) futurePeriod = Integer.parseInt(loanPeriod); 
		else if(!StringX.isEmpty(futurePeriodParam)) futurePeriod = Integer.parseInt(futurePeriodParam); 
		
		//�����µĻ���ƻ�
		List<BusinessObject> paymentScheduleListNew = PaymentScheduleCreator.getPaymentScheduleCreator(psType, rptTermID,rptSegTermID, bomanager).createPaymentScheduleList(relativeObject, futurePeriod);
		relativeObject.appendBusinessObjects(BUSINESSOBJECT_CONSTANTS.payment_schedule,paymentScheduleListNew);
		bomanager.updateBusinessObjects(paymentScheduleListNew);
		return 1;
	}

}
