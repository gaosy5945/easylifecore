package com.amarsoft.app.accounting.interest.accrue.impl;

import java.util.List;

import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.accounting.interest.accrue.InterestAccruer;
import com.amarsoft.app.accounting.interest.calc.InterestCalculator;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.script.ScriptConfig;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.StringX;

/**
 * 宽限期、节假日期内不计算罚息、复利
 * 
 * @author Amarsoft核算团队
 */
public class PaymentScheduleInterestAccruer extends InterestAccruer {

	
	public String getLastSettleDate(BusinessObject interestObject) throws Exception {
		String initDate = interestObject.getString("PayDate");
		String settleTermUnit = CashFlowConfig.getInterestAttribute(interestType, "SettleTermUnit");
		int settleTerm = Integer.parseInt(CashFlowConfig.getInterestAttribute(interestType, "SettleTerm"));
		String lastSettleDate = DateHelper.getRelativeDate(initDate, settleTermUnit, getPeriod(initDate,settleTermUnit,settleTerm)-1);
		return lastSettleDate;
		
	}
	
	public String getNextSettleDate(BusinessObject interestObject) throws Exception {
		String initDate = interestObject.getString("PayDate");
		String settleTermUnit = CashFlowConfig.getInterestAttribute(interestType, "SettleTermUnit");
		int settleTerm = Integer.parseInt(CashFlowConfig.getInterestAttribute(interestType, "SettleTerm"));
		String nextSettleDate = DateHelper.getRelativeDate(initDate, settleTermUnit, getPeriod(initDate,settleTermUnit,settleTerm));
		return nextSettleDate;
	}
	
	private int getPeriod(String fromDate,String settleTermUnit,int settleTerm) throws Exception 
	{
		int period = 1;
		if(DateHelper.TERM_UNIT_DAY.equalsIgnoreCase(settleTermUnit))
		{
			int days = DateHelper.getDays(fromDate, businessObject.getString("BusinessDate"));
			
			period = days/settleTerm+(days%settleTerm > 0 ? 1 : 0);
		}
		else if(DateHelper.TERM_UNIT_MONTH.equalsIgnoreCase(settleTermUnit))
		{
			period = (int)Math.ceil(DateHelper.getMonths(fromDate, businessObject.getString("BusinessDate")));
		}
		else if(DateHelper.TERM_UNIT_YEAR.equalsIgnoreCase(settleTermUnit))
		{
			settleTerm = settleTerm*12;
			int months = (int)Math.ceil(DateHelper.getMonths(fromDate, businessObject.getString("BusinessDate")));
			period = months/settleTerm+(months%settleTerm > 0 ? 1 : 0);
		}
		else
		{
			throw new ALSException("EC3018",interestType);
		}
		if(period <= 0) period = 1;
		return period;
	}

	@Override
	public List<BusinessObject> getInterestObjects() throws Exception {
		String condition = CashFlowConfig.getInterestAttribute(interestType, "Condition");
		if(StringX.isEmpty(condition)) condition = "";
		else if(!condition.toLowerCase().trim().startsWith("and")) condition = " and "+condition;
		List<BusinessObject> interestObjects=businessObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule, 
				"InteDate < :BusinessDate and InteDate <> null and InteDate <> '' and PSType=:PSType "+condition, "BusinessDate",businessObject.getString("BusinessDate"),"PSType",psType);
		return interestObjects;
	}
	
	
	public double getInterestRate(BusinessObject interestObject,String fromDate,String toDate) throws Exception{
		String lastSettleDate=this.getLastSettleDate(interestObject);
		String nextSettleDate=this.getNextSettleDate(interestObject);
		String interestEffectScript = CashFlowConfig.getInterestAttribute(interestType,rateType, "InterestEffectScript");
		if(StringX.isEmpty(interestEffectScript)) return 0d;
		boolean b = (boolean)ScriptConfig.executeELScript(interestEffectScript, "businessObject",businessObject,"interestObject",interestObject);
		if (!b) return 0d;
		List<BusinessObject> rateSegmentList =businessObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rate_segment, "Status='1' and RateType='"+rateType+"'");
		double rate=0d;
		for (BusinessObject rateSegment : rateSegmentList){
			rate+=InterestCalculator.getInterestCalculator(businessObject, interestType,psType)
				.getInterest(1.0d, rateSegment, lastSettleDate, nextSettleDate, fromDate, toDate);
		}
		return rate;
	}
	
	public BusinessObject settleInterest(BusinessObject interestObject,double baseAmount,String settleDate) throws Exception {
		String nextSettleDate=this.getNextSettleDate(interestObject);
		String lastSettleDate=this.getLastSettleDate(interestObject);
		if(StringX.isEmpty(nextSettleDate)||nextSettleDate.compareTo(lastSettleDate)<=0) return null;

		BusinessObject lastInterestLog = businessObject.getBusinessObjectBySql(BUSINESSOBJECT_CONSTANTS.interest_log," ObjectType=:ObjectType and ObjectNo=:ObjectNo and RateType=:RateType and InterestType=:InterestType and (NextSerialNo=null or NextSerialNo='')"
				,"ObjectType",interestObject.getBizClassName(),"ObjectNo",interestObject.getKeyString(),"RateType",rateType,"InterestType",interestType);
		if(lastInterestLog!=null&&StringX.isEmpty(lastInterestLog.getString("SettleDate"))){
			if(Math.abs(baseAmount-lastInterestLog.getDouble("BaseAmount")) < 0.00000001){//如果计息基础一致，则继续计息
				this.accrueInterestLog(interestObject,lastInterestLog,settleDate,nextSettleDate);
				return lastInterestLog;
			}
			else{//如果计息基础不一致，则将原来的一条结掉,新建一条
				this.accrueInterestLog(interestObject,lastInterestLog, settleDate,nextSettleDate);
				lastInterestLog.setAttributeValue("SettleDate",settleDate);
			}
		}
		
		double amount = this.getBaseAmount(interestObject);
		if(baseAmount > amount) baseAmount = amount;
		
		//如果没有或计息基础不一致，则也新建一条interestLog
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
		interestLog.setAttributeValue("SettleDate", settleDate);
		accrueInterestLog(interestObject,interestLog, settleDate,nextSettleDate);
		if(lastInterestLog!=null){//等计算完成利息后再赋值，避免取上次结息日出错
			lastInterestLog.setAttributeValue("NextSerialNo",interestLog.getKeyString());
			if(bomanager != null) bomanager.updateBusinessObject(lastInterestLog);
		}
		businessObject.appendBusinessObject(interestLog.getBizClassName(), interestLog);
		if(bomanager != null) bomanager.updateBusinessObject(interestLog);
		return interestLog;
	}
}
