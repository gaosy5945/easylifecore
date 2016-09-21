package com.amarsoft.app.accounting.cashflow.ps.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.cashflow.pmt.PMTScript;
import com.amarsoft.app.accounting.cashflow.ps.PaymentScheduleCreator;
import com.amarsoft.app.accounting.config.impl.AccountCodeConfig;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.accounting.util.XIRR;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.base.util.RateHelper;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectHelper;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

/**
 * ָ����������ɻ���ƻ���
 * 
 */
public class XIRRPaymentScheduleCreator extends PaymentScheduleCreator {
	public List<BusinessObject> createPaymentScheduleList(BusinessObject loan_T,int futurePeriod) throws Exception {
		ArrayList<BusinessObject> paymentScheduleList = new ArrayList<BusinessObject>();// �»���ƻ�
		
		BusinessObject loan = loan_T.clone();// ���ȿ�¡
		String businessDate = loan.getString("BusinessDate");
		List<BusinessObject> oldPSList = loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule, "PayDate>:BusinessDate and FinishDate=null and PSType=:PSType and FixPayPrincipalAmt=0 and FixPayInstalmentAmt=0", 
				"BusinessDate",businessDate,"PSType",psType);
		loan.removeBusinessObjects(BUSINESSOBJECT_CONSTANTS.payment_schedule, oldPSList);
		//��ȡ������µ��յĻ���ƻ������Ը��µ�ǰ�������
		List<BusinessObject> currentPSList = loan.getBusinessObjectsByAttributes(BUSINESSOBJECT_CONSTANTS.payment_schedule, "PayDate",businessDate,"PSType",psType);
		double currentPrincipalAmt = 0d;
		
		String payPrincipalAttributeID="",principalBalanceAttributeID="";
		String principalAmountCode=CashFlowConfig.getPaymentScheduleAttribute(psType, "PrincipalAmountCode");
		if(!StringX.isEmpty(principalAmountCode)){
			payPrincipalAttributeID=CashFlowConfig.getAmountCodeAttibute(principalAmountCode, "PS.PayAttributeID");
			principalBalanceAttributeID=CashFlowConfig.getAmountCodeAttibute(principalAmountCode, "PS.BalanceAttributeID");
			String actualPayAttributeID=CashFlowConfig.getAmountCodeAttibute(principalAmountCode, "PS.ActualPayAttributeID");;
			for (BusinessObject a : currentPSList) {
				currentPrincipalAmt += a.getDouble(payPrincipalAttributeID) - a.getDouble(actualPayAttributeID);
			}
		}
		
		String normalBalanceAccountCodeNo=CashFlowConfig.getAmountCodeAttibute(CashFlowConfig.getPaymentScheduleAttribute(psType, "PrincipalAmountCode"),"NormalBalanceAccountCode");
		BusinessObject subledger=loan.getBusinessObjectByAttributes(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger, "AccountCodeNo",normalBalanceAccountCodeNo);
		double loanBalance = AccountCodeConfig.getSubledgerBalance(subledger,AccountCodeConfig.Balance_DateFlag_CurrentDay);// ȡ���������Ϣ
		AccountCodeConfig.setSubledgerBalance(subledger, loanBalance-currentPrincipalAmt);// ���¸�ֵ�������
		String nextDueDate="";
		
