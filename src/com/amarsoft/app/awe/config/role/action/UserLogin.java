package com.amarsoft.app.awe.config.role.action;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.amarsoft.app.als.sys.tools.SystemConst;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.util.ASUserObject;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * �û���¼��Ϣ���
 * gfTang ALS743����
 */

public class UserLogin {

	/**
	 * ��½��ݻ��
	 * @param loginID
	 * @return
	 * @throws Exception
	 */
	public static String[] getUsers(String loginID) throws Exception {
		
		Map<String,String>   map = new HashMap<String, String>();
		BizObjectManager bm = JBOFactory.getBizObjectManager(SystemConst.JAVA_USER_INFO);
		String sql = "LOGINID=:LOGINID and Status='1'";
		
		@SuppressWarnings("unchecked")
		List<BizObject> sList = bm.createQuery(sql)
								  .setParameter("LOGINID",loginID)
								  .getResultList(false);
		
		for(BizObject biz:sList){
			String userID = biz.getAttribute("USERID").getString();
			String userName = biz.getAttribute("USERNAME").getString();
			String belongOrg = biz.getAttribute("BELONGORG").getString();
			String orgName = NameManager.getOrgName(belongOrg);
			// String value = userName+orgName;
			String value = userName+"("+userID+")"+orgName;
			map.put(userID, value);
		}
		String[] returnUsers = new String[2*(map.size())];
		int i = 0;
		for(java.util.Iterator<String> it=map.keySet().iterator();it.hasNext();)
		{
			String mapID = it.next();
			String mapValue = map.get(mapID);
			returnUsers[i++]=mapID;
			returnUsers[i]=mapValue;
			i++;
		}
		
		return returnUsers;
		
		
	}
	

	/**
	 * �жϵ�¼���Ƿ��Ӧ����û���
	 * @param Sqlca
	 * @param LogInID
	 * @param PassWord
	 * @throws Exception
	 */
	public static String MultiCheck(Transaction Sqlca,String LogInID) throws Exception{
		
		String sQuery = "SELECT count(*) FROM USER_INFO WHERE LogInID=:LogInID AND STATUS = '1' ";
		SqlObject asql = new SqlObject(sQuery).setParameter("LogInID",LogInID);
		
		if(Integer.parseInt(Sqlca.getString(asql))>1)
			return "Multi";
		else
			return "Single";
	}
	
	/**
	 * @throws Exception 
	 * 
	 */
	public static Map<String,String> MultiUserDegree(String loginID) throws Exception {
		
		Map<String,String>   map = new HashMap<String, String>();
		BizObjectManager bm = JBOFactory.getBizObjectManager(SystemConst.JAVA_USER_INFO);
		String sql = "LOGINID=:LOGINID and Status='1'";
		
		@SuppressWarnings("unchecked")
		List<BizObject> sList = bm.createQuery(sql)
								  .setParameter("LOGINID",loginID)
								  .getResultList(false);
		
		for(BizObject biz:sList){
			String userID = biz.getAttribute("USERID").getString();
			String userName = biz.getAttribute("USERNAME").getString();
			String belongOrg = biz.getAttribute("BELONGORG").getString();
			String orgName = NameManager.getOrgName(belongOrg);
			// String value = userName+orgName;
			String value = NameManager.getUserName(userID)+"("+userID+")"+orgName;
			map.put(userID, value);
		}
		return map;
	}
	/**
	 * �����һ��һ�ĵ�¼ID��ȡ��Ӧ��UserID
	 * @param Sqlca
	 * @param LogInID
	 * @return
	 * @throws Exception 
	 */
	public static String getSingleUserID(Transaction Sqlca,String LogInID) throws Exception{
		String sQuery = "SELECT UserID FROM USER_INFO WHERE LogInID=:LogInID AND STATUS = '1'";
		SqlObject asql = new SqlObject(sQuery).setParameter("LogInID",LogInID);
		return Sqlca.getString(asql);
	}
	
	/**
	 * �жϵ�½��LoginID�� UserID�Ƿ�ƥ��Ϸ�
	 * @param LogInID
	 * @param UserID
	 * @return
	 * @throws Exception
	 */
	public static BizObject  getUserInfo(String LogInID,String UserID) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager(SystemConst.JAVA_USER_INFO);
		BizObject bo = bm.createQuery("LogInID=:LogInID and UserID=:UserID and Status='1' ")
					   .setParameter("LogInID", LogInID)
					   .setParameter("UserID", UserID).getSingleResult(false);
		
