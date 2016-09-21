package com.amarsoft.acct.accounting.web;

import com.amarsoft.app.base.util.DateHelper;

public class DateCal {
	public static String getRelativeDate(String date, String termUnit, String term){
		String dateTime="";
		try {
			dateTime = DateHelper.getRelativeDate(date, termUnit, Integer.parseInt(term));
		} catch (NumberFormatException e) { 
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return dateTime;
	}
}
