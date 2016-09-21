<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "风险预警管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;风险预警信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"风险预警管理","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo='CreditAlarmApplyMain' and IsInUse='1'";
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","ItemDescribe","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为： ID字段,Name字段,Value字段,Script字段,Picture字段,From子句,OrderBy子句,Sqlca
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick(){	
		var sCurItemDescribe = getCurTVItem().value;
		if(sCurItemDescribe != "null"&&sCurItemDescribe!="root"){
			setTitle(getCurTVItem().name);
		}
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	startMenu();
	expandNode('root');	
	expandNode('01');	
	expandNode('02');
	selectItem('01010');
</script>
<%@ include file="/IncludeEnd.jsp"%>