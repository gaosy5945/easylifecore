<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ include file="/Accounting/include_accounting.jspf"%>


<head>
	<title>��ѯ����ƻ�</title>
</head>
<body class="pagebackground" leftmargin="0" topmargin="0">
	<%
		//�������
		BusinessObject transaction = null;
		
		//���ҳ�����
		String loanSerialNo = (String) CurPage.getParameter("LoanSerialNo");
		
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		
		List<BusinessObject> irrrates = bomanager.loadBusinessObjects(BUSINESSOBJECT_CONSTANTS.loan_rate_segment, "ObjectType=:ObjectType and ObjectNo=:ObjectNo and RateType=:RateType and Status=:Status and (SegFromDate is null or SegFromDate='' or SegFromDate<= :BusinessDate) and (SegToDate is null or SegToDate='' or SegToDate > :BusinessDate)",
				"Status","1","BusinessDate",DateHelper.getBusinessDate(),"ObjectType","jbo.acct.ACCT_LOAN","ObjectNo",loanSerialNo,"RateType","04");
		double irr = 0.0d;
		if(irrrates!=null && !irrrates.isEmpty())
		{
			irr = irrrates.get(0).getDouble("BusinessRate");
		}
		List<BusinessObject> list = bomanager.loadBusinessObjects(BUSINESSOBJECT_CONSTANTS.payment_schedule, "RelativeObjectType=:RelativeObjectType and RelativeObjectNo=:RelativeObjectNo and PSType=:PSType", "RelativeObjectType","jbo.acct.ACCT_LOAN", "RelativeObjectNo",loanSerialNo, "PSType","2");
		
		
		double allPrincipalAmt = 0.0;
		double allInteAmt = 0.0;
		double allFeeAmt = 0.0;
		double allAmt = 0.0;
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
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'><input type=button value='����' onclick="excelShow()"> </font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
</tr>
<tr id = "CRTitle"> 
	<td colspan="7" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>IRR������:<%=Arith.round(irr,4)%>��ǧ��֮��</font></td>
</tr>
<tr id = "CRTitle"> 
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>�ڴ�</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>����</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>Ӧ��IRR����</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>Ӧ��IRR��Ϣ</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>Ӧ��IRR����</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>Ӧ���ܽ��</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>IRRʣ�౾��</font></td>
</tr>

	<%
	if(list != null){
		for(BusinessObject bo:list){
			
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
			String fixInstallmentColor = "black";
			String payDateColor = "black";
			String flag = ""; //1 Ϊ������� 2 Ϊ��������
			
			
			allPrincipalAmt += bo.getDouble("PayPrincipalAmt");
			allInteAmt += bo.getDouble("PayInterestAmt");
			allFeeAmt+=otherFeeAmt;
			allAmt += bo.getDouble("PayPrincipalAmt")+bo.getDouble("PayInterestAmt")+otherFeeAmt;
		%>
		<script language="javascript">
		boList[<%=bo.getInt("PeriodNo")%>] = Array(<%=bo.getString("PayDate")%>,<%=bo.getDouble("PayPrincipalAmt")%>,<%=bo.getDouble("PayInterestAmt")%>,<%=bo.getDouble("FixInstallmentAmt")%>,<%=bo.getDouble("FixPrincipalAmt")%>,"<%=bo.getString("FinishDate")%>");
		</script>
		<tr>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><%=bo.getInt("PeriodNo")%><input id="SerialNo<%=bo.getInt("PeriodNo")%>" type=hidden value="<%=bo.getString("SerialNo")%>"/></font></td>
			<input id="Flag<%=bo.getInt("PeriodNo")%>" type=hidden value="<%=flag%>"/></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayDate<%=bo.getInt("PeriodNo")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payDateColor%>' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toString(bo.getString("PayDate"))%>" readonly ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayPrincipalAmt<%=bo.getInt("PeriodNo")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payPrincipalColor%>' class=fftdinput type=text onblur=parent.trimField(this) value="<%=DataConvert.toMoney(bo.getDouble("PayPrincipalAmt"))%>" readonly ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayInterestAmt<%=bo.getInt("PeriodNo")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payInteColor%>; ' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getDouble("PayInterestAmt"))%>" ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayFeeAmt<%=bo.getInt("PeriodNo")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payInteColor%>; ' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(otherFeeAmt)%>" ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="FixInstallmentAmt<%=bo.getInt("PeriodNo")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=fixInstallmentColor%>' class=fftdinput type=text onblur=parent.trimField(this) value="<%=DataConvert.toMoney(bo.getDouble("PayPrincipalAmt")+bo.getDouble("PayInterestAmt")+otherFeeAmt)%>" readonly ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PrincipalBalance<%=bo.getInt("PeriodNo")%>" style='text-align: right;WIDTH: 80px; COLOR: black;' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getDouble("PrincipalBalance"))%>" ></font></td>
		</tr>
		<%
		}
	}
	%>
	<tr>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'>�ϼ�</font></td>
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
	/*~[Describe=����excel;InputParam=��;OutPutParam=��;]~*/
	function excelShow()
	{
		var mystr = document.all('Layer1').innerHTML;
		spreadsheetTransfer(mystr.replace(/type=checkbox/g,"type=hidden"));
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>