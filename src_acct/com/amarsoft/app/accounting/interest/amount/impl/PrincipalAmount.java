package com.amarsoft.app.accounting.interest.amount.impl;


import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.interest.amount.AbstractAmount;
import com.amarsoft.are.util.Arith;

/**
 * ��ȡ�Ѿ����ڱ��𣬲��۳��ѹ黹�ı���
 * @author Amarsoft�����Ŷ�
 */
public class PrincipalAmount extends AbstractAmount {

	public double getAmount() throws Exception {
		double principalAmount = interestObject.getDouble("PayPrincipalAmt")-interestObject.getDouble("ActualPayPrincipalAmt");
		
		return Arith.round(principalAmount,CashFlowHelper.getMoneyPrecision(businessObject));
	}

}
