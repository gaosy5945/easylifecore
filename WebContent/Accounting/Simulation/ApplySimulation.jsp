<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.config.impl.CashFlowConfig" %>
<%@ page import="com.amarsoft.app.base.trans.TransactionHelper" %>
<%@ page import="com.amarsoft.app.base.util.DateHelper" %>
<%@ page import="com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS" %>

<%@ include file="/IncludeBegin.jsp"%>
<%@ include file="/Accounting/include_accounting.jspf"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "还款计划列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String applySerialNO = CurPage.getParameter("ApplySerialNo");
	String userID = CurPage.getParameter("UserID");
	String orgID = CurPage.getParameter("OrgID");
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
	BusinessObject ap = bom.keyLoadBusinessObject("jbo.app.BUSINESS_APPLY", applySerialNO);
	//贷款基本信息
	String businessSum = ap.getString("BUSINESSSUM");
	String currency = ap.getString("BUSINESSCURRENCY");
	String putoutDate = ap.getString("OCCURDATE");
	String loanTerm = ap.getString("BUSINESSTERM");
	String maturityDate = ap.getString("MATURITYDATE");
	
	BusinessObject simulationObject = BusinessObject.createBusinessObject("jbo.acct.ACCT_PUTOUT");
	simulationObject.setAttributeValue("SerialNo", "simulation_loan");
	simulationObject.setAttributeValue("LoanSerialNo", "simulation_loan");
	simulationObject.setAttributeValue("BusinessSum", businessSum);
	simulationObject.setAttributeValue("Currency", currency);
	simulationObject.setAttributeValue("PutoutDate", DateHelper.getBusinessDate());
	simulationObject.setAttributeValue("TERMMONTH", loanTerm);
	simulationObject.setAttributeValue("MaturityDate", DateHelper.getRelativeDate(DateHelper.getRelativeDate(DateHelper.getBusinessDate(), DateHelper.TERM_UNIT_MONTH, Integer.parseInt(loanTerm)),DateHelper.TERM_UNIT_DAY,ap.getInt("BUSINESSTERMDAY")));
	simulationObject.setAttributeValue("LoanPeriod", 0);
	
	List<BusinessObject> rateObjects = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTANTS.loan_rate_segment, "RateType in('01','06') and ObjectType=:ObjectType and ObjectNo=:ObjectNo","ObjectType","jbo.app.BUSINESS_APPLY","ObjectNo",applySerialNO);
	simulationObject.appendBusinessObjects(rateObjects.get(0).getBizClassName(), rateObjects);
	BusinessObject feeObject = bom.loadBusinessObject(BUSINESSOBJECT_CONSTANTS.loan_rate_segment, "ObjectType","jbo.app.BUSINESS_APPLY","ObjectNo",applySerialNO,"RateType","05");
	simulationObject.appendBusinessObject(rateObjects.get(0).getBizClassName(), feeObject);
	BusinessObject RPTObject = bom.loadBusinessObject(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment, "ObjectType","jbo.app.BUSINESS_APPLY","ObjectNo",applySerialNO);
	RPTObject.setAttributeValue("AMOUNTCODE", CashFlowConfig.getPaymentScheduleAttribute("1", "AmountCode"));
	String defaultDueDay = RPTObject.getString("DEFAULTDUEDAY");
	RPTObject.setAttributeValue("PSType", "1,3");
	simulationObject.appendBusinessObject(RPTObject.getBizClassName(), RPTObject);
	
	BusinessObject transaction = TransactionHelper.createTransaction("1001", simulationObject, null, 
			userID, orgID, DateHelper.getBusinessDate(),bom);
	TransactionHelper.executeTransaction(transaction, bom);
	BusinessObject relativeObject = transaction.getBusinessObject(transaction.getString("RelativeObjectType"));
	simulationObject.setAttributeValue("LoanSerialNo", relativeObject.getKeyString());
	List<BusinessObject> list =relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule,"PSType<>:PSType","PSType","2");
	String rightType =  "RPT05".equals(RPTObject.getString("TERMID"))?"":"ReadOnly";//灵活等额本息就要求可修改
	
	double allPrincipalAmt = 0.0;
	double allInteAmt = 0.0;
	double allFeeAmt = 0.0;
	double allAmt = 0.0;
	int firstPERIODNO = list.get(0).getInt("PERIODNO");
	int maxPERIODNO = list.size() + firstPERIODNO - 1;
	String rptTermID = simulationObject.getString("RPTTERMID");
