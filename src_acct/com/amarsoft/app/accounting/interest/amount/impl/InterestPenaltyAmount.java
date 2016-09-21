package com.amarsoft.app.accounting.interest.amount.impl;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.interest.amount.AbstractAmount;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.util.Arith;

/**
 * 获取已经结息的利息罚息，并扣除已归还的利息罚息
 * @author Amarsoft核算团队
 */
public class InterestPenaltyAmount extends AbstractAmount {

	public double getAmount() throws Exception {
		
		//取利息罚息计算规则类
		double actualInterestPenaltyAmount = interestObject.getDouble("ActualPayInterestPenaltyAmt");
		
		List<BusinessObject> interestLogs = interestAccruer.getBusinessObject().getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.interest_log," ObjectType=:ObjectType and ObjectNo=:ObjectNo and InterestType=:InterestType and SettleDate = :SettleDate "
				,"ObjectType",interestObject.getBizClassName(),"ObjectNo",interestObject.getKeyString(),"InterestType",interestAccruer.getInterestType(),"SettleDate",interestAccruer.getLastSettleDate(interestObject));//取利息罚息计息记录
		//截止上次结息日的利息罚息
		double currentInterestPenaltyAmount = 0d;
		for(BusinessObject interestLog:interestLogs)
		{
			currentInterestPenaltyAmount+=interestLog.getDouble("InterestTotal");
		}
		
		if(currentInterestPenaltyAmount > actualInterestPenaltyAmount) //上次结息日利息罚息大于实际还款利息罚息 则减掉实际还款利息罚息
			currentInterestPenaltyAmount -= actualInterestPenaltyAmount;
		else//否则 取零
			currentInterestPenaltyAmount = 0d;
		
		return Arith.round(currentInterestPenaltyAmount,CashFlowHelper.getMoneyPrecision(businessObject));
	}

}
