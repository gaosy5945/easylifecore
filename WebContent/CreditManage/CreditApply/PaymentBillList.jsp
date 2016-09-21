<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: smiao 2011.06.01
		Tester:
		Describe: 一笔放贷业务下的支付清单信息列表
		Input Param:
		Output Param:		
		HistoryLog: gftang 将DW改为OW
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "支付清单"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数
	String sPutoutSerialNo = CurPage.getParameter("ObjectNo");
	String sObjectType = CurPage.getParameter("ObjectType");
	
	if(sPutoutSerialNo == null) sPutoutSerialNo = ""; 
    if(sObjectType == null) sObjectType = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%//定义变量
	String sTempletNo = "";	 
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//显示模板		
	sTempletNo = "PaymentBillList";	
	
	//通过显示模版产生ASDataObject对象doTemp
	ASObjectModel doTemp = new ASObjectModel(sTempletNo,"");	
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

	//生成HTMLDataWindow
	 dwTemp.genHTMLObjectWindow(sPutoutSerialNo);
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%

	String sButtons[][] = {
		{"true","","Button","新增","新增","newRecord()","","","",""}, 
		{"true","","Button","详情","查看","viewRecord()","","","",""},
		{"true","","Button","删除","删除","deleteRecord()","","","",""}}; 
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
		OpenPage("/CreditManage/CreditApply/PaymentBillInfo.jsp","_self","");
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
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else 
		{
			OpenPage("/CreditManage/CreditApply/PaymentBillInfo.jsp?SerialNo="+sSerialNo,"_self","");				
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
