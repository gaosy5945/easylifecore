package com.amarsoft.app.check;

import java.text.SimpleDateFormat;
import java.util.Calendar;

import com.amarsoft.app.als.sys.tools.SystemConst;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.DateX;

/**
 * 判断密码强制更新是否启用
 * 若启用，则在密码到期前十天给出修改密码的提示
 * @author gfTang 20140424
 *
 */
public class PasswordStateCheck {
	
	/**
	 * 判断密码强制更新是否启用，判断当前LOGINID的密码是否到期
	 * @param loginID
	 * @return
	 * @throws Exception 
	 */
	public static String getPasswordState(String userID) throws Exception{
		String dateValue="",isInuse="";
		String  today= DateHelper.getBusinessDate();
		String lastPWDDay="2000/01/01";
		Calendar cal =Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
		try{
			BizObjectManager bm = JBOFactory.getBizObjectManager(SystemConst.SECURITY_AUDIT);
			BizObject bo = bm.createQuery("CodeType='SecurityAuditOption' and ItemNo='0301' ").getSingleResult(false);
			if(bo!=null){
				dateValue = bo.getAttribute("ItemValue").getString();
				isInuse = bo.getAttribute("IsInuse").getString();
			}
			if(isInuse.equals(SystemConst.NO)) return SystemConst.NO;
			else{
				
				BizObjectManager userMarkInfobm = JBOFactory.getBizObjectManager(SystemConst.USER_MARKINFO);
				BizObject userMarkInfobo =  userMarkInfobm.createQuery("userID=:userID").setParameter("userID", userID).getSingleResult(false);
				if(userMarkInfobo!=null){
					String  PWDUpdate = userMarkInfobo.getAttribute("PASSWORDUPDATEDATE").getString();
					lastPWDDay = PWDUpdate==null?lastPWDDay:PWDUpdate;
				}
				cal.setTime(sdf.parse(lastPWDDay));
				 cal.add(Calendar.DAY_OF_MONTH, Integer.parseInt(dateValue)-10);
				 if(DateX.format(cal.getTime(), "yyyy/MM/dd").compareTo(today)==3){
					 return SystemConst.YES;
				 }
			}
		}catch(Exception e){
			ARE.getLog().error("登陆配置检查失败", e);
		}
		return SystemConst.NO;
	}
}
