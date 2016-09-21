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
<%@ include file="/IncludeBegin.jsp"%>


<%
	String sUserID=CurPage.getParameter("UserID");

	//取当前用户和机构，并将其放入 Session
	CurUser = ASUser.getUser(SpecialTools.real2Amarsoft(sUserID),Sqlca);
	CurARC  = (RuntimeContext)session.getAttribute("CurARC");
	CurARC.setUser(CurUser);
	CurARC.setPref(new ASPreference(Sqlca, CurUser.getUserID()));
	CurARC.getCompSession().clear();
	CurARC.setCompSession(new ComponentSession());
	session.setAttribute("CurARC",CurARC);
	String nextPage="/Main.jsp";

%>

<script type="text/javascript">
		 window.open("<%=sWebRootPath%>/Redirector?ComponentURL=<%=nextPage%>","_self");
		<%-- window.open("<%=sWebRootPath%>/Redirector?ComponentURL=/Main.jsp","_top"); --%>
 </script>
 

<%@ include file="/IncludeEnd.jsp"%>