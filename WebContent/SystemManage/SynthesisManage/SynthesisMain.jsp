<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "综合信息管理主界面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;综合信息主界面&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"综合信息管理查询","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构,去掉跟踪的不良资产和催收函快速查询
	String sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'SynthesisManage' and IsInUse = '1' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;

		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];  //代码表描述字段中用@分隔的第1个串
		sCurItemDescribe2=sCurItemDescribe[1];  //代码表描述字段中用@分隔的第2个串
		sCurItemDescribe3=sCurItemDescribe[2];  //代码表描述字段中用@分隔的第3个串，根据情况，还可以很多。
		if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root" && hasChild(sCurItemID)){
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,sCurItemDescribe3+"&ComponentName="+sCurItemName,"right");
			setTitle(getCurTVItem().name);
		}
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');
	selectItem('010');
</script>
<%@ include file="/IncludeEnd.jsp"%>