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
		font-size:15px;
		height:1px;
	} 
	@media   print   {  
    .xx   {display:none}  
  	}  
</style>
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	//���ϸ�ҳ��õ�����Ĳ���
	//String duebillNo = CurPage.getParameter("ObjectNo");//�����ˮ��
	String putOutDate = CurPage.getParameter("PutOutDate");
	String startDate = "";
	if(putOutDate.length()==10){
		startDate = DateHelper.getStringDate(putOutDate);
	}else{
		startDate = putOutDate;
	}
	
	String accountType = CurPage.getParameter("AccountType");
	String accountNo = CurPage.getParameter("AccountNo");
	String accountCurrency = CurPage.getParameter("AccountCurrency");
	String Start = CurPage.getParameter("Start");
	//�����������ѯ�����
	String currencyId = "";

	ASResultSet sr = Sqlca.getResultSet("select Attribute2 from CODE_LIBRARY where CodeNo='Currency' and ItemNo = '"+accountCurrency+"'");
	if(sr.next()){
		currencyId = sr.getStringValue("Attribute2");
	}
	sr.getStatement().close();
	int num = 10;
	int start = DataConvert.toInt(Start == null || "".equals(Start) ? "1" : Start);
	
	if(accountType==null) accountType="";
	//Ϊ��֧���ڸ�ҳ���ظ���ѯ֧����Ϣ��ÿ�θ���������ʼ�գ�����Ҫ��������ϵͳ�ÿͻ����˻����Ͳ���   modified by jqliang 2015-03-11
	String sCreditaccountType = accountType;//����ϵͳ�˺�����
	accountType = com.amarsoft.dict.als.cache.CodeCache.getItem("AccountType",accountType).getAttribute1();//����ϵͳ�˺�����
	if(accountType==null) accountType="";
	if(accountNo==null) accountNo="";
	if(accountCurrency==null) accountCurrency="";
	%>
<%/*~END~*/%>
<html>
<body>
	

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%	
	StringBuffer sJSScript = new StringBuffer();
    String returnCode = "";
    String returnMsg = "";
    	
    OCITransaction oci = null;
	try{
		 oci = CoreInstance.RtlCrnAcctHistTranQry("92261005", "2261", "1","", accountType, accountNo,"", currencyId,"0","","","","","",startDate,"30180101","","","",num,start,"0001",Sqlca.getConnection());
		 returnCode = oci.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnCode");
		 returnMsg = oci.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnMsg");
	}catch(Exception e){
		e.printStackTrace();
	}
	
    // add by jqliang ��ѯ��ʼ�������
	%>
	<table>
	
	<tr><td>��ѯ������Ϣ��<textarea rows="3" cols="60">returnCode:<%=returnCode %> returnMsg:<%=returnMsg %></textarea></td></tr>
	 <tr><td>��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;�ţ�<input id="QueryAccountNo" type="text" readonly value="<%=accountNo %>"/></td></tr>
	 <tr>
	   <td>��ѯ��ʼ����(YYYYMMDD):<input id="QueryStartDate" type="text" /><input type="Button" value="��ѯ" onClick="query()"/></td>
	 </tr>
	</table>
	<%
	if("020001215042".equals(returnCode)){//��̨ϵͳ(����ҵ��ϵͳ)�����쳣
		return;
	}
	List<Message> imessage = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldByTag("CrnTranInfo").getFieldArrayValue();
	
	int i = 0;
	if(imessage != null)
	{
		for(i = 0; i < imessage.size() ; i ++){
			Message message = imessage.get(i);
			int j=i+start;
			sJSScript.append("<tr>");
			sJSScript.append("<td align='center'>"+j+"</td>");
			sJSScript.append("<td align='center'>"+message.getFieldValue("HostSeqNo")+"</td>");
			sJSScript.append("<td align='center'>"+message.getFieldValue("ActTranDate")+"</td>");
			sJSScript.append("<td align='center'>"+message.getFieldValue("ActTranTime")+"</td>");
	 	 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(message.getFieldValue("TranAmt"))+"</td>");
	 	 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(message.getFieldValue("AcctBal"))+"</td>");
			sJSScript.append("<td align='center'>"+message.getFieldValue("RelTranCode")+"</td>");
			sJSScript.append("<td align='center'>"+message.getFieldValue("DebitFlag")+"</td>");
			sJSScript.append("<td align='center'>"+message.getFieldValue("ClientAcctNo")+"</td>");
			sJSScript.append("<td align='center'>"+message.getFieldValue("BussBranchId")+"</td>");
			sJSScript.append("<td align='center'>"+message.getFieldValue("AbstractCode")+"</td>");
	 	 	sJSScript.append("</tr>");
		}
	}
	
	
