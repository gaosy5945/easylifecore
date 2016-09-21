<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="com.amarsoft.app.als.sys.tools.SYSNameManager"%>
<%@ page import="com.amarsoft.dict.als.cache.CodeCache"%>
<%
	String applyserialno = DataConvert.toString(CurPage.getParameter("SerialNo"));//获取页面传过来的申请流水号
	if(applyserialno == null)    applyserialno = "";//6501202110082701
	BizObject babiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY").createQuery("O.SERIALNO = :APPLYSERIALNO").setParameter("APPLYSERIALNO",applyserialno).getSingleResult(false);
	BizObject BPbiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_PUTOUT").createQuery("O.applyserialno = :applyserialno").setParameter("applyserialno",applyserialno).getSingleResult(false);
	if(babiz == null){
		babiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT").createQuery("O.applyserialno = :applyserialno").setParameter("applyserialno",applyserialno).getSingleResult(false);
	}
	BizObject bapbiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPROVE").createQuery("O.SerialNo = (select max(O.serialno) from O where O.applyserialno = :applyserialno)").setParameter("applyserialno",applyserialno).getSingleResult(false);
	String SERIALNO = "";
	if(babiz != null){
		SERIALNO = babiz.getAttribute("CONTRACTARTIFICIALNO").getString();//合同流水号
	}
	if(SERIALNO == null)    SERIALNO = "";
	String BAPSERIALNO = "";
	if(bapbiz != null){
		BAPSERIALNO = bapbiz.getAttribute("SERIALNO").getString();//审批流水号
	}
	if(BAPSERIALNO == null)    BAPSERIALNO = "";
	String REFTYPENAME = "借据号";
	String REFNO = "";
	if(BPbiz != null){
		REFNO = BPbiz.getAttribute("DUEBILLSERIALNO").getString();
	}else if(babiz != null){
		REFNO = babiz.getAttribute("DUEBILLSERIALNO").getString();
	}
	if(REFNO == null)    REFNO = "";
	String NAME = "";
	if(babiz != null){
		NAME = babiz.getAttribute("CUSTOMERNAME").getString();// 借 款 人 
	}
	if(NAME == null)    NAME = "";
	String LNID = "";
	if(babiz != null){
		LNID = babiz.getAttribute("BUSINESSTYPE").getString();
	}
	if(LNID == null)    LNID = "";
	String LNNAME = "";
	if(LNID != null){
		LNNAME = Sqlca.getString("select productname from prd_product_library where productid = '"+LNID+"'").toString();// 贷款种类
	}
	if(LNNAME == null)    LNNAME = "";
	String TOTAMT = "";
	if(babiz != null){
		TOTAMT = DataConvert.toMoney(babiz.getAttribute("BUSINESSSUM").getString()); // 贷款金额
	}
	if(TOTAMT == null)    TOTAMT = "";
	String INTRATE = "";
	if(BAPSERIALNO != null){
		INTRATE = Sqlca.getString("select ars.BUSINESSRATE from acct_rate_segment ars, BUSINESS_APPROVE bap  where ars.objectno = bap.serialno and bap.serialno = '"+BAPSERIALNO+"' and ars.objecttype = 'jbo.app.BUSINESS_APPROVE' and ars.TERMID = bap.LOANRATETERMID ").toString();// 贷款利率
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
		RTN_TYPE = SYSNameManager.getTermName(tempRTN_TYPE);//  还款方式
	}catch(NullPointerException e){
	}
	if(RTN_TYPE == null)    RTN_TYPE = "";
	String PROJECTNO = "";
	if(SERIALNO != null){
		PROJECTNO = Sqlca.getString("select PROJECTSERIALNO from prj_relative where objectType = 'jbo.app.BUSINESS_CONTRACT' and objectno = '"+SERIALNO+"'");// 合作项目
	}
	if( PROJECTNO == null) PROJECTNO = "";
	String VOUCHTYPEID = "";
	if(babiz != null){
		VOUCHTYPEID = babiz.getAttribute("VOUCHTYPE").getString();
	}
	String GUATCODE = "";//担保方式
	if(VOUCHTYPEID != null){
		GUATCODE = CodeCache.getItemName("VouchType", VOUCHTYPEID);
	}
	if(GUATCODE == null)    GUATCODE = "";
	String DZY_RATIO = "";// 抵质押率
	String GUATNAME = "";// 抵押物
