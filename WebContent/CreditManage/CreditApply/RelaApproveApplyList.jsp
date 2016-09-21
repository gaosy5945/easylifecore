<%@page import="com.amarsoft.app.als.credit.common.model.CreditConst"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xfliu 2014-04-13
		Tester:
		Describe: 
		Input Param:
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "附属批复信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数
	String packageNo = CurPage.getParameter("ObjectNo");//主批复编号
	if(StringX.isSpace(packageNo)) packageNo = "";
	String objectType = CurPage.getParameter("ObjectType");
	if(StringX.isSpace(objectType)) objectType = "ApproveApply";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	ASObjectModel doTemp = new ASObjectModel("RelaApproveApplyList");
	//生成datawindow
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.genHTMLObjectWindow(objectType+","+packageNo);

%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	String sButtons[][] = {
		{"true","","Button","详情","查看申请详情","viewAndEdit()","","","",""},
	};
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (!serialNo){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var paramString = "ObjectType=<%=objectType%>&ObjectNo="+serialNo;
		AsControl.OpenObjectTab(paramString);
		reloadSelf();
	}	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
</script>
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
