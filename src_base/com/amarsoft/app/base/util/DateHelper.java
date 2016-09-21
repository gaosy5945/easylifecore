package com.amarsoft.app.base.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

/**
 * ���ڴ���
 * 
 * @author �����Ŷ�
 * 
 * xjzhao@amarsoft.com �޸�������̬�������ڴ��룬��010��020��030�ֱ��޸�ΪD��M��Y�����ڴ����⣬��ֵ���벻ֱ̫��
 * 
 */
public final class DateHelper{
	//���ڸ�ʽ
	public static final String AMR_NOMAL_TIME_FORMAT = "HH:mm:ss";
	public static final String AMR_NOMAL_DATE_FORMAT = "yyyy/MM/dd";
	public static final String AMR_NOMAL_DATETIME_FORMAT = "yyyy/MM/dd HH:mm:ss";
	public static final String AMR_NOMAL_FULLDATETIME_FORMAT = "yyyy/MM/dd HH:mm:ss.SSS";
	public static final String AMR_NOMAL_FULLTIME_FORMAT = "HH:mm:ss.SSS";
	
	public static final String TERM_UNIT_DAY = "D";// ������
	public static final String TERM_UNIT_MONTH = "M";// ������
	public static final String TERM_UNIT_YEAR = "Y";// ������

	private static String businessDate;
	
	/**
	 * ��ȡ��ǰӪҵ����
	 * @return
	 * @throws Exception
	 */
	public static String getBusinessDate() throws Exception{
		if(businessDate==null||"".equals(businessDate) || businessDate.length() != 10)
		{
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.SYSTEM_SETUP");
			List<?> boList = bm.createQuery("O.BusinessDate is not null").getResultList(false);
			if(boList == null||boList.isEmpty())
				throw new Exception("ϵͳ����δ���壬����ϵϵͳ����Ա���ã�");
			
			businessDate = ((BizObject)boList.get(0)).getAttribute("BusinessDate").toString();
			if(StringX.isEmpty(businessDate))
				throw new Exception("ϵͳ����δ���壬����ϵϵͳ����Ա���ã�");
		}
		return businessDate;
	}
	
	
	public static String getBusinessTime() throws Exception{
		return getBusinessDate()+" "+DateX.format(new Date(),AMR_NOMAL_TIME_FORMAT);
	}
	
	/**
	 * ֱ������ϵͳӪҵ����
	 * @param BusinessDate
	 * @throws Exception
	 */
	public static void setBusinessDate(String BusinessDate) throws Exception{
		DateHelper.businessDate = BusinessDate;
	}
	
	public static String getRelativeDate(String date, String termUnit, String term) throws Exception {
		return DateHelper.getRelativeDate(date, date, termUnit, Integer.parseInt(term));
	}
	
	public static String getRelativeDate(String date, String termUnit, int term) throws Exception {
		return DateHelper.getRelativeDate(date, date, termUnit, term);
	}

	public static String getRelativeDate(String baseDate, boolean endOfMonth, String date, String termUnit, int term)
			throws Exception {
		if (term == 0) {
			return date;
		}

		if (!TERM_UNIT_DAY.equals(termUnit) && !TERM_UNIT_MONTH.equals(termUnit) && !TERM_UNIT_YEAR.equals(termUnit)) {
			throw new ALSException("ED1027",termUnit);
		}

		Calendar cal = Calendar.getInstance();
		SimpleDateFormat formatter = new SimpleDateFormat(AMR_NOMAL_DATE_FORMAT);
		cal.setTime(formatter.parse(date));
		if (termUnit.equals(DateHelper.TERM_UNIT_DAY)) {
			cal.add(Calendar.DATE, term);
		} else if (termUnit.equals(DateHelper.TERM_UNIT_MONTH)) {
			cal.add(Calendar.MONTH, term);
			
			if (DateHelper.monthEnd(baseDate) && endOfMonth) {
				String s = formatter.format(cal.getTime());
				return DateHelper.getEndDateOfMonth(s);
			}

		} else if (termUnit.equals(DateHelper.TERM_UNIT_YEAR)) {
			cal.add(Calendar.YEAR, term);
		}

		return formatter.format(cal.getTime());
	}

	public static String getRelativeDate(String baseDate, String date, String termUnit, int step) throws Exception {
		return DateHelper.getRelativeDate(baseDate, false, date, termUnit, step);
	}

	/**
	 * ��ú͸�������BeginDate��EndDate����������ȡ����ֱ���׵�С��λ��
	 */
	public static double getTermPeriod(String BeginDate, String EndDate, String termUnit, int step) throws Exception {
		if (step <= 0) {
			throw new ALSException("ED1028");
		}
		if (!TERM_UNIT_DAY.equals(termUnit) && !TERM_UNIT_MONTH.equals(termUnit) && !TERM_UNIT_YEAR.equals(termUnit)) {
			throw new ALSException("ED1027",termUnit);
		}
		double result=0d;
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat formatter = new SimpleDateFormat(AMR_NOMAL_DATE_FORMAT);
		cal.setTime(formatter.parse(BeginDate));
		if (termUnit.equals(DateHelper.TERM_UNIT_DAY)) {
			result = getDays(BeginDate, EndDate) / (step*1.0);
		} else if (termUnit.equals(DateHelper.TERM_UNIT_MONTH)) {
			result = getMonths(BeginDate, EndDate) / (step*1.0);
		} else {
			result = getYears(BeginDate, EndDate) / (step*1.0);
		}
		
		return Arith.round(result,5);
	}

