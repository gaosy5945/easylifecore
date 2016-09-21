<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: jytian 2004-12-11
		Tester:
		Describe: 相关票据信息
		Input Param:
			ObjectType: 阶段编号
			ObjectNo:
			SerialNo：业务流水号
		Output Param:
			SerialNo：业务流水号
		
		HistoryLog:
			2013-05-09 jqcao 修改为模板生成DataWindow
			2013-11-28 gftang 修改模板为ObjectWindow
			2014-01-23 lyin 出账阶段增加BUSINESS_PUTOUT与BILL_INFO的关联
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "相关票据信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String contractSerialNo=CurPage.getParameter("ContractSerialNo");
	String sBusinessType = CurPage.getParameter("BusinessType");

	if(sObjectType==null) sObjectType="";
	if(sObjectNo==null) sObjectNo="";
	if(contractSerialNo==null) contractSerialNo="";
	if(sBusinessType==null) sBusinessType="";
	
	if(sObjectType.equals("AfterLoan")) sObjectType = "BusinessContract";
	String sBillType = "2";//2 银行（含电子）承兑汇票贴现 3 商业（含电子）承兑汇票贴现
	if("1020020".equals(sBusinessType)) sBillType="3";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	ASObjectModel doTemp = new ASObjectModel("RelativeBillList","");
	//生成datawindow
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.genHTMLObjectWindow( sObjectNo + "," + sObjectType);

%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	String sButtons[][] = {
			{sObjectType.equals("PutOutApply")?"false":"true","All","Button","新增","新增票据信息","newRecord()","","","",""},
			{"true","","Button","详情","查看票据详情","viewAndEdit()","","","",""},
			{sObjectType.equals("PutOutApply")?"false":"true","All","Button","删除","删除票据信息","deleteRecord()","","","",""},
			{sObjectType.equals("PutOutApply")?"false":"true","All","Button","导入票据","导入票据信息","importBill()","","","",""},//银行承兑汇票没有导入票据的功能
			{sObjectType.equals("PutOutApply")?"false":"true","All","Button","复制票据","复制票据信息","copyBill()","","","",""},//银行承兑汇票没有导入票据的功能
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
		OpenPage("/CreditManage/CreditApply/RelativeBillInfo.jsp","_self","");
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
			OpenPage("/CreditManage/CreditApply/RelativeBillInfo.jsp?SerialNo="+sSerialNo, "_self","");	
		}
	}
	
	function importBill()
	{
	    var pageURL = "/AppConfig/FileImport/FileSelector.jsp";
	    var parameter = "BillType=<%=sBillType%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&clazz=jbo.import.excel.BILL_IMPORT"; //2 银行（含电子）承兑汇票贴现 3 商业（含电子）承兑汇票贴现
	    var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
	    var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
	    if(typeof(sReturn) != "undefined" && sReturn != "")
	    {
	    	reloadSelf();
	    }
	}
	
	function importContractBill()
	{
		var sContarctSerialNo = "<%=contractSerialNo%>";
		var sPutOutNo = "<%=sObjectNo%>";
		var sParaString = "ObjectNo" + "," + sContarctSerialNo + ",PutOutNo" + "," + sPutOutNo;
		sReturn = setObjectValue("selectContractBillInfo",sParaString,"",0,0,"");
		if (typeof(sReturn) == "undefined" || sReturn.length == 0) {
		    return false;
		} else {
			var sSerialNo = sReturn.split("@")[0];
			sParaString = sPutOutNo + "," + sSerialNo + "," + 
			              "<%=StringFunction.getToday()%>" + "," + "<%=CurUser.getUserID()%>" + "," + "<%=sBusinessType%>";
		    RunMethod("BusinessManage","InsertPutoutRelative",sParaString);
		    reloadSelf();
		}
	}
	
	/*~[Describe=复制票据;InputParam=无;OutPutParam=无;]~*/
	function copyBill(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		RunJavaMethod("com.amarsoft.app.als.credit.common.action.BillSingleCopy","copy","SerialNo="+sSerialNo+",ObjectNo=<%=sObjectNo%>,ObjectType=<%=sObjectType%>,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		UpdateBusinessSum();
		reloadSelf();
	}
	
	/*~[Describe=更新申请金额和汇票数量;InputParam=无;OutPutParam=无;]~*/
	function UpdateBusinessSum(){
		RunJavaMethod("com.amarsoft.app.als.credit.common.action.BillAction","UpdateBusinessSum","ObjectNo=<%=sObjectNo%>,ObjectType=<%=sObjectType%>");
	}
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
</script>
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
