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
	String AccountNo = CurPage.getParameter("AccountNo");
	if(AccountNo == null) AccountNo = "";
	String StartDate = CurPage.getParameter("StartDate");//借据号	
	if(StartDate == null) StartDate = "";
	String EndDate = CurPage.getParameter("EndDate");//借据号	
	if(EndDate == null) EndDate = "";
	String Start = CurPage.getParameter("Start");
	int num = 10;
	int start = DataConvert.toInt(Start == null || "".equals(Start) ? "1" : Start);
	
	%>
<%/*~END~*/%>
<html>
<body>
<title>保证金缴纳明细查询</title>	

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%	
	StringBuffer sJSScript = new StringBuffer();
	JBOTransaction tx = null;
	try{
	tx = JBOFactory.createJBOTransaction();
	String TranTellerNo = "92261005";
	String BranchId = "2261";
	int StartNum1 = 0;
	int QueryNum1 = 9;

	if(!"".equals(EndDate) || EndDate != null){
		EndDate = EndDate.substring(0, 4) + EndDate.substring(5, 7) + EndDate.substring(8, 10);
	}
	if(!"".equals(StartDate) || StartDate != null){
		StartDate = StartDate.substring(0, 4) + StartDate.substring(5, 7) + StartDate.substring(8, 10);
	}
	
	BizObjectManager bmCMI = JBOFactory.getBizObjectManager("jbo.guaranty.CLR_MARGIN_INFO");
	tx.join(bmCMI);
	try{
		OCITransaction oci = CoreInstance.MrgnAcctNoSeqQry(TranTellerNo, BranchId, AccountNo, StartDate, EndDate, StartNum1, QueryNum1, "", tx.getConnection(bmCMI));

	String ReturnCode = oci.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnCode");
	String ReturnMsg = oci.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnMsg");
	if(("000000000000").equals(ReturnCode)){
		List<Message> imessage = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldByTag("MrgnAcctNoInfo").getFieldArrayValue();

		if(imessage != null)
		{
			for(int i = 0; i < imessage.size() ; i ++){
				Message message = imessage.get(i);
				int j=i+start;
				sJSScript.append("<tr>");
				sJSScript.append("<td align='center'>"+j+"</td>");
				sJSScript.append("<td align='center'>"+message.getFieldValue("BussBranchId")+"</td>");
				sJSScript.append("<td align='center'>"+message.getFieldValue("ActTranDate")+"</td>");
				sJSScript.append("<td align='center'>"+message.getFieldValue("ActTranTime")+"</td>");
		 	 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(message.getFieldValue("TranAmt"))+"</td>");
		 	 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(message.getFieldValue("AcctBal"))+"</td>");
				sJSScript.append("<td align='right'>"+DataConvert.toMoney(message.getFieldValue("FreezeBal"))+"</td>");
				sJSScript.append("<td align='right'>"+DataConvert.toMoney(message.getFieldValue("CntlBal"))+"</td>");
		 	 	sJSScript.append("</tr>");
			}
		}
	}
	}catch(Exception ex)
	{
		String msg = ex.getMessage();
		if(!"".equals(msg) && !StringX.isEmpty(msg)){
			String rto = msg.substring(0, 10);
			if("WebService".equals(rto)){ 
				msg = "查询超时，请重试！";
			}
		}
		%> <script type="text/javascript"> alert("<%=msg%>"); top.close(); </script><%
	}
	tx.commit();
	}catch(Exception ex){
		tx.rollback();
		throw ex;
	}
%>
<%/*~END~*/%>

<div id="elDiv" style="overflow:auto;width:100%;height:100%" > 
	<table id="PlanTable" width=100% height=10%>
	<tr><td>
	  <br>
		  <table class="style1" style="margin:0px" border=1px  bordercolor=black cellspacing=0 cellpadding=0 id=planlist align="center">
		   <tr class="false1">
		   	 <th class="th_btn3" width=2%  align="center"></th>
			 <th class="th_btn3" width=7%  align="center">营业机构号</th>
			 <th class="th_btn3" width=7%  align="center">实际交易日期</th>
			 <th class="th_btn3" width=7%  align="center">实际交易时间</th>
			 <th class="th_btn3" width=9%  align="center">交易金额</th>
			 <th class="th_btn3" width=9%  align="center">账户余额</th>
			 <th class="th_btn3" width=9%  align="center">冻结余额</th>
			 <th class="th_btn3" width=7%  align="center">控制余额</th>
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

</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>