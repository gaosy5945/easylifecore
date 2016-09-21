package com.amarsoft.app.accounting.interest.amount.impl;


import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.interest.amount.AbstractAmount;
import com.amarsoft.are.util.Arith;

/**
 * ��ȡ�Ѿ���Ϣ����Ϣ�����۳��ѹ黹����Ϣ
 * @author Amarsoft�����Ŷ�
 */
public class InterestAmount extends AbstractAmount {

	public double getAmount() throws Exception {
		
		//ȡ��Ϣ��Ϣ���������
		double interestAmount = interestObject.getDouble("PayInterestAmt") - interestObject.getDouble("ActualPayInterestAmt");
		
		return Arith.round(interestAmount,CashFlowHelper.getMoneyPrecision(businessObject));
	}

}