	public static boolean monthEnd(String date) throws ParseException {
		return date.equals(getEndDateOfMonth(date));
	}

	/**
	 * �õ��µ�
	 */
	public static String getEndDateOfMonth(String curDate) throws ParseException {
		if (curDate == null || curDate.length() != 10) {
			return null;
		}
		curDate = curDate.substring(0, 8) + "01";
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat formatter = new SimpleDateFormat(AMR_NOMAL_DATE_FORMAT);
		cal.setTime(formatter.parse(curDate));
		int maxDays = cal.getActualMaximum(Calendar.DATE);// �õ����µ��������
		cal.set(Calendar.DATE, maxDays);
		return formatter.format(cal.getTime());
	}

	public static Date getDate(String curDate) throws ParseException {
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat formatter = new SimpleDateFormat(AMR_NOMAL_DATE_FORMAT);
		cal.setTime(formatter.parse(curDate));
		return cal.getTime();
	}

	/**
	 * @param date yyyy/MM/dd
	 * @param type 1 �������� 2 �������� 3 ����Ӣ�� �������� 1 ����һ ��2 ���ڶ� ��3��������4 �����ġ�5 �����塢6
	 *            ��������7 ������
	 */
	public static String getWeekDay(String date, String format) throws ParseException {
		String[] sWeekDates = { "������", "����һ", "���ڶ�", "������", "������", "������", "������" };
		String[] sWeekDatesE = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" };
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
		cal.setTime(formatter.parse(date));
		if (format.equals("2")) {
			return sWeekDates[cal.get(Calendar.DAY_OF_WEEK) - 1];
		} else if (format.equals("3")) {
			return sWeekDatesE[cal.get(Calendar.DAY_OF_WEEK) - 1];
		} else {
			return String.valueOf(cal.get(Calendar.DAY_OF_WEEK) - 1);
		}
	}

	/**
	 * @param beginDate
	 * @param endDate
	 * @return
	 * @throws ParseException ��ȡ��������֮�������
	 */
	public static int getDays(String sBeginDate, String sEndDate) {
		Date startDate = java.sql.Date.valueOf(sBeginDate.replace('/', '-'));
		Date endDate = java.sql.Date.valueOf(sEndDate.replace('/', '-'));

		int iDays = (int) ((endDate.getTime() - startDate.getTime()) / 86400000L);
		return iDays;
	}

	/**
	 * ��ȡ��������֮�������������С����ʾ��
	 * �û��ɸ���ʹ�ó���ȷ�������ϡ�����ȡ����ȡ��ʱ��ע��������
	 * 
	 * @param beginDate
	 * @param endDate
	 * @return
	 * @throws ParseException
	 * @author xjzhao@amarsoft.com
	 */
	public static double getMonths(String beginDate1, String endDate1) throws ParseException {
		Date beginDate = getDate(beginDate1);
		Date endDate = getDate(endDate1);
		Calendar former = Calendar.getInstance();
		Calendar latter = Calendar.getInstance();
		former.setTime(beginDate);
		latter.setTime(endDate);

		int monthCounter = (latter.get(Calendar.YEAR) - former.get(Calendar.YEAR)) * 12 + latter.get(Calendar.MONTH) - former.get(Calendar.MONTH);
		
		former.add(Calendar.MONTH, monthCounter);
		
		int dayCounter = latter.get(Calendar.DAY_OF_MONTH)-former.get(Calendar.DAY_OF_MONTH);
		int maxDays = latter.getActualMaximum(Calendar.DATE);
		
		return monthCounter*1.0 + dayCounter*1.0/maxDays*1.0;
	}
	
	/**
	 * ��ȡ��������֮������� add by xjzhao 2011/04/06
	 * 
	 * @param beginDate
	 * @param endDate
	 * @return
	 * @throws ParseException
	 * @throws ParseException
	 * 
	 */
	public static int getYears(String beginDate1, String endDate1) throws ParseException {
		Date beginDate = getDate(beginDate1);
		Date endDate = getDate(endDate1);
		Calendar former = Calendar.getInstance();
		Calendar latter = Calendar.getInstance();
		former.clear();
		latter.clear();
		boolean positive = true;
		if (beginDate.after(endDate)) {
			former.setTime(endDate);
			latter.setTime(beginDate);
			positive = false;
		} else {
			former.setTime(beginDate);
			latter.setTime(endDate);
		}

		int yearCounter = 0;
		while (former.get(Calendar.YEAR) != latter.get(Calendar.YEAR)) {
			former.add(Calendar.YEAR, 1);
			yearCounter++;
		}

		if (positive)
			return yearCounter;
		else
			return -yearCounter;
	}

	/**
	 * �ж��Ƿ�Ϊ����
	 * 
	 * @param year (int)
	 * @return
	 */
	public static boolean isLeapYear(int year) {
		if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * �ж��Ƿ�Ϊ����
	 * 
	 * @param date ��String��yyyy/mm/dd
	 * @return
	 */
	public static boolean isLeapYear(String date) throws Exception {
		return isLeapYear(Integer.parseInt(date.split("/")[0]));
	}

}
