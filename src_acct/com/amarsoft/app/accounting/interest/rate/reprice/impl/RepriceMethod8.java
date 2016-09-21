package com.amarsoft.app.accounting.interest.rate.reprice.impl;


import com.amarsoft.app.accounting.interest.rate.reprice.RepriceMethod;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.StringX;

/**
 * 按月调
 * @author Amarsoft 核算团队
 *
 */
public class RepriceMethod8 extends RepriceMethod{
	
	public String getNextRepriceDate(BusinessObject loan,BusinessObject rateSegment) throws Exception
	{
		String lastRepriceDate = rateSegment.getString("LastRepriceDate");
		String putoutDate = loan.getString("PutoutDate");
		if(StringX.isEmpty(lastRepriceDate)) lastRepriceDate = putoutDate;
		String nextRepriceDate = "";
		String businessDate = loan.getString("BusinessDate");
		
		String firstRepriceDate = rateSegment.getString("DEFAULTREPRICEDATE");// 首次利率重定价日期
		if (StringX.isEmpty(firstRepriceDate))
			firstRepriceDate = rateSegment.getString("LastRepriceDate");
		String fren = rateSegment.getString("RepriceTermUnit");// 重定价周期单位
		int cyc = rateSegment.getInt("RepriceTerm");// 重定价周期
		if (StringX.isEmpty(firstRepriceDate) || StringX.isEmpty(fren) || cyc <= 0)
			throw new ALSException("ED1025",firstRepriceDate,fren,String.valueOf(cyc));
		// 如果输入的首次调整日期比当前日期大则直接取值
		if (firstRepriceDate.compareTo(businessDate) > 0)
			nextRepriceDate = firstRepriceDate;
		else {
			if (fren.equals(DateHelper.TERM_UNIT_DAY)) {
				int iDay = DateHelper.getDays(firstRepriceDate, businessDate);
				nextRepriceDate = DateHelper.getRelativeDate(firstRepriceDate, DateHelper.TERM_UNIT_DAY,
						(iDay / cyc) * cyc);
				while (nextRepriceDate.compareTo(businessDate) <= 0)
					nextRepriceDate = DateHelper.getRelativeDate(firstRepriceDate, DateHelper.TERM_UNIT_DAY,
							(iDay / cyc) * cyc + cyc);
			} else if (fren.equals(DateHelper.TERM_UNIT_MONTH)) {
				int month = (int)Math.floor(DateHelper.getMonths(firstRepriceDate, businessDate));
				nextRepriceDate = DateHelper.getRelativeDate(firstRepriceDate, DateHelper.TERM_UNIT_MONTH,
						(month / cyc) * cyc);
				while (nextRepriceDate.compareTo(businessDate) <= 0)
					nextRepriceDate = DateHelper.getRelativeDate(firstRepriceDate,
							DateHelper.TERM_UNIT_MONTH, (month / cyc) * cyc + cyc);
			} else if (fren.equals(DateHelper.TERM_UNIT_YEAR)) {
				int year = DateHelper.getYears(firstRepriceDate, businessDate);
				nextRepriceDate = DateHelper.getRelativeDate(firstRepriceDate, DateHelper.TERM_UNIT_YEAR,
						(year / cyc) * cyc);
				while (nextRepriceDate.compareTo(businessDate) <= 0)
					nextRepriceDate = DateHelper.getRelativeDate(firstRepriceDate, DateHelper.TERM_UNIT_YEAR,
							(year / cyc) * cyc + cyc);
			}
		}
		return nextRepriceDate;
	}
}