// 	if("RPT05".equals(simulationObject.getString("RPTTERMID"))){
// 		List<BusinessObject> rptList = parentObject.getBusinessObjects();//("jbo.acct.ACCT_RPT_SEGMENT");
// 		if(rptList!=null &&rptList.size() > 0  )  {
// 			for(BusinessObject rpt:rptList)
// 			{

// 				if(rpt.getString("Status").equals("1"))
// 					defaultDueDay = rpt.getString("DefaultDueDay");
// 				if(defaultDueDay.length() == 1)
// 					defaultDueDay = "0" + defaultDueDay;
// 			}
// 		}
// 		if(defaultDueDay.equals("")){
// 			defaultDueDay = simulationObject.getString("PutOutDate").substring(8,10);
// 		}
// 	}
	
	%>
<%/*~END~*/%>

<script language="javascript">
	var boList = new Array();
</script>
<html> 
<head>
<title></title>
</head>
<body class=pagebackground leftmargin="0" topmargin="0" >
<input type=button value='导出' onclick="excelShow()"> 
<div id="Layer1" style="position:absolute;width:99.9%; height:99.9%; z-index:1; overflow: auto">
<table align='center' width='70%' border=0 cellspacing="4" cellpadding="0">
<tr id = "CRTitle"> 
	<td colspan="7" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>客户还款计划</font></td>
