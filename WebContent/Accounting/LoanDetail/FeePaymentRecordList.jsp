<%@ page contentType="text/html; charset=GBK"%>
<%-- <%@ include file="/IncludeBegin.jsp"%> --%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>


	<%
	String PG_TITLE = "费用还款记录列表"; // 浏览器窗口标题 <title> PG_TITLE </title>

	String templetFilter="1=1";
	String templetNo;
	//获得组件参数
	
	//获得页面参数
	String objectNo = (String)CurPage.getParameter("ObjectNo");
	String objectType =  (String)CurPage.getParameter("ObjectType");//借据编号
	if(objectType==null) objectType="";
	if(objectNo == null) objectNo="";

	String sTemplete = "FeeRecordList";
    //ASDataObject doTemp = new ASDataObject(sTemplete,Sqlca);
    ASObjectModel doTemp = new ASObjectModel(sTemplete,"");
	
	//ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Freeform风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	//将模版应用于Datawindow
	/* Vector vTemp = dwTemp.genHTMLDataWindow(objectType+","+objectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i)); */
    dwTemp.genHTMLObjectWindow(objectType+","+objectNo);
	String sButtons[][] = {
	};
	%> 

<%-- <%@include file="/Resources/CodeParts/List05.jsp"%> --%>
<%@include file="/Frame/resources/include/ui/include_list.jspf" %>


<script language=javascript>
	
/* 	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0'); */
</script>	

<%-- <%@ include file="/IncludeEnd.jsp"%> --%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
