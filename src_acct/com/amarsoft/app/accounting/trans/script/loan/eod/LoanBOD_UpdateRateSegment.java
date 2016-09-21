package com.amarsoft.app.accounting.trans.script.loan.eod;

import java.util.List;

import com.amarsoft.app.accounting.interest.rate.reprice.RepriceMethod;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.util.RateHelper;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;

/**
 * 贷款日初处理：利率调整
 * 
 * @author Amarsoft核算团队
 * 
 */
public final class LoanBOD_UpdateRateSegment extends TransactionProcedure{

	public int run() throws Exception {
		BusinessObject loan = transaction.getBusinessObject(BUSINESSOBJECT_CONSTANTS.loan);
		List<BusinessObject> rateSegmentList = loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rate_segment,"Status='1' and (SegToDate = null or SegToDate='' or SegToDate>:BusinessDate) and (SegFromDate = null or SegFromDate='' or SegFromDate<=:BusinessDate)","BusinessDate",loan.getString("BusinessDate"));// 利率信息
		for(BusinessObject rateSegment:rateSegmentList){
			String nextRepriceDate = rateSegment.getString("NextRepriceDate"); //下次利率调整日期
			if (!nextRepriceDate.equals(relativeObject.getString("BusinessDate"))) continue;
			rateSegment.setAttributeValue("NextRepriceDate", RepriceMethod.getRepriceMethod(rateSegment.getString("RepriceType")).getNextRepriceDate(relativeObject,rateSegment));
			updateBusinessRate(rateSegment);
		}
		return 1;
	}
	

	private BusinessObject updateBusinessRate(BusinessObject rateSegment) throws Exception {
		if(StringX.isEmpty(rateSegment.getString("BaseRateType"))) return null;
		String businessDate=relativeObject.getString("BusinessDate");
		double newBaseRate = 0.0d;
		if(RateHelper.exists(rateSegment.getString("BaseRateType"), relativeObject.getString("Currency"), businessDate))//如果无基准利率，则从其他利率类型中取数
		{
			newBaseRate = RateHelper.getBaseRate(relativeObject, rateSegment);
			setPSRestructureFlag("2");
		}else{
			int cnt = 0;
			List<BusinessObject> rateSegmentList = relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rate_segment,"Status='1' and (SegToDate = null or SegToDate='' or SegToDate>:BusinessDate) and (SegFromDate = nul or SegFromDate='' or SegFromDate<=:BusinessDate)","BusinessDate",relativeObject.getString("BusinessDate"));// 利率信息
			for(BusinessObject parentRateSegment:rateSegmentList)
			{
				if(parentRateSegment.getString("RateType").equals(rateSegment.getString("BaseRateType")))
				{
					cnt ++;
					newBaseRate = updateBusinessRate(parentRateSegment).getDouble("BusinessRate");
				}
			}
			
			if(cnt > 1) throw new ALSException("ED2016",rateSegment.getString("BaseRateType"));
			if(cnt <= 0) throw new ALSException("ED2017",rateSegment.getString("BaseRateType"));
		}
		
		
		double oldBaseRate = rateSegment.getDouble("BaseRate");
		double oldBusinessRate = rateSegment.getDouble("BusinessRate");
		if (Math.abs(oldBaseRate - newBaseRate) <= 0.000000001) return rateSegment;
		BusinessObject newRateSegment = BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.loan_rate_segment);
		newRateSegment.setValue(rateSegment);
		newRateSegment.generateKey(true);
		newRateSegment.setAttributeValue("SegFromDate",businessDate);
		newRateSegment.setAttributeValue("BaseRate", newBaseRate);
		double newBusinessRate = RateHelper.getBusinessRate(relativeObject, newRateSegment);
		if (Math.abs(newBusinessRate - oldBusinessRate) >= 0.000000001) {
			newRateSegment.setAttributeValue("BusinessRate", newBusinessRate);
			rateSegment.setAttributeValue("SegToDate", businessDate);
			relativeObject.appendBusinessObject(BUSINESSOBJECT_CONSTANTS.loan_rate_segment, newRateSegment);
			newRateSegment.setAttributeValue("LastRepriceDate", businessDate);// 如果贷款当前未到期
			bomanager.updateBusinessObject(rateSegment);
			bomanager.updateBusinessObject(newRateSegment);
			return newRateSegment;
		}
		else
		{
			return rateSegment;
		}
	}
	
	protected void setPSRestructureFlag(String flag) throws Exception {
		BusinessObject loan = transaction.getBusinessObject(BUSINESSOBJECT_CONSTANTS.loan);
		List<BusinessObject> rptList=loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment, 
				"Status='1' and PSType like :PSType", "PSType","1","BusinessDate",loan.getString("BusinessDate"));
		for(BusinessObject rpt:rptList){
			rpt.setAttributeValue("PSRestructureFlag", flag);
			this.bomanager.updateBusinessObject(rpt);
		}
	}
}