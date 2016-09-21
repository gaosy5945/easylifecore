<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@page import="com.amarsoft.amarscript.Expression"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.lang.DateX"%>
<%@page import="com.amarsoft.app.bizmethod.*"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@page import="com.amarsoft.are.jbo.JBOTransaction"%>
<%@page import="com.amarsoft.app.als.afterloan.change.handler.ChangeCommonHandler"%>
<%@page import="com.amarsoft.app.als.awe.ow.ALSBusinessProcess"%>

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
	String PG_TITLE = "业务基本信息"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//定义变量
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	String transSerialNo = CurPage.getParameter("TransSerialNo");
	String transCode = CurPage.getParameter("TransCode");
	if(objectNo == null) objectNo = "";
	if(objectType == null) objectType = "";
	
	
	String sTempletNo = "";
	String businessType="",productid="",maturityDate="",businesstermunit="",businesscurrency="";
	double businessappAMT=0d;
	int term=0,termDay=0;
	String selectCode = "select * from code_library where codeno='ChangeCode' and ItemNo=? ";
	PreparedStatement ps = Sqlca.getConnection().prepareStatement(selectCode);
	ps.setString(1, transCode);
	ResultSet rs = ps.executeQuery();
	if(rs.next())
	{
		sTempletNo = rs.getString("Attribute8");
	}
	rs.close();
	ps.close();
	
	String selectBC ="select bc.businesstype,bc.productid,cl.MaturityDate,cl.BusinessappAMT,cl.CLTermDay,cl.CLTerm,NVL(cl.businesstermunit,bc.businesstermunit)as businesstermunit,bc.businesscurrency "+ 
			"from Business_contract bc,cl_info cl where bc.SerialNo=? "+
			" and cl.objecttype='jbo.app.BUSINESS_CONTRACT' and cl.objectno=bc.serialno and cl.cltype not in ('0105','0106') ";
	ps = Sqlca.getConnection().prepareStatement(selectBC);
	ps.setString(1, objectNo);
	rs = ps.executeQuery();
	if(rs.next())
	{
		businessType = rs.getString("BusinessType");
		productid = rs.getString("productid");
		maturityDate = rs.getString("MaturityDate");
		businessappAMT = rs.getDouble("BusinessappAMT");
		term = rs.getInt("CLTerm");
		termDay = rs.getInt("CLTermDay");
		businesstermunit = rs.getString("businesstermunit");
		businesscurrency = rs.getString("businesscurrency");
	}
	rs.close();
	ps.close();
	
	int termYear = term/12;
	int termMonth = term%12;
	
	if(sTempletNo.indexOf("if")>=0)
	{
		sTempletNo = sTempletNo.replaceAll("BusinessType", businessType);
		sTempletNo = Expression.getExpressionValue(sTempletNo, Sqlca).stringValue();
	}
	
	//通过显示模版产生ASDataObject对象doTemp
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("TransSerialNo", transSerialNo);
	inputParameter.setAttributeValue("TransCode", transCode);
	inputParameter.setAttributeValue("ContractSerialNo", objectNo);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	if("555".equals(businessType)){
		doTemp.setVisible("OLDLOANGENERATETYPE,LOANGENERATETYPE", false);
	}

	dwTemp.Style="2";

	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");
	
	%>

<%
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改/新增额度调整交易","saveRecord()","","","",""},
	};
%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>


<script type="text/javascript">
	//全局变量，JS中需要
	var userId="<%=CurUser.getUserID()%>";
	var orgId="<%=CurUser.getOrgID()%>";
	
	/*~[Describe=保存;InputParam=无;OutPutParam=无;]~*/
	function saveRecord(){
		if(getRowCount(0)==0){
			if(!confirm("确认要发起当前额度的调整交易吗？")){
				return;
			}
			as_saveTmp("selfRefresh()");
		}else{
			as_save("selfRefresh()");
		}
		
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/%>
	function initRow(){
		if (getRowCount(0)==0){
			//1、额度调整基本信息
			setItemValue(0,0,"OLDCLMATURITYDATE","<%=maturityDate%>");
			setItemValue(0,0,"OLDBUSINESSSUM","<%=businessappAMT%>");
			setItemValue(0,0,"CONTRACTSERIALNO","<%=objectNo%>");
			setItemValue(0,0,"OldBusinessTerm","<%=term%>");
			setItemValue(0,0,"OldBusinessTermDay","<%=termDay%>");
			setItemValue(0,0,"OldBusinessTermYear","<%=termYear%>");
			setItemValue(0,0,"OldBusinessTermMonth","<%=termMonth%>");
		}
		setItemValue(0,0,"BUSINESSTYPE","<%=businessType%>");
		setItemValue(0,0,"PRODUCTID","<%=productid%>");
		setItemValue(0,0,"BusinessCurrency","<%=businesscurrency%>");
		setItemValue(0,0,"BUSINESSTERMUNIT","<%=businesstermunit%>");
	}

	function calcBusinessTerm(){
		var businessTermYear = getItemValue(0,getRow(),"BusinessTermYear");
		var businessTermMonth = getItemValue(0,getRow(),"BusinessTermMonth");
		if(typeof(businessTermYear) == "undefined" || businessTermYear.length == 0
			|| typeof(businessTermMonth) == "undefined" || businessTermMonth.length == 0) return;
		setItemValue(0,getRow(),"BusinessTerm",parseInt(businessTermYear)*12+parseInt(businessTermMonth));
	}
</script>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditManage/js/credit_common.js"></script>

<script type="text/javascript">
	var rightType="<%=CurPage.getParameter("RightType")%>";
	var objectType = "jbo.acct.BUSINESS_CONTRACT_CHANGE";
	var objectNo = "";
	function selfRefresh()
	{
		var para = "ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&TransSerialNo=<%=transSerialNo%>&TransCode=<%=transCode%>";
		AsControl.OpenPage("/CreditLineManage/CreditLineLimit/CreditLine/LimitChangeInfo.jsp", para, "_self");
	}
	
	$(document).ready(function(){
		//calcExceptReason();
		//calcBillMail();
		changePaymentType();

		initRepriceDate();
		initBusinessRate();
		setFineRateType();
		//initATT();
		//showReverseFund();
		//checkAccount('ACT_AccountIndicator','ACT_AccountType','ACT_AccountNo','ACT_AccountName','ACT_AccountCurrency','ACT_AccountNo1','ACT_CustomerID','ACT_MFCustomerID');
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
