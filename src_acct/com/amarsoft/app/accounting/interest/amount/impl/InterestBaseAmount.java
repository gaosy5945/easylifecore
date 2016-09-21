package com.amarsoft.app.accounting.interest.amount.impl;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.accounting.interest.accrue.InterestAccruer;
import com.amarsoft.app.accounting.interest.amount.AbstractAmount;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

/**
 * ���㸴����Ϣ���������ս����������InfluenceInterestType����
 * ���ֻ����������Ϣ���㸴������ο�����Ϣ�������ýű�������ʹ��java��
 * @author Amarsoft�����Ŷ�
 */
public class InterestBaseAmount extends AbstractAmount {

	public double getAmount() throws Exception {
		double baseInterestAmount = 0d;
		
		String[] amountCodes = CashFlowConfig.getAmountCodeConfigKeys();
		for(String amountCode:amountCodes)
		{
			String influenceInterestType = CashFlowConfig.getAmountCodeAttibute(amountCode,"InfluenceInterestType");
			if(interestAccruer.getInterestType().equals(influenceInterestType))
			{
				String className = CashFlowConfig.getAmountCodeAttibute(amountCode,"AmountCalculator");
				if(StringX.isEmpty(className))//����ý���ֶ�δ���þ��������Ϊ��������
				{
					baseInterestAmount += interestObject.getDouble(CashFlowConfig.getAmountCodeAttibute(amountCode,"PS.PayAttributeID"))-interestObject.getDouble(CashFlowConfig.getAmountCodeAttibute(amountCode,"PS.ActualPayAttributeID"));
				}else
				{
					Class<?> c = Class.forName(className);
					AbstractAmount interestAmount = ((AbstractAmount) c.newInstance());
					String interestType = CashFlowConfig.getAmountCodeAttibute(amountCode,"InterestType");
					if(StringX.isEmpty(interestType))
					{
						interestAmount.setInterestAccruer(null);
					}else
					{
						List<InterestAccruer> interestAccruers = InterestAccruer.getInterestAccruer(interestAccruer.getBusinessObject(),interestType,"",interestAccruer.getPsType(),interestAccruer.getBomanager());
						if(interestAccruers == null || interestAccruers.isEmpty())
						{
							interestAmount.setInterestAccruer(null);
						}else
						{
							interestAmount.setInterestAccruer(interestAccruers.get(0));
						}
					}
					
					interestAmount.setInterestObject(interestObject);
					interestAmount.setBusinessObject(businessObject);
					baseInterestAmount += interestAmount.getAmount();
				}
			}
		}
		
		return Arith.round(baseInterestAmount,CashFlowHelper.getMoneyPrecision(businessObject));
	}

}
