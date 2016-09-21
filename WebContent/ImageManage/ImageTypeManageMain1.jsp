<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明:影像类型配置页面
	 */
	String PG_TITLE = "影像类型配置主页面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;影像类型配置主页面&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "150";//默认的treeview宽度

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"影像类型配置","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	//定义树图结构
    //String sSqlTreeView = " from CODE_LIBRARY where CodeNo = 'ImageMain' and IsInUse='1' ";
	String sSqlTreeView = " from ECM_IMAGE_TYPE where length(typeNo)<=3 ";
    tviTemp.initWithSql("typeNo","typeName"," typeName ","","",sSqlTreeView,"Order By typeNo ",Sqlca);
	
	//另外两种定义树图结构的方法：SQL生成和代码生成   参见View的生成 ExampleView.jsp和ExampleView01.jsp
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	/*function TreeViewOnClick() {
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1 = sCurItemDescribe[0];
		sCurItemDescribe2 = sCurItemDescribe[1];
		
		if ( sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root") {
			AsControl.OpenView( sCurItemDescribe1, sCurItemDescribe2, "right" );
			setTitle( "影像类型预览" );
		}
	}*/
	function TreeViewOnClick() {
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		openComp("ImageFileTypeList","/ImageManage/ImageFileTypeList.jsp","StartWithId="+sCurItemID, "right");
		//AsControl.OpenView( "/ImageManage/ImageTypeManageFrame.jsp", "StartWithId="+sCurItemID, "right" );
		setTitle( "影像类型预览" );
	}
	
	<%/*~[Describe=生成treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		//selectItemByName("文件名称");	//默认打开的(叶子)选项
		selectItem(10);
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
