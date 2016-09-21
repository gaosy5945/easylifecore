package com.amarsoft.app.accounting.cashflow.pmt;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.due.DueDateScript;
import com.amarsoft.app.accounting.cashflow.due.PeriodScript;
import com.amarsoft.app.accounting.config.impl.AccountCodeConfig;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.accounting.interest.calc.InterestCalculator;
import com.amarsoft.app.accounting.interest.calc.impl.DailyCalculator;
import com.amarsoft.app.accounting.interest.calc.impl.MonthlyCalculator;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.are.lang.StringX;

/**
 * �����ڹ���������
 */
public abstract class PMTScript{
	protected BusinessObject loan;
	protected BusinessObject rptSegment;
	protected BusinessObjectManager bomanager;
	protected String psType;
	
	/**
	 * ��ȡ�ڹ�����ű�
	 * @param loan ����
	 * @param rptSegment ����������Ϣ
	 * @throws Exception
	 */
	public static PMTScript getPMTScript(BusinessObject loan, BusinessObject rptSegment, String psType,BusinessObjectManager bomanager) throws Exception {
		BusinessObject parameter = BusinessObject.createBusinessObject();
		parameter.setAttributeValue("PSType", psType);
		String className = BusinessComponentConfig.getComponentValue(loan,rptSegment, parameter, "PMTScript", "value");
		Class<?> c = Class.forName(className);
		PMTScript p=(PMTScript) c.newInstance();
		p.loan=loan;
		p.rptSegment=rptSegment;
		p.bomanager=bomanager;
		p.psType = psType;
		return p;
	}
	
	public abstract double getInstalmentAmount() throws Exception;
	public abstract double getPrincipalAmount() throws Exception;
	
	public void initRPTSegment() throws Exception {
		String psrestructureFlag = rptSegment.getString("PSRestructureFlag");
		if(StringX.isEmpty(psrestructureFlag)){//�������ʾΪ��ʱ�ų�ʼ���������γ�ʼ�����������쳣
			rptSegment.setAttributeValue("CurrentPeriod", 1);
			PeriodScript periodScript = PeriodScript.getPeriodScript(loan, rptSegment, psType);
			int t = periodScript.getTotalPeriod();
			rptSegment.setAttributeValue("TotalPeriod", t);
			
			rptSegment.setAttributeValue("NextDueDate", DueDateScript.getDueDateScript(loan, rptSegment,psType).generateNextDueDate());
			double instalmentAmount = this.getInstalmentAmount();
			rptSegment.setAttributeValue("SegInstalmentAmt", instalmentAmount);
			rptSegment.setAttributeValue("PSRestructureFlag", "0");
			bomanager.updateBusinessObject(rptSegment);
		}
		else if("2".equals(psrestructureFlag)) //�����ڹ�
		{
			PeriodScript periodScript = PeriodScript.getPeriodScript(loan, rptSegment, psType);
			int t = periodScript.getTotalPeriod();
			rptSegment.setAttributeValue("TotalPeriod", t);
			double instalmentAmount = this.getInstalmentAmount();
			rptSegment.setAttributeValue("SegInstalmentAmt", instalmentAmount);
			rptSegment.setAttributeValue("PSRestructureFlag", "0");
			bomanager.updateBusinessObject(rptSegment);
		}
	}

	public void nextInstalment() throws Exception {
		String psRestructureFlag = rptSegment.getString("PSRestructureFlag");//�����¹�������
		if (StringX.isEmpty(psRestructureFlag) || "2".equals(psRestructureFlag)) {//�����¹�
			int totalPeriod = PeriodScript.getPeriodScript(loan, rptSegment, psType).getTotalPeriod();
			rptSegment.setAttributeValue("TotalPeriod", totalPeriod);//�������ڴ�
			rptSegment.setAttributeValue("SegInstalmentAmt", getInstalmentAmount());//�����ڹ�
			rptSegment.setAttributeValue("PSRestructureFlag", "0");
		}

		double rptbalance = rptSegment.getDouble("SEGRPTBalance");//����ʣ�໹���
		double instalmentPrincipalAmtTemp = getPrincipalAmount();
		if (rptbalance >= instalmentPrincipalAmtTemp) {
			rptbalance -= instalmentPrincipalAmtTemp;
		} else {
			rptbalance = 0d;
		}
		rptSegment.setAttributeValue("SEGRPTBalance", rptbalance);

		String nextDueDate = rptSegment.getString("NextDueDate");// �´λ�������
		String lastDueDate = rptSegment.getString("LastDueDate");
		
		//ԭ����
		double oldBusinessRate = getPreiodRate();
		
		rptSegment.setAttributeValue("FirstDueDate", lastDueDate);//ʹ��FirstDueDate�洢�ϴλ�������
		rptSegment.setAttributeValue("LastDueDate", nextDueDate);
		rptSegment.setAttributeValue("NextDueDate",
				DueDateScript.getDueDateScript(loan, rptSegment, psType).generateNextDueDate());
		
		//������
		double newBusinessRate = getPreiodRate();
		//�������ʱ���д������ʵ����������¼����ڹ�
		if(Math.abs(newBusinessRate-oldBusinessRate) > 0.000001)
		{
			double instalmentAmount = this.getInstalmentAmount();
			rptSegment.setAttributeValue("SegInstalmentAmt", instalmentAmount);
		}
		// ���µ�ǰ�ڴ�
		rptSegment.setAttributeValue("CurrentPeriod", rptSegment.getInt("CurrentPeriod") + 1);
	}
	