		int x = 0;
		List<String> dates = new ArrayList<String>();
		dates.add(loan.getString("PUTOUTDATE"));
		List<Double> amts = new ArrayList<Double>();
		amts.add(-loan.getDouble("BusinessSum"));
		while (x < 1000) {// ��ֹ��ѭ��
			x++;
			List<BusinessObject> rptList=loan.getBusinessObjects(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment);
			String nextDueDateTmp = (String)BusinessObjectHelper.getMinValue(rptList, "NextDueDate");
			if(nextDueDate.equals(nextDueDateTmp)) break;//�������ڲ��ڱ仯ʱ������Ϊ�Ѿ��ƻ�����
			nextDueDate = nextDueDateTmp;
			
			TreeSet<String> interestAmountCodes=new TreeSet<String>();
			String[] amountCodes=CashFlowConfig.getPaymentScheduleAttribute(psType, "AmountCode").split(",");
			for(String amountCode:amountCodes){
				interestAmountCodes.add(amountCode);
			}
			double instalmentAmt = 0d;//�����ڹ�
			List<BusinessObject> currentRPTList = BusinessObjectHelper.getBusinessObjectsByAttributes(rptList, "NextDueDate",nextDueDate);
			int currentPeriod = 1;//��ǰ�ڴ�
			String autoPayFlag = "";
			for (BusinessObject rptSegment : currentRPTList) {
				currentPeriod = Math.max(currentPeriod, rptSegment.getInt("CurrentPeriod"));
				PMTScript p = PMTScript.getPMTScript(loan, rptSegment, psType,bomanager);
				instalmentAmt+=p.getInstalmentAmount();
				autoPayFlag = rptSegment.getString("AutoPayFlag");
			}
			loan.setAttributeValue("BusinessDate", nextDueDate);

			// �½�����ƻ�
			BusinessObject paymentSchedule = BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.payment_schedule);
			paymentSchedule.generateKey();
			paymentSchedule.setAttributeValue("ObjectType", loan.getBizClassName());
			paymentSchedule.setAttributeValue("ObjectNo", loan.getString("SerialNo"));
			paymentSchedule.setAttributeValue("RelativeObjectType", loan.getBizClassName());
			paymentSchedule.setAttributeValue("RelativeObjectNo", loan.getString("SerialNo"));
			paymentSchedule.setAttributeValue("PeriodNo", currentPeriod);
			paymentSchedule.setAttributeValue("Currency", loan.getString("Currency"));
			paymentSchedule.setAttributeValue("PSType", psType);
			paymentSchedule.setAttributeValue("PayDate", nextDueDate);
			paymentSchedule.setAttributeValue("PayAmt",instalmentAmt);
			
			dates.add(nextDueDate);
			amts.add(instalmentAmt);
			
			
			for (BusinessObject rptSegment : currentRPTList) {
				PMTScript p = PMTScript.getPMTScript(loan, rptSegment, psType,bomanager);
				p.nextInstalment();// ������һ�������ڴΣ��������´λ����ռ���������
			}
			
			paymentSchedule.setAttributeValue("AutoPayFlag", (StringX.isEmpty(autoPayFlag) ? CashFlowConfig.getPaymentScheduleAttribute(psType, "AutoPayFlag") : autoPayFlag));
			paymentSchedule.setAttributeValue("PayItemCode", CashFlowConfig.getPaymentScheduleAttribute(psType, "PayItemCode"));
			paymentSchedule.setAttributeValue("Direction", CashFlowConfig.getPaymentScheduleAttribute(psType, "Direction"));
			paymentSchedule.setAttributeValue("Status", "1");
			
			paymentScheduleList.add(paymentSchedule);
			
