<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ include file="/Accounting/include_accounting.jspf"%>


<head>
	<title>IRR帐卡</title>
</head>
<body class="pagebackground" leftmargin="0" topmargin="0">
	<%
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		//获取项目编号
		String prjSerialNo = CurPage.getParameter("PrjSerialNo");
		String payDate = CurPage.getParameter("payDate");
		if(StringX.isEmpty(payDate)) payDate = DateHelper.getBusinessDate().substring(0,7);//自动赋值当前月份
		if(prjSerialNo==null) prjSerialNo="";
		//根据项目编号获取当月的还款计划,
		BizObjectManager bomAPS = JBOFactory.getBizObjectManager("jbo.acct.ACCT_PAYMENT_SCHEDULE");
		double intAMT =0.0d;//应还利息
		double prinAMT = 0.0d;//应还本金
		double prinBalance = 0.0d;//剩余本金
		double balanceIRR = 0.0d;//获得收益--本金*执行利率
		
		
		double intdAMT =0.0d;//应还利息
		double prindAMT = 0.0d;//应还本金
		double prindBalance = 0.0d;//剩余本金
		double balanced = 0.0d;//获得收益--本金*执行利率
		
		List<BizObject> listdFee = bomAPS.createQuery("SELECT left(O.PAYDATE,7) as v.PDATE,SUM(O.PAYINTERESTAMT) as v.INTAMT FROM jbo.prj.PRJ_RELATIVE PR, jbo.acct.ACCT_LOAN AL,O where O.PSTYPE<>'2' and PR.OBJECTTYPE='jbo.app.BUSINESS_CONTRACT' and PR.PROJECTSERIALNO=:prjSerialNo and PR.RELATIVETYPE='02' and AL.CONTRACTSERIALNO=PR.OBJECTNO and O.OBJECTTYPE='jbo.acct.ACCT_LOAN' and O.OBJECTNO=AL.SERIALNO and O.parentserialno is not null group by left(O.PAYDATE,7)")
				.setParameter("prjSerialNo", prjSerialNo)
				.getResultList(false);
		//执行利率*businesssum
		List<BizObject> listd = bomAPS.createQuery("SELECT left(O.PAYDATE,7) as v.PDATE,SUM((O.PAYPRINCIPALAMT+O.PRINCIPALBALANCE)*ARS.BUSINESSRATE/1000) as v.BALANCEIRR,SUM(O.PAYINTERESTAMT) as v.INTAMT, SUM(O.PAYPRINCIPALAMT) as v.PRINAMT,SUM(O.PRINCIPALBALANCE) as v.PRINBALANCE  FROM jbo.acct.ACCT_RATE_SEGMENT ARS, jbo.prj.PRJ_RELATIVE PR, jbo.acct.ACCT_LOAN AL,O where O.PSTYPE<>'2' and PR.OBJECTTYPE='jbo.app.BUSINESS_CONTRACT' and PR.PROJECTSERIALNO=:prjSerialNo and PR.RELATIVETYPE='02' and AL.CONTRACTSERIALNO=PR.OBJECTNO and O.OBJECTTYPE='jbo.acct.ACCT_LOAN' and O.OBJECTNO=AL.SERIALNO and ARS.ObjectType='jbo.acct.ACCT_LOAN' and ARS.ObjectNo=O.OBJECTNO and ARS.RateType='04' and ARS.Status='1' and (ARS.SegFromDate is null or ARS.SegFromDate='' or ARS.SegFromDate<= :BusinessDate) and (ARS.SegToDate is null or ARS.SegToDate='' or ARS.SegToDate > :BusinessDate) group by left(O.PAYDATE,7)")
				.setParameter("prjSerialNo", prjSerialNo)
				.setParameter("BusinessDate", DateHelper.getBusinessDate())
				.getResultList(false);
		for(int i=0;i<listd.size();i++){
			balanced += listd.get(i).getAttribute("BALANCEIRR").getDouble()+ i< listdFee.size() ? listdFee.get(i).getAttribute("INTAMT").getDouble() : 0.0d;//费用+执行利率*剩余本金
			intdAMT += listd.get(i).getAttribute("INTAMT").getDouble();//产生利息和费用之和
			prindAMT += listd.get(i).getAttribute("PRINAMT").getDouble();//投入本金
		}
		
		
		//费用
		List<BizObject> listFee = bomAPS.createQuery("SELECT left(O.PAYDATE,7) as v.PDATE,SUM(O.PAYINTERESTAMT) as v.INTAMT FROM jbo.prj.PRJ_RELATIVE PR, jbo.acct.ACCT_LOAN AL,O where O.PSTYPE='2' and PR.OBJECTTYPE='jbo.app.BUSINESS_CONTRACT' and PR.PROJECTSERIALNO=:prjSerialNo and PR.RELATIVETYPE='02' and AL.CONTRACTSERIALNO=PR.OBJECTNO and O.OBJECTTYPE='jbo.acct.ACCT_LOAN' and O.OBJECTNO=AL.SERIALNO and O.parentserialno is not null group by left(O.PAYDATE,7)")
				.setParameter("prjSerialNo", prjSerialNo)
				.getResultList(false);
		//执行利率*businesssum
		List<BizObject> list = bomAPS.createQuery("SELECT left(O.PAYDATE,7) as v.PDATE,SUM((O.PAYPRINCIPALAMT+O.PRINCIPALBALANCE)*ARS.BUSINESSRATE/1000) as v.BALANCEIRR,SUM(O.PAYINTERESTAMT) as v.INTAMT, SUM(O.PAYPRINCIPALAMT) as v.PRINAMT,SUM(O.PRINCIPALBALANCE) as v.PRINBALANCE  FROM jbo.acct.ACCT_RATE_SEGMENT ARS, jbo.prj.PRJ_RELATIVE PR, jbo.acct.ACCT_LOAN AL,O where O.PSTYPE='2' and PR.OBJECTTYPE='jbo.app.BUSINESS_CONTRACT' and PR.PROJECTSERIALNO=:prjSerialNo and PR.RELATIVETYPE='02' and AL.CONTRACTSERIALNO=PR.OBJECTNO and O.OBJECTTYPE='jbo.acct.ACCT_LOAN' and O.OBJECTNO=AL.SERIALNO and ARS.ObjectType='jbo.acct.ACCT_LOAN' and ARS.ObjectNo=O.OBJECTNO and ARS.RateType='04' and ARS.Status='1' and (ARS.SegFromDate is null or ARS.SegFromDate='' or ARS.SegFromDate<= :BusinessDate) and (ARS.SegToDate is null or ARS.SegToDate='' or ARS.SegToDate > :BusinessDate) group by left(O.PAYDATE,7)")
				.setParameter("prjSerialNo", prjSerialNo)
				.setParameter("BusinessDate", DateHelper.getBusinessDate())
				.getResultList(false);
		for(int i=0;i<list.size();i++){
			balanceIRR += list.get(i).getAttribute("BALANCEIRR").getDouble()+i< listFee.size() ? listFee.get(i).getAttribute("INTAMT").getDouble() : 0.0d;//费用+执行利率*剩余本金
			intAMT += list.get(i).getAttribute("INTAMT").getDouble();//产生利息和费用之和
			prinAMT += list.get(i).getAttribute("PRINAMT").getDouble();//投入本金
		}
		
		double irr = prinAMT < 0.0000001 ? 0.0d : Arith.round(balanceIRR/prinAMT*1000,4);
		String payPrincipalColor = "black";
		String payInteColor = "black";
		String fixInstallmentColor = "black";
		String payDateColor = "black";
		String flag = ""; //1 为本金调整 2 为还款额调整
	%>

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
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'><input type=button value='导出' onclick="excelShow()"> </font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
</tr>

