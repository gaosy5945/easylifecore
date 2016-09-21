<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="com.amarsoft.app.als.sys.tools.SYSNameManager"%>
<%@ page import="com.amarsoft.dict.als.cache.CodeCache"%>
<%
	String applyserialno = DataConvert.toString(CurPage.getParameter("SerialNo"));//��ȡҳ�洫������������ˮ��
	if(applyserialno == null)    applyserialno = "";//6501202110082701
	BizObject babiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY").createQuery("O.SERIALNO = :APPLYSERIALNO").setParameter("APPLYSERIALNO",applyserialno).getSingleResult(false);
	BizObject BPbiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_PUTOUT").createQuery("O.applyserialno = :applyserialno").setParameter("applyserialno",applyserialno).getSingleResult(false);
	if(babiz == null){
		babiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT").createQuery("O.applyserialno = :applyserialno").setParameter("applyserialno",applyserialno).getSingleResult(false);
	}
	BizObject bapbiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPROVE").createQuery("O.SerialNo = (select max(O.serialno) from O where O.applyserialno = :applyserialno)").setParameter("applyserialno",applyserialno).getSingleResult(false);
	String SERIALNO = "";
	if(babiz != null){
		SERIALNO = babiz.getAttribute("CONTRACTARTIFICIALNO").getString();//��ͬ��ˮ��
	}
	if(SERIALNO == null)    SERIALNO = "";
	String BAPSERIALNO = "";
	if(bapbiz != null){
		BAPSERIALNO = bapbiz.getAttribute("SERIALNO").getString();//������ˮ��
	}
	if(BAPSERIALNO == null)    BAPSERIALNO = "";
	String REFTYPENAME = "��ݺ�";
	String REFNO = "";
	if(BPbiz != null){
		REFNO = BPbiz.getAttribute("DUEBILLSERIALNO").getString();
	}else if(babiz != null){
		REFNO = babiz.getAttribute("DUEBILLSERIALNO").getString();
	}
	if(REFNO == null)    REFNO = "";
	String NAME = "";
	if(babiz != null){
		NAME = babiz.getAttribute("CUSTOMERNAME").getString();// �� �� �� 
	}
	if(NAME == null)    NAME = "";
	String LNID = "";
	if(babiz != null){
		LNID = babiz.getAttribute("BUSINESSTYPE").getString();
	}
	if(LNID == null)    LNID = "";
	String LNNAME = "";
	if(LNID != null){
		LNNAME = Sqlca.getString("select productname from prd_product_library where productid = '"+LNID+"'").toString();// ��������
	}
	if(LNNAME == null)    LNNAME = "";
	String TOTAMT = "";
	if(babiz != null){
		TOTAMT = DataConvert.toMoney(babiz.getAttribute("BUSINESSSUM").getString()); // ������
	}
	if(TOTAMT == null)    TOTAMT = "";
	String INTRATE = "";
	if(BAPSERIALNO != null){
		INTRATE = Sqlca.getString("select ars.BUSINESSRATE from acct_rate_segment ars, BUSINESS_APPROVE bap  where ars.objectno = bap.serialno and bap.serialno = '"+BAPSERIALNO+"' and ars.objecttype = 'jbo.app.BUSINESS_APPROVE' and ars.TERMID = bap.LOANRATETERMID ").toString();// ��������
	}
	if(INTRATE == null)    INTRATE = "";
	else INTRATE = INTRATE + "%";
	int businessTerm = babiz.getAttribute("BusinessTerm").getInt();
	int businessTermDay = babiz.getAttribute("BusinessTermDay").getInt() ;
	
	String loanTerm = (businessTerm/12 < 10 ? "0"+String.valueOf(businessTerm/12) : String.valueOf(businessTerm/12))
			+ (businessTerm%12 < 10 ? "0"+String.valueOf(businessTerm%12) : String.valueOf(businessTerm%12))
			+ (businessTermDay < 10 ? "0"+String.valueOf(businessTermDay) : String.valueOf(businessTermDay))
			;
	
	String RTN_TYPE = "";
	try{
		String tempRTN_TYPE =  "";
		tempRTN_TYPE =  bapbiz.getAttribute("TermID").getString();
		if(tempRTN_TYPE == null)   tempRTN_TYPE = "";
		RTN_TYPE = SYSNameManager.getTermName(tempRTN_TYPE);//  ���ʽ
	}catch(NullPointerException e){
	}
	if(RTN_TYPE == null)    RTN_TYPE = "";
	String PROJECTNO = "";
	if(SERIALNO != null){
		PROJECTNO = Sqlca.getString("select PROJECTSERIALNO from prj_relative where objectType = 'jbo.app.BUSINESS_CONTRACT' and objectno = '"+SERIALNO+"'");// ������Ŀ
	}
	if( PROJECTNO == null) PROJECTNO = "";
	String VOUCHTYPEID = "";
	if(babiz != null){
		VOUCHTYPEID = babiz.getAttribute("VOUCHTYPE").getString();
	}
	String GUATCODE = "";//������ʽ
	if(VOUCHTYPEID != null){
		GUATCODE = CodeCache.getItemName("VouchType", VOUCHTYPEID);
	}
	if(GUATCODE == null)    GUATCODE = "";
	String DZY_RATIO = "";// ����Ѻ��
	String GUATNAME = "";// ��Ѻ��
