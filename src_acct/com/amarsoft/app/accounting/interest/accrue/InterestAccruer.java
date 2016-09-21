package com.amarsoft.app.accounting.interest.accrue;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.accounting.interest.amount.AbstractAmount;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.script.ScriptConfig;
import com.amarsoft.are.lang.StringX;

/**
 * ��Ϣ����
 */
public abstract class InterestAccruer {
	protected BusinessObject businessObject=null;
	protected BusinessObjectManager bomanager=null;
	protected String interestType=null;
	protected String rateType=null;
	protected String psType=null;
	
	public BusinessObject getBusinessObject() {
		return businessObject;
	}

	public BusinessObjectManager getBomanager() {
		return bomanager;
	}

	public String getInterestType() {
		return interestType;
	}

	public String getRateType() {
		return rateType;
	}

	public String getPsType() {
		return psType;
	}

	/**
	 * 
	 * @param businessObject ������
	 * @param interestType ��Ϣ��������
	 * @param rateType ��������
	 * @param psType �ƻ����ͣ��ɲ�������ڴ�����������ƻ���Ҫ
	 * @param bomanager �����������Ϊ��ʱ��ʾ���������ݲ��롢���¡�ɾ��
	 * @return �����Ϣ������󣬱��ڷֶμ�������
	 * @throws Exception
	 */
	public static List<InterestAccruer> getInterestAccruer(BusinessObject businessObject,String interestType,String rateType,String psType,BusinessObjectManager bomanager) throws Exception {
		String classNames=CashFlowConfig.getInterestAttribute(interestType, "AccrueInterestScript");
		
		List<InterestAccruer> accruers = new ArrayList<InterestAccruer>();
		if (classNames != null && !"".equals(classNames)) {
			String[] classNameArray = classNames.split(",");
			for(String className:classNameArray)
			{
				Class<?> c = Class.forName(className);
				InterestAccruer scriptClass = ((InterestAccruer) c.newInstance());
				scriptClass.businessObject=businessObject;
				scriptClass.bomanager=bomanager;
				scriptClass.interestType=interestType;
				scriptClass.rateType=rateType;
				scriptClass.psType=psType;
				accruers.add(scriptClass);
			}
		}
		return accruers;
	}

	public abstract String getLastSettleDate(BusinessObject interestObject) throws Exception;
	
	public abstract String getNextSettleDate(BusinessObject interestObject) throws Exception;
	
	public abstract List<BusinessObject> getInterestObjects() throws Exception;
	
	/**
	 * ���ݼ�Ϣ�����ȡ��Ϣ���
	 * 
	 * @param interestObject
	 * @return
	 * @throws Exception
	 */
	public double getBaseAmount(BusinessObject interestObject) throws Exception{
		String baseAmountCalculatorType = CashFlowConfig.getInterestAttribute(interestType,rateType, "BaseAmountCalculatorType");
		String baseAmountCalculator = CashFlowConfig.getInterestAttribute(interestType,rateType, "BaseAmountCalculator");
		if(StringX.isEmpty(baseAmountCalculatorType)||baseAmountCalculatorType.equalsIgnoreCase(ScriptConfig.SCRIPT_TYPE_EL)){
			return (double)ScriptConfig.executeELScript(baseAmountCalculator, "businessObject",businessObject,"interestObject",interestObject);
		}
		else if(baseAmountCalculatorType.equalsIgnoreCase(ScriptConfig.SCRIPT_TYPE_JAVA)){
			Class<?> c = Class.forName(baseAmountCalculator);
			AbstractAmount interestAmount = ((AbstractAmount) c.newInstance());
			interestAmount.setInterestAccruer(this);
			interestAmount.setInterestObject(interestObject);
			interestAmount.setBusinessObject(businessObject);
			return interestAmount.getAmount();
		}
		else{
			return 0d;
		}
	}
	
	public abstract double getInterestRate(BusinessObject interestObject,String fromDate,String toDate) throws Exception;
	
	public BusinessObject suspenseInterest(BusinessObject interestObject,String settleDate,double suspenseBaseAmount) throws Exception {
		BusinessObject interestLog= settleInterest(interestObject, settleDate);
		String nextSettleDate=this.getNextSettleDate(interestObject);
		if(settleDate.equals(nextSettleDate)) return interestLog;//����ǽ�Ϣ�յ��죬�������Ϣ��
		if(suspenseBaseAmount>0){
			double interestRate=this.getInterestRate(interestObject, interestLog.getString("InterestDate"), settleDate);
			double interest=suspenseBaseAmount*interestRate;
			interestLog.setAttributeValue("InterestSuspense", interest);
			interestLog.setAttributeValue("SettleDate",settleDate);
		}
		return interestLog;
	}
	
