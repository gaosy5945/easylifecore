package com.amarsoft.app.accounting.cashflow.ps.impl;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.due.DueDateScript;
import com.amarsoft.app.accounting.cashflow.pmt.PMTScript;
import com.amarsoft.app.accounting.cashflow.ps.PaymentScheduleCreator;
import com.amarsoft.app.accounting.config.impl.AccountCodeConfig;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.accounting.interest.accrue.InterestAccruer;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

public class IPCPaymentScheduleCreator extends PaymentScheduleCreator{

	public List<BusinessObject> createPaymentScheduleList(BusinessObject loan,int futurePeriod) throws Exception {
		BusinessObject loanTemp =loan.clone();
		String businessDate = loanTemp.getString("BusinessDate");
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
		
		
		List<BusinessObject> rptList=loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment, 
				"PSType like :PSType and Status=1 and (SegFromDate=null or SegFromDate='' or SegFromDate<=:BusinessDate) and NextDueDate>:BusinessDate and (SegToDate=null or SegToDate='' or SegToDate>:BusinessDate)"
				, "PSType",psType,"BusinessDate",loan.getString("BusinessDate"));
		BusinessObject rptSegment = rptList.get(0); 
		
		DueDateScript dueDateScript = DueDateScript.getDueDateScript(loanTemp, rptSegment, psType);
		PMTScript pmtScript = PMTScript.getPMTScript(loanTemp, rptSegment, psType,this.bomanager);
		
