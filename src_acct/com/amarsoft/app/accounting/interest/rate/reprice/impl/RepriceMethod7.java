package com.amarsoft.app.accounting.interest.rate.reprice.impl;



import com.amarsoft.app.accounting.interest.rate.reprice.RepriceMethod;
import com.amarsoft.app.base.businessobject.BusinessObject;

/**
 * 次年首个还款日调整
 * @author Amarsoft 核算团队
 *
 */
public class RepriceMethod7 extends RepriceMethod{
	
	public String getNextRepriceDate(BusinessObject loan,BusinessObject rateSegment) throws Exception
	{
		return rateSegment.getString("LastRepriceDate");
	}
}
