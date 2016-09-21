<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//获得页面参数
	String sExampleId = CurPage.getParameter("ObjectNo");

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"复杂树图","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo='ExampleTree' and IsInUse='1' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemName","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	CurPage.setAttribute("HideMinButton", "true");
%>
<html>
	<head>
		<title>影像树图</title>
	</head>
	<body style="margin:0;padding:0;overflow:hidden;height:100%;width:100%;">
		<iframe width="100%" height="100%" frameborder="0" name="left"></iframe>
	</body>
	<script type="text/javascript">
	function openChildComp(sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		/*
		 * 附加两个参数
		 * ToInheritObj:是否将对象的权限状态相关变量复制至子组件
		 * OpenerFunctionName:用于自动注册组件关联（REG_FUNCTION_DEF.TargetComp）
		 */
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		AsControl.OpenView(sURL,sParaStringTmp,"RightImage");
	}
	
	//treeview单击选中事件
	function TreeViewOnClick(){
		//var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=="基本信息"){
			openChildComp("/FrameCase/widget/dw/ExampleList.jsp","");
		}else if(sCurItemname=="其他信息1"){
			openChildComp("/FrameCase/widget/dw/ExampleList.jsp","");
		}else if(sCurItemname=="其他信息2"){
			openChildComp("/FrameCase/widget/dw/ExampleList.jsp","");
		}else if(sCurItemname=="其他的信息"){
			openChildComp("/FrameCase/widget/dw/ExampleList.jsp","");
		}else if(sCurItemname=="另外的信息"){
			openChildComp("/FrameCase/widget/dw/ExampleList.jsp","");
		}
		//parent.setTitle(getCurTVItem().name);
	}
	
	function initTreeView(){
		_Tree_Show_In_View = true;
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("基本信息");
	}
	</script>
</html>
<%@ include file="/IncludeEnd.jsp"%>