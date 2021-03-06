<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.7
		Tester:
		Content: 创建授信额度申请
		Input Param:
			ObjectType：对象类型
			ApplyType：申请类型
			PhaseType：阶段类型
			FlowNo：流程号
			PhaseNo：阶段号		
		Output param:
		History Log: zywei 2005/07/28
					 zywei 2005/07/28 将授信额度新增页面单独处理
					 jgao1 2009/10/21 增加集团授信额度，以及选择客户类型变化时清空Data操作
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授信方案新增信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数	：对象类型、申请类型、阶段类型、流程编号、阶段编号
	String sObjectType =(String)CurPage.getParameter("ObjectType");
	String sApplyType =  (String)CurPage.getParameter("ApplyType");
	String sPhaseType = (String)CurPage.getParameter("PhaseType");
	String sFlowNo =  (String)CurPage.getParameter("FlowNo");
	String sPhaseNo =  (String)CurPage.getParameter("PhaseNo");
	
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
		
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "CreditLineApplyCreationInfo";
	
	//根据模板编号设置数据对象	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
    dwTemp.genHTMLObjectWindow(CurPage.getParameter(""));
	
	//设置保存时操作关联数据表的动作
	 /* dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.getUserID()+","+CurUser.getOrgID()+") + !WorkFlowEngine.InitializeCLInfo(#SerialNo,#BusinessType,#CustomerID,#CustomerName,#InputUserID,#InputOrgID)"); */
		
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
			{"true","","Button","确认","确认新增授信额度申请","doCreation()",""},
			{"true","","Button","取消","取消新增授信额度申请","doCancel()",""}	
	};
	sButtonPosition = "south";
	%> 
<%/*~END~*/%>


	<%@include file="/Frame/resources/include/ui/include_info.jspf"%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{		
		setItemValue(0,0,"ContractFlag","2");//不占用额度
		initSerialNo();
		as_save("myiframe0",sPostEvents);		
	}
		   
    /*~[Describe=取消新增授信方案;InputParam=无;OutPutParam=取消标志;]~*/
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">

	/*~[Describe=新增一笔授信申请记录;InputParam=无;OutPutParam=无;]~*/
	function doCreation()
	{
		saveRecord("doReturn();");
	}
	
	/*~[Describe=确认新增授信申请;InputParam=无;OutPutParam=申请流水号;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sObjectType = "<%=sObjectType%>";
		top.returnValue = sObjectNo+"@"+sObjectType;
		top.close();
	}
		
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{		
		sCustomerType = getItemValue(0,getRow(),"CustomerType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
		{
			alert("请先选择客户类型!");
			return;
		}
		//具有业务申办权的客户信息
		sParaString = "UserID"+","+"<%=CurUser.getUserID()%>"+","+"CustomerType"+","+sCustomerType;
		if(sCustomerType == "02"){
			//选择集团客户
			setObjectValue("SelectApplyCustomer2",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
		}
		else{
			//选择公司类客户(包括大型企业与已认定的中小企业)
			setObjectValue("SelectApplyCustomer3",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
		}
	}
	
	/*~[Describe=弹出业务品种选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectBusinessType(sType)
	{		
		if(sType == "CL") //授信额度的业务品种
		{
			sCustomerType = getItemValue(0,getRow(),"CustomerType");
			if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
			{
				alert("请先选择客户类型!");
				return;
			}
			//“01”代表公司客户，“02”代表集团客户，如果选择的是公司客户，则弹出授信额度业务品种，如果选择的是集团客户，则默认为集团授信额度
			if(sCustomerType=="01")
				setObjectValue("SelectCLBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");	
			if(sCustomerType=="02"){
				//新增弹出框提示语句，防止出现异议！
				alert("集团客户只能申请集团授信额度！");
				return;
			}		
		}
	}
							
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{      
			setItemValue(0,0,"OccurType","010");
			//发生日期
			setItemValue(0,0,"OccurDate","<%=StringFunction.getToday()%>");
			//申请类型
			setItemValue(0,0,"ApplyType","<%=sApplyType%>");
			//经办机构
			setItemValue(0,0,"OperateOrgID","<%=CurUser.getOrgID()%>");
			//经办人
			setItemValue(0,0,"OperateUserID","<%=CurUser.getUserID()%>");
			//经办日期
			setItemValue(0,0,"OperateDate","<%=StringFunction.getToday()%>");
			//登记机构
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			//登记人
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			//登记日期			
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			//更新日期
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			//暂存标志
			setItemValue(0,0,"TempSaveFlag","1");//是否标志（1：是；0：否）
			//客户类型默认为公司客户
			setItemValue(0,0,"CustomerType","01");
			//批复标志
			setItemValue(0,0,"Flag5","010");//标志（010：初始化未批复；020：已批复）	
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_APPLY";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
								
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	/*~[Describe=清空信息;InputParam=无;OutPutParam=申请流水号;]~*/
	function clearData(){
		var sCustomerType = getItemValue(0,getRow(),"CustomerType");
		if(sCustomerType=="02")
		{
			//如果客户类型为集团客户，则默认为集团授信额度，代码为3020
			setItemValue(0,0,"BusinessType","3020");
			setItemValue(0,0,"BusinessTypeName","集团授信额度");
		}else{
			setItemValue(0,0,"BusinessTypeName","");
			setItemValue(0,0,"BusinessType","");
		}
		setItemValue(0,0,"CustomerID","");
		setItemValue(0,0,"CustomerName","");
	}
	function getSerialNo(sTableName,sColumnName,sPrefix){
		//使用GetSerialNo.jsp来抢占一个流水号
		if(typeof(sPrefix)=="undefined" || sPrefix=="") sPrefix="";
		return RunJspAjax("/Frame/page/sys/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix);
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>