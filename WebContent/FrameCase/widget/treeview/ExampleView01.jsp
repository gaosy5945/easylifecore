<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明:代码生成树图
	 */
	String PG_TITLE = "代码生成树图"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;代码生成树图&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	
	//获得页面参数
	String sExampleId = CurPage.getParameter("ObjectNo");
	String sViewId = CurPage.getParameter("ViewId");

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"代码生成树图","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
	//代码生成树图 
	//参数从左至右依次为：代码编号，where条件，Sqlca
	tviTemp.initWithCode("ExampleTree","(RelativeCode like '%"+sViewId+"%' or RelativeCode='All')",Sqlca);
%><%@include file="/Resources/CodeParts/View04.jsp"%>
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
		AsControl.OpenView(sURL,sParaStringTmp,"right");
	}
	
	<%/*treeview单击选中事件*/%>
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
		setTitle(getCurTVItem().name);
	}

	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("基本信息");
	}

	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>