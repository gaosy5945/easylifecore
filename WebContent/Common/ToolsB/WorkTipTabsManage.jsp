<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
	Content: 工作台用户自定义TAB与数据库交互桥接页面，由于直接使用RunMethod时，参数传递会有问题
	*/
	String operate  = CurPage.getParameter("Operate");
	String userid  = CurPage.getParameter("UserID");
	String tabid = CurPage.getParameter("TabID");
	String tabname = CurPage.getParameter("TabName");
	String script = CurPage.getParameter("Script");
	String cache = CurPage.getParameter("Cache");
	String close = CurPage.getParameter("Close");
	
	com.amarsoft.app.util.WorkTipTabsManage wttm = new com.amarsoft.app.util.WorkTipTabsManage();
	wttm.setAttribute("Operate",operate);
	wttm.setAttribute("UserID",userid);
	wttm.setAttribute("TabID",tabid);
	wttm.setAttribute("TabName",tabname);
	wttm.setAttribute("Script",script);
	wttm.setAttribute("Cache",cache);
	wttm.setAttribute("Close",close);
	out.println(wttm.run(Sqlca));
%><%@ include file="/IncludeEndAJAX.jsp"%>