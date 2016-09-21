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
<%@page import="com.amarsoft.dict.als.cache.CodeCache"  %>
<%@page import="com.amarsoft.dict.als.object.Item"  %>
<%@page import="com.amarsoft.app.als.prd.analysis.dwcontroller.impl.DefaultObjectWindowController"  %>

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
	String relativeObjectNo = CurPage.getParameter("RelativeObjectNo");
	String relativeObjectType = CurPage.getParameter("RelativeObjectType");
	if(objectNo == null) objectNo = "";
	if(objectType == null) objectType = "";
	
	
	String sTempletNo = "";
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
	BusinessObject businessObject = bom.loadBusinessObject(relativeObjectType, relativeObjectNo);
	String businessType = businessObject.getString("BusinessType");
	String productID = businessObject.getString("ProductID");
	String loanType = businessObject.getString("LOANTYPE");
	Item changeCode = CodeCache.getItem("ChangeCode", transCode);
	sTempletNo = changeCode.getAttribute6();
	
	if(sTempletNo.indexOf("if")>=0)
	{
		sTempletNo = sTempletNo.replaceAll("BusinessType", businessType);
		sTempletNo = Expression.getExpressionValue(sTempletNo, Sqlca).stringValue();
	}
	
	//通过显示模版产生ASDataObject对象doTemp
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", objectNo);
	inputParameter.setAttributeValue("LoanType", businessObject.getString("LoanType"));
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	if("555".equals(businessType)){
		doTemp.setVisible("OLDLOANGENERATETYPE,LOANGENERATETYPE", false);
	}
	
	dwTemp.Style="2";
	DefaultObjectWindowController dwcontroller = new DefaultObjectWindowController();
	dwcontroller.initDataWindow(dwTemp,businessObject);
	doTemp.setVisible("BUSINESSCURRENCY", false);

	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");
	
	%>

<%
	String sButtons[][] = {
		{"true","All","Button","保存","保存修改","saveRecord()","","","",""},
	};
%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>


<script type="text/javascript">
	//全局变量，JS中需要
	var userId="<%=CurUser.getUserID()%>";
	var orgId="<%=CurUser.getOrgID()%>";
	
	/*~[Describe=保存;InputParam=无;OutPutParam=无;]~*/
	function saveRecord(){
		if("ChangeLimitInfo06"=="<%=sTempletNo%>"){
			beforeSave();
			var businessTerm = getItemValue(0, getRow(0), "BusinessTerm");
			var RPTTermID = getItemValue(0, getRow(0), "RPTTermID");
			var returnValue = AsControl.RunASMethod("WorkFlowEngine","CheckBusinessTerm","<%=relativeObjectNo%>,"+businessTerm+","+RPTTermID);
			if(returnValue.split("@")[0] == "false"){
				alert(returnValue.split("@")[2]);
				return;
			}
		}
		as_save("selfRefresh()");
	}
	
</script>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditManage/js/credit_common.js"></script>

