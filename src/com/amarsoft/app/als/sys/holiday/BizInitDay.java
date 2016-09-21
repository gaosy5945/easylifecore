package com.amarsoft.app.als.sys.holiday;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import com.amarsoft.app.als.sys.tools.SystemConst;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class BizInitDay {

	BizObjectManager bm;
	List<BizObject> bizlist;
	Calendar c = Calendar.getInstance();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
	private String area =  "";//����
	private String beginDate = "";
	private String endDate = "";
	
	
	public String getArea() {
		return area;
	}


	public void setArea(String area) {
		this.area = area;
	}


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


	public String run(JBOTransaction tx)
			throws Exception {
		int totalDay = 0;	//ѡ����������������������ʼ����
		String curDate = "";//��ǰ����
		

		totalDay = DateHelper.getDays(beginDate, endDate);
		curDate = beginDate;
		
		bm = JBOFactory.getBizObjectManager(SystemConst.JBO_ACCT_WORK_REGISTER);
		bizlist = bm.createQuery("select CurDate from O where CurDate >= '"+beginDate+"' and curDate <= '"+endDate+"' and CalendarType =:CalendarType")
				.setParameter("CalendarType", area).getResultList(false);
		
		for(int i = 0; i <= totalDay; i++)
		{
			Date d = sdf.parse(curDate);
			c.setTime(d);
			if(!isExistRecord(curDate, area)){
				saveWorkRegister(curDate, area);
			}
			curDate = nextDay();
		}
		return "true";
	}
	
	
	/**
	 * ��ǰ�����Ƿ���������������
	 * @param curDate
	 * @param area
	 * @return
	 * @throws JBOException
	 */
	private boolean isExistRecord(String curDate, String area) throws JBOException{
		if(bizlist == null || bizlist.size() == 0)
			return false;
		
		for(BizObject bo : bizlist)
			if(curDate.equals(bo.getAttribute("CurDate").toString()))
				return true;
		
		return false;
	}
	
	/**
	 * ���ù����պ���Ϣ��
	 * @param curDate
	 * @param area
	 * @throws JBOException 
	 * @throws ParseException 
	 */
	private void saveWorkRegister(String curDate, String area) throws JBOException, ParseException{
		BizObject newBO = bm.newObject();
		newBO.setAttributeValue("CurDate", curDate);
		newBO.setAttributeValue("CalendarType", area);
		if(isWorkDay()) {
			newBO.setAttributeValue("WorkFlag", "1");//������
		} else {
			newBO.setAttributeValue("WorkFlag", "2");//�ڼ���
		}
		
		bm.saveObject(newBO);
	}
	
	/**
	 * �Ƿ��ǹ�����
	 * @param curDate
	 * @param area
	 * @return
	 * @throws ParseException 
	 * 
	 */
	private boolean isWorkDay() throws ParseException{
		//1�����գ�2����һ��������7������
		int star = c.get(Calendar.DAY_OF_WEEK);
		if(star > 1 && star < 7)
			return true;
		
		return false;
	}
	
	/**
	 * ������һ�������
	 * @param curDate
	 * @return
	 * @throws ParseException
	 */
	private String nextDay() throws ParseException{
		c.add(Calendar.DATE, +1);
		return sdf.format(c.getTime());
	}

}
