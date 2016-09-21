package com.amarsoft.app.accounting.trans.script.loan.repay;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.accounting.interest.accrue.InterestAccruer;
import com.amarsoft.app.accounting.interest.amount.AbstractAmount;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectHelper;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

public abstract class PayProcedure extends TransactionProcedure{
	protected List<BusinessObject> paymentLogs= new ArrayList<BusinessObject>();
	
	public void updatePaymentSchedules() throws Exception {
		String[] psTypes=TransactionConfig.getScriptConfig(transactionCode, scriptID, "PSType").split(",");
		for(String psType:psTypes)
		{
			String[] amountCodes=CashFlowConfig.getPaymentScheduleAttribute(psType, "AmountCode").split(",");
			for(BusinessObject paymentLog:paymentLogs){
				BusinessObject paymentSchedule=this.relativeObject.getBusinessObjectByKey(paymentLog.getString("ObjectType"),paymentLog.getString("ObjectNo"));
				HashMap<String,Double> iitmap = new HashMap<String,Double>();
				List<String> keys = new ArrayList<String>();
				for (String amountCode : amountCodes) {
					String ps_actualPayAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"PS.ActualPayAttributeID");
					String pl_actualPayAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"PL.ActualPayAttributeID");
					String influenceInterestType = CashFlowConfig.getAmountCodeAttibute(amountCode,"InfluenceInterestType");
					if(StringX.isEmpty(pl_actualPayAttributeID)) pl_actualPayAttributeID=ps_actualPayAttributeID;
					double amount = paymentLog.getDouble(pl_actualPayAttributeID);
					if (amount <= 0d) continue;
					
					//���Ϣ����жϴ���
					double baseAmount = 0.0d;
					String className = CashFlowConfig.getAmountCodeAttibute(amountCode,"AmountCalculator");
					if(StringX.isEmpty(className))//����ý���ֶ�δ���þ��������Ϊ��������
					{
						baseAmount += paymentSchedule.getDouble(CashFlowConfig.getAmountCodeAttibute(amountCode,"PS.PayAttributeID"))-paymentSchedule.getDouble(CashFlowConfig.getAmountCodeAttibute(amountCode,"PS.ActualPayAttributeID"));
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
							List<InterestAccruer> interestAccruers = InterestAccruer.getInterestAccruer(relativeObject,interestType,"",psType,bomanager);
							if(interestAccruers == null || interestAccruers.isEmpty())
							{
								interestAmount.setInterestAccruer(null);
							}else
							{
								interestAmount.setInterestAccruer(interestAccruers.get(0));
							}
						}
						
						interestAmount.setInterestObject(paymentSchedule);
						interestAmount.setBusinessObject(relativeObject);
						baseAmount += interestAmount.getAmount();
					}
						
					//���ʵ�ʻ�������ڼ�Ϣ������ֱ��ȡ��Ϣ�������
					if(amount > baseAmount) amount = baseAmount;
					
					if(!StringX.isEmpty(influenceInterestType))
					{
						Double d = iitmap.get(influenceInterestType);
						if(d == null){
							iitmap.put(influenceInterestType, amount);
						}
						else
							iitmap.put(influenceInterestType, d+amount);
						if(!keys.contains(influenceInterestType))
							keys.add(influenceInterestType);
					}
				}
				//�Թ黹�ı�����Ϣ����Ϣ ���н�Ϣ
				for(String influenceInterestType:keys)
				{
					String interestObjectType = CashFlowConfig.getInterestAttribute(influenceInterestType, "InterestObjectType");
					if(interestObjectType.equals(paymentSchedule.getBizClassName())){
						String[] rateTypes=CashFlowConfig.getRateTypes(influenceInterestType);
						for(String rateType:rateTypes){
							List<InterestAccruer> interestAccruers = InterestAccruer.getInterestAccruer(relativeObject,influenceInterestType,rateType,psType,bomanager);
							for(InterestAccruer interestAccruer:interestAccruers)
							{
								if(interestAccruer.getInterestObjects().contains(paymentSchedule))
								{
									if(relativeObject.getString("BusinessDate").equals(
											interestAccruer.getNextSettleDate(paymentSchedule)))
											continue;//����´ν�Ϣ���ǵ��� 
									BusinessObject interestLog = interestAccruer.settleInterest(paymentSchedule,iitmap.get(influenceInterestType), relativeObject.getString("BusinessDate"));
									interestLog.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));
								}
							}
						}
					}
				}
				
				
				for (String amountCode : amountCodes) {
					String ps_actualPayAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"PS.ActualPayAttributeID");
					String pl_actualPayAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"PL.ActualPayAttributeID");
					if(StringX.isEmpty(pl_actualPayAttributeID)) pl_actualPayAttributeID=ps_actualPayAttributeID;
					double amount = paymentLog.getDouble(pl_actualPayAttributeID);
					if (amount <= 0d) continue;
					paymentSchedule.setAttributeValue(ps_actualPayAttributeID, Arith.round(paymentSchedule.getDouble(ps_actualPayAttributeID) + amount,CashFlowHelper.getMoneyPrecision(relativeObject)));
				}
				bomanager.updateBusinessObject(paymentSchedule);
			}
		}
	}
	
	/**
	 * �������ù�����н����
	 * @param payAmount
	 * @param payRuleCode
	 * @param pslist
	 * @return
	 * @throws Exception
	 */
	
	public double splitPayRule(double payAmount,String payRuleCode,List<BusinessObject> pslist) throws Exception{
		if(payAmount<=0d) return payAmount;
		BusinessObject payRuleConfig=CashFlowConfig.getPayRuleConfig(payRuleCode);
		List<BusinessObject> payRuleGroupList = payRuleConfig.getBusinessObjects(CashFlowConfig.JBO_NAME_PAY_RULE_GROUP);
		for(BusinessObject payRuleGroup:payRuleGroupList){
			if(payAmount<=0d) break;
			List<BusinessObject> payRules = payRuleGroup.getBusinessObjects(CashFlowConfig.JBO_NAME_PAY_RULE);
			
			List<BusinessObject> newpsList = new ArrayList<BusinessObject>();
			String amountCodeString="";
			for(BusinessObject payRule:payRules)
			{
				String querySql=payRule.getString("Filter");
				List<BusinessObject> newpsListTmp = BusinessObjectHelper.getBusinessObjectsBySql(pslist, querySql);
				String amountCodeStringTmp = payRule.getString("AmountCode");
				if(StringX.isEmpty(amountCodeStringTmp)) break;
				if(StringX.isEmpty(amountCodeString))
					amountCodeString = amountCodeStringTmp;
				else
					amountCodeString=amountCodeString+","+amountCodeStringTmp;
				for(BusinessObject newpsTmp:newpsListTmp)
				{
					if(!newpsList.contains(newpsTmp))
						newpsList.add(newpsTmp);
				}
			}
			String[] amountCodes=amountCodeString.split(",");
			payAmount=this.splitTimePriority(payAmount, amountCodes, newpsList);
		}
		return payAmount;
	}
	
	/**
	 * ����ʱ��˳����л�����
	 * @param payAmount
	 * @param amountCodes
	 * @param pslist
	 * @return
	 * @throws Exception
	 */
	public double splitTimePriority(double payAmount,String[] amountCodes,List<BusinessObject> pslist) throws Exception{
		if(payAmount<=0d) return payAmount;
		List<Object> payDateArray = BusinessObjectHelper.getValues(pslist, "PayDate");
		for(Object payDate:payDateArray){
			if(payAmount<=0d) break;
			List<BusinessObject> newpsList = BusinessObjectHelper.getBusinessObjectsBySql(pslist, "PayDate=:PayDate","PayDate",payDate);
			payAmount = this.splitAmountCodePriority(payAmount, amountCodes, newpsList);
		}
		return payAmount;
	}
	
	/**
	 * ���ս�����ͽ��л�����
	 * @param payAmount
	 * @param amountCodes
	 * @param pslist
	 * @return
	 * @throws Exception
	 */
	public double splitAmountCodePriority(double payAmount,String[] amountCodes,List<BusinessObject> pslist) throws Exception{
		if(payAmount<=0d) return payAmount;
		for(String amountCode:amountCodes){
			payAmount=this.splitAmountCode(payAmount, amountCode, pslist);
			if(payAmount<=0d){
				payAmount=0d;
				break;
			}
		}
		return payAmount;
	}
	
	/**
	 * ָ����������ͽ��л�����
	 * @param payAmount
	 * @param amountCode
	 * @param pslist
	 * @return
	 * @throws Exception
	 */
	private double splitAmountCode(double payAmount,String amountCode,List<BusinessObject> pslist) throws Exception{
		String ps_payAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"PS.PayAttributeID");
		String ps_actualPayAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"PS.ActualPayAttributeID");
		String ps_waiveAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"PS.WaiveAttributeID");
		
		String pl_payAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"PL.PayAttributeID");
		if(StringX.isEmpty(pl_payAttributeID)) pl_payAttributeID=ps_payAttributeID;
		String pl_actualPayAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"PL.ActualPayAttributeID");
		if(StringX.isEmpty(pl_actualPayAttributeID)) pl_actualPayAttributeID=ps_actualPayAttributeID;
		String pl_waiveAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"PL.WaiveAttributeID");
		if(StringX.isEmpty(pl_waiveAttributeID)) pl_waiveAttributeID=ps_waiveAttributeID;
		
		String tp_payAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"TP.PayAttributeID");
		if(StringX.isEmpty(tp_payAttributeID)) tp_payAttributeID=pl_payAttributeID;
		String tp_actualPayAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"TP.ActualPayAttributeID");
		if(StringX.isEmpty(tp_actualPayAttributeID)) tp_actualPayAttributeID=pl_actualPayAttributeID;
		String tp_waiveAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"TP.WaiveAttributeID");
		if(StringX.isEmpty(tp_waiveAttributeID)) tp_waiveAttributeID=pl_waiveAttributeID;
		
		for(BusinessObject ps:pslist){
			String psAmountCode = CashFlowConfig.getPaymentScheduleAttribute(ps.getString("PSType"), "AmountCode");
			if((","+psAmountCode+",").indexOf(","+amountCode+",") <= -1) continue;
			
			double amt = Arith.round(ps.getDouble(ps_payAttributeID)-ps.getDouble(ps_actualPayAttributeID),CashFlowHelper.getMoneyPrecision(relativeObject));
			if(amt<=0d) continue;
			if(payAmount<=amt) amt=payAmount;
			payAmount=payAmount-amt;
			
			BusinessObject paymentLog = BusinessObjectHelper.getBusinessObjectByAttributes(paymentLogs,"ObjectType",ps.getBizClassName(), "ObjectNo",ps.getKeyString());
			if(paymentLog==null){
				paymentLog=BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.payment_log);
				paymentLog.generateKey();
				paymentLog.setAttributeValue("ObjectType", ps.getBizClassName());
				paymentLog.setAttributeValue("ObjectNo", ps.getKeyString());
				paymentLog.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));
				paymentLog.setAttributeValue("PayDate", ps.getString("PayDate"));
				paymentLog.setAttributeValue("PSType", ps.getString("PSType"));
				paymentLog.setAttributeValue("ActualPayDate", relativeObject.getString("BusinessDate"));
				paymentLog.setAttributeValue("Currency", relativeObject.getString("Currency"));
				paymentLog.setAttributeValue("Status", "1");
				paymentLog.setAttributeValue("RelativeObjectType", ps.getString("RelativeObjectType"));
				paymentLog.setAttributeValue("RelativeObjectNo", ps.getString("RelativeObjectNo"));
				paymentLogs.add(paymentLog);
			}
			paymentLog.setAttributeValue(pl_payAttributeID, Arith.round(paymentLog.getDouble(pl_payAttributeID)+ps.getDouble(ps_payAttributeID)-ps.getDouble(ps_actualPayAttributeID),CashFlowHelper.getMoneyPrecision(relativeObject)));
			paymentLog.setAttributeValue(pl_actualPayAttributeID, Arith.round(paymentLog.getDouble(pl_actualPayAttributeID)+amt,CashFlowHelper.getMoneyPrecision(relativeObject)));
			if(payAmount<=0d){
				payAmount=0d;
				break;
			}
		}
		return payAmount;
	}
	
	/**
	 * ָ��������ͻ��ֻ��ָ��һ�ֻ���ƻ����ͣ����ֻ���ƻ����ͻ�����ֶ��ظ�
	 * @param pslist
	 * @return
	 * @throws Exception
	 */
	public double splitManual(List<BusinessObject> pslist) throws Exception{
		double suspenseAmt=0d;
		String[] psTypes=TransactionConfig.getScriptConfig(transactionCode, scriptID, "PSType").split(",");
		for(String psType:psTypes)
		{
			String[] amountCodes=CashFlowConfig.getPaymentScheduleAttribute(psType, "AmountCode").split(",");
			for(String amountCode:amountCodes){
				String tp_actualPayAttributeID = CashFlowConfig.getAmountCodeAttibute(amountCode,"TP.ActualPayAttributeID");
				double payAmount=this.documentObject.getDouble(tp_actualPayAttributeID);
				payAmount=this.splitAmountCode(payAmount, amountCode, pslist);
				if(payAmount>0d){
					suspenseAmt+=payAmount;
				}
			}
		}
		return suspenseAmt;
	}
}