<script type="text/javascript">
	var rightType="<%=CurPage.getParameter("RightType")%>";
	var objectType = "<%=objectType%>";
	var objectNo = "<%=objectNo%>";
	var loanType = "<%=loanType%>";
	function changeBusinessTerm(){
		calcBusinessTerm();
		var businessTerm = getItemValue(0, getRow(0), "BusinessTerm");
		var RPTTermID = getItemValue(0, getRow(0), "RPTTermID");
		var returnValue = AsControl.RunASMethod("WorkFlowEngine","CheckBusinessTerm","<%=relativeObjectNo%>,"+businessTerm+","+RPTTermID);
		if(returnValue.split("@")[0] == "false"){
			alert(returnValue.split("@")[2]);
			if(returnValue.split("@")[1] == "BusinessTerm"){
				setItemValue(0, getRow(0), "BusinessTerm", "0");
				setItemValue(0, getRow(0), "BusinessTermYear", "0");
				setItemValue(0, getRow(0), "BusinessTermMonth", "0");
				setItemValue(0, getRow(0), "BusinessTermDay", "0");
				return;
			}else{
				setItemValue(0, getRow(0), "RPTTermID", "");
				return;
			}
		}
		initRPT();
	}
	
	function beforeSave(){
		if(rightType == "ReadOnly") return;
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"RAT");
		if(subdwname==-1)return;
		var currency = getItemValue(0,getRow(0),"BusinessCurrency");
		var termUnit = getItemValue(0,getRow(0),"BusinessTermUnit");
		var termMonth = getItemValue(0,getRow(0),"BusinessTerm");
		var termDay = getItemValue(0,getRow(0),"BusinessTermDay");
		var sum = getRowCount(subdwname);
		for(var i=0;i<sum;i++){
			var LoanRateTermID = getItemValue(0, getRow(0), "LoanRateTermID");
			var baseRateType = getItemValue(subdwname,i,"BaseRateType");
			var rateUnit = getItemValue(subdwname,i,"RateUnit");
			
			if(typeof(baseRateType) == "undefined" || baseRateType == "" || baseRateType == null)return;
			
			var baseRateGrade = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.common.action.RateAction","getBaseRateGrade","BaseRateType="+baseRateType+",RateUnit="+rateUnit+",Currency="+currency+",TermUnit="+termUnit+",TermMonth="+termMonth+",TermDay="+termDay);
			if(typeof(baseRateGrade) == "undefined" || baseRateGrade == "" || baseRateGrade == null)return;
			setItemValue(subdwname,i,"BaseRateGrade",baseRateGrade);
			
			var baseRate = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.common.action.RateAction","getBaseRate","BaseRateType="+baseRateType+",RateUnit="+rateUnit+",Currency="+currency+",TermUnit="+termUnit+",TermMonth="+termMonth+",TermDay="+termDay);
			if(baseRate==0 || baseRate.length==0){
				alert("请检查是否已经维护基准利率！");
				return;
			}
			setItemValue(subdwname,i,"BaseRate",baseRate);
			if(LoanRateTermID == "RAT03"){
				LoanRateTermID = getItemValue(subdwname,i,"RateMode");
			}
			var BusinessRate = getItemValue(subdwname,i,"BusinessRate");
			var RateFloat = getItemValue(subdwname,i,"RateFloat");
			if(LoanRateTermID == "RAT01" || LoanRateTermID == "1"){
				BusinessRate = baseRate*(1+RateFloat/100.0);
				setItemValue(subdwname, i, "BusinessRate", BusinessRate);
			}else if(LoanRateTermID == "RAT02" || LoanRateTermID == "2"){
				RateFloat = ((BusinessRate-baseRate)/baseRate)*100.0;
				setItemValue(subdwname, i, "RateFloat", RateFloat);
			}
		}
	}
	
	function selfRefresh()
	{
		var para = "ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&TransSerialNo=<%=transSerialNo%>&TransCode=<%=transCode%>&RelativeObjectNo=<%=relativeObjectNo%>&RelativeObjectType=<%=relativeObjectType%>";
		AsControl.OpenPage("/CreditLineManage/CreditLineLimit/CreditLine/LimitChangeInfo01.jsp", para, "_self");
	}
	
	//计算基准利率，需页面录入开始时间、结束时间、基准利率类型
	function initBaseRate(){
		if(rightType == "ReadOnly") return;
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"RAT");
		if(subdwname==-1)return;
		var baseRateType = getItemValue(subdwname,getRow(subdwname),"BaseRateType");
		var rateUnit = getItemValue(subdwname,getRow(subdwname),"RateUnit");
		var termMonth = getItemValue(0,getRow(0),"BusinessTerm");
		var termDay = getItemValue(0,getRow(0),"BusinessTermDay");
		var currency = "<%=businessObject.getString("BusinessCurrency")%>";
		var termUnit = "<%=businessObject.getString("BusinessTermUnit")%>";
		
		if(typeof(baseRateType) == "undefined" || baseRateType == "" || baseRateType == null)return;
		
		var baseRateGrade = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.common.action.RateAction","getBaseRateGrade","BaseRateType="+baseRateType+",RateUnit="+rateUnit+",Currency="+currency+",TermUnit="+termUnit+",TermMonth="+termMonth+",TermDay="+termDay);
		if(typeof(baseRateGrade) == "undefined" || baseRateGrade == "" || baseRateGrade == null)return;
		setItemValue(subdwname,getRow(subdwname),"BaseRateGrade",baseRateGrade);
		
		var baseRate = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.common.action.RateAction","getBaseRate","BaseRateType="+baseRateType+",RateUnit="+rateUnit+",Currency="+currency+",TermUnit="+termUnit+",TermMonth="+termMonth+",TermDay="+termDay);
		if(baseRate==0 || baseRate.length==0){
			alert("请检查是否已经维护基准利率！");
			return;
		}
		setItemValue(subdwname,getRow(subdwname),"BaseRate",baseRate);
	}
	
	$(document).ready(function(){
		if("ChangeLimitInfo06"=="<%=sTempletNo%>"){
			calcBusinessTerm();
			setItemValue(0,getRow(0),"BusinessTermUnit","<%=businessObject.getString("BusinessTermUnit")%>");
			setItemValue(0,getRow(0),"BusinessCurrency","<%=businessObject.getString("BusinessCurrency")%>");
			setItemValue(0,0,"BUSINESSTYPE","<%=businessType%>");
			setItemValue(0,0,"PRODUCTID","<%=productID%>");
			changePaymentType();

			initRepriceDate();
			initBusinessRate();
			initFinbaseRateType(loanType);
			setFineRateType();
		}
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
