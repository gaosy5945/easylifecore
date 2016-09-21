<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: sjchuan 2009-10-20
		Tester:
		Describe: 出账信息中的票据信息列表
		Input Param:
		Output Param:		
		HistoryLog: 2013-11-30 将页面配置OW模板
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "票据信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数

	//获得组件参数
	String sObjectType = CurPage.getParameter("ObjectType");
	String sPutoutSerialNo = CurPage.getParameter("ObjectNo");
	String sContractSerialNo = CurPage.getParameter("ContractSerialNo");
	String sBusinessType = CurPage.getParameter("BusinessType");
	
    if(sObjectType == null) sObjectType = "";
    if(sPutoutSerialNo == null) sPutoutSerialNo = ""; 
    if(sContractSerialNo == null) sContractSerialNo = "";
    if(sBusinessType == null) sBusinessType = ""; 
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//由SQL语句生成窗体对象。
	ASObjectModel doTemp = new ASObjectModel("RelativeBillListX","");
	//生成datawindow
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	dwTemp.genHTMLObjectWindow(sPutoutSerialNo+","+sObjectType);


%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	String sButtons[][] = {
		{"true","All","Button","新增票据","新增票据信息","newRecord()","","","",""},
		{"true","","Button","票据详情","查看票据详情","viewAndEdit()","","","",""},
		{"true","All","Button","删除票据","删除票据信息","deleteRecord()","","","",""},		
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/CreditManage/CreditApply/BillInfo.jsp","_self","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
	 	sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_delete('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		} 
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else 
		{
			OpenPage("/CreditManage/CreditApply/BillInfo.jsp?SerialNo="+sSerialNo, "_self","");	
		}
	}
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
</script>
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
