<%@page import="com.amarsoft.app.accounting.cashflow.CashFlowHelper"%>
<%@page import="com.amarsoft.app.accounting.config.impl.CashFlowConfig"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObjectManager"%>
<%@page import="com.amarsoft.app.base.trans.TransactionHelper"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObject"%>
<%@page import="com.amarsoft.are.util.json.*" %>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "还款计划列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	String rpt = CurPage.getParameterNoCheck("rpt");
	String rat = CurPage.getParameterNoCheck("rat");
	String loan = CurPage.getParameterNoCheck("loan");
	String ps = CurPage.getParameterNoCheck("ps");
	
	BusinessObject simulationObject = BusinessObject.createBusinessObject("jbo.acct.ACCT_PUTOUT");
	simulationObject.setAttributes(BusinessObject.createBusinessObject(JSONDecoder.decode(loan)));
	simulationObject.setAttributeValue("SerialNo", "simulation_loan");
	simulationObject.setAttributeValue("LoanSerialNo", "simulation_loan");
	simulationObject.setAttributeValue("LoanPeriod", 0);
	
	
	JSONObject rpts = JSONDecoder.decode(rpt);
	BusinessObject RPTObject=null;
	for(int i = 0;i < rpts.size(); i ++)
	{	
		RPTObject = BusinessObject.createBusinessObject("jbo.acct.ACCT_RPT_SEGMENT");
		RPTObject.setAttributes(BusinessObject.createBusinessObject((JSONObject)rpts.get(i).getValue()));
		RPTObject.setAttributeValue("STATUS", "1");
		RPTObject.setAttributeValue("AMOUNTCODE", CashFlowConfig.getPaymentScheduleAttribute("1", "AmountCode"));
		RPTObject.generateKey();
		simulationObject.appendBusinessObject(RPTObject.getBizClassName(), RPTObject);
	}
	if(!"RPT-14".equals(RPTObject.getString("TERMID"))){
		JSONObject rats = JSONDecoder.decode(rat);
		for(int i = 0;i < rats.size(); i ++)
		{
			BusinessObject rateObject = BusinessObject.createBusinessObject("jbo.acct.ACCT_RATE_SEGMENT");
			rateObject.setAttributes(BusinessObject.createBusinessObject((JSONObject)rats.get(i).getValue()));
			rateObject.setAttributeValue("STATUS", "1");
			rateObject.generateKey();
			simulationObject.appendBusinessObject(rateObject.getBizClassName(), rateObject);
		}
	}
	
	if(!StringX.isEmpty(ps))
	{
		JSONObject pss = JSONDecoder.decode(ps);
		for(int i = 0;i < pss.size(); i ++)
		{
			BusinessObject paymentSchedule = BusinessObject.createBusinessObject("jbo.acct.ACCT_PAYMENT_SCHEDULE");
			paymentSchedule.setAttributes(BusinessObject.createBusinessObject((JSONObject)pss.get(i).getValue()));
			paymentSchedule.setAttributeValue("STATUS", "1");
			paymentSchedule.generateKey();
			simulationObject.appendBusinessObject("FixPaymentSchedule", paymentSchedule);
		}
	}
	
	BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
	BusinessObject transaction = TransactionHelper.createTransaction("1001", simulationObject, null, 
			CurUser.getUserID(), CurUser.getOrgID(), DateHelper.getBusinessDate(),bomanager);
	TransactionHelper.executeTransaction(transaction, bomanager);
	BusinessObject relativeObject = transaction.getBusinessObject(transaction.getString("RelativeObjectType"));
	
	List<BusinessObject> rates = relativeObject.getBusinessObjects("jbo.acct.ACCT_RATE_SEGMENT");
	
	simulationObject.setAttributeValue("LoanSerialNo", relativeObject.getKeyString());
	List<BusinessObject> list =relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule,"PSType='1'");
	String rptTermID = RPTObject.getString("TERMID");
	String rightType =  "RPT-20".equals(rptTermID)?"":"ReadOnly";//灵活等额本息就要求可修改
	
	double allPrincipalAmt = 0.0;
	double allInteAmt = 0.0;
	double allAmt = 0.0;
	String putoutDate = relativeObject.getString("PutOutDate");
	String maturityDate = relativeObject.getString("MaturityDate");
	int firstPeriodNo = list.get(0).getInt("PERIODNO");
	int maxPeriodNo = list.size() + firstPeriodNo - 1;
	String defaultDueDay = "";
 	if("RPT-20".equals(rptTermID)){
 		List<BusinessObject> rptList = relativeObject.getBusinessObjects("jbo.acct.ACCT_RPT_SEGMENT");
 		if(rptList!=null &&rptList.size() > 0  )  {
 			for(BusinessObject bo:rptList)
 			{

 				defaultDueDay = bo.getString("DefaultDueDay");
				if(defaultDueDay.length() == 1)
 					defaultDueDay = "0" + defaultDueDay;
 			}
 		}
 		if(defaultDueDay.equals("")){
 			defaultDueDay = simulationObject.getString("PutOutDate").substring(8,10);
 		}
 	}
	
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

