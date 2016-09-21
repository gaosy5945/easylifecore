<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zmxu 2012/04/19
		Tester:
		Describe: 还款记录
		Input Param:
		Output Param:
					
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "还款记录"; // 浏览器窗口标题 <title> PG_TITLE </title>

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得页面参数
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");

	
	if(objectNo==null) objectNo="";
	if(objectType==null) objectType="";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//String sTempletNo = "PaymentRecordList";

	String sTempletNo = "PaymentLogList";
	
	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20); 	//服务器分页
	dwTemp.genHTMLObjectWindow(objectNo+","+objectType);

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
		{"false","","Button","导出EXCEL","导出EXCEL","exportAll()",""},
	};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	
	/*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}

	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
// 	init();
	var bHighlightFirst = true;//自动选中第一条记录
// 	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@ include file="/Frame/resources/include/include_end.jspf"%>