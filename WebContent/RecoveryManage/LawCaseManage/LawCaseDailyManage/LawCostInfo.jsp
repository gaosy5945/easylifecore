<%@page import="org.apache.poi.ss.usermodel.DateUtil"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Tester:
		Content: 法律费用台帐信息
		Input Param:
			        SerialNo:记录流水号
			        ObjectNo：案件编号
			        ObjectType：对象类型
		Output param:
		               
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "法律费用台帐信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	
	//获得页面参数
	//记录流水号、案件编号、对象类型	
	String sSerialNo = CurPage.getParameter("SerialNo");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sObjectType = CurPage.getParameter("ObjectType");
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "";
	
	//根据不同的费用类型显示不同的费用台帐模板
	//抵债资产费用信息
	//if (sObjectType.equals("ASSET_INFO"))
	//	sTempletNo = "ASSETCostInfo";
	
	//法律事务费用信息
	if (sObjectType.equals("LawcaseInfo"))
		sTempletNo = "LawCostInfo";
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,BusinessObject.createBusinessObject(),CurPage, request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	//ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置为freeform风格
	dwTemp.ReadOnly = "0"; //设置为只读

	dwTemp.setParameter("SERIALNO", sSerialNo);
	dwTemp.setParameter("OBJECTNO", sObjectNo);
	dwTemp.setParameter("OBJECTTYPE", sObjectType);
	dwTemp.genHTMLObjectWindow("");
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
			{"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
			{"true","","Button","返回","返回列表页面","goBack()","","","",""}
		};
	%> 
<%/*~END~*/%>




<%@include file="/Frame/resources/include/ui/include_info.jspf" %>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		var sSerialNo = "<%=sSerialNo%>";

		if(sSerialNo == "")	{
			beforeInsert();
		}
		beforeUpdate();
		as_save(0,"");	
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		var sObjectType = "<%=sObjectType%>";
		//if(sObjectType == "ASSET_INFO")	//抵债资产费用信息
		//	OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCostList.jsp","_self","");

		if(sObjectType == "LawcaseInfo")	//法律事务费用信息
			AsControl.OpenView("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCostList.jsp","SerialNo=<%=sObjectNo%>","right","");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=执行新增操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段		
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			
			//对象编号、对象类型
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
		
			//登记人、登记人名称、登记机构、登记机构名称
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			
			//登记日期						
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");

			//登记人、登记人名称、登记机构、登记机构名称
			setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"UpdateOrgName","<%=CurOrg.getOrgName()%>");
			
			//登记日期						
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{		
		var sTableName = "NPA_FEE_LOG";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>