	/**
	 * ��ȡ��������ʣ�౾��
	 * 
	 * @param loan ����
	 * @param rptSegment ��������
	 * @return ���ݻ������ε����ν���ʶ�� ���ض�Ӧ���軹����������ε�ʣ�౾��
	 * @throws Exception
	 */
	public double getOutStandingPrincipal() throws Exception {
		// ���ν���ʶ
		String segRPTAmountFlag = rptSegment.getString("SegRPTAmountFlag");
		// ����в�����ʱ��Ĭ�ϱ������
		if (StringX.isEmpty(segRPTAmountFlag)) {
			segRPTAmountFlag = CashFlowConfig.SEGRPTAMOUNT_LOAN_BALANCE;
		}

		// ���㱾����� ���Ҫ��
		String normalBalanceAccountCodeNo=CashFlowConfig.getAmountCodeAttibute(CashFlowConfig.getPaymentScheduleAttribute(psType, "PrincipalAmountCode"),"NormalBalanceAccountCode");
		BusinessObject subledger=loan.getBusinessObjectByAttributes(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger, "AccountCodeNo",normalBalanceAccountCodeNo);
		double loanBalance = AccountCodeConfig.getSubledgerBalance(subledger,AccountCodeConfig.Balance_DateFlag_CurrentDay);// ȡ���������Ϣ
		
		// 3-ָ���ڻ����
		if(CashFlowConfig.SEGRPTAMOUNT_SEG_INSTALMENTAMT.equals(segRPTAmountFlag)) {
			return 0d;
		}
		//2-ָ���黹������
		else if (CashFlowConfig.SEGRPTAMOUNT_SEG_AMT.equals(segRPTAmountFlag)) {
			if (rptSegment.getDouble("SegRPTAmount") <= 0d) {
				return 0.0d;
			} else {
				return rptSegment.getDouble("SegRPTBalance");
			}
		}
		// 1-���������ش��ǰ�ͻ�����������
		else if (CashFlowConfig.SEGRPTAMOUNT_LOAN_BALANCE.equals(segRPTAmountFlag)) {
			return loanBalance;
		}
		// 4-β����ص�ǰ�ͻ��ʱ������ȥָ�����
		else if (CashFlowConfig.SEGRPTAMOUNT_FINAL_PAYMENT.equals(segRPTAmountFlag)) {
			if(Math.abs(rptSegment.getDouble("SegRPTAmount")) < 0.00000001)  //���ָ��β��Ϊ�ջ���
				return loanBalance - loan.getDouble("BusinessSum")*rptSegment.getDouble("SegRPTPercent")/100.0d;
			else
				return loanBalance - rptSegment.getDouble("SegRPTAmount");
		} else {
			throw new ALSException("ED1024",loan.getKeyString());
		}
	}
	
