<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%@
 page import="com.amarsoft.are.jbo.*" %><%
	//获取jbo的list
	ASObjectModel doTemp = new ASObjectModel();
 	String queryStr = "select o.userid,O.USERNAME,o.CERTID,MOBILETEL,EMAIL,UR.ROLEID,UR.GRANTOR from O,jbo.sys.USER_ROLE UR where UR.UserID = O.UserID";
	doTemp.initQuery("jbo.sys.USER_INFO", queryStr);
	/* 
	doTemp.setVisible("*",false); //缺省显示全部属性，这里设置全部不显示的
	doTemp.setVisible("userid,USERNAME,CERTID,ROLEID",true);   //设置显示的属性
	 */
	doTemp.setColumnFilter("userid",true);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.setPageSize(15);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1";//只读模式
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {};
%><%@
include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>