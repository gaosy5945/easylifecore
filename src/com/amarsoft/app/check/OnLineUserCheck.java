package com.amarsoft.app.check;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.amarsoft.app.als.sys.tools.SystemConst;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.object.Item;

/**
 * 在线用户检查
 * 
 * @author gfTang ALS743升级
 * 
 */
public class OnLineUserCheck {

	private HttpSession session;
	private ServletContext application;
	private HttpServletRequest request;
	private BizObjectManager bm;
	private BizObject bo;
	private String curIP="";
	private String curUserID="";
	private ASUser curUser;
	private String sessionId="";
	private List<BizObject> sameUserList;
	private List<BizObject> sameIpList;
	private String   today="";
	private String yestToday="";
	/**
	 * 检查在线用户
	 * @throws JBOException 
	 */
	@SuppressWarnings("deprecation")
	public OnLineUserCheck(HttpSession _session,HttpServletRequest req,ServletContext app,ASUser user) throws JBOException {
		session=_session;
		today=new DateX().getDateString();
		yestToday=StringFunction.getRelativeDate(today, -1)+" "+StringFunction.getNow();
		sessionId=session.getId();
		request=req;
		application=app;
		bm=JBOFactory.getBizObjectManager(SystemConst.JAVA_USER_LIST);
		curUser=user;
		curUserID=user.getUserID();
		curIP=OnLineUserCheck.getIpAddr(request);
		initSession();
	}
 
	/**
	 * 是否存在相同用户
	 * @return
	 * @throws JBOException
	 */
	public synchronized boolean exists() throws JBOException{
		try{
			Item item=CodeManager.getItem("LoginOne", "10");//cjyu 如果进行了配置，则不进行校验
			if(item!=null ){
				String itemDescribe=item.getItemDescribe();
				if("1".equalsIgnoreCase(itemDescribe)){
					return  false;
				}
			}
		}catch(Exception e){
			ARE.getLog().error("登陆配置检查失败", e);
		}
		sameUserList=getUserList(); 
		return (sameUserList.size()>0 );
	}
	
	public synchronized void  initSession(){
		HashMap<String,HttpSession> sessionPool = (HashMap<String,HttpSession>) application.getAttribute("ACTIVE_IP_POOL");
		if (sessionPool == null) {
			sessionPool = new   HashMap<String,HttpSession>();
			application.setAttribute("ACTIVE_IP_POOL", sessionPool);
		}
		if (!sessionPool.containsKey(sessionId)) {
			sessionPool.put(sessionId, session);
		}
	}
	/**
	 * session退出注销
	 * @param application
	 * @param session
	 */
	@SuppressWarnings("unchecked")
	public synchronized static void removeSession(ServletContext application,HttpSession session){
		HashMap<String,HttpSession> sessionPool = (HashMap<String,HttpSession>) application.getAttribute("ACTIVE_IP_POOL");
		String sessionId=session.getId();
		if (sessionPool!=null&&sessionPool.containsKey(sessionId)) {
			sessionPool.remove(sessionId);
		}
	}
	 
	@SuppressWarnings("unchecked")
	public synchronized void clearSession(String oldSessionId){
		HashMap<String,HttpSession> sessionPool = (HashMap<String,HttpSession>) application.getAttribute("ACTIVE_IP_POOL");
		if (sessionPool == null) {
			sessionPool = new   HashMap<String,HttpSession>();
			application.setAttribute("ACTIVE_IP_POOL", sessionPool);
		}
		if (sessionPool.containsKey(oldSessionId)) {
			HttpSession oldSession=sessionPool.get(oldSessionId); 
			if(oldSession!=null && oldSession!=session && oldSession.isNew()) {
				oldSession.invalidate();
			}
		}
	}
	/**
	 * 获得当前用户未正常退出的用户
	 * @param userID
	 * @return
	 * @throws JBOException
	 */
	public List<BizObject> getUserList() throws JBOException{
		
		@SuppressWarnings("unchecked")
		List<BizObject> lst=bm.createQuery("(UserID=:userid or remoteaddr=:ip) and  beginTime>:startTime and endtime is null and sessionid<>:sessionId")
							  .setParameter("userid", curUserID)
  							  .setParameter("startTime", yestToday)
  							  .setParameter("ip", curIP)
							  .setParameter("sessionId", this.sessionId).getResultList(false);
		return lst;

	}
	
	 
	public List<BizObject> getSameIpList() {
		return sameIpList;
	}
	public List<BizObject> getSameUserList() {
		return sameUserList;
	}
	 
	Transaction sqlca;
	
	public void setSqlca(Transaction sqlca) {
		this.sqlca = sqlca;
	}
	/**
	 * 
	 * @param tx
	 * @param sessionId
	 * @throws Exception 
	 */
	public synchronized void checkOut(String sessionId) throws Exception{
		
		String endTime=new DateX().getDateString(DateHelper.AMR_NOMAL_DATETIME_FORMAT);
		SqlObject sql=new SqlObject("update User_List set EndTime=:endTime where SessionID=:sessionId");
		sql.setParameter("endTime", endTime);
		sql.setParameter("sessionId", sessionId);
		sqlca.executeSQL(sql);
		clearSession(sessionId);
	}
	/**
	 * 获得Session是否已经结清
	 * @return
	 * @throws SQLException
	 */
	public boolean getEndTime() throws SQLException{
		SqlObject sql=new SqlObject("select count(1) as vcount from  User_List where SessionID=:sessionId and" +
				" remoteaddr=:ip and UserID=:userID and EndTime is null");
		sql.setParameter("sessionId", sessionId);
		sql.setParameter("ip", this.curIP);
		sql.setParameter("userID", this.curUserID);
		ASResultSet rs=sqlca.getASResultSet(sql);
		int icount=0;
		if(rs.next()){
			icount=rs.getInt("vcount");
		}
		rs.close();
		if(icount>0) return true;
		return false;
	}
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
	 * 更新用户地址
	 * @param curUser
	 * @param _session
	 * @param sqlca
	 * @param request
	 * @throws Exception
	 */
	public synchronized static void updateAddrIp(ASUser curUser,HttpSession _session,Transaction sqlca,HttpServletRequest request) throws Exception{
		String ip=getIpAddr(request);
		ARE.getLog().info("用户"+curUser.getUserID()+"登录IP为:"+ip);
		SqlObject sql=new SqlObject("update User_List set remoteaddr=:remoteaddr where SessionID=:sessionId and UserID=:userID");
		sql.setParameter("remoteaddr", ip);
		sql.setParameter("sessionId", _session.getId());
		sql.setParameter("userID", curUser.getUserID());
		sqlca.executeSQL(sql);
	}
}
