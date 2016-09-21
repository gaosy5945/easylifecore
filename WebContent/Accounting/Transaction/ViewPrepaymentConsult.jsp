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
		String transactionSerialNo = (String) CurPage.getParameter("TransSerialNo");
		String transactionCode = (String) CurPage.getParameter("TransactionCode");
		String sTransDate =  (String) CurPage.getParameter("TransDate");
		String rightType =  (String)CurPage.getParameter("RightType");
		if(StringX.isEmpty(sTransDate)) sTransDate = DateHelper.getBusinessDate();
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		
		if ("9090".equals(transactionCode)) {
			String date_9090 = DateHelper.getRelativeDate(sTransDate, DateHelper.TERM_UNIT_DAY, -1);
			BusinessObject loan = bomanager.keyLoadBusinessObject(BUSINESSOBJECT_CONSTANTS.loan, loanSerialNo);
			
			loan.setAttributeValue("LoanPeriod", 0);
			transaction = TransactionHelper.createTransaction("9090", null, loan, CurUser.getUserID(),CurUser.getOrgID(),date_9090,bomanager);
			if("0".equals(loan.getString("LoanStatus")) || "1".equals(loan.getString("LoanStatus")))
			{
				TransactionHelper.loadTransaction(transaction, bomanager);
				List<BusinessObject> rptList = loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment, "Status='1' ");
				for (BusinessObject rptSegment : rptList) {
					rptSegment.setAttributeValue("PSRestructureFlag", "1");
				}
				TransactionHelper.executeTransaction(transaction, bomanager);
			}
		} else {
			transaction = TransactionHelper.loadTransaction(transactionSerialNo, bomanager);
			BusinessObject loan = transaction.getBusinessObject(transaction.getString("RelativeObjectType"));
			loan.setAttributeValue("LoanPeriod", 0);
			sTransDate = transaction.getString("TransDate");
			//������Ч���ڲ����ڵ���Ľ��л��ս��׵Ĵ���
			/*
			if (sTransDate.compareTo(loan.getString("BusinessDate")) > 0) {
				
				transaction = TransactionHelper.createTransaction("9090", null, loan, CurUser.getUserID(),CurUser.getOrgID(),DateHelper.getRelativeDate(sTransDate, DateHelper.TERM_UNIT_DAY, -1),bomanager);
				TransactionHelper.loadTransaction(transaction, bomanager);
				TransactionHelper.executeTransaction(transaction, bomanager);
			}*/
			
			TransactionHelper.executeTransaction(transaction, bomanager);
		}

		BusinessObject loan = transaction.getBusinessObject(transaction.getString("RelativeObjectType"));
		List<BusinessObject> list = loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule, "PayDate<=:PayDate", "PayDate",loan.getString("BusinessDate"));
		List<BusinessObject> psList = loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule,  "PayDate>:PayDate and Direction = 'R'", "PayDate",loan.getString("BusinessDate"));
		rightType =  "RPT15".equals(loan.getString("RPTTERMID")) ? rightType:"ReadOnly";
		
		//ɾ��ԭʼ�Ļ���ƻ�
		BusinessObject loanChange = transaction.getBusinessObject(transaction.getString("DocumentType"));
		if(loanChange!=null&&!rightType.equals("ReadOnly")){
			
			BusinessObjectManager bom1 = BusinessObjectManager.createBusinessObjectManager();
			//ɾ����ʷ
			bom1.updateBusinessObjects(loanChange.getBusinessObjects(BUSINESSOBJECT_CONSTANTS.payment_schedule));
			bom1.updateDB();
			
			for(BusinessObject a:psList){
				BusinessObject b = BusinessObject.createBusinessObject(a.getBizClassName());
				b.setValue(a);
				b.setAttributeValue("ObjectType",loanChange.getBizClassName());
				b.setAttributeValue("ObjectNo",loanChange.getKeyString());
				bom1.updateBusinessObject(b);
				list.add(b);
			}
			bom1.updateDB();
		}
		else if(loanChange!=null&&"ReadOnly".equals(rightType)&&"RPT15".equals(loanChange.getString("RPTTERMID")))
		{
			ASValuePool as = new ASValuePool();
			as.setAttribute("ObjectType",loanChange.getBizClassName());
			as.setAttribute("ObjectNo",loanChange.getKeyString());
			list = bomanager.loadBusinessObjects(BUSINESSOBJECT_CONSTANTS.payment_schedule,"ObjectType=:ObjectType and ObjectNo=:ObjectNo order by PayDate,PeriodNo",as);
		}else list.addAll(psList);
		
		
		
		double allPrincipalAmt = 0.0,allActualPrincipalAmt=0.0d;
		double allInteAmt = 0.0,allActualInteAmt=0.0d;
		double allFineAmt = 0.0,allActualFineAmt=0.0d;
		double allCompAmt = 0.0,allActualCompAmt=0.0d;
		double allFeeAmt = 0.0,allActualFeeAmt=0.0d;
		double allAmt = 0.0,allActualAmt=0.0d;
		String putoutDate = loan.getString("PutOutDate");
		String maturityDate = loan.getString("MaturityDate");
		int firstSeqID = 1;
		if(!list.isEmpty()) firstSeqID = list.get(0).getInt("PeriodNo");
		int maxSeqID = list.size() + firstSeqID - 1;
		String rptTermID = loan.getString("RPTTERMID");
		String defaultDueDay = "";
		if(loanChange != null && "RPT15".equals(loanChange.getString("RPTTERMID"))){
			List<BusinessObject> rptList = bomanager.loadBusinessObjects(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment, "  ObjectNo=:ObjectNo and ObjectType=:ObjectType ", "ObjectNo",loanChange.getKeyString(),"ObjectType",loanChange.getBizClassName());
			if(rptList != null && rptList.size() > 0) {
				for(BusinessObject rpt:rptList)
				{
					if(rpt.getString("Status").equals("0"))
						defaultDueDay = rpt.getString("DefaultDueDay");
					if(defaultDueDay.length() == 1)
						defaultDueDay = "0" + defaultDueDay;
				}
			}
			if(defaultDueDay.equals("")){
				defaultDueDay = loan.getString("PutOutDate").substring(8,10);
			}
		}
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
<table align='center' width='100%' border=0 cellspacing="4" cellpadding="0">
<tr id = "CRTitle"> 
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'><input type=button value='����' onclick="excelShow()"> </font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'><input type=button value='���û���ƻ�' onclick="reset()"> </font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
</tr>
<tr id = "CRTitle"> 
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>�ڴ�</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>����</font></td>
	<td colspan="2" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>Ӧ��/�ѻ�����</font></td>
	<td colspan="2" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>Ӧ��/�ѻ���Ϣ</font></td>
	<td colspan="2" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>Ӧ��/�ѻ�����</font></td>
	<td colspan="2" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>Ӧ��/�ѻ���Ϣ</font></td>
	<td colspan="2" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>Ӧ��/�ѻ�����</font></td>
	<td colspan="2" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>Ӧ��/�ѻ��ܽ��</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>ʣ�౾��</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>��������</font></td>
