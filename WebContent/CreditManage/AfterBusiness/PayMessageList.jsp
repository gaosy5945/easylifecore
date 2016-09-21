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
  
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	//从上个页面得到传入的参数
	//String duebillNo = CurPage.getParameter("ObjectNo");//借据流水号
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
	//定义变量：查询结果集
	String currencyId = "";

	ASResultSet sr = Sqlca.getResultSet("select Attribute2 from CODE_LIBRARY where CodeNo='Currency' and ItemNo = '"+accountCurrency+"'");
	if(sr.next()){
		currencyId = sr.getStringValue("Attribute2");
	}
	sr.getStatement().close();
	int num = 10;
	int start = DataConvert.toInt(Start == null || "".equals(Start) ? "1" : Start);
	
	if(accountType==null) accountType="";
	//为了支持在该页面重复查询支付信息（每次更换插叙起始日）、需要保持零售系统该客户的账户类型不变   modified by jqliang 2015-03-11
	String sCreditaccountType = accountType;//零售系统账号类型
	accountType = com.amarsoft.dict.als.cache.CodeCache.getItem("AccountType",accountType).getAttribute1();//核心系统账号类型
	if(accountType==null) accountType="";
	if(accountNo==null) accountNo="";
	if(accountCurrency==null) accountCurrency="";
	%>
<%/*~END~*/%>
<html>
<body>
	

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
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
	
    // add by jqliang 查询起始日输入框
	%>
	<table>
	
	<tr><td>查询反馈信息：<textarea rows="3" cols="60">returnCode:<%=returnCode %> returnMsg:<%=returnMsg %></textarea></td></tr>
	 <tr><td>账&nbsp;&nbsp;&nbsp;户&nbsp;&nbsp;&nbsp;号：<input id="QueryAccountNo" type="text" readonly value="<%=accountNo %>"/></td></tr>
	 <tr>
	   <td>查询起始日期(YYYYMMDD):<input id="QueryStartDate" type="text" /><input type="Button" value="查询" onClick="query()"/></td>
	 </tr>
	</table>
	<%
	if("020001215042".equals(returnCode)){//后台系统(核心业务系统)返回异常
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
					<td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","上一页","上一页","back()","")%></td>
					<td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","下一页","下一页","next();","")%></td>
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
			 <th class="th_btn3" width=7%  align="center">柜员流水</th>
			 <th class="th_btn3" width=7%  align="center">交易日期</th>
			 <th class="th_btn3" width=7%  align="center">交易时间</th>
			 <th class="th_btn3" width=9%  align="right">交易金额</th>
			 <th class="th_btn3" width=9%  align="right">账户余额</th>
			 <th class="th_btn3" width=9%  align="center">关联交易码</th>
			 <th class="th_btn3" width=7%  align="center">借贷标志</th>
			 <th class="th_btn3" width=10%  align="center">客户账号</th>
			 <th class="th_btn3" width=9%  align="center">营业机构号</th>
			 <th class="th_btn3" width=15%  align="center">摘要代码</th>
		   </tr>
		  <tbody>
		  <!--输出表格-->
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
			alert("已经是最后一页");
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
			alert("已经是第一页");
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
			alert("查询日期输入格式不正确");
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