%>
<style>
#table td{ border-right:none; border-bottom:none;}
#table{ border-left:none; border-top:none;} 
</style>
<body>
<div align="center">
<table width="600" border="1" cellpadding="3" bordercolor = "black" cellspacing = "0" id="table">
  <tr>
    <td colspan=6 style="height:40px;line-height:40px;font-size:14px;font-family:楷体_GB2312;text-align:center;font-weight:bold;"> 上海浦东发展银行个人贷款审批表</td>
 </tr>
  <tr height="45">
    <td width=80><div style="font-size: 15px">&nbsp;<%=REFTYPENAME %></div></td>
    <td ><div style="font-size: 15px">&nbsp;<%=REFNO %></div></td>
    <td ><div style="font-size: 15px">&nbsp;借 款 人</div></td>
    <td ><div style="font-size: 15px">&nbsp;<%=NAME %></div></td>
    <td ><div style="font-size: 15px">&nbsp;贷款种类</div></td>
    <td width="23%"><div style="font-size: 15px">&nbsp;<%=LNNAME %></div></td>
  </tr>
  <tr height="45">
    <td ><div style="font-size: 15px">&nbsp;贷款金额</div></td>
    <td ><div style="font-size: 15px">&nbsp;<%=TOTAMT %></div></td>
    <td ><div style="font-size: 15px">&nbsp;贷款利率</div></td>
    <td ><div style="font-size: 15px">&nbsp;<%=INTRATE %></div></td>
    <td ><div style="font-size: 15px">&nbsp;贷款期限</div></td>
    <td ><div style="font-size: 15px">&nbsp;<%=loanTerm %></div></td>
  </tr>
  <tr height="45">
    <td ><div style="font-size: 15px">&nbsp;还款方式</div></td>
    <td ><div style="font-size: 15px">&nbsp;<%=RTN_TYPE %></div></td>
    <td ><div style="font-size: 15px">&nbsp;合作项目</div></td>
    <td ><div style="font-size: 15px">&nbsp;<%=PROJECTNO %></div></td>
    <td ><div style="font-size: 15px">&nbsp;担保方式</div></td>
    <td ><div style="font-size: 15px">&nbsp;<%=GUATCODE %></div></td>
  </tr>
  <tr height="45">
    <td ><div style="font-size: 15px">&nbsp;抵质押率</div></td>
    <td ><div style="font-size: 15px">&nbsp;<%=DZY_RATIO %></div></td>
    <td colspan="2"><div style="font-size: 15px">&nbsp;抵押物/质押物/保证人</div></td>
    <td colspan="2"><div style="font-size: 15px">&nbsp;<%=GUATNAME %></div></td>
  </tr>



<%
 //查询审批意见
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
			  		<td valign="bottom" align="right">签字&nbsp;<%=ft.getString("UserName")%>&nbsp;&nbsp;&nbsp;日期&nbsp;<%=ft.getString("InputDate")%></td>
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
	  		<td valign="bottom" align="right" style='font-size: 15px'>签字：&nbsp;<%=ft.getString("UserName")%>&nbsp;&nbsp;&nbsp;日期：&nbsp;<%=ft.getString("InputDate")%>&nbsp;&nbsp;&nbsp;机构：&nbsp;<%=ft.getString("orgName") %></td>
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
		<td id="print"><%=HTMLControls.generateButton("打印", "打印", "printPaper()", "") %></td>
	</tr>
</table>
</body>

<script>
   function printPaper(){
	   var print = document.getElementById("print");
	   if(window.confirm("是否确定要打印？")){
		   //打印	  
		   print.style.display = "none";
		   window.print();	
		   window.close();
	   }
   }
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
