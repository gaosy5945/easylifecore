<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "业务信息提醒"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;详细信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"业务提示和预警","right");
	//tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
	
	//定义树图结构
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo='ClewAndAlarmMain' and IsInUse='1'";
	tviTemp.initWithSql("SortNo","ItemName","ItemNo","ItemDescribe","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为： ID字段,Name字段,Value字段,Script字段,Picture字段,From子句,OrderBy子句,Sqlca
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	//treeview单击选中事件
	function TreeViewOnClick(){
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;	
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	myleft.width=225;
	startMenu();
	expandNode('root');
	expandNode('01');	
	expandNode('02');
</script>
<%@ include file="/IncludeEnd.jsp"%>