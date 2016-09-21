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
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ģ�⻹�ʽ������"; // ��������ڱ��� <title> PG_TITLE </title>
	//���ϸ�ҳ��õ�����Ĳ���
	String DstrAmt = CurPage.getParameter("DstrAmt");//������
	String RepayMode = CurPage.getParameter("RepayMode");//���ʽ
	String IntRate = CurPage.getParameter("IntRate");//ִ�����ʣ��꣩
	String IntActualPrd = CurPage.getParameter("IntActualPrd");//��Ϣ����
	String StartIntDate = DateHelper.getStringDate(CurPage.getParameter("StartIntDate"));//������ʼ��
	String ExpiredDate = DateHelper.getStringDate(CurPage.getParameter("ExpiredDate"));//�������
	String DeductDate = CurPage.getParameter("DeductDate");//ÿ�¿ۿ���
	String StartNum1 = CurPage.getParameter("StartNum1");//��ʼ����
	String QueryNum1 = CurPage.getParameter("QueryNum1");//��ѯ����
	String MoExpiredDate = CurPage.getParameter("MoExpiredDate");//��������
	String FxdFlag = CurPage.getParameter("FxdFlag");//�̶�������־
	%>
<%/*~END~*/%>


<html>
<body>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%	int sRepayMode = Integer.parseInt(RepayMode);
	String repayMode = "";
	switch(sRepayMode){
		case 1 : 
			repayMode = "�ȶϢ";
			break;
		case 2 : 
			repayMode = "�ȶ��";
			break;
		case 3 : 
			repayMode = "һ�λ�����Ϣ";
			break;
		case 4 : 
			repayMode = "�ִθ�Ϣһ�λ���";
			break;
		default :
			repayMode = "�̶�����";
			break;
	}
	ArrayList<Map<String,String>> list1 = new ArrayList<Map<String,String>>();
	ArrayList<Map<String,String>> list2 = new ArrayList<Map<String,String>>();
	
	Map tmp=new HashMap();		
	tmp.put("PrdStopTerm","");
	tmp.put("FxdPrncpl","");
	tmp.put("RepayMode1","");
	list1.add(tmp);	
	Map tmp1=new HashMap();	
	tmp1.put("ExpiredDate1","");
	tmp1.put("FxdFlag","");
	tmp1.put("FxdIntRate","");
	tmp1.put("FloatPercent","");
	tmp1.put("IntRateAdjType1","");
	tmp.put("SpclDate","");
	list2.add(tmp1);
	
	StringBuffer sJSScript = new StringBuffer();
	//OCITransaction oci = CoreInstance.CorpMrtgOrPslLnPrdPymtMsr("92261005", "2261", 150000.00,"1",4.585,"0",0,"20050601","20300601","10",10,20,0,"","","","0", list1,list2, conn);
	OCITransaction oci = CoreInstance.CorpMrtgOrPslLnPrdPymtMsr("92261005", "2261", Double.parseDouble(DstrAmt), RepayMode, Double.parseDouble(IntRate), IntActualPrd,0, StartIntDate, ExpiredDate, DeductDate, Integer.parseInt(StartNum1),Integer.parseInt(QueryNum1), 0.0, "", "", MoExpiredDate,"0", list1, list2, Sqlca.getConnection());
	List<Message> imessage = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldByTag("RepymtMsrInfo").getFieldArrayValue();
	String[] aa = null;
	aa = new String[imessage.size()];
	double businessSum = Double.parseDouble(DstrAmt);
	double allTotAmt = 0.0d;
	double allPrnAmt = 0.0d;
	double allIntAmt = 0.0d;
	for(int i = 0; i < imessage.size() ; i ++){
		Message message = imessage.get(i);
		businessSum-=Double.parseDouble(message.getFieldValue("RepymtPrncpl"));
		allTotAmt += Double.parseDouble(message.getFieldValue("TotAmt"));
		allPrnAmt += Double.parseDouble(message.getFieldValue("RepymtPrncpl"));
		allIntAmt += Double.parseDouble(message.getFieldValue("RepymtIntAmt"));
		
		sJSScript.append("<tr>");
		sJSScript.append("<td align='center'>"+message.getFieldValue("PrdStopTerm")+"</td>");
 	 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(message.getFieldValue("TotAmt"))+"</td>");
 	 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(message.getFieldValue("RepymtPrncpl"))+"</td>");
 	 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(message.getFieldValue("RepymtIntAmt"))+"</td>");
 	 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(businessSum)+"</td>");
 	 	sJSScript.append("</tr>");
	}
	
	sJSScript.append("<tr>");
	sJSScript.append("<td align='center'>�ϼ�</td>");
 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(allTotAmt)+"</td>");
 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(allPrnAmt)+"</td>");
 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(allIntAmt)+"</td>");
 	sJSScript.append("<td align='right'></td>");
 	sJSScript.append("</tr>");
