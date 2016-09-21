package com.amarsoft.app.als.credit.common.action;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.JBOTransaction;

public class DateAction {
	private String beginDate;
	private String endDate;
	
	

	public String getBeginDate() {
		return beginDate;
	}

	public void setBeginDate(String beginDate) {
		this.beginDate = beginDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}



	public String calcTerm(JBOTransaction tx) throws Exception{
		
		if(beginDate == null || "".equals(beginDate)) return "0@0@0@0";
		if(endDate == null || "".equals(endDate)) return "0@0@0@0";
		
		int month = (int) Math.floor(DateHelper.getMonths(beginDate, endDate));
		
		int year = month/12;
		int otherMonth = month%12;
		
		String tempDate = DateHelper.getRelativeDate(beginDate, DateHelper.TERM_UNIT_MONTH, month);
		
		int day = DateHelper.getDays(tempDate, endDate);
		
		return month+"@"+day+"@"+year+"@"+otherMonth;
	}
	
}