	public List<BusinessObject> getRateSegments(String interestType) throws Exception{
		String nextDueDate = DueDateScript.getDueDateScript(loan, rptSegment, psType).generateNextDueDate();
		String[] rateTypes=CashFlowConfig.getRateTypes(interestType);
		List<BusinessObject> rateList = loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rate_segment, 
								"(SegFromDate=null or SegFromDate='' or SegFromDate<:NextDueDate) and (SegToDate=null or SegToDate='' or SegToDate>:NextDueDate) and Status=:Status and RateType in(:RateTypes) " ,"NextDueDate",nextDueDate,"Status","1", "RateTypes",rateTypes);
		return rateList;
	}
	
	public double getInterestRate() throws Exception{
		String fromDate = rptSegment.getString("LASTDUEDATE");
		String toDate = rptSegment.getString("NEXTDUEDATE");
		double installInterestRate=0d;
		String amountCodes = CashFlowConfig.getPaymentScheduleAttribute(psType, "AmountCode");
		String[] amountCodeArray=amountCodes.split(",");
		for(String amountCode:amountCodeArray){
			String interestType=CashFlowConfig.getAmountCodeAttibute(amountCode, "InterestType");
			if(interestType.isEmpty()) continue;
			if(!loan.getBizClassName().equals(CashFlowConfig.getInterestAttribute(interestType, "InterestObjectType"))) continue;
			List<BusinessObject> rateList = this.getRateSegments(interestType);
			if (!rateList.isEmpty()) {// ������������Ĭ��Ϊ��
				BusinessObject rateTerm = rateList.get(rateList.size()-1);//ʹ�����ڹ���Ϣ
				installInterestRate += InterestCalculator.getInterestCalculator(loan,interestType,psType)
						.getInterest(1.0, rateTerm.getString("RateUnit"), rateTerm.getDouble("BusinessRate"), fromDate, toDate, fromDate, toDate);
			}
		}
		return installInterestRate;
	}
	
	public double getPreiodRate() throws Exception{
		double installInterestRate = 0.0d;
		
		String payFrequencyType = rptSegment.getString("PayFrequencyType");
		BusinessObject payFrequency = CashFlowConfig.getPayFrequencyTypeConfig(payFrequencyType);
		String termUnit = payFrequency.getString("TermUnit");
		int term=payFrequency.getInt("Term");
		
		if(StringX.isEmpty(termUnit) && term == 0){
			termUnit = rptSegment.getString("PayFrequencyUnit");
			term = rptSegment.getInt("PayFrequency");
		}
		
		
		if(DateHelper.TERM_UNIT_YEAR.equals(termUnit))
		{
			termUnit = DateHelper.TERM_UNIT_MONTH;
			term = term*12;
			
		}
		
		if(DateHelper.TERM_UNIT_MONTH.equals(termUnit))
		{
			String fromDate = DateHelper.getBusinessDate();
			String toDate = DateHelper.getRelativeDate(fromDate, termUnit, term);
			String amountCodes = CashFlowConfig.getPaymentScheduleAttribute(psType, "AmountCode");
			String[] amountCodeArray=amountCodes.split(",");
			for(String amountCode:amountCodeArray){
				String interestType=CashFlowConfig.getAmountCodeAttibute(amountCode, "InterestType");
				if(interestType.isEmpty()) continue;
				if(!loan.getBizClassName().equals(CashFlowConfig.getInterestAttribute(interestType, "InterestObjectType"))) continue;
				List<BusinessObject> rateList = this.getRateSegments(interestType);
				if (!rateList.isEmpty()) {// ������������Ĭ��Ϊ��
					BusinessObject rateTerm = rateList.get(rateList.size()-1);//ʹ�����ڹ���Ϣ
					InterestCalculator mc = new MonthlyCalculator();
					mc.setBusinessObject(this.loan);
					installInterestRate += mc.getInterest(1.0, rateTerm.getString("RateUnit"), rateTerm.getDouble("BusinessRate"), fromDate, toDate, fromDate, toDate);
				}
			}
		}else if(DateHelper.TERM_UNIT_DAY.equals(termUnit))
		{
			String fromDate = DateHelper.getBusinessDate();
			String toDate = DateHelper.getRelativeDate(fromDate, termUnit, term);
			
			String amountCodes = CashFlowConfig.getPaymentScheduleAttribute(psType, "AmountCode");
			String[] amountCodeArray=amountCodes.split(",");
			for(String amountCode:amountCodeArray){
				String interestType=CashFlowConfig.getAmountCodeAttibute(amountCode, "InterestType");
				if(interestType.isEmpty()) continue;
				if(!loan.getBizClassName().equals(CashFlowConfig.getInterestAttribute(interestType, "InterestObjectType"))) continue;
				List<BusinessObject> rateList = this.getRateSegments(interestType);
				if (!rateList.isEmpty()) {// ������������Ĭ��Ϊ��
					BusinessObject rateTerm = rateList.get(rateList.size()-1);//ʹ�����ڹ���Ϣ
					InterestCalculator mc = new DailyCalculator();
					mc.setBusinessObject(this.loan);
					installInterestRate += mc.getInterest(1.0, rateTerm.getString("RateUnit"), rateTerm.getDouble("BusinessRate"), fromDate, toDate, fromDate, toDate);
				}
			}
		}
		
		return installInterestRate;
	}
}
