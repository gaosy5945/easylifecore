<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "业务台账"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;业务台账&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	
	//获得组件参数	，组件名称、模板类型
	String sTreeviewTemplet = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TreeviewTemplet"));
    if(sTreeviewTemplet == null) sTreeviewTemplet = "";

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"业务台帐管理","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
     //move by fbkang 2005-7-30
     //把不良贷款的内容删除，如果用可以在解开
	//定义树图结构
	String sSqlTreeView = " from CODE_LIBRARY where CodeNo= '"+sTreeviewTemplet+"' and IsInUse = '1'";
	tviTemp.initWithSql("SortNo","ItemName","ItemNo","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick(){
		var sCurItemName = getCurTVItem().name;//--获得当前节点名称
		var sCurItemValue = getCurTVItem().value;//--获得当前节点的代码值
		if((sCurItemValue.length == 6 && sCurItemValue.indexOf("030") < 0) || sCurItemValue.length == 9){
			OpenComp("ContractList","/CreditManage/CreditPutOut/ContractList.jsp","ComponentName="+sCurItemName+"&ContractType="+sCurItemValue,"right");
			setTitle(getCurTVItem().name);
		}
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
	
	startMenu();
	expandNode('root');		
	expandNode('010');		
	expandNode('020');
	selectItem('010010');		
</script>
<%@ include file="/IncludeEnd.jsp"%>