</tr>
<tr id = "CRTitle"> 
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>期次</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>还款日期</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>本金</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>利息</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>费用</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>还款金额</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>剩余本金</font></td>
</tr>

	<%
	if(list != null)
	{
		for(BusinessObject bo:list)
		{
			BusinessObject pbo = BusinessObjectHelper.getBusinessObjectBySql(list, "SerialNo=:SerialNo", "SerialNo", bo.getString("ParentSerialNo"));
			if(pbo != null) continue;
			
			double otherFeeAmt = 0.0d;
			
			List<BusinessObject> cls = BusinessObjectHelper.getBusinessObjectsBySql(list, "ParentSerialNo=:SerialNo", "SerialNo", bo.getString("SerialNo"));
			for(BusinessObject cl:cls)
			{
				otherFeeAmt += cl.getDouble("PayPrincipalAmt")+cl.getDouble("PayInterestAmt");
			}
			
			String payPrincipalColor = "black";
			String payInteColor = "black";
			String payDateColor = "black";
			String fixInstallmentColor = "black";
			String flag = ""; //1 为本金调整 2 为还款额调整
			
			if( bo.getDouble("FixPrincipalAmt") > 0.0d)
			{
				payPrincipalColor = "red";
				flag = "1";
			}
			else if(bo.getDouble("FixInstallmentAmt") > 0.0d)
			{
				fixInstallmentColor = "red";
				flag = "2";
			}
			else if(!defaultDueDay.equals("") && !bo.getString("PayDate").substring(8, 10).equals(defaultDueDay) && !bo.getString("PayDate").equals(maturityDate))
			{
				payDateColor = "red";
			}
			
			allPrincipalAmt += bo.getDouble("PayPrincipalAmt");
			allInteAmt += bo.getDouble("PAYINTERESTAMT");
			allFeeAmt+=otherFeeAmt;
			allAmt += bo.getDouble("PayPrincipalAmt")+bo.getDouble("PAYINTERESTAMT")+otherFeeAmt;
		%>
		<script language="javascript">
		boList[<%=bo.getInt("PERIODNO")%>] = Array(<%=bo.getString("PayDate")%>,<%=bo.getDouble("PayPrincipalAmt")%>,<%=bo.getDouble("PAYINTERESTAMT")%>,<%=bo.getDouble("FixInstallmentAmt")%>,<%=bo.getDouble("FixPrincipalAmt")%>);
		</script>
		<tr>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><%=bo.getInt("PERIODNO")%><input id="SerialNo<%=bo.getInt("PERIODNO")%>" type=hidden value="<%=bo.getString("SerialNo")%>"/></font></td>
			<input id="Flag<%=bo.getInt("PERIODNO")%>" type=hidden value="<%=flag%>"/></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayDate<%=bo.getInt("PERIODNO")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payDateColor%>' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toString(bo.getString("PayDate"))%>" <%=rightType %> onclick=selectDate("<%=bo.getInt("PERIODNO")%>","PayDate","<%=bo.getInt("PERIODNO")%>") ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayPrincipalAmt<%=bo.getInt("PERIODNO")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payPrincipalColor%>' class=fftdinput type=text onblur=parent.trimField(this) value="<%=DataConvert.toMoney(bo.getDouble("PayPrincipalAmt"))%>" <%=rightType %> onchange=ChangeValue("<%=bo.getInt("PERIODNO")%>","PayPrincipalAmt","<%=bo.getInt("PERIODNO")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PAYINTERESTAMT<%=bo.getInt("PERIODNO")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payInteColor%>; ' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getDouble("PAYINTERESTAMT"))%>" onchange=ChangeValue("<%=bo.getInt("PERIODNO")%>","PAYINTERESTAMT","<%=bo.getInt("PERIODNO")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayFeeAmt<%=bo.getInt("PeriodNo")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payInteColor%>; ' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(otherFeeAmt)%>" onchange=ChangeValue("<%=bo.getInt("PeriodNo")%>","PayFeeAmt","<%=bo.getInt("PeriodNo")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="FixInstallmentAmt<%=bo.getInt("PERIODNO")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=fixInstallmentColor%>' class=fftdinput type=text onblur=parent.trimField(this) value="<%=DataConvert.toMoney(bo.getDouble("PayPrincipalAmt")+bo.getDouble("PAYINTERESTAMT")+otherFeeAmt)%>" <%=rightType %> onchange=ChangeValue("<%=bo.getInt("PERIODNO")%>","FixInstallmentAmt","<%=bo.getInt("PERIODNO")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PrincipalBalance<%=bo.getInt("PERIODNO")%>" style='text-align: right;WIDTH: 80px; COLOR: black;' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getDouble("PrincipalBalance"))%>" onchange=ChangeValue("<%=bo.getInt("PERIODNO")%>","PrincipalBalance","<%=bo.getInt("PERIODNO")%>")></font></td>
		</tr>
		<%
		}
	}
	%>
	<tr>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'>合计</font></td>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allPrincipalAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allInteAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allFeeAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allAmt)%></font></td>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'></font></td>
	</tr>
</table>


<table align='center' width='70%' border=0 cellspacing="4" cellpadding="0">
<tr id = "CRTitle"> 
	<td colspan="7" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>IRR账卡</font></td>
</tr>
<tr id = "CRTitle"> 
	<td colspan="7" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>IRR月利率:<%=Arith.round(relativeObject.getDouble("IRRRate"),4)%>%</font></td>
</tr>
<tr id = "CRTitle"> 
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>期次</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>日期</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>应收IRR本金 </font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>应还IRR利息</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>应还IRR费用</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>应还总金额</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>IRR剩余本金</font></td>
</tr>

	<%
	list =relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule,"PSType=:PSType","PSType","2");
	allPrincipalAmt = 0d;
	allInteAmt =0d;
	allFeeAmt = 0d;
	allAmt=0;
	if(list != null)
	{
		for(BusinessObject bo:list)
		{
			BusinessObject pbo = BusinessObjectHelper.getBusinessObjectBySql(list, "SerialNo=:SerialNo", "SerialNo", bo.getString("ParentSerialNo"));
			if(pbo != null) continue;
			
			double otherFeeAmt = 0.0d;
			
			List<BusinessObject> cls = BusinessObjectHelper.getBusinessObjectsBySql(list, "ParentSerialNo=:SerialNo", "SerialNo", bo.getString("SerialNo"));
			for(BusinessObject cl:cls)
			{
				otherFeeAmt += cl.getDouble("PayPrincipalAmt")+cl.getDouble("PayInterestAmt");
			}
			
			String payPrincipalColor = "black";
			String payInteColor = "black";
			String payDateColor = "black";
			String fixInstallmentColor = "black";
			String flag = ""; //1 为本金调整 2 为还款额调整
			
			if( bo.getDouble("FixPrincipalAmt") > 0.0d)
			{
				payPrincipalColor = "red";
				flag = "1";
			}
			else if(bo.getDouble("FixInstallmentAmt") > 0.0d)
			{
				fixInstallmentColor = "red";
				flag = "2";
			}
			else if(!defaultDueDay.equals("") && !bo.getString("PayDate").substring(8, 10).equals(defaultDueDay) && !bo.getString("PayDate").equals(maturityDate))
			{
				payDateColor = "red";
			}
			
			allPrincipalAmt += bo.getDouble("PayPrincipalAmt");
			allInteAmt += bo.getDouble("PAYINTERESTAMT");
			allFeeAmt+=otherFeeAmt;
			allAmt += bo.getDouble("PayPrincipalAmt")+bo.getDouble("PAYINTERESTAMT")+otherFeeAmt;
		%>
		<script language="javascript">
		boList[<%=bo.getInt("PERIODNO")%>] = Array(<%=bo.getString("PayDate")%>,<%=bo.getDouble("PayPrincipalAmt")%>,<%=bo.getDouble("PAYINTERESTAMT")%>,<%=bo.getDouble("FixInstallmentAmt")%>,<%=bo.getDouble("FixPrincipalAmt")%>);
		</script>
		<tr>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><%=bo.getInt("PERIODNO")%><input id="SerialNo<%=bo.getInt("PERIODNO")%>" type=hidden value="<%=bo.getString("SerialNo")%>"/></font></td>
			<input id="Flag<%=bo.getInt("PERIODNO")%>" type=hidden value="<%=flag%>"/></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayDate<%=bo.getInt("PERIODNO")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payDateColor%>' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toString(bo.getString("PayDate"))%>" <%=rightType %> onclick=selectDate("<%=bo.getInt("PERIODNO")%>","PayDate","<%=bo.getInt("PERIODNO")%>") ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayPrincipalAmt<%=bo.getInt("PERIODNO")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payPrincipalColor%>' class=fftdinput type=text onblur=parent.trimField(this) value="<%=DataConvert.toMoney(bo.getDouble("PayPrincipalAmt"))%>" <%=rightType %> onchange=ChangeValue("<%=bo.getInt("PERIODNO")%>","PayPrincipalAmt","<%=bo.getInt("PERIODNO")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PAYINTERESTAMT<%=bo.getInt("PERIODNO")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payInteColor%>; ' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getDouble("PAYINTERESTAMT"))%>" onchange=ChangeValue("<%=bo.getInt("PERIODNO")%>","PAYINTERESTAMT","<%=bo.getInt("PERIODNO")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayFeeAmt<%=bo.getInt("PeriodNo")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payInteColor%>; ' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(otherFeeAmt)%>" onchange=ChangeValue("<%=bo.getInt("PeriodNo")%>","PayFeeAmt","<%=bo.getInt("PeriodNo")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="FixInstallmentAmt<%=bo.getInt("PERIODNO")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=fixInstallmentColor%>' class=fftdinput type=text onblur=parent.trimField(this) value="<%=DataConvert.toMoney(bo.getDouble("PayPrincipalAmt")+bo.getDouble("PAYINTERESTAMT")+otherFeeAmt)%>" <%=rightType %> onchange=ChangeValue("<%=bo.getInt("PERIODNO")%>","FixInstallmentAmt","<%=bo.getInt("PERIODNO")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PrincipalBalance<%=bo.getInt("PERIODNO")%>" style='text-align: right;WIDTH: 80px; COLOR: black;' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getDouble("PrincipalBalance"))%>" onchange=ChangeValue("<%=bo.getInt("PERIODNO")%>","PrincipalBalance","<%=bo.getInt("PERIODNO")%>")></font></td>
		</tr>
		<%
		}
	}
	%>
	<tr>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'>合计</font></td>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allPrincipalAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allInteAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allFeeAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allAmt)%></font></td>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'></font></td>
	</tr>
</table>
</div>
</body>
</html>

<script language="javascript">
	/*~[Describe=导出excel;InputParam=无;OutPutParam=无;]~*/
	function excelShow()
	{
		var mystr = document.all('Layer1').innerHTML;
		spreadsheetTransfer(mystr.replace(/type=checkbox/g,"type=hidden"));
	}
	
</script>
<%@ include file="/IncludeEnd.jsp"%>