<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "不良资产管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;不良资产管理&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(Sqlca,CurComp,sServletURL,"不良资产管理","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	String sSqlTreeView = " from CODE_LIBRARY where CodeNo = 'NPADaily' and ItemNo not like '005%' and IsInUse = '1' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick(){
		var sItemMenuNo = getCurTVItem().id;      //CodeLibrary 的describe段为菜单编号
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		var sCurItemDescribe = sCurItemDescribe.split("@");
		var sCurItemDescribe1=sCurItemDescribe[0];
		var sCurItemDescribe2=sCurItemDescribe[1];
			
		if(sItemMenuNo!="root" && sItemMenuNo!="0" && sItemMenuNo!="005" && sItemMenuNo!="010" && sItemMenuNo!="020" && sItemMenuNo!="1" && sItemMenuNo!="110" && sItemMenuNo!="120")
		{
			if(sItemMenuNo != "null" ){   //菜单不再允许有目录
				OpenComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName=sCurItemName&ItemMenuNo="+sItemMenuNo,"right",OpenStyle);
				setTitle(sCurItemName);
			}
		}
	}

	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
	
	startMenu();
	expandNode('root');
	expandNode('0');
	expandNode('010');
	expandNode('040');
	expandNode('005');
	expandNode('030');
	expandNode('045');
	selectItem('01010');	 
</script>
<%@ include file="/IncludeEnd.jsp"%>