		return bo;
	}
	
	
	/**
	 * ��ȡ��ǰ�û��ϴε�¼��¼
	 * @return
	 * @throws JBOException
	 */
	public static List<BizObject> getCurUserLastRecord(String loginID,String sessionID) throws JBOException{
		
		BizObjectManager bm=JBOFactory.getBizObjectManager(SystemConst.JAVA_USER_LIST);
		List<BizObject> lst=bm.createQuery(" beginTime in (select max(beginTime) from O where sessionid<>:sessionId" +
											" and UserID in (select ui.userid from "+ SystemConst.JAVA_USER_INFO+" ui where ui.loginID=:loginID))")
							  .setParameter("sessionId", sessionID)
							  .setParameter("loginID", loginID)
							  .getResultList(false);
		return lst;
	} 
	
	/**
	 * ��ȡ��ǰ�û��ϴε�¼��¼
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getCurUserLastEndTime(String loginID,String sessionID) throws JBOException{
		BizObjectManager bm=JBOFactory.getBizObjectManager(SystemConst.JAVA_USER_LIST);
		BizObject bo=bm.createQuery(" beginTime in (select max(beginTime) from O where sessionid<>:sessionId" +
											" and UserID in (select ui.userid from "+ SystemConst.JAVA_USER_INFO+" ui where ui.loginID=:loginID)) and EndTime is null")
							  .setParameter("sessionId", sessionID)
							  .setParameter("loginID", loginID)
							  .getSingleResult(false);
		return bo;
	} 
	
	/**
	 * ��ȡ��ǰ�û��ϴε�¼��¼
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getCurUserLastLogin(String loginID,String sessionID) throws JBOException{
		BizObjectManager bm=JBOFactory.getBizObjectManager(SystemConst.JAVA_USER_LIST);
		BizObject bo=bm.createQuery(" beginTime in (select max(beginTime) from O where sessionid<>:sessionId" +
											" and UserID in (select ui.userid from "+ SystemConst.JAVA_USER_INFO+" ui where ui.loginID=:loginID))")
							  .setParameter("sessionId", sessionID)
							  .setParameter("loginID", loginID)
							  .getSingleResult(false);
		return bo;
	} 
	
	
	/**
	 * ��õ�ǰIP��ַδ�����˳����û�
	 * @param userID
	 * @return
	 * @throws JBOException
	 */
	public static List<BizObject> getCurIPUserList(String curIP,String sessionID) throws JBOException{
		BizObjectManager bm=JBOFactory.getBizObjectManager(SystemConst.JAVA_USER_LIST);
		List<BizObject> lst=bm.createQuery("remoteaddr=:ip  and endtime is null and sessionid<>:sessionId")
  							  //.setParameter("startTime", DateTool.getTime())
  							  .setParameter("ip", curIP)
							  .setParameter("sessionId", sessionID).getResultList(false);
		return lst;

	}
	
	
	/**
	 * ���iP��ַ
	 * @param request
	 * @return
	 */
	public static String getIpAddr(HttpServletRequest request){
		String ip=request.getHeader("X-Forwarded-For");
		if(ip==null || ip.length()==0 ||"unknown".equalsIgnoreCase(ip)){
			ip=request.getHeader("Proxy-Client-IP");
		} 
		if(ip==null || ip.length()==0 ||"unknown".equalsIgnoreCase(ip)){
			ip=request.getHeader("WL-Proxy-Client-IP");
		}
		if(ip==null || ip.length()==0 ||"unknown".equalsIgnoreCase(ip)){
			ip=request.getHeader("HTTP_CLIENT_IP");
		}
		if(ip==null || ip.length()==0 ||"unknown".equalsIgnoreCase(ip)){
			ip=request.getHeader("HTTP_X_FORWARDED_FOR");
		}
		if(ip==null || ip.length()==0 ||"unknown".equalsIgnoreCase(ip)){
			ip=request.getRemoteAddr();
		}
		return ip;
	}
	
	/**
	 * �ж�ֱ�ӵ�¼������
	 * @param loginID
	 * @param sessionID
	 * @param curIP
	 * @return
	 */
	public static boolean isLogonDirect(String loginID,String sessionID,String curIP){
		boolean returnResult = true;
		try {
			//��⵱ǰ�û��ϴ��Ƿ������˳�
			BizObject bo = UserLogin.getCurUserLastEndTime(loginID, sessionID);
			if(bo!=null){
				return false;//û�������˳�
			}
			//��⵱ǰ�����Ƿ��������û���ʹ��
			 List<BizObject> userLst=UserLogin.getCurIPUserList(curIP,sessionID);
			 if(userLst.size()>0){//�ϴ�δ�����˳������ߵ�ǰIP��ַ��½����û�
				return  false;
			 }
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return returnResult;
	}
	
	/**
	 * ��Session�л���û��Ƿ����
	 * @param application
	 * @param request
	 * @param session
	 * @param curUser
	 * @return
	 */
	public synchronized static Map<String,Object>  getSessionUser(ServletContext application,HttpServletRequest request,HttpSession session,String loginId){
		  String curip=getIpAddr(request);
		  HashMap userPool = (HashMap)application.getAttribute("ACTIVE_USER_POOL");
		  if(userPool==null) return null;
		  for(Iterator<String> it=userPool.keySet().iterator();it.hasNext();){
			  String key=it.next();
			  Map<String,Object> map=(Map<String,Object>)userPool.get(key);
			  String session_loginid=map.get("LoginID").toString();
			  String session_ip=map.get("IP").toString();
			  if(session_loginid.equalsIgnoreCase(loginId) || curip.equalsIgnoreCase(session_ip)) return map;
		  } 
		  return null;
	}
	/**
	 * ���û����ӵ�session��
	 * @param application
	 * @param session
	 * @param curUser
	 * @throws Exception 
	 */
	public   synchronized static void addSession(ServletContext application,HttpServletRequest request,HttpSession session,ASUser curUser) throws Exception{
		  String userId=curUser.getUserID();
		  ASUserObject userObject=ASUserObject.getUser(userId);//Ϊ�˻��LoginId;
		  HashMap userPool = (HashMap)application.getAttribute("ACTIVE_USER_POOL");
		  String ip=getIpAddr(request);
		  if(userPool==null){
			  userPool = new  HashMap();
			  application.setAttribute("ACTIVE_USER_POOL",userPool);
		  }
		  Map<String,Object> map=new HashMap<String,Object>();
		  map.put("IP", ip);
		  map.put("sessionid", session.getId());
		  map.put("session", session);
		  map.put("UserID", curUser.getUserID());
		  map.put("LoginID", userObject.getLoginID());
		  map.put("UserName", curUser.getUserName());
		  map.put("OrgID", curUser.getOrgID());
		  map.put("OrgName", curUser.getOrgName());
		  map.put("EntryTime", DateHelper.getBusinessDate());
		  userPool.put(session.getId(), map);
		  ARE.getLog().info("USER["+userId+"] LOGIN ["+session.getId()+"] COUNT["+userPool.size()+"]");
	}
	/**
	 * ���sessionInfo
	 * @param application
	 * @param request
	 * @param session
	 * @return
	 */
	public synchronized static Map<String,Object> getSessionInfo(ServletContext application,HttpServletRequest request,HttpSession session){
		  HashMap userPool = (HashMap)application.getAttribute("ACTIVE_USER_POOL");
		  String ip=getIpAddr(request);
		  if(userPool==null) return null;
		  if(userPool.get(session.getId())==null) return null;
		  return (Map<String,Object>)userPool.get(session.getId());
	}
	/**
	 * �Ƴ�
	 * @param application
	 * @param session
	 * @param curUser
	 */
	public  synchronized static void clearSession(ServletContext application,HttpServletRequest request,HttpSession session,String  sessionid){
		  HashMap userPool = (HashMap)application.getAttribute("ACTIVE_USER_POOL");
		  if(userPool==null) return ;
		  String ip=getIpAddr(request);
		  if(userPool==null) return ;
		  Map<String,Object> map=(HashMap<String,Object>)userPool.get(sessionid);
		  if(map==null) return ;
		  String userId=map.get("UserID").toString();
		  HttpSession sess=(HttpSession)map.get("session");
		  if(sess.isNew()) sess.invalidate();
		  userPool.remove(sessionid);
		  ARE.getLog().info("USER["+userId+"] REMOVE ["+session.getId()+"]  COUNT["+userPool.size()+"]");
	}
	
	
	/**
	 * �Ƴ�
	 * @param application
	 * @param session
	 * @param curUser
	 */
	public  synchronized static void removeSession(ServletContext application,HttpServletRequest request,HttpSession session,String  sessionid){
		  HashMap userPool = (HashMap)application.getAttribute("ACTIVE_USER_POOL");
		  if(userPool==null) return ;
		  String ip=getIpAddr(request);
		  if(userPool==null) return ;
		  Map<String,Object> map=(HashMap<String,Object>)userPool.get(sessionid);
		  if(map==null) return ;

		  String userId=map.get("UserID").toString();
		  userPool.remove(sessionid);
		  ARE.getLog().info("USER["+userId+"] REMOVE ["+session.getId()+"]  COUNT["+userPool.size()+"]");
	}
	
	
	/**
	 * 
	 * @param application
	 * @param request
	 * @param session
	 * @param userId
	 * @return
	 */
	public static boolean  getOnLineUser(ServletContext application,HttpServletRequest request,HttpSession session,String userId){
		 HashMap userPool = (HashMap)application.getAttribute("ACTIVE_USER_POOL");
		 HashMap ipPool = (HashMap)application.getAttribute("ACTIVE_IP_POOL");
		 String ip=getIpAddr(request);
		 if(userPool==null) return false;
		 if(userPool.get(userId)!=null) return true;
		 if(ipPool.get(ip)!=null){
			 return true;
		 }
		 return false;
	}
	
	/**
	 * 
	 * @param application
	 * @param request
	 * @param session
	 * @param userId
	 * @return
	 */
	public static String  getIpUser(ServletContext application,HttpServletRequest request,HttpSession session){
		 HashMap ipPool = (HashMap)application.getAttribute("ACTIVE_IP_POOL");
		 String ip=getIpAddr(request);
		 if(ipPool==null) return "";
		 if(ipPool.get(ip)==null) return "";
		 String userId=ipPool.get(ip).toString();
		 return userId;
	}
}
