<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明:资产受让列表
	 */
	String PG_TITLE = "资产受让"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;资产受让主页面&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"资产受让主页面","right");
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	//定义树图结构
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo='AssetTransferTree' and IsInUse='1' and (itemNo like '02%' or itemNo like '03%')";
	tviTemp.initWithSql("SortNo","ItemName","","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	function TreeViewOnClick(){
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		var sUrl = "/AssetTransfer/AssetTransfereeList.jsp";
		
		if(sCurItemID == '0201'){
			AsControl.OpenView(sUrl,"projectStatus=010","right");//新建
		}else if(sCurItemID == '0202'){
			AsControl.OpenView(sUrl,"projectStatus=020","right");//下账（生效）
		}else if(sCurItemID == '0203'){
			AsControl.OpenView(sUrl,"projectStatus=040","right");//结清
		}else if(sCurItemID == '0204'){
			AsControl.OpenView(sUrl,"projectStatus=050","right");//归档
		}else if(sCurItemID == '03'){//项目相关查询
			AsControl.OpenView("/AssetTransfer/AssetProjectQueryList.jsp","AssetProjectType=020","right");
		}else{
			return;
		}
		
		setTitle(sCurItemname);
	}
	
	<%/*~[Describe=生成treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		expandNode('02');
		selectItem('0201');
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>