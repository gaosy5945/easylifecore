package com.amarsoft.app.awe.config.role.action;

import java.util.ArrayList;

import com.amarsoft.app.als.sys.tools.SystemConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.dict.als.manage.NameManager;
/**
 * 
 * 
 * 用户悬浮信息获取
 * @author gfTang ALS743升级
 *
 */
public class SYSUserInfoAction {
	
	public static ArrayList<String> userInfo(String userID) throws Exception {
	
		String noRecord = SystemConst.NORECORD;
		ArrayList<String> ar = new ArrayList<String>();
		BizObjectManager m = JBOFactory.getBizObjectManager(SystemConst.JAVA_USER_INFO);
		String sql = "USERID=:USERID";
		BizObject  biz= m.createQuery(sql)
						 .setParameter("USERID",userID)
						 .getSingleResult(false);
		
		String orgID = biz.getAttribute("BELONGORG").getString()==null?"":biz.getAttribute("BELONGORG").getString();
		String orgName =orgID.equals("")?noRecord: NameManager.getOrgName(orgID);
		String mobile = biz.getAttribute("MOBILETEL").getString()==null?noRecord:biz.getAttribute("MOBILETEL").getString();
		String email = biz.getAttribute("EMAIL").getString()==null?noRecord:biz.getAttribute("EMAIL").getString();
		String cretNo = biz.getAttribute("CERTID").getString()==null?noRecord:biz.getAttribute("CERTID").getString();
		ar.add(orgName);
		ar.add(mobile);
		ar.add(email);
		return ar;
	}
	
	

}
