package com.amarsoft.app.als.sys.user;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.context.ASUser;

public class CheckUserAction {

	
	/**
	 * 获得iP地址
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
	 * 将用户增加到session中
	 * @param application
	 * @param session
	 * @param curUser
	 * @throws Exception 
	 */
	public   synchronized static void addSession(ServletContext application,HttpServletRequest request,HttpSession session,ASUser curUser) throws Exception{
		  String userId=curUser.getUserID();
		  HashMap userPool = (HashMap)application.getAttribute("ACTIVE_USER_POOL");
		  String ip=getIpAddr(request);
		  if(userPool==null){
			  userPool = new java.util.HashMap();
			  application.setAttribute("ACTIVE_USER_POOL",userPool);
		  }
		  Map<String,Object> map=new HashMap<String,Object>();
		  map.put("IP", ip);
		  map.put("session", session);
		  map.put("sessionid", session.getId());
		  map.put("UserName", curUser.getUserName());
		  map.put("OrgID", curUser.getOrgID());
		  map.put("OrgName", curUser.getOrgName());
		  map.put("EntryTime", DateHelper.getBusinessDate());
		  userPool.put(session.getId(), map);
	}
	
	/**
	 * 移除
	 * @param application
	 * @param session
	 * @param curUser
	 */
	public  synchronized static void removeSession(ServletContext application,HttpServletRequest request,HttpSession session,String userId){
		  HashMap userPool = (HashMap)application.getAttribute("ACTIVE_USER_POOL");
		  String ip=getIpAddr(request);
		  if(userPool==null) return ;
		  Map<String,Object> map=(Map<String,Object>)userPool.get(userId);
			HttpSession ses=(HttpSession)map.get("session");
		    ses.invalidate();
		   userPool.remove(userId);
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
