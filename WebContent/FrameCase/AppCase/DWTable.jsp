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
						{"UserID","�ͻ����","style=\"width:'100px'\""},
						{"UserName","�û�����","style=\"width:'200px'\""},
						{"Password","����","style=\"width:'200px'\""},
						{"LoginID","�������","style=\"width:'200px'\""},
						{"UserName","�û�����","style=\"width:'200px'\""},
						{"UserName","�û�����","style=\"width:'200px'\""},
						};
	DWList dwList=new DWList(header,lst);
	out.print(dwList.getHTML());

%>

<%@ include file="/IncludeEnd.jsp"%>