<%@page import="com.amarsoft.awe.control.SessionListener"%>
<%@page import="com.amarsoft.are.util.StringFunction"%>
<%@page import="com.amarsoft.app.check.OnLineUserCheck"%>
<%@page import="com.amarsoft.awe.control.model.ComponentSession"%>
<%@page import="com.amarsoft.context.ASPreference"%>
<%@page import="com.amarsoft.awe.RuntimeContext"%>
<%@page import="com.amarsoft.awe.util.Transaction"%>
<%@page import="com.amarsoft.awe.Configure"%>
<%@page import="com.amarsoft.are.util.SpecialTools"%>
<%@page import="com.amarsoft.context.ASUser"%>
<%@page import="com.amarsoft.app.awe.config.role.action.UserLogin"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>

<%
		String sUserID = CurPage.getAttribute("UserID");
		String sLoginID = (String)session.getAttribute("LogInID");
		String nextPage="/Main.jsp";
	 	 //身份选择界面在js端操作，无法直接操作session，故从页面获得参数
		if(sUserID==null || "".equals(sUserID)){
			CurUser = ASUser.getUser(SpecialTools.real2Amarsoft(sLoginID),Sqlca);
		} else  CurUser = ASUser.getUser(sUserID, Sqlca);
		
		 sUserID=CurUser.getUserID();
		if(sUserID==null || "".equals(sUserID))
		throw new Exception("用户ID 不存在！");
		//校验LoginID 和 UserID 的合法匹配
		BizObject boUser=UserLogin.getUserInfo(sLoginID,sUserID);
		String CheckResult ="true";// UserLogin.getUserInfo(sLoginID,sUserID);
		if(boUser==null) CheckResult="false";
		if(!"true".equals(CheckResult))		throw new Exception("登陆用户非法！请重新登陆！");
		
		//取当前用户和机构，并将其放入 Session
		CurARC.setUser(CurUser);
		CurARC.setPref(new ASPreference(Sqlca, CurUser.getUserID()));
		CurARC.setCompSession(new ComponentSession());
		session.setAttribute("CurARC",CurARC);
		session.setAttribute("LogInID",sUserID);
	    
	  //用户登陆成功，记录登陆信息
	    SessionListener sessionListener=new SessionListener(request,session,CurUser,CurConfig.getConfigure("DataSource"));
	    session.setAttribute("listener",sessionListener);
		%>
<script type="text/javascript">
		 window.open("<%=sWebRootPath%>/Redirector?ComponentURL=<%=nextPage%>&NBLoginType=1","_self");
		<%-- window.open("<%=sWebRootPath%>/Redirector?ComponentURL=/Main.jsp","_top"); --%>
		</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>