package com.amarsoft.app.creditline;

import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Calendar;
import com.amarsoft.are.lang.DateX;

/**
 * 
 * @author zyang 2013/12/18
 * 根据合同起始日和期限计算到期日
 *
 */
public class CaculateMaturityDate 
{
	private String termDay;
	private String termMonth;
	private String termYear;
	private String putOutDate;

	public String getTermDay() {
		return termDay;
	}

	public void setTermDay(String termDay) {
		this.termDay = termDay;
	}

	public String getTermMonth() {
		return termMonth;
	}

	public void setTermMonth(String termMonth) {
		this.termMonth = termMonth;
	}

	public String getTermYear() {
		return termYear;
	}

	public void setTermYear(String termYear) {
		this.termYear = termYear;
	}

	public String getPutOutDate() {
		return putOutDate;
	}

	public void setPutOutDate(String putOutDate) {
		this.putOutDate = putOutDate;
	}

	public String calculateMaturityOfApprovePhase()
	{
		int year = formatTime(termYear);
		int month = formatTime(termMonth);
		int day = formatTime(termDay);
		
		Calendar cal =Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        
		try {
			cal.setTime(sdf.parse(putOutDate));
		} 
		catch (ParseException e) {
			e.printStackTrace();
		}
		cal.add(Calendar.YEAR, year);
        cal.add(Calendar.MONTH, month);
        cal.add(Calendar.DAY_OF_MONTH, day);
        
        String maturityOfApprovePhase = DateX.format(cal.getTime(), "yyyy/MM/dd");
        
        return maturityOfApprovePhase; 
	}
	
	private int formatTime(String time)
	{
		if(time == null || time.length() == 0 || time.equalsIgnoreCase("null")){
			return 0;
		}
		else{
			return Integer.parseInt(time);
		}
	}
}
