package com.amarsoft.app.accounting.interest.rate.reprice.impl;


import com.amarsoft.app.accounting.interest.rate.reprice.RepriceMethod;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;

/**
 * 次年对月对日
 * @author Amarsoft 核算团队
 *
 */
public class RepriceMethod3 extends RepriceMethod{
	
	public String getNextRepriceDate(BusinessObject loan,BusinessObject rateSegment) throws Exception
	{
		String putoutDate = loan.getString("PutoutDate");
		String nextRepriceDate = "";
		String businessDate = loan.getString("BusinessDate");
		
		int years = DateHelper.getYears(putoutDate, businessDate);
		nextRepriceDate = DateHelper.getRelativeDate(putoutDate, DateHelper.TERM_UNIT_YEAR,years);
		while (nextRepriceDate.compareTo(businessDate) <= 0){
			years++;
			nextRepriceDate = DateHelper.getRelativeDate(putoutDate, DateHelper.TERM_UNIT_YEAR, years);
		}
		return nextRepriceDate;
	}
}
