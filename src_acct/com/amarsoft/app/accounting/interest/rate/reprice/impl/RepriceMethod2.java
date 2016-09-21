package com.amarsoft.app.accounting.interest.rate.reprice.impl;


import com.amarsoft.app.accounting.interest.rate.reprice.RepriceMethod;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;

/**
 * �����
 * @author Amarsoft �����Ŷ�
 *
 */
public class RepriceMethod2 extends RepriceMethod{
	
	public String getNextRepriceDate(BusinessObject loan,BusinessObject rateSegment) throws Exception
	{
		String businessDate = loan.getString("BusinessDate");
		return DateHelper.getRelativeDate(businessDate, DateHelper.TERM_UNIT_YEAR, 1).substring(0,4)+ "/01/01";
	}
}
