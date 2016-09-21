package com.amarsoft.app.accounting.interest.amount.impl;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.interest.amount.AbstractAmount;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.util.Arith;

/**
 * ��ȡ�Ѿ���Ϣ����Ϣ��Ϣ�����۳��ѹ黹����Ϣ��Ϣ
 * @author Amarsoft�����Ŷ�
 */
public class InterestPenaltyAmount extends AbstractAmount {

	public double getAmount() throws Exception {
		
		//ȡ��Ϣ��Ϣ���������
		double actualInterestPenaltyAmount = interestObject.getDouble("ActualPayInterestPenaltyAmt");
		
		List<BusinessObject> interestLogs = interestAccruer.getBusinessObject().getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.interest_log," ObjectType=:ObjectType and ObjectNo=:ObjectNo and InterestType=:InterestType and SettleDate = :SettleDate "
				,"ObjectType",interestObject.getBizClassName(),"ObjectNo",interestObject.getKeyString(),"InterestType",interestAccruer.getInterestType(),"SettleDate",interestAccruer.getLastSettleDate(interestObject));//ȡ��Ϣ��Ϣ��Ϣ��¼
		//��ֹ�ϴν�Ϣ�յ���Ϣ��Ϣ
		double currentInterestPenaltyAmount = 0d;
		for(BusinessObject interestLog:interestLogs)
		{
			currentInterestPenaltyAmount+=interestLog.getDouble("InterestTotal");
		}
		
		if(currentInterestPenaltyAmount > actualInterestPenaltyAmount) //�ϴν�Ϣ����Ϣ��Ϣ����ʵ�ʻ�����Ϣ��Ϣ �����ʵ�ʻ�����Ϣ��Ϣ
			currentInterestPenaltyAmount -= actualInterestPenaltyAmount;
		else//���� ȡ��
			currentInterestPenaltyAmount = 0d;
		
		return Arith.round(currentInterestPenaltyAmount,CashFlowHelper.getMoneyPrecision(businessObject));
	}

}
