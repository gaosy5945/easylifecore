package com.amarsoft.app.als.sys.holiday;

import java.util.List;
import com.amarsoft.app.als.sys.tools.SystemConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 
 * @author gfTang
 * 得到展示月份的节假日维护情况
 *
 */
public class SelectCalendar extends Bizlet{

	@SuppressWarnings("unchecked")
	public Object run(Transaction Sqlca) throws Exception {
		//定义变量
		String sReturn = "";
		boolean flag = false;
		
		String sCurDate = (String) this.getAttribute("CurDate");
		String sArea = (String) this.getAttribute("Area");
		if(sCurDate.split("/")[1].length()==1){
			sCurDate = sCurDate.split("/")[0]+"/0"+sCurDate.split("/")[1];
		}
		
		//将空值转化为空字符串
		if(sCurDate == null) sCurDate = "";
	   	if(sArea==null) sArea="";
	   	
	   	try{
	   		BizObjectManager bm = JBOFactory.getBizObjectManager(SystemConst.JBO_ACCT_WORK_REGISTER);
	   		List<BizObject> boList = bm.createQuery("select CurDate,WorkFlag from O where CurDate like :CurDate and CalendarType=:CalendarType")
	   				.setParameter("CurDate", sCurDate+"%").setParameter("CalendarType", sArea).getResultList(false);
	   		
	   		if(boList.size()>0){
	   			if(!flag){
	   				flag=true;
	   			}
	   			for(BizObject bo:boList)
	   			sReturn += bo.getAttribute("CurDate").getString()+","+bo.getAttribute("WorkFlag")+"@";
	   		}
	   		if(flag){
	   			sReturn = sReturn.substring(0, sReturn.length()-1);
	   		}
	   		return sReturn;
	   	}catch (Exception e) {
			e.printStackTrace();
			return sReturn;
		}
	}

}
