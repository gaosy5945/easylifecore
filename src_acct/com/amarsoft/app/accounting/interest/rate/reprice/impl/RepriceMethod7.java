package com.amarsoft.app.accounting.interest.rate.reprice.impl;



import com.amarsoft.app.accounting.interest.rate.reprice.RepriceMethod;
import com.amarsoft.app.base.businessobject.BusinessObject;

/**
 * �����׸������յ���
 * @author Amarsoft �����Ŷ�
 *
 */
public class RepriceMethod7 extends RepriceMethod{
	
	public String getNextRepriceDate(BusinessObject loan,BusinessObject rateSegment) throws Exception
	{
		return rateSegment.getString("LastRepriceDate");
	}
}
