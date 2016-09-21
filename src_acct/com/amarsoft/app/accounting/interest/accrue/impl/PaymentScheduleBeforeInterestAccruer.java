package com.amarsoft.app.accounting.interest.accrue.impl;

import java.util.List;

import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.accounting.interest.calc.InterestCalculator;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.script.ScriptConfig;
import com.amarsoft.are.lang.StringX;

/**
 * 宽限期、节假日期内采用正常利率计算罚息
 * 
 * @author Amarsoft核算团队
 *
 */
public class PaymentScheduleBeforeInterestAccruer extends PaymentScheduleInterestAccruer {
	
	public double getInterestRate(BusinessObject interestObject,String fromDate,String toDate) throws Exception{
		String lastSettleDate=this.getLastSettleDate(interestObject);
		String nextSettleDate=this.getNextSettleDate(interestObject);
		String interestEffectScript = CashFlowConfig.getInterestAttribute(interestType,rateType, "InterestEffectScript");
		if(StringX.isEmpty(interestEffectScript)) return 0d;
		boolean b = (boolean)ScriptConfig.executeELScript(interestEffectScript, "businessObject",businessObject,"interestObject",interestObject);
		if (!b) return 0d;
		List<BusinessObject> rateSegmentList =businessObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rate_segment, "Status='1' and RateType='01'");//正常利率
		double rate=0d;
		for (BusinessObject rateSegment : rateSegmentList){
			rate+=InterestCalculator.getInterestCalculator(businessObject, interestType,psType)
				.getInterest(1.0d, rateSegment, lastSettleDate, nextSettleDate, fromDate, toDate);
		}
		return rate;
	}
	
	
	public List<BusinessObject> getInterestObjects() throws Exception {
		String condition = CashFlowConfig.getInterestAttribute(interestType, "Condition");
		if(StringX.isEmpty(condition)) condition = "";
		else if(!condition.toLowerCase().trim().startsWith("and")) condition = " and "+condition;
		List<BusinessObject> interestObjects=businessObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule, 
				" PayDate <= :BusinessDate and InteDate <> null and InteDate <> '' and InteDate >=:BusinessDate and PSType=:PSType "+condition, "BusinessDate",businessObject.getString("BusinessDate"),"PSType",psType);
		return interestObjects;
	}
}
