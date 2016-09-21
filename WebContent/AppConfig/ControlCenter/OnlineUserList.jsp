<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
 	/* 在线用户列表 */
	String time=DateX.format(new java.util.Date(), "yyyy/MM/dd");

 	ASObjectModel doTemp = new ASObjectModel("OnlineUserList");
 	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.genHTMLObjectWindow(time);

	String sButtons[][] = {
		{"true","","Button","关闭","关闭","top.close();","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>