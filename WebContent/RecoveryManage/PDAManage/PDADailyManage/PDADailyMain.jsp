 <%@page import="com.amarsoft.app.als.sys.function.model.FunctionWebTools"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
	Author:   cjyu   2014年5月15日17:06:51 
	Content:  业务申请界面
	Input Param:
 
 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = CurPage.getParameter("ComponentName"); // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = CurPage.getParameter("PG_CONTENT_TITLE"); //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%> 

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数
	String functionID = CurPage.getParameter("SYS_FUNCTIONID");
	String parameters=FunctionWebTools.getPageStringParmeters(CurPage);
	parameters+="&SYS_FUNCTIONID="+functionID;
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
	<%
 
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
	
<script type="text/javascript"> 
	
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/

	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
 
		
	</script> 
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
	<script type="text/javascript"> 
		myleft.width=1; 
		AsControl.OpenPage("/AppMain/resources/widget/FunctionView.jsp","<%=parameters%>","right");
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
	