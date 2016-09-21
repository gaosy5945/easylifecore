<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 贷后检查报告
	 */
	String PG_TITLE = "贷后检查报告"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;贷后检查报告&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//获得组件参数	
	String sSerialNo = CurPage.getParameter("SerialNo");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sObjectType = CurPage.getParameter("ObjectType");
	String sCustomerID = sObjectNo;

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"贷后检查报告","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'InspectView' and IsInUse = '1' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemNo","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	function TreeViewOnClick(){
		if (getCurTVItem().id == "010030") {
			OpenComp("MemorabiliaList","/CustomerManage/EntManage/MemorabiliaList.jsp","CustomerID=<%=sCustomerID%>","right");
		}else if (getCurTVItem().id == "010040") {
			OpenComp("AutoRiskSignalInfo","/CreditManage/CreditPutOut/AutoRiskSignalInfo.jsp","CustomerID=<%=sCustomerID%>","right");
		}else if (getCurTVItem().id == "020") { //贷后检查报告摘要			
			OpenPage("/CreditManage/CreditCheck/PrintInspectResume.jsp?SerialNo=<%=sSerialNo%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","right","");
		}else if (getCurTVItem().id == "030") { //贷后检查报告正文			
			OpenPage("/CreditManage/CreditCheck/InspectFrame.jsp?SerialNo=<%=sSerialNo%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","right","");
		}else if (getCurTVItem().id == "040") { //贷后检查报告审核表
			OpenPage("/CreditManage/CreditCheck/PrintInspectSheet.jsp?SerialNo=<%=sSerialNo%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","right","");
		}else if (getCurTVItem().id == "050") {
			OpenComp("SumInspectInfo","/CreditManage/CreditCheck/SumInspectInfo.jsp","SerialNo=<%=sSerialNo%>","right");
		}
		setTitle(getCurTVItem().name);
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');		
</script>
<%@ include file="/IncludeEnd.jsp"%>