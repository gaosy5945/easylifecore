package com.amarsoft.app.accounting.interest.rate.reprice.impl;


import com.amarsoft.app.accounting.interest.rate.reprice.RepriceMethod;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;

/**
 * 按月调
 * @author Amarsoft 核算团队
 *
 */
public class RepriceMethod4 extends RepriceMethod{
	
	public String getNextRepriceDate(BusinessObject loan,BusinessObject rateSegment) throws Exception
	{
		String putoutDate = loan.getString("PutoutDate");
		String nextRepriceDate = "";
		String businessDate = loan.getString("BusinessDate");
		
		int iMonth = (int)Math.floor(DateHelper.getMonths(putoutDate, businessDate));
		nextRepriceDate = DateHelper.getRelativeDate(putoutDate, DateHelper.TERM_UNIT_MONTH, iMonth);
		while (nextRepriceDate.compareTo(businessDate) <= 0){
			iMonth++;
			nextRepriceDate = DateHelper.getRelativeDate(putoutDate, DateHelper.TERM_UNIT_MONTH,iMonth);
		}
		
		return nextRepriceDate;
	}
}
