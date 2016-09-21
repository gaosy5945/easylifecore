<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>

 

<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@page import="com.amarsoft.app.als.sys.tools.SystemConst"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.app.als.sys.widget.DWList"%><link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/widget.css">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/dw/list.css"> 

<%
	BizObjectManager bm=JBOFactory.getBizObjectManager(SystemConst.JAVA_USER_INFO);
	List<BizObject> lst=bm.createQuery("").getResultList(false);
	String[][] header={
						{"UserID","客户编号","style=\"width:'100px'\""},
						{"UserName","用户名称","style=\"width:'200px'\""},
						{"Password","密码","style=\"width:'200px'\""},
						{"LoginID","机构编号","style=\"width:'200px'\""},
						{"UserName","用户名称","style=\"width:'200px'\""},
						{"UserName","用户名称","style=\"width:'200px'\""},
						};
	DWList dwList=new DWList(header,lst);
	out.print(dwList.getHTML());

%>

<%@ include file="/IncludeEnd.jsp"%>