<tr id = "CRTitle"> 
	<td colspan="7" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>收款计划</font></td>
</tr>
<tr id = "CRTitle"> 
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>月份</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>应还本金</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>应还利息</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>应还费用</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>应还总金额</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>剩余本金</font></td>
</tr>

	<%
	double allPrincipalAmt = 0.0;
	double allInteAmt = 0.0;
	double allAmt = 0.0;
	double allFee = 0.0;
	if(list != null){
		
		for(int i=0;i<listd.size();i++){
			BizObject bo = listd.get(i);
			allPrincipalAmt +=bo.getAttribute("PRINAMT").getDouble();//应还本金 
			allInteAmt +=bo.getAttribute("INTAMT").getDouble();//应还利息 
			double fee = i < listdFee.size() ? listdFee.get(i).getAttribute("INTAMT").getDouble() : 0.0d;
			allFee += fee;
			allAmt +=bo.getAttribute("PRINAMT").getDouble()+bo.getAttribute("INTAMT").getDouble()+fee;//剩余本金 

		%>
		<script language="javascript">
		boList[<%=bo.getAttribute("PDATE").getString()%>] = Array(<%=bo.getAttribute("INTAMT").getString()%>,<%=bo.getAttribute("PRINAMT").getString()%>,<%=bo.getAttribute("PRINBALANCE").getString()%>);
		</script>
		<tr>
			<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'><%=bo.getAttribute("PDATE").getString()%></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="INTAMT<%=bo.getAttribute("PDATE").getString()%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payDateColor%>' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getAttribute("PRINAMT").getDouble())%>" readonly ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="ALLBALANCE<%=bo.getAttribute("PDATE").getString()%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payInteColor%>; ' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getAttribute("INTAMT").getDouble()-fee)%>" ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PRINAMT<%=bo.getAttribute("PDATE").getString()%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payPrincipalColor%>' class=fftdinput type=text onblur=parent.trimField(this) value="<%=DataConvert.toMoney(fee)%>" readonly ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="ALLBALANCE<%=bo.getAttribute("PDATE").getString()%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payInteColor%>; ' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getAttribute("PRINAMT").getDouble()+bo.getAttribute("INTAMT").getDouble())%>" ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PRINBALANCE<%=bo.getAttribute("PDATE").getString()%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payInteColor%>; ' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getAttribute("PRINBALANCE").getDouble())%>" ></font></td>
			
		</tr>
		<%
		}
	}
	%>
		<tr>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'>合计</font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allPrincipalAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allInteAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allFee)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allAmt)%></font></td>
		
	</tr>
