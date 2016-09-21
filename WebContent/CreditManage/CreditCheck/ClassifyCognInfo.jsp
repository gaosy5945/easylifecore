<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cchang 2004-12-07
		Tester:
		Describe: 风险分类认定信息;
		Input Param:
			SerialNo：分类流水号
			ObjectNo：对象编号（合同流水号/借据流水号）
			ObjectType：对象类型（BusinessContract：按合同分类；BusinessDueBill：按借据分类）
			ClassifyType：分类类型（010：需认定的分类；020：已认定完成的分类）
		Output Param:
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "资产风险分类认定"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义参数:显示模板编号、首次发放日、Sql语句、查询结果集
	String sTempletNo = "";	
	String sOrgLevel = CurOrg.getOrgLevel();//机构级别（0：总行；3：分行；6：支行；9：网点）
		
	//获得页面参数
	String sSerialNo = CurPage.getParameter("SerialNo");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sObjectType = CurPage.getParameter("ObjectType");
	String sClassifyType = CurPage.getParameter("ClassifyType");

	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sClassifyType == null) sClassifyType = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//将空值转化为空字符串
	if(sOrgLevel == null) sOrgLevel = "";
	//待完成分类的显示模板编号
	if(sClassifyType.equals("010"))
	{
		//定义表头文件
		if(sObjectType.equals("BusinessContract")) //按合同分类
		{
			if(sOrgLevel.equals("0")) //总行
				sTempletNo = "HeadClassifyInfo1";
			if(sOrgLevel.equals("3")) //分行
				sTempletNo = "BranchClassifyInfo1";
			if(sOrgLevel.equals("6")) //支行
				sTempletNo = "SubbranchClassifyInfo1";
		}	
		if(sObjectType.equals("BusinessDueBill")) //按借据分类
		{
			if(sOrgLevel.equals("0")) //总行
				sTempletNo = "HeadClassifyInfo2";
			if(sOrgLevel.equals("3")) //分行
				sTempletNo = "BranchClassifyInfo2";
			if(sOrgLevel.equals("6")) //支行
				sTempletNo = "SubbranchClassifyInfo2";
		}
	}
	
	//已完成分类的显示模板编号
	if(sClassifyType.equals("020"))
	{
		if(sObjectType.equals("BusinessContract"))
			sTempletNo = "ViewClassifyInfo1";
		if(sObjectType.equals("BusinessDueBill"))
			sTempletNo = "ViewClassifyInfo2";
	}
	//通过显示模版产生ASDataObject对象doTemp
	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//定义后续事件
	if(sObjectType.equals("BusinessContract")) //按合同分类
		dwTemp.setEvent("AfterUpdate","!五级分类.更新合同分类信息(#OBJECTNO,#FinallyResult,#OriginalPutOutDate,#AccountMonth,#ClassifyLevel,#SUM1,#SUM2,#SUM3,#SUM4,#SUM5)");
	if(sObjectType.equals("BusinessDueBill")) //按借据分类
		dwTemp.setEvent("AfterUpdate","!五级分类.更新合同分类信息(#OBJECTNO,#FinallyResult,null,#AccountMonth,#ClassifyLevel,#SUM1,#SUM2,#SUM3,#SUM4,#SUM5)");
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo + "," + sObjectNo + "," + sObjectType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


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
		{(sClassifyType.equals("010")?"true":"false"),"","Button","保存","保存所有修改","saveRecord()","","","",""},		
		{"true","","Button","返回","返回列表页面","goBack()","","","",""}
		};
		
	%>
<%/*~END~*/%>
<%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		var sObjectType = "<%=sObjectType%>";
		if(sObjectType == "BusinessContract")
		{
			sSum1 = getItemValue(0,getRow(),"SUM1");			
			sSum2 = getItemValue(0,getRow(),"SUM2");			
			sSum3 = getItemValue(0,getRow(),"SUM3");			
			sSum4 = getItemValue(0,getRow(),"SUM4");			
			sSum5 = getItemValue(0,getRow(),"SUM5");
			
			sBusinessBalance = getItemValue(0,getRow(),"Balance");			
			sSum1 = sSum1 + sSum2 + sSum3 + sSum4 + sSum5;
			
			if(sSum1 != sBusinessBalance)
			{
				alert(getBusinessMessage('662'));//当前认定金额之和与合同当前余额不相等，请调整认定金额！
				return;
			}			
		}else
		{			
			setSum();
		}   
    
		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~根据不同的五级分类结果置入不同的值~*/
	function setSum()
	{
		var sOrgLevel = "<%=sOrgLevel%>";
		var sClassifyResult = "";
		var sBusinessSum = getItemValue(0,getRow(),"Balance");
		
    	if(sOrgLevel == "0")
    		sClassifyResult = getItemValue(0,getRow(),"RESULT5");
    	if(sOrgLevel == "3")
    		sClassifyResult = getItemValue(0,getRow(),"RESULT3");
    	if(sOrgLevel == "6")
    		sClassifyResult = getItemValue(0,getRow(),"RESULT2");
    		
        setItemValue(0,getRow(),"SUM1",0);
        setItemValue(0,getRow(),"SUM2",0);
        setItemValue(0,getRow(),"SUM3",0);
        setItemValue(0,getRow(),"SUM4",0);
        setItemValue(0,getRow(),"SUM5",0);
    
		if(sClassifyResult == "01")
		    setItemValue(0,getRow(),"SUM1",sBusinessSum);

		if(sClassifyResult == "02")
		    setItemValue(0,getRow(),"SUM2",sBusinessSum);

		if(sClassifyResult == "03")
		    setItemValue(0,getRow(),"SUM3",sBusinessSum);

		if(sClassifyResult == "04")
		    setItemValue(0,getRow(),"SUM4",sBusinessSum);

		if(sClassifyResult == "05")
		    setItemValue(0,getRow(),"SUM5",sBusinessSum);
	}
		
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{		
		OpenPage("/CreditManage/CreditCheck/ClassifyCognList.jsp","_self","");		
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">


	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		var sOrgLevel = "<%=sOrgLevel%>";
		setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
				
       	if(sOrgLevel == "0")
    	{
    		sClassifyResult = getItemValue(0,getRow(),"RESULT5");
    		setItemValue(0,0,"FinallyResult",sClassifyResult);
			setItemValue(0,0,"ClassifyLevel","0");			
    	}
		if(sOrgLevel == "3")
    	{
    		sClassifyResult = getItemValue(0,getRow(),"RESULT3");
    		setItemValue(0,0,"FinallyResult",sClassifyResult);
			setItemValue(0,0,"ClassifyLevel","3");			
    	}
    	if(sOrgLevel == "6")
    	{
    		sClassifyResult = getItemValue(0,getRow(),"RESULT2");
    		setItemValue(0,0,"FinallyResult",sClassifyResult);
			setItemValue(0,0,"ClassifyLevel","6");						
    	} 	
	}

	function initRow()
	{
       	var sOrgLevel = "<%=sOrgLevel%>";
       	
       	if(sOrgLevel == "0")
    	{
    		setItemValue(0,0,"ResultUserID5","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"ResultUserName5","<%=CurUser.getUserName()%>");			
    	}
		if(sOrgLevel == "3")
    	{
    		setItemValue(0,0,"ResultUserID3","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"ResultUserName3","<%=CurUser.getUserName()%>");		
    	}
    	if(sOrgLevel == "6")
    	{
    		setItemValue(0,0,"ResultUserID2","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"ResultUserName2","<%=CurUser.getUserName()%>");						
    	}        
  	}
	
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>