		if(oldPSList==null||oldPSList.isEmpty()){
			//���δ������ƻ�Ϊ�գ�������δ������ƻ���ֻ��ȷ��PayDate��ObjectNo��PayType���ɣ�������㱾����Ϣ
			List<String> payDateList = dueDateScript.getDueDateList();
			int currentPeriod=rptSegment.getInt("CurrentPeriod");
			for(String payDate:payDateList){
				BusinessObject ps = BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.payment_schedule);
				ps.generateKey();
				ps.setAttributeValue("ObjectType", loanTemp.getBizClassName());
				ps.setAttributeValue("ObjectNo", loanTemp.getKeyString());
				ps.setAttributeValue("RelativeObjectType", loan.getBizClassName());
				ps.setAttributeValue("RelativeObjectNo", loan.getString("SerialNo"));
				ps.setAttributeValue("PayDate", payDate);
				ps.setAttributeValue("PSType", psType);
				ps.setAttributeValue("PeriodNo", currentPeriod);
				ps.setAttributeValue("Currency", loan.getString("Currency"));
				ps.setAttributeValue("AutoPayFlag", (StringX.isEmpty(rptSegment.getString("AutoPayFlag")) ? CashFlowConfig.getPaymentScheduleAttribute(psType, "AutoPayFlag") : rptSegment.getString("AutoPayFlag")));
				ps.setAttributeValue("PayItemCode", CashFlowConfig.getPaymentScheduleAttribute(psType, "PayItemCode"));
				ps.setAttributeValue("Direction", CashFlowConfig.getPaymentScheduleAttribute(psType, "Direction"));
				ps.setAttributeValue("Status", "1");
				loanTemp.appendBusinessObject(ps.getBizClassName(), ps);
				oldPSList.add(ps);
				currentPeriod++;
			}
		}
		
		
		String lastDueDate = DueDateScript.getLastDueDate(loanTemp, psType);
		double principalBalance =  AccountCodeConfig.getSubledgerBalance(subledger,AccountCodeConfig.Balance_DateFlag_CurrentDay);
		//��ʼ��ָ�����
		List<BusinessObject> fixpsList = loan.getBusinessObjects("FixPaymentSchedule");
		if(fixpsList!=null&&fixpsList.size()>0){
			for(BusinessObject fixps:fixpsList){
				double fixInstallmentAmt = fixps.getDouble("FixPayInstalmentAmt");
				double fixPrincipalAmt = fixps.getDouble("FixPayPrincipalAmt");
				String payDate = fixps.getString("PayDate");
				int periodNo = fixps.getInt("PeriodNo");
				for(BusinessObject ps:oldPSList){
					if(periodNo == ps.getInt("PeriodNo")){
						if(fixInstallmentAmt!=0d||fixPrincipalAmt!=0d){
							ps.setAttributeValue("FixPayInstalmentAmt", fixInstallmentAmt);
							ps.setAttributeValue("FixPayPrincipalAmt", fixPrincipalAmt);
							ps.setAttributeValue("PayDate", payDate);
						}
						else if(!payDate.equals(ps.getString("PayDate"))) {
							ps.setAttributeValue("PayDate", payDate);
						}
						break;
					}
				}
			}
		}
		
		double installmentAmt = pmtScript.getInstalmentAmount();
		rptSegment.setAttributeValue("SegInstalmentAmt", installmentAmt);
		int i=0;
		for(BusinessObject ps:oldPSList){//���㻹��ƻ��������Ϣ
			i++;
			String payDate = ps.getString("PayDate");
			double principalAmount = 0d;
			double fixInstallmentAmt = ps.getDouble("FixPayInstalmentAmt");
			double fixPrincipalAmt = ps.getDouble("FixPayPrincipalAmt");
			
			if(fixInstallmentAmt==0d){
				fixInstallmentAmt=installmentAmt;
			}
			else if(fixInstallmentAmt<0d){
				ps.setAttributeValue(principalBalanceAttributeID, principalBalance);
				ps.setAttributeValue(payPrincipalAttributeID, 0d);
				ps.setAttributeValue("PayInterestAmt", 0d);
				continue;
			}
			
			//�����ڹ���Ϣ
			double psInterestRate = 0.0d;
			String[] amountCodes=CashFlowConfig.getPaymentScheduleAttribute(psType, "AmountCode").split(",");
			for(String amountCode:amountCodes){//������Ϣ���
				String interestType = CashFlowConfig.getAmountCodeAttibute(amountCode, "InterestType");
				if(StringX.isEmpty(interestType))continue;
				String interestObjectType=CashFlowConfig.getInterestAttribute(interestType, "InterestObjectType");
				if(!loanTemp.getBizClassName().equals(interestObjectType)) continue;
				String[] rateTypes=CashFlowConfig.getRateTypes(interestType);
				for(String rateType:rateTypes){
					List<InterestAccruer> interestAccruers = InterestAccruer.getInterestAccruer(loanTemp,interestType,rateType,psType,null);
					for(InterestAccruer interestAccruer : interestAccruers)
					{
						psInterestRate += interestAccruer.getInterestRate(loanTemp, lastDueDate, payDate);
					}
				}
			}
    		double interestAmount = Arith.round(principalBalance*psInterestRate,2);
			ps.setAttributeValue("PayInterestAmt", interestAmount);
			//�����ڹ�����
			if(fixPrincipalAmt>0d){
				principalAmount=fixPrincipalAmt;//���ָ���������ʹ�ñ�����
			}
			else if(fixPrincipalAmt<0d){
				principalAmount=0;//���ָ���������ʹ�ñ�����
			}
			else{
				principalAmount= Arith.round(fixInstallmentAmt-interestAmount,2);
			}
			//���һ���������β���ϲ�
			if(principalAmount>principalBalance||i==oldPSList.size()||principalBalance-principalAmount<oldPSList.size()*0.01){
				principalAmount=principalBalance;
			}
			if(principalAmount<0d) principalAmount=0;
	    	ps.setAttributeValue(payPrincipalAttributeID, Arith.round(principalAmount,2));
	    	//����ʣ�౾��
			principalBalance = Arith.round(principalBalance-principalAmount,2);
			ps.setAttributeValue(principalBalanceAttributeID, principalBalance);
			
			AccountCodeConfig.setSubledgerBalance(subledger, principalBalance);// ���¸�ֵ�������
			
			lastDueDate=payDate;
			ps.setAttributeValue("AutoPayFlag", (StringX.isEmpty(rptSegment.getString("AutoPayFlag")) ? CashFlowConfig.getPaymentScheduleAttribute(psType, "AutoPayFlag") : rptSegment.getString("AutoPayFlag")));
			ps.setAttributeValue("PayItemCode", CashFlowConfig.getPaymentScheduleAttribute(psType, "PayItemCode"));
			ps.setAttributeValue("Direction", CashFlowConfig.getPaymentScheduleAttribute(psType, "Direction"));
			ps.setAttributeValue("Status", "1");
		}
		return oldPSList;
	}
}
