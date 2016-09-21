package com.amarsoft.app.accounting.interest.amount.impl;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.interest.amount.AbstractAmount;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.util.Arith;

/**
 * 获取已经结息的本金罚息，并扣除已归还的本金罚息
 * @author Amarsoft核算团队
 */
public class PrincipalPenaltyAmount extends AbstractAmount {

	public double getAmount() throws Exception {
		
		//取本金罚息计算规则类
		List<BusinessObject> interestLogs = interestAccruer.getBusinessObject().getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.interest_log," ObjectType=:ObjectType and ObjectNo=:ObjectNo and InterestType=:InterestType and SettleDate = :SettleDate "
				,"ObjectType",interestObject.getBizClassName(),"ObjectNo",interestObject.getKeyString(),"InterestType",interestAccruer.getInterestType(),"SettleDate",interestAccruer.getLastSettleDate(interestObject));//取本金罚息计息记录
		
		double actualPrincipalPenaltyAmount = interestObject.getDouble("ActualPayPrincipalPenaltyAmt");
		
		//截止上次结息日的罚息
		double currentPrincipalPenaltyAmount = 0d;
		for(BusinessObject interestLog:interestLogs)
		{
			currentPrincipalPenaltyAmount+=interestLog.getDouble("InterestTotal");
		}
		
		if(currentPrincipalPenaltyAmount > actualPrincipalPenaltyAmount) //上次结息日本金罚息大于实际还款本金罚息 则减掉实际还款本金罚息
			currentPrincipalPenaltyAmount -= actualPrincipalPenaltyAmount;
		else//否则 取零
			currentPrincipalPenaltyAmount = 0d;
		
		return Arith.round(currentPrincipalPenaltyAmount,CashFlowHelper.getMoneyPrecision(businessObject));
	}

}