<div id="Layer1" style="position:absolute;width:99.9%; height:99.9%; z-index:1; overflow: auto">
<table align='center' width='70%' border=0 cellspacing="4" cellpadding="0">
<tr id = "CRTitle"> 
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'><input type=button value='导出' onclick="excelShow()"> </font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'><input type=button value='重置还款计划' style="<%=("ReadOnly".equals(rightType) ? "display:none" : "") %>" onclick="reset()"> </font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
</tr>
<tr id = "CRTitle"> 
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>期次</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>还款日期</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>本金</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>利息</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>还款金额</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>剩余本金</font></td>
</tr>

	<%
	if(list != null)
	{
		for(BusinessObject bo:list)
		{
			String payPrincipalColor = "black";
			String payInteColor = "black";
			String payDateColor = "black";
			String fixInstallmentColor = "black";
			String flag = ""; //1 为本金调整 2 为还款额调整
			
			if( bo.getDouble("FixPayPrincipalAmt") != 0.0d)
			{
				payPrincipalColor = "red";
				flag = "1";
			}
			else if(bo.getDouble("FixPayInstalmentAmt") != 0.0d)
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
			allAmt += bo.getDouble("PayPrincipalAmt")+bo.getDouble("PAYINTERESTAMT");
		%>
		<script language="javascript">
		boList[<%=bo.getInt("PERIODNO")%>] = Array('<%=bo.getString("PayDate")%>',<%=bo.getDouble("PayPrincipalAmt")%>,<%=bo.getDouble("PAYINTERESTAMT")%>,<%=Arith.round(bo.getDouble("PayPrincipalAmt")+bo.getDouble("PAYINTERESTAMT"),CashFlowHelper.getMoneyPrecision(simulationObject))%>,<%=bo.getDouble("FixPayInstalmentAmt")%>,<%=bo.getDouble("FixPayPrincipalAmt")%>);
		</script>
		<tr>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><%=bo.getInt("PERIODNO")%><input id="SerialNo<%=bo.getInt("PERIODNO")%>" type=hidden value="<%=bo.getString("SerialNo")%>"/></font></td>
			<input id="Flag<%=bo.getInt("PERIODNO")%>" type=hidden value="<%=flag%>"/></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayDate<%=bo.getInt("PERIODNO")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payDateColor%>' class=fftdinput type=text readOnly value="<%=DataConvert.toString(bo.getString("PayDate"))%>" <%=rightType %> onclick=selectDate("<%=bo.getInt("PERIODNO")%>","PayDate") ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayPrincipalAmt<%=bo.getInt("PERIODNO")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payPrincipalColor%>' class=fftdinput type=text value="<%=DataConvert.toMoney(bo.getDouble("PayPrincipalAmt"))%>" <%=rightType %> onchange=ChangeValue("<%=bo.getInt("PERIODNO")%>","PayPrincipalAmt")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PAYINTERESTAMT<%=bo.getInt("PERIODNO")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payInteColor%>; ' class=fftdinput type=text readOnly value="<%=DataConvert.toMoney(bo.getDouble("PAYINTERESTAMT"))%>" onchange=ChangeValue("<%=bo.getInt("PERIODNO")%>","PAYINTERESTAMT")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="FixPayInstalmentAmt<%=bo.getInt("PERIODNO")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=fixInstallmentColor%>' class=fftdinput type=text value="<%=DataConvert.toMoney(bo.getDouble("PayPrincipalAmt")+bo.getDouble("PAYINTERESTAMT"))%>" <%=rightType %> onchange=ChangeValue("<%=bo.getInt("PERIODNO")%>","FixPayInstalmentAmt")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PrincipalBalance<%=bo.getInt("PERIODNO")%>" style='text-align: right;WIDTH: 80px; COLOR: black;' class=fftdinput type=text readOnly value="<%=DataConvert.toMoney(bo.getDouble("PrincipalBalance"))%>" onchange=ChangeValue("<%=bo.getInt("PERIODNO")%>","PrincipalBalance")></font></td>
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
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allAmt)%></font></td>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'></font></td>
	</tr>
</table>
</div>
</body>
</html>

<script language="javascript">
	function ChangeValue(colID,colName)
	{
		var value = document.getElementById(colName+colID).value;
		var serialNo = document.getElementById("SerialNo"+colID).value;
		var flag = document.getElementById("Flag"+colID).value;
		if(value == null) return;
		var boTemp = boList[colID];
		if(boTemp == null)
		{
			alert("不存在该还款计划，请刷新后重新输入！");
			return;
		}
		
		if(colName == "FixPayInstalmentAmt")
		{
			if(parseFloat(value) < boTemp[2] && parseFloat(value) != 0) 
			{
				alert("还款金额不能小于利息金额！");
				document.getElementById(colName+colID).value=boTemp[1]+boTemp[2];
				return;
			}
			if(flag == "1")
			{
				alert("已经进行本金调整，不能再调整还款金额！");
				document.getElementById(colName+colID).value=boTemp[1]+boTemp[2];
				reloadSelf();
			}
			if(value==0) value=-1;
			
			reLoad();
		}
		else if(colName == "PayPrincipalAmt")
		{
			if(parseFloat(value) < 0.0) 
			{
				alert("调整本金不能将应还本金调整为负数！");
				document.getElementById(colName+colID).value=boTemp[1];
				return;
			}
			if(value==0) value=-1;
			if(flag == "2")
			{
				alert("已经进行还款金额调整，不能再调整本金！");
				document.getElementById(colName+colID).value=boTemp[1];
				reloadSelf();
			}
			
			reLoad();
		}else if(colName == "PayDate")
		{		
			if(typeof(value)=="undefined")
				return;
			if(flag == "1" || flag == "2")
			{
				alert("已经进行还款金额调整，不能再调整日期！");				
				reloadSelf();
			}
			else {
				reLoad();
			}
		}
	}
	/*~[Describe=导出excel;InputParam=无;OutPutParam=无;]~*/
	function excelShow()
	{
		var mystr = document.all('Layer1').innerHTML;
		spreadsheetTransfer(mystr.replace(/type=checkbox/g,"type=hidden"));
	}
	/*~[Describe=重置还款计划;InputParam=无;OutPutParam=无;]~*/
	function reset()
	{
		var form = document.createElement("form");    
	    form.id="runform";    
	    form.method="post";    
	    form.action="<%=sWebRootPath%>/Accounting/LoanSimulation/PaymentScheduleList.jsp";    
	    form.target="_self";    
	    var hideInput = document.createElement("input");    
	    hideInput.type="hidden";    
	    hideInput.name= "loan"  
	    hideInput.value= JSON.stringify(<%=loan%>);  
	    form.appendChild(hideInput);     
	  
	    hideInput = document.createElement("input");    
	    hideInput.type="hidden";    
	    hideInput.name= "rpt"  
	    hideInput.value= JSON.stringify(<%=rpt%>);  
	    form.appendChild(hideInput);
	     
	    hideInput = document.createElement("input");    
	    hideInput.type="hidden";    
	    hideInput.name= "rat"  
	    hideInput.value= JSON.stringify(<%=rat%>);  
	    form.appendChild(hideInput);
	     
	    hideInput = document.createElement("input");    
	    hideInput.type="hidden";    
	    hideInput.name= "CompClientID"  
	    hideInput.value= "<%=sCompClientID%>";
	    form.appendChild(hideInput);
	     
	    document.body.appendChild(form);    
	    form.submit();
	    document.body.removeChild(form); 
	}
	
	function reLoad()
	{
		//获取还款计划调整内容
		var ps = {};
		var maxPeriodNo = <%=maxPeriodNo%>;
		var firstPeriodNo = <%=firstPeriodNo%>;
		for(var i = firstPeriodNo;i <= maxPeriodNo;i++)
		{
			ps[i]={};
			ps[i]["PeriodNo"] = i+"";
			ps[i]["PayDate"] = document.getElementById("PayDate"+i).value;
			
			var reg=new RegExp(",","g"); //创建正则RegExp对象  
			
			var payPrincipalAmt = document.getElementById("PayPrincipalAmt"+i).value.replace(reg,"");
			if(parseFloat(payPrincipalAmt) == 0) payPrincipalAmt = "-1";
			if(parseFloat(payPrincipalAmt) != boList[i][1])
				ps[i]["FixPayPrincipalAmt"] = payPrincipalAmt;
			else
				ps[i]["FixPayPrincipalAmt"] = boList[i][5];
			ps[i]["PayPrincipalAmt"] = document.getElementById("PayPrincipalAmt"+i).value.replace(reg,"");
			ps[i]["PAYINTERESTAMT"] = document.getElementById("PAYINTERESTAMT"+i).value.replace(reg,"");
			var value = document.getElementById("FixPayInstalmentAmt"+i).value.replace(reg,"");
			if(parseFloat(value) == 0) value = "-1";
			if(parseFloat(value) != boList[i][3])
				ps[i]["FixPayInstalmentAmt"] = value;
			else
				ps[i]["FixPayInstalmentAmt"] = boList[i][4];
			ps[i]["PrincipalBalance"] = document.getElementById("PrincipalBalance"+i).value.replace(reg,"");
		}
		
		
		var form = document.createElement("form");    
	    form.id="runform";    
	    form.method="post";    
	    form.action="<%=sWebRootPath%>/Accounting/LoanSimulation/PaymentScheduleList.jsp";    
	    form.target="_self";    
	    var hideInput = document.createElement("input");    
	    hideInput.type="hidden";    
	    hideInput.name= "loan"  
	    hideInput.value= JSON.stringify(<%=loan%>);  
	    form.appendChild(hideInput);     
	  
	    hideInput = document.createElement("input");    
	    hideInput.type="hidden";    
	    hideInput.name= "rpt"  
	    hideInput.value= JSON.stringify(<%=rpt%>);  
	    form.appendChild(hideInput);
	    
	    hideInput = document.createElement("input");    
	    hideInput.type="hidden";    
	    hideInput.name= "rat"  
	    hideInput.value= JSON.stringify(<%=rat%>);  
	    form.appendChild(hideInput);
	    
	    hideInput = document.createElement("input");    
	    hideInput.type="hidden";    
	    hideInput.name= "ps"  
	    hideInput.value= JSON.stringify(ps);  
	    form.appendChild(hideInput);
	     
	    hideInput = document.createElement("input");    
	    hideInput.type="hidden";    
	    hideInput.name= "CompClientID"  
	    hideInput.value= "<%=sCompClientID%>";
	    form.appendChild(hideInput);
	     
	    document.body.appendChild(form);    
	    form.submit();
	    document.body.removeChild(form); 
	}
	
	function selectDate(colID,colName){
		var rpt = "<%=rptTermID%>";
		if(rpt != "RPT-20") return;
		var putoutDate = "<%=putoutDate%>";
		var maturityDate = "<%=maturityDate%>";
		var maxPeriodNo = "<%=maxPeriodNo%>";
		var firstPeriodNo = "<%=firstPeriodNo%>";
	
		var sDate = PopPage("/FixStat/SelectDate.jsp?rand="+randomNumber(),"","dialogWidth=300px;dialogHeight=220px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		
		if(typeof(sDate)!="undefined" && sDate!=""){
			if((parseInt(colID) > parseInt(firstPeriodNo)) && (parseInt(colID) < parseInt(maxPeriodNo))){
				if((sDate > document.getElementById(colName+(parseInt(colID)-1)).value) && (sDate < document.getElementById(colName+(parseInt(colID)+1)).value))
				{	
					document.getElementById(colName+colID).value=sDate;
					ChangeValue(colID,colName);
				}
				else{
					alert("本期还款日期应当介于上期和下期还款日期，请重新选择！");
					reloadSelf();
				}			
			}
			else 				
			{	if(parseInt(firstPeriodNo) == parseInt(colID)){
					if(sDate <= putoutDate){
						alert("还款日期必需大于贷款出账日期，请重新选择！");
						reloadSelf();
					}else if(parseInt(colID) < parseInt(maxPeriodNo) && sDate > document.getElementById(colName+(parseInt(colID)+1)).value){
						alert("还款日期必需小于下期还款日期，请重新选择！");
						reloadSelf();
					}
					else{
						document.getElementById(colName+colID).value=sDate;
						ChangeValue(colID,colName);
					}
				}
				else if(parseInt(maxPeriodNo) == parseInt(colID)){					
					if(sDate >= maturityDate){
						alert("还款日期必需小于贷款到期日期，请重新选择！");
						reloadSelf();
					}else if(parseInt(firstPeriodNo) < parseInt(maxPeriodNo) && sDate < document.getElementById(colName+(parseInt(colID)-1)).value){
						alert("还款日期必需大于上期还款日期，请重新选择！");
						reloadSelf();
					}
					else{
						document.getElementById(colName+colID).value=sDate;
						ChangeValue(colID,colName);
					}
				}
			}			
		}
	}
	
	
	//对于指定还款额反算利率使用下面代码
	try{parent.RATFrame.setItemValue(0,0,"BusinessRate","<%=rates.get(0).getRate("BusinessRate")%>");}catch(e){}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>