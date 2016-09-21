package com.amarsoft.app.accounting.interest.amount.impl;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.accounting.interest.accrue.InterestAccruer;
import com.amarsoft.app.accounting.interest.amount.AbstractAmount;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

/**
 * 计算复利计息基础：按照金额类型配置InfluenceInterestType计算
 * 如果只采用逾期利息计算复利，请参考本金罚息基数配置脚本，无需使用java类
 * @author Amarsoft核算团队
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
				if(StringX.isEmpty(className))//如果该金额字段未配置具体计算作为基数的类
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