			loan.setAttributeValue("CurrentPeriodNo", currentPeriod);
		}
		loan.appendBusinessObjects(BUSINESSOBJECT_CONSTANTS.payment_schedule, paymentScheduleList);
		
		double rate = XIRR.evaluate(amts,dates);
		
		BusinessObject IRRRateSegment=BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.loan_rate_segment);
		IRRRateSegment.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTANTS.loan);
		IRRRateSegment.setAttributeValue("ObjectNo", loan.getKeyString());
		IRRRateSegment.setAttributeValue("RateType", "01");
		IRRRateSegment.setAttributeValue("RateUnit", RateHelper.RateUnit_Year);
		IRRRateSegment.setAttributeValue("Status", "1");
		IRRRateSegment.setAttributeValue("BusinessRate",  rate * 100);
		IRRRateSegment.setAttributeValue("SegFromDate", loan.getString("PUTOUTDATE"));
		bomanager.updateBusinessObject(IRRRateSegment);
		loan_T.appendBusinessObject(IRRRateSegment.getBizClassName(), IRRRateSegment);
		
		double payTotalAmt = 0d;
		String lastDueDate = loan.getString("PUTOUTDATE");
		
		
		
		for(BusinessObject paymentSchedule :paymentScheduleList)
		{
			int days = DateHelper.getDays(lastDueDate, paymentSchedule.getString("PAYDATE"));
			double interestamt = 0d;
			if(paymentSchedule.getInt("PeriodNo") == 1)
				interestamt = Arith.round(rate/360.0*loanBalance*days,CashFlowHelper.getMoneyPrecision(loan));
			else
				interestamt = Arith.round(rate/12*loanBalance,CashFlowHelper.getMoneyPrecision(loan));
			if(interestamt > paymentSchedule.getDouble("PayAmt")) interestamt = paymentSchedule.getDouble("PayAmt");
			
			double principalamt = Arith.round(paymentSchedule.getDouble("PayAmt")-interestamt,CashFlowHelper.getMoneyPrecision(loan));
			
			
			if(principalamt > loanBalance){
				principalamt = loanBalance;
				interestamt = Arith.round(paymentSchedule.getDouble("PayAmt")-principalamt,CashFlowHelper.getMoneyPrecision(loan));
			}
			
			lastDueDate = paymentSchedule.getString("PAYDATE");
			loanBalance = Arith.round(loanBalance-principalamt,CashFlowHelper.getMoneyPrecision(loan));
			
			paymentSchedule.setAttributeValue("PAYPRINCIPALAMT", principalamt);
			paymentSchedule.setAttributeValue("PAYINTERESTAMT", interestamt);
			paymentSchedule.setAttributeValue(principalBalanceAttributeID, loanBalance);
			
			payTotalAmt += paymentSchedule.getDouble("PayAmt");
		}
		
		loan_T.setAttributeValue("TotalAmt", Arith.round(payTotalAmt, CashFlowHelper.getMoneyPrecision(loan_T)));//����+��Ϣ�ܶ�
		loan_T.setAttributeValue("InterestAmt", Arith.round(payTotalAmt-loan_T.getDouble("BusinessSum"), CashFlowHelper.getMoneyPrecision(loan_T)));//��Ϣ�ܶ�
		loan_T.setAttributeValue("InterestAmt_Cost", Arith.round(loan_T.getDouble("InterestAmt")/(1+loan_T.getDouble("TaxRate")/100.0), CashFlowHelper.getMoneyPrecision(loan_T)));//��Ϣ�ܶ�
		loan_T.setAttributeValue("InterestAmt_Tax", Arith.round(loan_T.getDouble("InterestAmt")-loan_T.getDouble("InterestAmt_Cost"), CashFlowHelper.getMoneyPrecision(loan_T)));//��Ϣ�ܶ�
		
		double businessSum_Tax = Arith.round(loan_T.getDouble("BusinessSum")*loan_T.getDouble("TaxRate")/(1+loan_T.getDouble("TaxRate")/100.0)/100.0, CashFlowHelper.getMoneyPrecision(loan_T));
		//�˴���Ҫͨ��Ʊ���ܽ������ж��ܶ�
		if(loan_T.getDouble("Tax") < businessSum_Tax)
		{
			businessSum_Tax = Arith.round(loan_T.getDouble("Tax"),CashFlowHelper.getMoneyPrecision(loan_T));
		}
		loan_T.setAttributeValue("Tax", Arith.round(loan_T.getDouble("Tax")-businessSum_Tax,CashFlowHelper.getMoneyPrecision(loan_T)));
		
		loan_T.setAttributeValue("BusinessSum_Tax", businessSum_Tax);//����˰
		loan_T.setAttributeValue("BusinessSum_Cost", Arith.round(loan_T.getDouble("BusinessSum")-loan_T.getDouble("BusinessSum_Tax"), CashFlowHelper.getMoneyPrecision(loan_T)));//������˰���
		
		
		loan_T.setAttributeValue("TotalAmt_Tax", Arith.round(payTotalAmt-loan_T.getDouble("BusinessSum_Cost")-loan_T.getDouble("InterestAmt_Cost"), CashFlowHelper.getMoneyPrecision(loan_T)));//����+��Ϣ�ܶ�
		
		return paymentScheduleList;
	}

}