%>
<style>
#table td{ border-right:none; border-bottom:none;}
#table{ border-left:none; border-top:none;} 
</style>
<body>
<div align="center">
<table width="600" border="1" cellpadding="3" bordercolor = "black" cellspacing = "0" id="table">
  <tr>
    <td colspan=6 style="height:40px;line-height:40px;font-size:14px;font-family:����_GB2312;text-align:center;font-weight:bold;"> �Ϻ��ֶ���չ���и��˴���������</td>
 </tr>
  <tr height="45">
    <td width=80><div style="font-size: 15px">&nbsp;<%=REFTYPENAME %></div></td>
    <td ><div style="font-size: 15px">&nbsp;<%=REFNO %></div></td>
    <td ><div style="font-size: 15px">&nbsp;�� �� ��</div></td>
    <td ><div style="font-size: 15px">&nbsp;<%=NAME %></div></td>
    <td ><div style="font-size: 15px">&nbsp;��������</div></td>
    <td width="23%"><div style="font-size: 15px">&nbsp;<%=LNNAME %></div></td>
  </tr>
  <tr height="45">
    <td ><div style="font-size: 15px">&nbsp;������</div></td>
    <td ><div style="font-size: 15px">&nbsp;<%=TOTAMT %></div></td>
    <td ><div style="font-size: 15px">&nbsp;��������</div></td>
    <td ><div style="font-size: 15px">&nbsp;<%=INTRATE %></div></td>
    <td ><div style="font-size: 15px">&nbsp;��������</div></td>
    <td ><div style="font-size: 15px">&nbsp;<%=loanTerm %></div></td>
  </tr>
  <tr height="45">
    <td ><div style="font-size: 15px">&nbsp;���ʽ</div></td>
    <td ><div style="font-size: 15px">&nbsp;<%=RTN_TYPE %></div></td>
    <td ><div style="font-size: 15px">&nbsp;������Ŀ</div></td>
    <td ><div style="font-size: 15px">&nbsp;<%=PROJECTNO %></div></td>
    <td ><div style="font-size: 15px">&nbsp;������ʽ</div></td>
    <td ><div style="font-size: 15px">&nbsp;<%=GUATCODE %></div></td>
  </tr>
  <tr height="45">
    <td ><div style="font-size: 15px">&nbsp;����Ѻ��</div></td>
    <td ><div style="font-size: 15px">&nbsp;<%=DZY_RATIO %></div></td>
    <td colspan="2"><div style="font-size: 15px">&nbsp;��Ѻ��/��Ѻ��/��֤��</div></td>
    <td colspan="2"><div style="font-size: 15px">&nbsp;<%=GUATNAME %></div></td>
  </tr>



