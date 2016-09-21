package com.amarsoft.app.accounting.interest.accrue.impl;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.cashflow.due.DueDateScript;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.accounting.interest.accrue.InterestAccruer;
import com.amarsoft.app.accounting.interest.calc.InterestCalculator;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.script.ScriptConfig;
import com.amarsoft.are.lang.StringX;

public class LoanInterestAccruer extends InterestAccruer {

	@Override
	public String getLastSettleDate(BusinessObject interestObject) throws Exception {
		String lastSettleDate = "";
		String filter=" ObjectType=:ObjectType and ObjectNo=:ObjectNo and InterestType=:InterestType and RateType=:RateType and (NextSerialNo=null or NextSerialNo='')";
		List<BusinessObject> interestLogList = businessObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.interest_log, filter,"ObjectType",interestObject.getBizClassName(),"ObjectNo",interestObject.getKeyString(),"InterestType",interestType,"RateType",rateType);
		for (BusinessObject interestLog : interestLogList) {
			String interestDate="";
			if(!StringX.isEmpty(interestLog.getString("SettleDate"))){
				interestDate = interestLog.getString("SettleDate");
			}
			else{
				interestDate = interestLog.getString("InterestDate");
			}
			if (StringX.isEmpty(lastSettleDate) || interestDate.compareTo(lastSettleDate) > 0)//取计息日最大的
				lastSettleDate = interestDate;
		}

		if (StringX.isEmpty(lastSettleDate))
			return interestObject.getString("PutoutDate");
		else
			return lastSettleDate;
	}

	@Override
	public String getNextSettleDate(BusinessObject interestObject) throws Exception {
		String nextPayDate = DueDateScript.getNextDueDate(businessObject,psType);
		return nextPayDate;
	}

	@Override
	public List<BusinessObject> getInterestObjects() throws Exception {
		List<BusinessObject> interestObjects=new ArrayList<BusinessObject>();
		interestObjects.add(this.businessObject);
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
		
		if(Math.abs(baseAmount-this.getBaseAmount(interestObject)) < 0.0000001)//如果计算金额等于贷款余额则采用正常结息方式处理
		{
			BusinessObject interestLog = settleInterest(interestObject,settleDate);
			interestLog.setAttributeValue("SettleDate", settleDate);
			BusinessObject lastInterestLog = interestLog.getBusinessObject(BUSINESSOBJECT_CONSTANTS.interest_log);
			if(lastInterestLog != null && bomanager != null) bomanager.updateBusinessObject(lastInterestLog);
			return interestLog;
		}
		else
		{
			String nextSettleDate=this.getNextSettleDate(interestObject);
			String lastSettleDate=this.getLastSettleDate(interestObject);
			if(StringX.isEmpty(nextSettleDate)||nextSettleDate.compareTo(lastSettleDate)<=0) return null;
	
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
			accrueInterestLog(interestObject,interestLog, settleDate,nextSettleDate);
			interestLog.setAttributeValue("NextSerialNo",interestLog.getKeyString());//提前还款结息默认NextSerialNo等于自己
			interestLog.setAttributeValue("SettleDate", settleDate);
			businessObject.appendBusinessObject(interestLog.getBizClassName(), interestLog);
			return interestLog;
		}
	}
}