<tr id = "CRTitle"> 
	<td colspan="7" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>IRR财务计划</font></td>
</tr>
<tr id = "CRTitle"> 
	<td colspan="7" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>IRR月利率:<%=Arith.round(irr,4)%>（千分之）</font></td>
</tr>
<tr id = "CRTitle"> 
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>月份</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>应还IRR本金</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>应还IRR利息</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>应还IRR费用</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>应还总金额</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>IRR剩余本金</font></td>
	
</tr>

	<%
	allPrincipalAmt = 0.0;
	allInteAmt = 0.0;
	allAmt = 0.0;
	allFee = 0.0;
	if(list != null){
		for(int i=0;i<list.size();i++){
			BizObject bo = list.get(i);
			allPrincipalAmt +=bo.getAttribute("PRINAMT").getDouble();//应还本金 
			allInteAmt +=bo.getAttribute("INTAMT").getDouble();//应还利息 
			
			double fee = i < listFee.size() ? listFee.get(i).getAttribute("INTAMT").getDouble() : 0.0d;
			allFee += fee;
			
			allAmt +=bo.getAttribute("PRINAMT").getDouble()+bo.getAttribute("INTAMT").getDouble()+fee;//剩余本金 
		%>
		<script language="javascript">
		boList[<%=bo.getAttribute("PDATE").getString()%>] = Array(<%=bo.getAttribute("INTAMT").getString()%>,<%=bo.getAttribute("PRINAMT").getString()%>,<%=bo.getAttribute("PRINBALANCE").getString()%>);
		</script>
		<tr>
			<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'><%=bo.getAttribute("PDATE").getString()%></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="INTAMT<%=bo.getAttribute("PDATE").getString()%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payDateColor%>' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getAttribute("PRINAMT").getDouble())%>" readonly ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="ALLBALANCE<%=bo.getAttribute("PDATE").getString()%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payInteColor%>; ' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getAttribute("INTAMT").getDouble()-fee)%>" ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PRINAMT<%=bo.getAttribute("PDATE").getString()%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payPrincipalColor%>' class=fftdinput type=text onblur=parent.trimField(this) value="<%=DataConvert.toMoney(fee)%>" readonly ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="ALLBALANCE<%=bo.getAttribute("PDATE").getString()%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payInteColor%>; ' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getAttribute("PRINAMT").getDouble()+bo.getAttribute("INTAMT").getDouble())%>" ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PRINBALANCE<%=bo.getAttribute("PDATE").getString()%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payInteColor%>; ' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getAttribute("PRINBALANCE").getDouble())%>" ></font></td>
		</tr>
		<%
		}
	}
	%>
		<tr>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'>合计</font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allPrincipalAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allInteAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allFee)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allAmt)%></font></td>
		
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