%>
<%/*~END~*/%>

<div id="elDiv" style="overflow:auto;width:100%;height:100%" > 
		<table width="100%" height=5px cellspacing="0" cellpadding="0" border="0">
    <tr>
	    <td class="buttonback" valign=top align="center">
		    <table>
		    	<tr class="xx">	
					<td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��һҳ","��һҳ","back()","")%></td>
					<td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��һҳ","��һҳ","next();","")%></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
	<table id="PlanTable" width=100% height=10%>
	<tr><td>
	  <br>
		  <table class="style1" style="margin:0px" border=1px  bordercolor=black cellspacing=0 cellpadding=0 id=planlist align="center">
		   <tr class="false1">
		   	 <th class="th_btn3" width=2%  align="center"></th>
			 <th class="th_btn3" width=7%  align="center">��Ա��ˮ</th>
			 <th class="th_btn3" width=7%  align="center">��������</th>
			 <th class="th_btn3" width=7%  align="center">����ʱ��</th>
			 <th class="th_btn3" width=9%  align="right">���׽��</th>
			 <th class="th_btn3" width=9%  align="right">�˻����</th>
			 <th class="th_btn3" width=9%  align="center">����������</th>
			 <th class="th_btn3" width=7%  align="center">�����־</th>
			 <th class="th_btn3" width=10%  align="center">�ͻ��˺�</th>
			 <th class="th_btn3" width=9%  align="center">Ӫҵ������</th>
			 <th class="th_btn3" width=15%  align="center">ժҪ����</th>
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
<script>   
	function next(){
		var i = <%=i%>;
		if(i < 10){
			alert("�Ѿ������һҳ");
			return;
		}else{
			var start = <%=start%> + <%=num%>;
			var accountType = "<%=sCreditaccountType%>";
			var accountNo = "<%=accountNo%>";
			var accountCurrency = "<%=accountCurrency%>";
			AsControl.OpenComp("/CreditManage/AfterBusiness/PayMessageList.jsp","Start="+start+"&AccountNo="+accountNo+"&AccountType="+accountType+"&AccountCurrency="+accountCurrency,"_self");
		}
		
	}
	function back(){
		var start = <%=start%> - <%=num%>;
		if(start < 0){
			alert("�Ѿ��ǵ�һҳ");
			return;
		}else{
			var accountType = "<%=sCreditaccountType%>";
			var accountNo = "<%=accountNo%>";
			var accountCurrency = "<%=accountCurrency%>";
			AsControl.OpenComp("/CreditManage/AfterBusiness/PayMessageList.jsp","Start="+start+"&AccountNo="+accountNo+"&AccountType="+accountType+"&AccountCurrency="+accountCurrency,"_self");
		}
	}
	
	function query(){
		var sQueryStartDate = document.getElementById("QueryStartDate").value.trim();
		
		if(sQueryStartDate.length!=8){
			alert("��ѯ���������ʽ����ȷ");
			return;
		}
		var putOutDate = sQueryStartDate;
		var accountType = "<%=sCreditaccountType%>";
		var accountNo = "<%=accountNo%>";
		var accountCurrency = "<%=accountCurrency%>";
		//var Start = "<%=start%>";
		AsControl.OpenComp("/CreditManage/AfterBusiness/PayMessageList.jsp","PutOutDate="+putOutDate+"&AccountType="+accountType+"&AccountNo="+accountNo+"&AccountCurrency="+accountCurrency,"_self");
	}
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>