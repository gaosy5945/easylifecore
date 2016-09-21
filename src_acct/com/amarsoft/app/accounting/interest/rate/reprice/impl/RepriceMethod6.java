package com.amarsoft.app.accounting.interest.rate.reprice.impl;


import java.util.List;

import com.amarsoft.app.accounting.interest.rate.reprice.RepriceMethod;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.StringX;

/**
 * 次年首个还款日调整
 * @author Amarsoft 核算团队
 *
 *未来还款计划不再完全生成，此部分需再调整
 */
public class RepriceMethod6 extends RepriceMethod{
	
	public String getNextRepriceDate(BusinessObject loan,BusinessObject rateSegment) throws Exception
	{
		String lastRepriceDate = rateSegment.getString("LastRepriceDate");
		String putoutDate = loan.getString("PutoutDate");
		if(StringX.isEmpty(lastRepriceDate)) lastRepriceDate = putoutDate;
		String nextRepriceDate = "";
		String businessDate = loan.getString("BusinessDate");
		
		String nextYear = DateHelper.getRelativeDate(businessDate, DateHelper.TERM_UNIT_YEAR, 1).substring(0,5)+ "01/01";
		List<BusinessObject> a = loan.getBusinessObjects(BUSINESSOBJECT_CONSTANTS.payment_schedule);
		for (BusinessObject rpt : a) {
			if (nextYear.compareTo(rpt.getString("PayDate")) <= 0) {
				nextRepriceDate = rpt.getString("PayDate");
				break;
			}
		}
		if ("".equals(nextRepriceDate))
			nextRepriceDate = loan.getString("MaturityDate");
		
		return nextRepriceDate;
	}
}
