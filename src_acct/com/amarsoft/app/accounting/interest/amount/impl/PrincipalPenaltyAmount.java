package com.amarsoft.app.accounting.interest.amount.impl;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.interest.amount.AbstractAmount;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.util.Arith;

/**
 * ��ȡ�Ѿ���Ϣ�ı���Ϣ�����۳��ѹ黹�ı���Ϣ
 * @author Amarsoft�����Ŷ�
 */
public class PrincipalPenaltyAmount extends AbstractAmount {

	public double getAmount() throws Exception {
		
		//ȡ����Ϣ���������
		List<BusinessObject> interestLogs = interestAccruer.getBusinessObject().getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.interest_log," ObjectType=:ObjectType and ObjectNo=:ObjectNo and InterestType=:InterestType and SettleDate = :SettleDate "
				,"ObjectType",interestObject.getBizClassName(),"ObjectNo",interestObject.getKeyString(),"InterestType",interestAccruer.getInterestType(),"SettleDate",interestAccruer.getLastSettleDate(interestObject));//ȡ����Ϣ��Ϣ��¼
		
		double actualPrincipalPenaltyAmount = interestObject.getDouble("ActualPayPrincipalPenaltyAmt");
		
		//��ֹ�ϴν�Ϣ�յķ�Ϣ
		double currentPrincipalPenaltyAmount = 0d;
		for(BusinessObject interestLog:interestLogs)
		{
			currentPrincipalPenaltyAmount+=interestLog.getDouble("InterestTotal");
		}
		
		if(currentPrincipalPenaltyAmount > actualPrincipalPenaltyAmount) //�ϴν�Ϣ�ձ���Ϣ����ʵ�ʻ����Ϣ �����ʵ�ʻ����Ϣ
			currentPrincipalPenaltyAmount -= actualPrincipalPenaltyAmount;
		else//���� ȡ��
			currentPrincipalPenaltyAmount = 0d;
		
		return Arith.round(currentPrincipalPenaltyAmount,CashFlowHelper.getMoneyPrecision(businessObject));
	}

}