%>
<%/*~END~*/%>
<table width="100%" height=10px cellspacing="0" cellpadding="0" border="0">
    <tr>
	    <td class="buttonback" valign=top>
		    <table>
		    	<tr class="xx">	
					
					<td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��ӡ","��ӡ�ڹ��б�","ExcelPrint()","")%></td>
					 <td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","�ر�","�ر�","self.close();","")%></td>
					 <td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","Excel�в鿴","Excel�в鿴","htmlToExcel();","")%></td>
					 <td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","Word�в鿴","Word�в鿴","htmlToWord();","")%></td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<!--MODIFY BY XJQIN 200908-->
<div id="elDiv" style="overflow:auto;width:100%;height:95%" > 
	<table id="PlanTable" width=100% height=50%>
	<tr>
	  <td>
		<table  width=70%  style="border-collapse:collapse;" id="planList" align="center" border="2" cellpadding="0" cellspacing="0"  bordercolor="#000000">
		    <tr  bordercolor="#FFFFFF">
			  <th colspan=6 style="border-bottom:1px solid #000000;"><h1>ģ�⻹�ʽ������<h1></th>
		   </tr>
<%-- 		   <tr >
			  <th width=16% class="th_btn3" align="right">�ͻ�����:</th><td align="center" width=16%><%=StringEscapeUtils.escapeHtml(sCustomerName)%></td>
			  <th width=16% class="th_btn3" align="right">ҵ��Ʒ��:</th><td  align="center" width=16%><%=StringEscapeUtils.escapeHtml(sBusinessTypeName)%></td>
			  <th colspan=2 class="th_btn3" ></td>
		  </tr> --%>
		   <tr >
			  <th width=25% class="th_btn3" align="right">������:</th><td align="center" width=25%>&nbsp;<%=DataConvert.toMoney(DstrAmt)%></td>
			  <th width=25% class="th_btn3" align="right">����󻹿ʽ:</th><td  align="center" width=25%>&nbsp;<%=StringEscapeUtils.escapeHtml(repayMode)%></td>
			  <th colspan=2 class="th_btn3" ></td>
		  </tr>
		  
		   <tr>
			  <th width=25% class="th_btn3" align="right">����������:</th><td align="center" width=25%><%=StringEscapeUtils.escapeHtml(IntRate+"%")%></td>
			  <th width=25% class="th_btn3" align="right">��������:</th><td align="center" width=25%><%=StringEscapeUtils.escapeHtml(MoExpiredDate)%></td>
			  <th class="th_btn3"  colspan=2></td>
		  </tr>
 		  <tr>
		<%--  <th width=25% class="th_btn3" align="right">������:</th><td align="center" width=25%><%=DataConvert.toMoney(Revenue)%></td>
			  <th width=25% class="th_btn3" align="right">��������ծ��֧��:</th><td align="center" width=25%><%=StringEscapeUtils.escapeHtml(DataConvert.toMoney(OtherDebt))%></td> --%>
			  <th colspan=2 class="th_btn3" ></td>
		  </tr>
<%-- 		  <tr>
			  <th width=16% class="th_btn3" align="right">�����¹������:</th><td align="center" width=16%><%=StringEscapeUtils.escapeHtml(sMainReturnTypeName)%></td>
			  <th width=16% class="th_btn3" align="right">���¹������:</th><td align="center" width=16%><%=StringEscapeUtils.escapeHtml(DataConvert.toMoney(0))%></td>
		  </tr>  --%>
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
			 
			 <th class="th_btn3" width=4%  align="center">�ڴ�</th>
			 <th class="th_btn3" width=15%  align="center">�ڹ�</th>
			 <th class="th_btn3" width=15%  align="center">����</th>
			 <th class="th_btn3" width=15%  align="center">��Ϣ</th>
			 <th class="th_btn3" width=15%  align="center">�������</th>
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


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>   
	</script>
<%/*~END~*/%>



<%@ include file="/IncludeEnd.jsp"%>