</tr>

	<%
	if(list != null){
		for(BusinessObject bo:list){
			
			BusinessObject pbo = BusinessObjectHelper.getBusinessObjectBySql(list, "SerialNo=:SerialNo", "SerialNo", bo.getString("ParentSerialNo"));
			if(pbo != null) continue;
			
			double otherFeeAmt = 0.0d;
			double actualFeeAmt = 0.0d;
			List<BusinessObject> cls = BusinessObjectHelper.getBusinessObjectsBySql(list, "ParentSerialNo=:SerialNo", "SerialNo", bo.getString("SerialNo"));
			for(BusinessObject cl:cls)
			{
				otherFeeAmt += cl.getDouble("PayPrincipalAmt")+cl.getDouble("PayInterestAmt");
				actualFeeAmt += cl.getDouble("ActualPayPrincipalAmt")+cl.getDouble("ActualPayInterestAmt");
			}
			
			String payPrincipalColor = "black";
			String payInteColor = "black";
			String fixInstallmentColor = "black";
			String payDateColor = "black";
			String flag = ""; //1 Ϊ������� 2 Ϊ��������
			
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
			allActualPrincipalAmt += bo.getDouble("ActualPayPrincipalAmt");
			allInteAmt += bo.getDouble("PayInterestAmt");
			allActualInteAmt += bo.getDouble("ActualPayInterestAmt");
			allFeeAmt+=otherFeeAmt;
			allActualFeeAmt+=actualFeeAmt;
			
			 
			allFineAmt += bo.getDouble("PAYPRINCIPALPENALTYAMT");
			allActualFineAmt += bo.getDouble("ACTUALPAYPRINCIPALPENALTYAMT");
			allCompAmt += bo.getDouble("PAYINTERESTPENALTYAMT");
			allActualCompAmt += bo.getDouble("ACTUALPAYINTERESTPENALTYAMT");
			allAmt += bo.getDouble("PayPrincipalAmt")+bo.getDouble("PayInterestAmt")+bo.getDouble("PAYPRINCIPALPENALTYAMT")+bo.getDouble("PAYINTERESTPENALTYAMT")+otherFeeAmt;
			allActualAmt += bo.getDouble("ActualPayPrincipalAmt")+bo.getDouble("ActualPayInterestAmt")+bo.getDouble("ACTUALPAYPRINCIPALPENALTYAMT")+bo.getDouble("ACTUALPAYINTERESTPENALTYAMT")+actualFeeAmt;
		%>
		<script language="javascript">
		boList[<%=bo.getInt("PeriodNo")%>] = Array(<%=bo.getString("PayDate")%>,<%=bo.getDouble("PayPrincipalAmt")%>,<%=bo.getDouble("PayInterestAmt")%>,<%=bo.getDouble("FixInstallmentAmt")%>,<%=bo.getDouble("FixPrincipalAmt")%>,"<%=bo.getString("FinishDate")%>");
		</script>
		<tr>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><%=bo.getInt("PeriodNo")%><input id="SerialNo<%=bo.getInt("PeriodNo")%>" type=hidden value="<%=bo.getString("SerialNo")%>"/></font></td>
			<input id="Flag<%=bo.getInt("PeriodNo")%>" type=hidden value="<%=flag%>"/></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayDate<%=bo.getInt("PeriodNo")%>" style='text-align: right;WIDTH: 70px;COLOR: <%=payDateColor%>' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toString(bo.getString("PayDate"))%>" <%=rightType %> onclick=selectDate("<%=bo.getInt("PeriodNo")%>","PayDate","<%=bo.getInt("PeriodNo")%>") ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayPrincipalAmt<%=bo.getInt("PeriodNo")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payPrincipalColor%>' class=fftdinput type=text onblur=parent.trimField(this) value="<%=DataConvert.toMoney(bo.getDouble("PayPrincipalAmt"))%>" <%=rightType %> onchange=ChangeValue("<%=bo.getInt("PeriodNo")%>","PayPrincipalAmt","<%=bo.getInt("PeriodNo")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'></font><%=DataConvert.toMoney(bo.getDouble("ActualPayPrincipalAmt"))%></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayInterestAmt<%=bo.getInt("PeriodNo")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payInteColor%>; ' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getDouble("PayInterestAmt"))%>" onchange=ChangeValue("<%=bo.getInt("PeriodNo")%>","PayInterestAmt","<%=bo.getInt("PeriodNo")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'></font><%=DataConvert.toMoney(bo.getDouble("ActualPayInterestAmt"))%></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayFeeAmt<%=bo.getInt("PeriodNo")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payInteColor%>; ' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(otherFeeAmt)%>" onchange=ChangeValue("<%=bo.getInt("PeriodNo")%>","PayFeeAmt","<%=bo.getInt("PeriodNo")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'></font><%=DataConvert.toMoney(actualFeeAmt)%></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PAYPRINCIPALPENALTYAMT<%=bo.getInt("PeriodNo")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payInteColor%>; ' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getDouble("PAYPRINCIPALPENALTYAMT"))%>" onchange=ChangeValue("<%=bo.getInt("PeriodNo")%>","PAYPRINCIPALPENALTYAMT","<%=bo.getInt("PeriodNo")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'></font><%=DataConvert.toMoney(bo.getDouble("ACTUALPAYPRINCIPALPENALTYAMT"))%></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PAYINTERESTPENALTYAMT<%=bo.getInt("PeriodNo")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payInteColor%>; ' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getDouble("PAYINTERESTPENALTYAMT"))%>" onchange=ChangeValue("<%=bo.getInt("PeriodNo")%>","PAYINTERESTPENALTYAMT","<%=bo.getInt("PeriodNo")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'></font><%=DataConvert.toMoney(bo.getDouble("ACTUALPAYINTERESTPENALTYAMT"))%></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="FixInstallmentAmt<%=bo.getInt("PeriodNo")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=fixInstallmentColor%>' class=fftdinput type=text onblur=parent.trimField(this) value="<%=DataConvert.toMoney(bo.getDouble("PayPrincipalAmt")+bo.getDouble("PayInterestAmt")+bo.getDouble("PAYPRINCIPALPENALTYAMT")+bo.getDouble("PAYINTERESTPENALTYAMT")+otherFeeAmt)%>" <%=rightType %> onchange=ChangeValue("<%=bo.getInt("PeriodNo")%>","FixInstallmentAmt","<%=bo.getInt("PeriodNo")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><%=DataConvert.toMoney(bo.getDouble("ActualPayPrincipalAmt")+bo.getDouble("ActualPayInterestAmt")+bo.getDouble("ACTUALPAYPRINCIPALPENALTYAMT")+bo.getDouble("ACTUALPAYINTERESTPENALTYAMT")+actualFeeAmt)%></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PrincipalBalance<%=bo.getInt("PeriodNo")%>" style='text-align: right;WIDTH: 80px; COLOR: black;' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getDouble("PrincipalBalance"))%>" onchange=ChangeValue("<%=bo.getInt("PeriodNo")%>","PrincipalBalance","<%=bo.getInt("PeriodNo")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><%=DataConvert.toString(bo.getString("FinishDate"))%></font></td>
		</tr>
		<%
		}
	}
	%>
	<tr>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'>�ϼ�</font></td>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allPrincipalAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allActualPrincipalAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allInteAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allActualInteAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allFeeAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allActualFeeAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allFineAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allActualFineAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allCompAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allActualCompAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allActualAmt)%></font></td>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'></font></td>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'></font></td>
	</tr>
</table>
</div>
</body>
</html>

<script language="javascript">
	function ChangeValue(seqID,colName,colID)
	{
		var value = document.getElementById(colName+colID).value;
		var serialNo = document.getElementById("SerialNo"+colID).value;
		var flag = document.getElementById("Flag"+colID).value;
		if(value == null) return;
		var boTemp = boList[colID];
		if(boTemp == null)
		{
			alert("�����ڸû���ƻ�����ˢ�º��������룡");
			return;
		}
		if(colName == "FixInstallmentAmt")
		{
			if(parseFloat(value) < boTemp[2] && parseFloat(value) != 0) 
			{
				alert("�������С����Ϣ��");
				document.getElementById(colName+colID).value=boTemp[1]+boTemp[2];
				return;
			}
			if(flag == "1")
			{
				alert("�Ѿ����б�������������ٵ��������");
				reloadSelf();
			}
			if(value==0) value=-1;
			
			RunMethod('LoanAccount','updatePSFixInstallmentAmount',serialNo+','+value);
			reLoad();
		}
		else if(colName == "PayPrincipalAmt")
		{
			if(parseFloat(value) < 0.0) 
			{
				alert("���������ܽ�Ӧ���������Ϊ������");
				document.getElementById(colName+colID).value=boTemp[1];
				return;
			}
			if(value==0) value=-1;
			if(flag == "2")
			{
				alert("�Ѿ����л���������������ٵ�������");
				document.getElementById(colName+colID).value=boTemp[1];
				reloadSelf();
			}
			
			RunMethod('LoanAccount','updatePSFixPrincipalAmt',serialNo+','+parseFloat(value));
			reLoad();
		}
		else if(colName == "PayDate")
		{		
			if(typeof(value)=="undefined")
				return;
			if(flag == "1" || flag == "2")
			{
				alert("�Ѿ����л���������������ٵ������ڣ�");				
				reloadSelf();
			} 
			else{
				RunMethod('LoanAccount','updatePayDate',serialNo+','+value);	
				reLoad();
			}			
		}
	}
	/*~[Describe=����excel;InputParam=��;OutPutParam=��;]~*/
	function excelShow()
	{
		var mystr = document.all('Layer1').innerHTML;
		spreadsheetTransfer(mystr.replace(/type=checkbox/g,"type=hidden"));
	}
	/*~[Describe=���û���ƻ�;InputParam=��;OutPutParam=��;]~*/
	function reset()
	{
		RunMethod('LoanAccount','deletePaymentSchedule','<%=transaction.getString("DocumentSerialNo")%>,<%=transaction.getString("DocumentType")%>');
		reLoad();
	}
	
	function reLoad()
	{
		OpenComp("SimulationPaymentSchedule","/Accounting/Transaction/ViewPrepaymentConsult.jsp","TransSerialNo=<%=transactionSerialNo%>","_self");
	}
	
	function selectDate(seqID,colName,colID){
		var rpt = "<%=rptTermID%>";
		if(rpt != "RPT15") return;
		var putoutDate = "<%=putoutDate%>";
		var maturityDate = "<%=maturityDate%>";
		var maxseqID = "<%=maxSeqID%>";
		var firstSeqID = "<%=firstSeqID%>";

		var sDate = PopPage("/FixStat/SelectDate.jsp?rand="+randomNumber(),"","dialogWidth=300px;dialogHeight=220px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		
		if(typeof(sDate)!="undefined" && sDate!=""){
			if((parseInt(colID) > parseInt(firstSeqID)) && (parseInt(colID) < parseInt(maxseqID))){
				if((sDate > document.getElementById(colName+(parseInt(colID)-1)).value) && (sDate < document.getElementById(colName+(parseInt(colID)+1)).value))
				{	
					document.getElementById(colName+colID).value=sDate;
					ChangeValue(seqID,colName,colID);
				}
				else{
					alert("���ڻ�������Ӧ���������ں����ڻ������ڣ�������ѡ��");
					reloadSelf();
				}			
			}
			else 				
			{	if(parseInt(firstSeqID) == parseInt(colID)){
					if(sDate <= putoutDate){
						alert("�������ڱ�����ڴ���������ڣ�������ѡ��");
						reloadSelf();
					}else if(parseInt(colID) < parseInt(maxseqID) && sDate > document.getElementById(colName+(parseInt(colID)+1)).value){
						alert("�������ڱ���С�����ڻ������ڣ�������ѡ��");
						reloadSelf();
					}
					else{
						document.getElementById(colName+colID).value=sDate;
						ChangeValue(seqID,colName,colID);
					}
				}
				else if(parseInt(maxseqID) == parseInt(colID)){					
					if(sDate >= maturityDate){
						alert("�������ڱ���С�ڴ�������ڣ�������ѡ��");
						reloadSelf();
					}else if(parseInt(firstSeqID) < parseInt(maxseqID) && sDate < document.getElementById(colName+(parseInt(colID)-1)).value){
						alert("�������ڱ���������ڻ������ڣ�������ѡ��");
						reloadSelf();
					}
					else{
						document.getElementById(colName+colID).value=sDate;
						ChangeValue(seqID,colName,colID);
					}
				}
			}			
		}
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>