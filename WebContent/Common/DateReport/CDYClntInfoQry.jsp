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

	String sCertType = CurPage.getParameter("CERTTYPE");
	String sCertID = CurPage.getParameter("CERTID");
	if(sCertType==null) sCertType="";
	if(sCertID==null) sCertID="";

	String Start = CurPage.getParameter("Start");
	int num = 10;
	int start = DataConvert.toInt(Start == null || "".equals(Start) ? "1" : Start);
	
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
		 oci = CoreInstance.CDYClntInfoQry("92261005","2261",start,num,"1","2","",sCertType,sCertID,"","","","","","","","11",Sqlca.getConnection());
		 returnCode = oci.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnCode");
		 returnMsg = oci.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnMsg");
	}catch(Exception e){
		e.printStackTrace();
	}
	if(!"000000000000".equals(returnCode)){
		out.println("returnCode:"+returnCode);
		out.println("returnMsg:"+returnMsg);
		return;
	}
	List<Message> imessage = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldByTag("XDYClntInfo").getFieldArrayValue();

	int i = 0;
	if(imessage != null)
	{
		for(i = 0; i < imessage.size() ; i ++){
			Message message = imessage.get(i);
			int j=i+start;
			sJSScript.append("<tr>");
			sJSScript.append("<td align='center'>"+j+"</td>");
			sJSScript.append("<td align='center'>"+message.getFieldValue("BussId1")+"</td>");
			sJSScript.append("<td align='center'>"+message.getFieldValue("ClientNo1")+"</td>");
			sJSScript.append("<td align='center'>"+message.getFieldValue("ClientName1")+"</td>");
	 	 	sJSScript.append("<td align='center'>"+message.getFieldValue("CtfType1")+"</td>");
	 	 	sJSScript.append("<td align='center'>"+message.getFieldValue("CtfId1")+"</td>");
			sJSScript.append("<td align='center'>"+message.getFieldValue("ClientAcctNo1")+"</td>");
			sJSScript.append("<td align='center'>"+message.getFieldValue("LoanTerm")+"</td>");
			sJSScript.append("<td align='center'>"+message.getFieldValue("StartIntDate1")+"</td>");
			sJSScript.append("<td align='center'>"+message.getFieldValue("ExpiredDate1")+"</td>");
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
			 <th class="th_btn3" width=9%  align="center">����ױ��</th>
			 <th class="th_btn3" width=9%  align="center">�ͻ����</th>
			 <th class="th_btn3" width=7%  align="center">�ͻ�����</th>
			 <th class="th_btn3" width=7%  align="center">֤������</th>
			 <th class="th_btn3" width=9%  align="center">֤������</th>
			 <th class="th_btn3" width=9%  align="center">����ģʽ�˺�</th>
			 <th class="th_btn3" width=7%  align="center">ҵ��ʹ������</th>
			 <th class="th_btn3" width=7%  align="center">ҵ��ʼ����</th>
			 <th class="th_btn3" width=7%  align="center">ҵ��������</th>
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
			var CertType = "<%=sCertType%>";
			var CertID = "<%=sCertID%>";
			AsControl.OpenComp("/Common/DateReport/CDYClntInfoQry.jsp","Start="+start+"&CertType="+CertType+"&CertID="+CertID,"_self");
		}
		
	}
	function back(){
		var start = <%=start%> - <%=num%>;
		if(start < 0){
			alert("�Ѿ��ǵ�һҳ");
			return;
		}else{
			var CertType = "<%=sCertType%>";
			var CertID = "<%=sCertID%>";
			AsControl.OpenComp("/Common/DateReport/CDYClntInfoQry.jsp","Start="+start+"&CertType="+CertType+"&CertID="+CertID,"_self");
		}
	}
	
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>