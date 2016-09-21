<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="com.amarsoft.app.oci.bean.OCITransaction"%>
<%@page import="com.amarsoft.app.oci.bean.Message"%>
<%@page import="com.amarsoft.app.oci.instance.CoreInstance"%>
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
		font-size:13px;
		height:1px;
	} 
	@media   print   {  
    .xx   {display:none}  
  	}  
</style>
  
	<%
	String PG_TITLE = "ģ����ǰ������"; // ��������ڱ��� <title> PG_TITLE </title>
	//���ϸ�ҳ��õ�����Ĳ���
	String DuebillNo = CurPage.getParameter("DuebillNo");//��ݺ�	
	//DuebillNo = "7201200510051101";
	String RepayDate = DateHelper.getStringDate(CurPage.getParameter("RepayDate"));//��������
	if(RepayDate == null) RepayDate = "";
	String TranAmt = CurPage.getParameter("TranAmt");//��ǰ������
	double nTranAmt = 0.0;
	if(!(TranAmt== null||"".equals(TranAmt))){
		nTranAmt = Double.parseDouble(TranAmt);
	}
	
	String TrialMode = CurPage.getParameter("TrialMode"); //���㷽ʽ
	if(TrialMode == null) TrialMode = "";
	
	String RepayMode = CurPage.getParameter("cRepayMode"); //��ǰ߀�ʽ
	if(RepayMode == null) RepayMode = "";	
	
	%>


<html>
<body>
<%	
try{
	StringBuffer sJSScript = new StringBuffer();
	
	OCITransaction oci = CoreInstance.PreRepymtMsr("92261005", "2261",DuebillNo,RepayDate,TrialMode,RepayMode,nTranAmt,Sqlca.getConnection());	
	

	String RepymtPrncplAmt = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("AgrtAmt");
	String TotAmt = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("TotAmt");
	String AcctBal = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("AcctBal");
	String NoRepayInt = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("NoRepayInt");
	List<Message> imessage = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldByTag("PreRepymtMsrInfo").getFieldArrayValue();
	if(imessage != null)
	{
		for(int i = 0; i < imessage.size() ; i ++){
			Message message = imessage.get(i);
			sJSScript.append("<tr>");
			sJSScript.append("<td align='center'>"+message.getFieldValue("RepayDate")+"</td>");
	 	 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(message.getFieldValue("RepymtPrncpl"))+"</td>");
	 	 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(message.getFieldValue("RepymtIntAmt"))+"</td>");
	 	 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(message.getFieldValue("TranAmt"))+"</td>");
	 	 	sJSScript.append("</tr>");
		}
	}

%>
<%/*~END~*/%>
<%-- <table width="100%" height=10px cellspacing="0" cellpadding="0" border="0">
    <tr>
	    <td class="buttonback" valign=top>
		    <table>
		    	<tr class="xx">	
					
					<td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��ӡ","��ӡ","ExcelPrint()","")%></td>
					 <td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","�ر�","�ر�","self.close();","")%></td>
					 <td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","Excel�в鿴","Excel�в鿴","htmlToExcel();","")%></td>
					 <td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","Word�в鿴","Word�в鿴","htmlToWord();","")%></td>
				</tr>
			</table>
		</td>
	</tr>
</table> --%>

<!--MODIFY BY XJQIN 200908-->
<div id="elDiv" style="overflow:auto;width:100%;height:95%" > 
	<table id="PlanTable" width=100% height=50%>
	<tr>
	  <td>
		<table  width=70%  style="border-collapse:collapse;" id="planList" align="center" border="2" cellpadding="0" cellspacing="0"  bordercolor="#000000">
		    <tr  bordercolor="#FFFFFF">
			  <th colspan=6 style="border-bottom:1px solid #000000;"><h1>ģ����ǰ������<h1></th>
		   </tr>
<%-- 		   <tr >
			  <th width=16% class="th_btn3" align="right">�ͻ�����:</th><td align="center" width=16%><%=StringEscapeUtils.escapeHtml(sCustomerName)%></td>
			  <th width=16% class="th_btn3" align="right">ҵ��Ʒ��:</th><td  align="center" width=16%><%=StringEscapeUtils.escapeHtml(sBusinessTypeName)%></td>
			  <th colspan=2 class="th_btn3" ></td>
		  </tr> --%>
		   <tr >
			  <th width=25% class="th_btn3" align="right">�������:</th><td align="center" width=25%>&nbsp;<%=DataConvert.toMoney(RepymtPrncplAmt)%></td>
		  	  <th width=25% class="th_btn3" align="right">��Ϣ���:</th><td  align="center" width=25%>&nbsp;<%=DataConvert.toMoney(NoRepayInt)%></td>
			  <th colspan=2 class="th_btn3" ></td>
		  </tr>
		  
		   <tr>
			  <th width=25% class="th_btn3" align="right">�ϼƽ��:</th><td align="center" width=25%><%=DataConvert.toMoney(TotAmt)%></td>
			  <th width=25% class="th_btn3" align="right">�˻����:</th><td align="center" width=25%><%=DataConvert.toMoney(AcctBal)%></td>
			  <th class="th_btn3"  colspan=2></td>
		  </tr>
<%-- 		  <tr>
			  <th width=16% class="th_btn3" align="right">������:</th><td align="center" width=16%><%=DataConvert.toMoney(ATTRIBUTE6)%></td>
			  <th width=16% class="th_btn3" align="right">��������ծ��֧��:</th><td align="center" width=16%><%=StringEscapeUtils.escapeHtml(DataConvert.toMoney(ATTRIBUTE7))%></td>
			  <th colspan=2 class="th_btn3" ></td>
		  </tr>s
		  <tr>
			  <th width=16% class="th_btn3" align="right">�����¹������:</th><td align="center" width=16%><%=StringEscapeUtils.escapeHtml(sMainReturnTypeName)%></td>
			  <th width=16% class="th_btn3" align="right">���¹������:</th><td align="center" width=16%><%=StringEscapeUtils.escapeHtml(DataConvert.toMoney(0))%></td>
		  </tr> --%>
	    </table>
	  </td>
	</tr>
	<tr><td>
	  <br>
		  <table class="style1" style="margin:0px" border=1px  bordercolor=black cellspacing=0 cellpadding=0 id=planlist align="center">
		   <tr class="false1">
		      <%
		      	 double columns = 7;
		      %>
			 
			 <th class="th_btn3" width=10%  align="center">��������</th>
			 <th class="th_btn3" width=15%  align="center">Ӧ������</th>
			 <th class="th_btn3" width=15%  align="center">��Ϣ���</th>
			 <th class="th_btn3" width=15%  align="center">���׽��</th>
		   </tr>
		  <tbody>
		    <!--������-->
		   <%out.println(org.apache.commons.lang.StringEscapeUtils.escapeSql(sJSScript.toString()));%>
		  </tbody>
		</table>
		<tr><td>
	  </table>
	   </div>
<!---->
</body>
</html>


<%
}catch(Exception ex)
{
	ex.printStackTrace();
	
%>
	<script language=javascript>
		alert("<%=ex.getMessage()%>");
		self.close();
	</script>
<%
}
%>



<%@ include file="/IncludeEnd.jsp"%>
