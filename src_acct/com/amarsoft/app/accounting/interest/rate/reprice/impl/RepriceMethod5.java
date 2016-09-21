package com.amarsoft.app.accounting.interest.rate.reprice.impl;


import com.amarsoft.app.accounting.interest.rate.reprice.RepriceMethod;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectHelper;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.StringX;

/**
 * ���µ�
 * @author Amarsoft �����Ŷ�
 *
 *δ������ƻ�������ȫ���ɣ��˲������ٵ���
 */
public class RepriceMethod5 extends RepriceMethod{
	
	public String getNextRepriceDate(BusinessObject loan,BusinessObject rateSegment) throws Exception
	{
		String lastRepriceDate = rateSegment.getString("LastRepriceDate");
		String putoutDate = loan.getString("PutoutDate");
		String maturityDate = loan.getString("MaturityDate");
		if(StringX.isEmpty(lastRepriceDate)) lastRepriceDate = putoutDate;
		String nextRepriceDate = "";
		String businessDate = loan.getString("BusinessDate");
		
		if (maturityDate.compareTo(businessDate) < 0){// ���ں���������
			nextRepriceDate = DateHelper.getRelativeDate(businessDate, DateHelper.TERM_UNIT_DAY, 1);
		}
		else{
			String psType="1";
			nextRepriceDate = (String)BusinessObjectHelper.getMinValue(loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule, "PSType=:PSType and PayDate>:BusinessDate",
					"PSType",psType,"BusinessDate",loan.getString("BusinessDate")),"PayDate");
		}
		if (nextRepriceDate.length() == 0)
			nextRepriceDate = DateHelper.getRelativeDate(businessDate, DateHelper.TERM_UNIT_DAY, 1);
		return nextRepriceDate;
	}
}
