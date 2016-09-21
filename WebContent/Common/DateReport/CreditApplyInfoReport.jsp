<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@page import="com.amarsoft.are.jbo.JBOTransaction"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.lang.DateX"%>
<%@page import="com.amarsoft.app.bizmethod.*"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>

<style>
	.modify_div{
		position: absolute;
		top:10px;
		right:15px;
	}
</style>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
<%
	/*
		Author:   赵晓建  2014/11/12
		Tester:
		Content: 业务基本信息
		Input Param:
				 ObjectType：对象类型
				 ObjectNo：对象编号
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
<%
	//String PG_TITLE = "业务基本信息"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//定义变量：SQL语句
	String sSql = "";
	//定义变量：显示模版名称、发生类型、暂存标志
	String sDisplayTemplet = "",sOccurType = "",sTempSaveFlag = "";
	
	//获得页面参数	
	String sObjectType = CurPage.getParameter("ObjectType");//jbo.app.BUSINESS_APPLY
	String sObjectNo = CurPage.getParameter("ObjectNo");
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	
	String productID = Sqlca.getString(new SqlObject("select case when ProductID is null or ProductID = ' ' then BusinessType else ProductID end from BUSINESS_APPLY where SerialNo=:SerialNo").setParameter("SerialNo", sObjectNo));
	
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select ProductType2 as ProductType2,ProductType3 as ProductType3 from PRD_PRODUCT_LIBRARY WHERE Status in('1','0') and ProductID=:ProductID").setParameter("ProductID", productID));
	String productType2 = "",productType3="";
	if(rs.next())
	{
		productType2 = rs.getString("ProductType2");
		productType3 = rs.getString("ProductType3");
	}
	rs.close();
	
	
	if("01".equals(productType3))
	{
		if("2".equals(productType2))
		{
			sDisplayTemplet = "ApplyCLInfo0010Report";
		}
		else
		{
			sDisplayTemplet = "ApplyInfo0020Report";
		}
	}else{
		sDisplayTemplet = "ApplyInfo0030Report";
	}
	if("500".equals(productID))
	{
		sDisplayTemplet = "ApplyRZInfo0010Report";
	}
	if("502".equals(productID))
	{
		sDisplayTemplet = "ApplyRZInfo0020Report";
	}
	if("666".equals(productID))
	{
		sDisplayTemplet = "ApplyCLInfo0020Report";
	}

	//通过显示模版产生ASDataObject对象doTemp
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType", sObjectType);
	inputParameter.setAttributeValue("ObjectNo", sObjectNo);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sDisplayTemplet,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();


	dwTemp.Style="2";   

	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");
	
	%>

<%
	String sButtons[][] = {
		{"false","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"false","All","Button","暂存","暂时保存所有修改内容","saveRecordTemp()","","","",""}, 
		{"false","","Button","打印条形码","打印条形码","print()","","","",""},
	};
	//当暂存标志为否，即已保存，暂存按钮应隐藏
	if(sTempSaveFlag.equals("0"))
		sButtons[1][0] = "false";
%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>


<script type="text/javascript">
	function print(){
		var ContractArtificialNo = getItemValue(0, getRow(), "ContractArtificialNo");
		AsControl.PopPage("/CreditManage/CreditApply/PrintSerialNo.jsp","ObjectNo="+ContractArtificialNo,"dialogWidth:400px;dialogHeight:80px;");
	}
	//全局变量，JS中需要
	var userId="<%=CurUser.getUserID()%>";
	var orgId="<%=CurUser.getOrgID()%>";
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		//录入数据有效性检查
		if ( !ValidityCheck() ){
			return;	
		}
		beforeUpdate();
		setItemValue(0,getRow(),"TempSaveFlag","0"); //暂存标志（1：是；0：否）
		as_save();
	}
	
	/*~[Describe=暂存;InputParam=无;OutPutParam=无;]~*/
	function saveRecordTemp()
	{
		setItemValue(0,getRow(),'TempSaveFlag',"1");//暂存标志（1：是；0：否）
		as_saveTmp("myiframe0");   //暂存
	}		
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{	
		setItemValue(0,0,"UpdateDate","<%=DateHelper.getToday()%>");					
	}
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{
		return true;
	}
	
</script>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditManage/js/credit_common.js"></script>

<script type="text/javascript">
	$(document).ready(function(){
		calcExceptReason();
		calcBillMail();
		initRPT();
		initRate();
		initATT();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
