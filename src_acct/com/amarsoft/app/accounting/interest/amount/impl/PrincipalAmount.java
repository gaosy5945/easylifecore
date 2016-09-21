package com.amarsoft.app.accounting.interest.amount.impl;


import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.interest.amount.AbstractAmount;
import com.amarsoft.are.util.Arith;

/**
 * 获取已经到期本金，并扣除已归还的本金
 * @author Amarsoft核算团队
 */
public class PrincipalAmount extends AbstractAmount {

	public double getAmount() throws Exception {
		double principalAmount = interestObject.getDouble("PayPrincipalAmt")-interestObject.getDouble("ActualPayPrincipalAmt");
		
		return Arith.round(principalAmount,CashFlowHelper.getMoneyPrecision(businessObject));
	}

}
