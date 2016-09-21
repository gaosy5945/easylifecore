<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ include file="/Accounting/include_accounting.jspf"%>


<head>
	<title>IRR�ʿ�</title>
</head>
<body class="pagebackground" leftmargin="0" topmargin="0">
	<%
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		//��ȡ��Ŀ���
		String prjSerialNo = CurPage.getParameter("PrjSerialNo");
		String payDate = CurPage.getParameter("payDate");
		if(StringX.isEmpty(payDate)) payDate = DateHelper.getBusinessDate().substring(0,7);//�Զ���ֵ��ǰ�·�
		if(prjSerialNo==null) prjSerialNo="";
		//������Ŀ��Ż�ȡ���µĻ���ƻ�,
		BizObjectManager bomAPS = JBOFactory.getBizObjectManager("jbo.acct.ACCT_PAYMENT_SCHEDULE");
		double intAMT =0.0d;//Ӧ����Ϣ
		double prinAMT = 0.0d;//Ӧ������
		double prinBalance = 0.0d;//ʣ�౾��
		double balanceIRR = 0.0d;//�������--����*ִ������
		
		
		double intdAMT =0.0d;//Ӧ����Ϣ
		double prindAMT = 0.0d;//Ӧ������
		double prindBalance = 0.0d;//ʣ�౾��
		double balanced = 0.0d;//�������--����*ִ������
		
		List<BizObject> listdFee = bomAPS.createQuery("SELECT left(O.PAYDATE,7) as v.PDATE,SUM(O.PAYINTERESTAMT) as v.INTAMT FROM jbo.prj.PRJ_RELATIVE PR, jbo.acct.ACCT_LOAN AL,O where O.PSTYPE<>'2' and PR.OBJECTTYPE='jbo.app.BUSINESS_CONTRACT' and PR.PROJECTSERIALNO=:prjSerialNo and PR.RELATIVETYPE='02' and AL.CONTRACTSERIALNO=PR.OBJECTNO and O.OBJECTTYPE='jbo.acct.ACCT_LOAN' and O.OBJECTNO=AL.SERIALNO and O.parentserialno is not null group by left(O.PAYDATE,7)")
				.setParameter("prjSerialNo", prjSerialNo)
				.getResultList(false);
		//ִ������*businesssum
		List<BizObject> listd = bomAPS.createQuery("SELECT left(O.PAYDATE,7) as v.PDATE,SUM((O.PAYPRINCIPALAMT+O.PRINCIPALBALANCE)*ARS.BUSINESSRATE/1000) as v.BALANCEIRR,SUM(O.PAYINTERESTAMT) as v.INTAMT, SUM(O.PAYPRINCIPALAMT) as v.PRINAMT,SUM(O.PRINCIPALBALANCE) as v.PRINBALANCE  FROM jbo.acct.ACCT_RATE_SEGMENT ARS, jbo.prj.PRJ_RELATIVE PR, jbo.acct.ACCT_LOAN AL,O where O.PSTYPE<>'2' and PR.OBJECTTYPE='jbo.app.BUSINESS_CONTRACT' and PR.PROJECTSERIALNO=:prjSerialNo and PR.RELATIVETYPE='02' and AL.CONTRACTSERIALNO=PR.OBJECTNO and O.OBJECTTYPE='jbo.acct.ACCT_LOAN' and O.OBJECTNO=AL.SERIALNO and ARS.ObjectType='jbo.acct.ACCT_LOAN' and ARS.ObjectNo=O.OBJECTNO and ARS.RateType='04' and ARS.Status='1' and (ARS.SegFromDate is null or ARS.SegFromDate='' or ARS.SegFromDate<= :BusinessDate) and (ARS.SegToDate is null or ARS.SegToDate='' or ARS.SegToDate > :BusinessDate) group by left(O.PAYDATE,7)")
				.setParameter("prjSerialNo", prjSerialNo)
				.setParameter("BusinessDate", DateHelper.getBusinessDate())
				.getResultList(false);
		for(int i=0;i<listd.size();i++){
			balanced += listd.get(i).getAttribute("BALANCEIRR").getDouble()+ i< listdFee.size() ? listdFee.get(i).getAttribute("INTAMT").getDouble() : 0.0d;//����+ִ������*ʣ�౾��
			intdAMT += listd.get(i).getAttribute("INTAMT").getDouble();//������Ϣ�ͷ���֮��
			prindAMT += listd.get(i).getAttribute("PRINAMT").getDouble();//Ͷ�뱾��
		}
		
		
		//����
		List<BizObject> listFee = bomAPS.createQuery("SELECT left(O.PAYDATE,7) as v.PDATE,SUM(O.PAYINTERESTAMT) as v.INTAMT FROM jbo.prj.PRJ_RELATIVE PR, jbo.acct.ACCT_LOAN AL,O where O.PSTYPE='2' and PR.OBJECTTYPE='jbo.app.BUSINESS_CONTRACT' and PR.PROJECTSERIALNO=:prjSerialNo and PR.RELATIVETYPE='02' and AL.CONTRACTSERIALNO=PR.OBJECTNO and O.OBJECTTYPE='jbo.acct.ACCT_LOAN' and O.OBJECTNO=AL.SERIALNO and O.parentserialno is not null group by left(O.PAYDATE,7)")
				.setParameter("prjSerialNo", prjSerialNo)
				.getResultList(false);
		//ִ������*businesssum
		List<BizObject> list = bomAPS.createQuery("SELECT left(O.PAYDATE,7) as v.PDATE,SUM((O.PAYPRINCIPALAMT+O.PRINCIPALBALANCE)*ARS.BUSINESSRATE/1000) as v.BALANCEIRR,SUM(O.PAYINTERESTAMT) as v.INTAMT, SUM(O.PAYPRINCIPALAMT) as v.PRINAMT,SUM(O.PRINCIPALBALANCE) as v.PRINBALANCE  FROM jbo.acct.ACCT_RATE_SEGMENT ARS, jbo.prj.PRJ_RELATIVE PR, jbo.acct.ACCT_LOAN AL,O where O.PSTYPE='2' and PR.OBJECTTYPE='jbo.app.BUSINESS_CONTRACT' and PR.PROJECTSERIALNO=:prjSerialNo and PR.RELATIVETYPE='02' and AL.CONTRACTSERIALNO=PR.OBJECTNO and O.OBJECTTYPE='jbo.acct.ACCT_LOAN' and O.OBJECTNO=AL.SERIALNO and ARS.ObjectType='jbo.acct.ACCT_LOAN' and ARS.ObjectNo=O.OBJECTNO and ARS.RateType='04' and ARS.Status='1' and (ARS.SegFromDate is null or ARS.SegFromDate='' or ARS.SegFromDate<= :BusinessDate) and (ARS.SegToDate is null or ARS.SegToDate='' or ARS.SegToDate > :BusinessDate) group by left(O.PAYDATE,7)")
				.setParameter("prjSerialNo", prjSerialNo)
				.setParameter("BusinessDate", DateHelper.getBusinessDate())
				.getResultList(false);
		for(int i=0;i<list.size();i++){
			balanceIRR += list.get(i).getAttribute("BALANCEIRR").getDouble()+i< listFee.size() ? listFee.get(i).getAttribute("INTAMT").getDouble() : 0.0d;//����+ִ������*ʣ�౾��
			intAMT += list.get(i).getAttribute("INTAMT").getDouble();//������Ϣ�ͷ���֮��
			prinAMT += list.get(i).getAttribute("PRINAMT").getDouble();//Ͷ�뱾��
		}
		
		double irr = prinAMT < 0.0000001 ? 0.0d : Arith.round(balanceIRR/prinAMT*1000,4);
		String payPrincipalColor = "black";
		String payInteColor = "black";
		String fixInstallmentColor = "black";
		String payDateColor = "black";
		String flag = ""; //1 Ϊ������� 2 Ϊ��������
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
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'><input type=button value='����' onclick="excelShow()"> </font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
</tr>

