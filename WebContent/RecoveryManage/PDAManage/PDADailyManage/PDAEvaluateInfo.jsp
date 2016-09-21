<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>


	<%
	String PG_TITLE = "抵债资产价值评估详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得组件参数
	String sAssetStatus = CurComp.getParameter("AssetStatus");
	//获取合同终结类型
    String sFinishType = CurComp.getParameter("FinishType");   
	
	//将空值转化为空字符串
	if(sAssetStatus ==  null) sAssetStatus = "";
	if(sFinishType == null) sFinishType = "";
	//获得页面参数
	String sSerialNo = CurPage.getParameter("SerialNo");			//评估记录流水号
	if(sSerialNo == null ) sSerialNo = "";
	String sAssetSerialNo = CurPage.getParameter("AssetSerialNo");			//评估记录流水号
	if(sAssetSerialNo == null ) sAssetSerialNo = "";
	String sRightType = CurPage.getParameter("RightType");
	if(sRightType == null) sRightType = "";
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo ="PDAEvaluateInfo1";
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();

	inputParameter.setAttributeValue("SerialNo", sSerialNo);
	inputParameter.setAttributeValue("AssetSerialNo", sAssetSerialNo);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();	
	
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	//ALSInfoHtmlGenerator.replaceSubObjectWindow(dwTemp);
	doTemp.setBusinessProcess("com.amarsoft.app.als.awe.ow.ALSBusinessProcess");
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{sAssetStatus.equals("04")?"false":(sFinishType.equals("")?"true":"false"),"","Button","保存","保存所有修改","saveRecord()","","","",""},
			{"true","","Button","返回","返回到上级页面","goBack()","","","",""}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		beforeUpdate();
		as_save("myiframe0",sPostEvents);					
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">

	/*~[Describe=返回前页;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAEvaluateList.jsp","right");
	}

	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	
	/*~[Describe=页面装载时，对OW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			bIsInsert = true;	
			initSerialNo();//初始化流水号字段
			setItemValue(0,getRow(),"EvaluateValue","0.00");
			setItemValue(0,getRow(),"AssetSerialNo","<%=sAssetSerialNo%>");
			setItemValue(0,getRow(),"EvaDate","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputOrgID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.getOrgName()%>");	
			setItemValue(0,getRow(),"InputDate","<%=StringFunction.getToday()%>");
		}
    }
	

	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "Asset_Evaluate";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>