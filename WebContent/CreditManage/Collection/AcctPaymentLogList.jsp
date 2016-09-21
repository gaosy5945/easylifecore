<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="com.amarsoft.app.oci.bean.OCITransaction"%>
<%@page import="com.amarsoft.app.oci.bean.Message"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<style type="text/css">
    .style1{
		border:none;
		border-collapse:collapse; 

	}
    #planlist tbody tr.true1 td {
      background-color: #eee;
      height:1px;
    }
    #planlist tbody tr.false1  td {
      background-color: #fff;
      height:1px;
    }
	.th_btn3
	{
		background-color: #eee;
		font-size:15px;
		height:1px;
	} 
	@media   print   {  
    .xx   {display:none}  
  	}  
</style>
  
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	//从上个页面得到传入的参数
	String loanSerialNo = CurPage.getParameter("ObjectNo");//借据流水号
	//定义变量：查询结果集
	String serialNo = "";
	String SeqID="0" ;
	String payDate = "";//应还日期
	double PrinciPalBalance = 0.0d;//逾期本金
	double PrinciPalBalanceSum = 0.0d;//逾期本金
	double OverdueInteamt = 0.0d;//逾期利息
	double OverdueInteamtSum =0.0d;
	double OverdueFineamt = 0.0d;//逾期罚息
	double OverdueFineamtSum = 0.0d;//逾期罚息
	String Status="";//本期形态
	
	StringBuffer sJSScript = new StringBuffer();
	ASResultSet sr = Sqlca.getResultSet("select PERIODNO,payDate,PrinciPalBalance,OverdueInteamt,OverdueFineamt,getItemName('BusinessStatus',Status) as Status from acct_payment_schedule where DUEBILLNO = '"+loanSerialNo+"' and Status like 'L1%' order by PERIODNO");
	while(sr.next()){
		SeqID = sr.getString("PERIODNO");
		if("".equals(SeqID)) SeqID = "0";
		payDate = sr.getStringValue("payDate");
		if("".equals(payDate)) payDate = "";
		String PrinciPalBalance1 = sr.getStringValue("PrinciPalBalance");
		if("".equals(PrinciPalBalance1)) PrinciPalBalance1 = "0";
		String OverdueInteamt1 = sr.getStringValue("OverdueInteamt");
		if("".equals(OverdueInteamt1)) OverdueInteamt1 = "0";
		String OverdueFineamt1 = sr.getStringValue("OverdueFineamt");
		if("".equals(OverdueFineamt1)) OverdueFineamt1 = "0";
		Status = sr.getStringValue("Status");
		if("".equals(Status)) Status = "";
		
		PrinciPalBalance =  Double.parseDouble(PrinciPalBalance1);
		PrinciPalBalanceSum += PrinciPalBalance;
		OverdueInteamt =  Double.parseDouble(OverdueInteamt1);
		OverdueInteamtSum += OverdueInteamt;
		OverdueFineamt=  Double.parseDouble(OverdueFineamt1);
		OverdueFineamtSum += OverdueFineamt;

		
		sJSScript.append("<tr align=right>");
		sJSScript.append("<td align=right>"+Integer.parseInt(SeqID)+"</td>");
		sJSScript.append("<td align=right>"+payDate+"</td>");
		sJSScript.append("<td align=right>"+DataConvert.toMoney(PrinciPalBalance)+"</td>");
		sJSScript.append("<td align=right>"+DataConvert.toMoney(OverdueInteamt)+"</td>");
		sJSScript.append("<td align=right>"+DataConvert.toMoney(OverdueFineamt)+"</td>");
		sJSScript.append("<td align=right>"+Status+"</td>");
 	 	sJSScript.append("</tr>"); 
	}
	sr.getStatement().close();
	sJSScript.append("<tr align=right>");
	sJSScript.append("<td align=center>合计</td>");
 	sJSScript.append("<td align=right></td>");
	sJSScript.append("<td align=right>"+DataConvert.toMoney(PrinciPalBalanceSum)+"</td>");
	sJSScript.append("<td align=right>"+DataConvert.toMoney(OverdueInteamtSum)+"</td>");
	sJSScript.append("<td align=right>"+DataConvert.toMoney(OverdueFineamtSum)+"</td>");
	sJSScript.append("<td align=right></td>");
	sJSScript.append("</tr>");
%>
<%/*~END~*/%>
<html>
<body>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%	
	
%>
<%/*~END~*/%>
<div>
			<table>
		    	<tr class="xx">	
					<td class="buttontd" id="print"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","打印","打印","PrintPaper()","")%></td>
					<td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","导出","导出","Export();","")%></td>
					<td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","关闭","关闭","returnList();","")%></td>
				</tr>
			</table>
</div>
<div id="elDiv" style="overflow:auto; width:100%;height:100%" > 
		<table width="100%" height=5px cellspacing="0" cellpadding="0" border="0">
			<tr  bordercolor="#FFFFFF">
			  <th colspan=6 style="border-bottom:1px solid #000000;"><h1>欠款明细<h1></th>
		   </tr>
		</table>
		 <br>
<!-- 	<table id="PlanTable" width=100% height=10% align="center">
	<tr align="center"><td align="center"> -->
	 
		  <table class="style1" style="margin:0px" border=1px  bordercolor=black cellspacing=0 cellpadding=0 id=planlist align="center">
		   <tr class="false1" align="center">
		   	 <th class="th_btn3" width=150px  align="center">期次</th>
			 <th class="th_btn3" width=150px  align="center">应还款日</th>
			 <th class="th_btn3" width=150px  align="center">逾期本金</th>
			 <th class="th_btn3" width=150px  align="center">逾期利息</th>
			 <th class="th_btn3" width=150px  align="center">逾期罚息</th>
			 <th class="th_btn3" width=150px  align="center">本期形态</th>
		   </tr>
		  <tbody>
		  <!--输出表格-->
		  <%out.println(org.apache.commons.lang.StringEscapeUtils.escapeSql(sJSScript.toString()));%>  
		  </tbody>
		<!-- </table>
		<td><tr> -->
	  </table>
	   </div>
		<!---->
</body>
</html>
<script>   
	function returnList(){
		self.close();
	}
	function Export(){
		var mystr = document.all('elDiv').innerHTML;
		if(confirm("是否导出当前还款信息！")){
			spreadsheetTransfer(mystr.replace(/type=checkbox/g,"type=hidden"));
		}
	}
	
    function PrintPaper(){
	    var print = document.getElementById("print");
	    if(window.confirm("是否确定要打印？")){
	     	window.print();     
	    }
	}



</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>