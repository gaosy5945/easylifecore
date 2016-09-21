<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明:资产转受让详情页面
	 */
	String PG_TITLE = "资产转受让详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;资产转受让详情&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	
	String viewID = CurPage.getParameter("ViewID");
	if(viewID == null) viewID = "";
	//获得页面参数
	String projectStatus = DataConvert.toString(CurPage.getParameter("projectStatus"));//项目状态
	String sAssetProjectType = DataConvert.toString(CurPage.getParameter("AssetProjectType"));//项目类型
	String objectNo=CurComp.getParameter("ObjectNo");
	CurPage.setAttribute("SerialNo",objectNo);
	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"资产转受让详情","right");
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	//定义树图结构
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo='AssetTransferViewTree' and IsInUse='1' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	function TreeViewOnClick(){
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		var sItemDescribe = getCurTVItem().value;
		
		//alert("sCurItemID = "+sCurItemID);
		
		if(typeof(sItemDescribe) == 'undefined' || sItemDescribe.length == 0 || sItemDescribe=="null"){
			return;
		}
		AsControl.OpenView(sItemDescribe,"projectStatus=010&View=<%=viewID%>&ItemNo="+sCurItemID +"&AssetProjectType=<%=sAssetProjectType%>","right");
		setTitle(sCurItemname);
	}
	
	<%/*~[Describe=生成treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		expandNode('03');
		selectItem('01');
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>