<%
 //��ѯ�������
ASResultSet ft = Sqlca.getResultSet(new SqlObject("select FT.* from FLOW_TASK FT,FLOW_MODEL FM,FLOW_OBJECT FO where FO.ObjectType = 'jbo.app.BUSINESS_APPLY' and "
 +" (FO.ObjectNo = :ObjectNo or FO.ObjectNo = (select AR.ObjectNo from APPLY_RELATIVE AR where AR.ApplySerialNo = :ObjectNo and AR.objectType = 'jbo.app.BUSINESS_APPLY' AND AR.RELATIVETYPE = '06')) "
 +" and FO.FlowSerialNo = FT.FlowSerialNo and FO.FlowNo = FM.FlowNo and FO.FlowVersion = FM.FlowVersion and FM.PhaseNo = FT.PhaseNo and FM.PhaseType in('0050','0060') order by FT.TaskSerialNo").setParameter("ObjectNo", applyserialno));
String PhaseName = "";
String PhaseActionType = "";
String PhaseOpinion = "";

while(ft.next()){
	PhaseName = ft.getString("PhaseName");
	if(PhaseName == null) break;
	PhaseActionType = ft.getString("PhaseActionType");
	PhaseActionType = CodeCache.getItem("BPMPhaseActionType", PhaseActionType).getItemName();
	if(PhaseActionType == null) PhaseActionType = "";
	PhaseOpinion = ft.getString("PhaseOpinion");
	if(PhaseOpinion == null) PhaseOpinion = ""; 


%>
<tr>
  <%-- <td colspan=6>
	  <table border=0>
	  	<tr>
	  		<td  width="3%" align="center" valign="top" height="1"><%=PhaseName%></td>
	  		<td  width="97%" valign="top" heigth="auto">
			  <table width="100%" heigth="100%">
			  	<tr height="1">
			  		<td><%=PhaseActionType%></td>
			  	</tr>
			  	<tr height="100" valign="top">
			  		<td ><%=PhaseOpinion%></td>
			  	</tr>
			  	<tr height="1" valign="bottom">
			  		<td valign="bottom" align="right">ǩ��&nbsp;<%=ft.getString("UserName")%>&nbsp;&nbsp;&nbsp;����&nbsp;<%=ft.getString("InputDate")%></td>
			  	</tr>
			  </table>
	  		</td>
	  	</tr>
	  </table>
  <td> --%>
  <td colspan=1 width="3" style="padding-left:35px;padding-top:10px;font-size:15px" valign="top" height="1" ><%=PhaseName%></td>
  <td colspan=5 valign="top" heigth="auto">
	  <table width="100%" heigth="100%">
	  	<tr height="1">
	  		<td style='font-size: 15px'><%=PhaseActionType%></td>
	  	</tr>
	  	<tr height="<%=16*PhaseName.length()%>" valign="top">
	  		<td style='font-size: 15px'><%=PhaseOpinion%></td>
	  	</tr>
	  	<tr height="1" valign="bottom">
	  		<td valign="bottom" align="right" style='font-size: 15px'>ǩ�֣�&nbsp;<%=ft.getString("UserName")%>&nbsp;&nbsp;&nbsp;���ڣ�&nbsp;<%=ft.getString("InputDate")%>&nbsp;&nbsp;&nbsp;������&nbsp;<%=ft.getString("orgName") %></td>
	  	</tr>
	  </table>
  </td>
</tr>
<%
}
ft.close();
%>
</table>
</div>



<table align="center">
	<tr>	
		<td id="print"><%=HTMLControls.generateButton("��ӡ", "��ӡ", "printPaper()", "") %></td>
	</tr>
</table>
</body>

<script>
   function printPaper(){
	   var print = document.getElementById("print");
	   if(window.confirm("�Ƿ�ȷ��Ҫ��ӡ��")){
		   //��ӡ	  
		   print.style.display = "none";
		   window.print();	
		   window.close();
	   }
   }
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
