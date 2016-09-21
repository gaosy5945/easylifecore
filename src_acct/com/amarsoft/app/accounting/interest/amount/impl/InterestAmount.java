package com.amarsoft.app.accounting.interest.amount.impl;


import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.interest.amount.AbstractAmount;
import com.amarsoft.are.util.Arith;

/**
 * 获取已经结息的利息，并扣除已归还的利息
 * @author Amarsoft核算团队
 */
public class InterestAmount extends AbstractAmount {

	public double getAmount() throws Exception {
		
		//取利息罚息计算规则类
		double interestAmount = interestObject.getDouble("PayInterestAmt") - interestObject.getDouble("ActualPayInterestAmt");
		
		return Arith.round(interestAmount,CashFlowHelper.getMoneyPrecision(businessObject));
	}

}
