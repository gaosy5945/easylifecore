package com.amarsoft.app.als.credit.apply.action;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

/**
 * @author t-zhangq2
 * ��������������������������롢����ƽ�������롢�����¹�
 */
public class PaymentAbilityAnalyse {

	private BusinessObjectManager businessObjectManager;
	private JBOTransaction tx;
	private BusinessObject creditObject;
	private double monthlyIncome = 0.0;
	private double avgMonthlyIncome = 0.0;
	private double paymentAmount = 0.0;
	
	public PaymentAbilityAnalyse(String objectType, String objectNo) throws Exception{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager();
		this.tx = businessObjectManager.getTx();
		
		creditObject = this.businessObjectManager.keyLoadBusinessObject(objectType, objectNo);//ҵ�����
		if(creditObject == null)
			throw new Exception("δȡ��ҵ�����"+objectType+","+objectNo);
	}
	
	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}

	//�������������
	public double getMonthlyIncome() throws Exception{
		String customerID = creditObject.getString("CustomerID");
		if(StringX.isEmpty(customerID)) throw new Exception("δȡ�ÿͻ���Ϣ");
		List<BusinessObject> financeList = this.businessObjectManager.loadBusinessObjects("jbo.customer.CUSTOMER_FINANCE", 
				"CustomerID=:CustomerID", "CustomerID",customerID);
		for(BusinessObject o:financeList){
			String financialItem = o.getString("FinancialItem");
			if(!financialItem.startsWith("30")) continue; //����������
			double amt = o.getDouble("Amount");
			String currency = o.getString("Currency");
			amt = amt;// / RateHelper.getExchangeRate(currency, "CNY", DateHelper.getToday()); //���ʻ������
			monthlyIncome += amt;
		}
		
		return monthlyIncome;
	}
	
	//�������ƽ��������
	public double getAvgMonthlyIncome() throws Exception{
		//todo
		
		return avgMonthlyIncome;
	}
	
	//������˴����¹�
	public double getMonthlyPayment() throws Exception{
		double businessSum = creditObject.getDouble("BusinessSum");
		int businessTerm = creditObject.getInt("BusinessTerm");
		
		List<BusinessObject> rates = this.businessObjectManager.loadBusinessObjects("jbo.acct.ACCT_RATE_SEGMENT", 
				" ObjectType=:ObjectType and ObjectNo=:ObjectNo and RateType = '01' ", "ObjectType",creditObject.getBizClassName(),"ObjectNo",creditObject.getKeyString());
		if(rates == null || (rates != null && rates.size() == 0)) return 0;
		double rateValue = rates.get(0).getDouble("BusinessRate")/1200.0;
		
		String currency = creditObject.getString("BusinessCurrency");
		paymentAmount = getLoanInstallmentAmount(businessSum,businessTerm,rateValue,currency);
		return paymentAmount;
	}
	
	//�ȶϢ�¹�����
	public static double getLoanInstallmentAmount(double loanAmount, int loanPeriod, double instalmentInterestRate, String currency) throws Exception {
		double instalmentAmount = Arith.round(
				loanAmount * instalmentInterestRate
						* (1 + 1 / (java.lang.Math.pow(1 + instalmentInterestRate, loanPeriod) - 1)), 2);
		return instalmentAmount;
	}
}