<tr id = "CRTitle"> 
	<td colspan="7" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>�տ�ƻ�</font></td>
</tr>
<tr id = "CRTitle"> 
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>�·�</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>Ӧ������</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>Ӧ����Ϣ</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>Ӧ������</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>Ӧ���ܽ��</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>ʣ�౾��</font></td>
</tr>

	<%
	double allPrincipalAmt = 0.0;
	double allInteAmt = 0.0;
	double allAmt = 0.0;
	double allFee = 0.0;
	if(list != null){
		
		for(int i=0;i<listd.size();i++){
			BizObject bo = listd.get(i);
			allPrincipalAmt +=bo.getAttribute("PRINAMT").getDouble();//Ӧ������ 
			allInteAmt +=bo.getAttribute("INTAMT").getDouble();//Ӧ����Ϣ 
			double fee = i < listdFee.size() ? listdFee.get(i).getAttribute("INTAMT").getDouble() : 0.0d;
			allFee += fee;
			allAmt +=bo.getAttribute("PRINAMT").getDouble()+bo.getAttribute("INTAMT").getDouble()+fee;//ʣ�౾�� 

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
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'>�ϼ�</font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allPrincipalAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allInteAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allFee)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allAmt)%></font></td>
		
	</tr>
<tr id = "CRTitle"> 
	<td colspan="7" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>IRR����ƻ�</font></td>
</tr>
<tr id = "CRTitle"> 
	<td colspan="7" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>IRR������:<%=Arith.round(irr,4)%>��ǧ��֮��</font></td>
</tr>
<tr id = "CRTitle"> 
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>�·�</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>Ӧ��IRR����</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>Ӧ��IRR��Ϣ</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>Ӧ��IRR����</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>Ӧ���ܽ��</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>IRRʣ�౾��</font></td>
	
</tr>

	<%
	allPrincipalAmt = 0.0;
	allInteAmt = 0.0;
	allAmt = 0.0;
	allFee = 0.0;
	if(list != null){
		for(int i=0;i<list.size();i++){
			BizObject bo = list.get(i);
			allPrincipalAmt +=bo.getAttribute("PRINAMT").getDouble();//Ӧ������ 
			allInteAmt +=bo.getAttribute("INTAMT").getDouble();//Ӧ����Ϣ 
			
			double fee = i < listFee.size() ? listFee.get(i).getAttribute("INTAMT").getDouble() : 0.0d;
			allFee += fee;
			
			allAmt +=bo.getAttribute("PRINAMT").getDouble()+bo.getAttribute("INTAMT").getDouble()+fee;//ʣ�౾�� 
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
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'>�ϼ�</font></td>
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
	/*~[Describe=����excel;InputParam=��;OutPutParam=��;]~*/
	function excelShow()
	{
		var mystr = document.all('Layer1').innerHTML;
		spreadsheetTransfer(mystr.replace(/type=checkbox/g,"type=hidden"));
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>