	/**
	 * ������Ϣ����
	 * @param interestObject
	 * @param settleDate
	 * @return
	 * @throws Exception
	 */
	public BusinessObject settleInterest(BusinessObject interestObject,String settleDate) throws Exception {
		String nextSettleDate=this.getNextSettleDate(interestObject);
		String lastSettleDate=this.getLastSettleDate(interestObject);
		if(StringX.isEmpty(nextSettleDate)||nextSettleDate.compareTo(lastSettleDate)<=0) return null;
		double baseAmount=this.getBaseAmount(interestObject);
		
		BusinessObject lastInterestLog = businessObject.getBusinessObjectBySql(BUSINESSOBJECT_CONSTANTS.interest_log," ObjectType=:ObjectType and ObjectNo=:ObjectNo and RateType=:RateType and InterestType=:InterestType and (NextSerialNo=null or NextSerialNo='')"
				,"ObjectType",interestObject.getBizClassName(),"ObjectNo",interestObject.getKeyString(),"RateType",rateType,"InterestType",interestType);
		if(lastInterestLog!=null&&StringX.isEmpty(lastInterestLog.getString("SettleDate"))){
			if(Math.abs(baseAmount-lastInterestLog.getDouble("BaseAmount")) < 0.00000001){//�����Ϣ����һ�£��������Ϣ
				this.accrueInterestLog(interestObject,lastInterestLog,settleDate,nextSettleDate);
				return lastInterestLog;
			}
			else{//�����Ϣ������һ�£���ԭ����һ�����,�½�һ��
				this.accrueInterestLog(interestObject,lastInterestLog, settleDate,nextSettleDate);
				lastInterestLog.setAttributeValue("SettleDate",settleDate);
			}
		}
		
		//���û�л��Ϣ������һ�£���Ҳ�½�һ��interestLog
		BusinessObject interestLog=BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.interest_log);
		interestLog.generateKey();
		interestLog.setAttributeValue("RelativeObjectType", businessObject.getBizClassName());
		interestLog.setAttributeValue("RelativeObjectNo", businessObject.getKeyString());
		interestLog.setAttributeValue("ObjectType", interestObject.getBizClassName());
		interestLog.setAttributeValue("ObjectNo", interestObject.getKeyString());
		interestLog.setAttributeValue("InterestType", interestType);
		interestLog.setAttributeValue("RateType", rateType);
		interestLog.setAttributeValue("InterestDate", lastSettleDate);
		interestLog.setAttributeValue("BaseAmount", baseAmount);
		
		if(lastInterestLog!=null){
			interestLog.setAttributeValue("InterestTotal",lastInterestLog.getDouble("InterestTotal"));
			interestLog.setAttributeValue("InterestSuspense",lastInterestLog.getDouble("InterestSuspense"));
			interestLog.appendBusinessObject(BUSINESSOBJECT_CONSTANTS.interest_log, lastInterestLog);
		}
		this.accrueInterestLog(interestObject,interestLog, settleDate,nextSettleDate);
		if(lastInterestLog!=null){//�ȼ��������Ϣ���ٸ�ֵ������ȡ�ϴν�Ϣ�ճ���
			lastInterestLog.setAttributeValue("NextSerialNo",interestLog.getKeyString());
		}
		businessObject.appendBusinessObject(interestLog.getBizClassName(), interestLog);
		return interestLog;
	}
	
	/**
	 * ָ������Ϣ����ǰ�����Ϣ��������ʱ����
	 * @param interestObject
	 * @param baseAmount
	 * @param settleDate
	 * @return
	 * @throws Exception
	 */
	public abstract BusinessObject settleInterest(BusinessObject interestObject,double baseAmount,String settleDate) throws Exception;
		
	protected void accrueInterestLog(BusinessObject interestObject,BusinessObject interestLog, String accrueDate,String nextSettleDate) throws Exception {
		double intersetRate=this.getInterestRate(interestObject, interestLog.getString("InterestDate"), accrueDate);
		double baseAmount=interestLog.getDouble("BaseAmount");
		double oldunsettledInterest= interestLog.getDouble("InterestAMT");
		//���������Ϣ�յ������յ���Ϣ
		double newunsettledInterest = intersetRate*(baseAmount);
		interestLog.setAttributeValue("InterestAMT", newunsettledInterest);
		
		//��Ϣ�ܶ�
		interestLog.setAttributeValue("InterestTotal",
				interestLog.getDouble("InterestTotal")+newunsettledInterest - oldunsettledInterest);
		interestLog.setAttributeValue("LastInteDate", accrueDate);
		
		if(accrueDate.compareTo(nextSettleDate)>0) throw new ALSException("����������ڽ�Ϣ��");
		else if(accrueDate.equals(nextSettleDate)){//����������������Ϣ���㣬���򲻽�
			interestLog.setAttributeValue("SettleDate", accrueDate);
			interestLog.setAttributeValue("InterestAmt",interestLog.getDouble("InterestAmt")+interestLog.getDouble("InterestSuspense"));
			interestLog.setAttributeValue("InterestTotal",interestLog.getDouble("InterestTotal")+interestLog.getDouble("InterestSuspense"));
			interestLog.setAttributeValue("InterestSuspense",0d);
			if(bomanager != null) bomanager.updateBusinessObject(interestLog);
			BusinessObject lastInterestLog = interestLog.getBusinessObject(BUSINESSOBJECT_CONSTANTS.interest_log);
			if(lastInterestLog != null && bomanager != null) bomanager.updateBusinessObject(lastInterestLog);
		}
	}
}
