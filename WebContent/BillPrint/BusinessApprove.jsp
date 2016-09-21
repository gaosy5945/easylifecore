<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="com.amarsoft.app.als.sys.tools.SYSNameManager"%>
<%@ page import="com.amarsoft.are.jbo.BizObject"%>
<%@ page import="com.amarsoft.dict.als.cache.CodeCache"%>
<%@ page import="com.amarsoft.app.als.common.util.NumberHelper" %>
<%
String APPLYSERIALNO = DataConvert.toString(CurPage.getParameter("SerialNo"));//申请流水号 
if(APPLYSERIALNO == null)      APPLYSERIALNO = "";
BizObject babiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY").createQuery("O.SERIALNO = :APPLYSERIALNO").setParameter("APPLYSERIALNO",APPLYSERIALNO).getSingleResult();
if(babiz == null){
	babiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT").createQuery("O.APPLYSERIALNO = :APPLYSERIALNO").setParameter("APPLYSERIALNO",APPLYSERIALNO).getSingleResult();
}
String CONTRACTSERIALNO = babiz.getAttribute("CONTRACTARTIFICIALNO").toString();//合同流水号
String CUSTOMERNAME = babiz.getAttribute("CUSTOMERNAME").toString();//借款人
String CUSTOMERID = babiz.getAttribute("CUSTOMERID").toString();//客户号
if(CUSTOMERID == null) CUSTOMERID = "";
String TaskSerialNo = Sqlca.getString("select max(ft.taskserialno) from flow_task ft where ft.PhaseActionType is not null and ft.flowserialno in (select fo.flowserialno from flow_object fo where fo.ObjectType = 'jbo.app.BUSINESS_APPLY' and (fo.objectno = '"+APPLYSERIALNO+"'"
						+" or fo.objectno = (select AR.ObjectNo from APPLY_RELATIVE AR where AR.ApplySerialNo = '"+APPLYSERIALNO+"' and AR.objectType = 'jbo.app.BUSINESS_APPLY' AND AR.RELATIVETYPE = '06')))");
BizObject bapbiz = null;
if(TaskSerialNo != null){
	bapbiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPROVE").createQuery("O.APPLYSERIALNO = :APPLYSERIALNO and O.TaskSerialNo = :TaskSerialNo").setParameter("APPLYSERIALNO",APPLYSERIALNO).setParameter("TaskSerialNo", TaskSerialNo).getSingleResult(false);
}
String SERIALNO = "";
if(bapbiz != null){
	SERIALNO = bapbiz.getAttribute("SERIALNO").toString();//审批流水号
}
if(SERIALNO == null) SERIALNO = "";
String RPTTermID = Sqlca.getString(new SqlObject("select rpttermid from BUSINESS_APPROVE where SerialNo = :SerialNo").setParameter("SerialNo", SERIALNO));
if(RPTTermID == null) RPTTermID = "";
String loanratetermid = Sqlca.getString(new SqlObject("select loanratetermid from BUSINESS_APPROVE where SerialNo = :SerialNo").setParameter("SerialNo", SERIALNO));
if(loanratetermid == null) loanratetermid = "";
String MFCUSTOMERID = Sqlca.getString("select MFCUSTOMERID from customer_info where customerid = '"+CUSTOMERID+"'");
if(MFCUSTOMERID == null) MFCUSTOMERID =""; 
String BUSINESSTYPEID = babiz.getAttribute("BUSINESSTYPE").toString();
BizObject btbiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_TYPE").createQuery("O.TYPENO = :BUSINESSTYPEID").setParameter("BUSINESSTYPEID",BUSINESSTYPEID).getSingleResult();
String BUSINESSTYPE = "";
if(btbiz != null){
	BUSINESSTYPE = btbiz.getAttribute("TYPENAME").toString();//业务种类
}
String BUSINESSCURRENCYID = babiz.getAttribute("BUSINESSCURRENCY").toString();//币种
String BUSINESSCURRENCY = "";
if(BUSINESSCURRENCYID != null){
	BUSINESSCURRENCY = CodeCache.getItem("Currency", BUSINESSCURRENCYID).getItemName();
}
Double BUSINESSSUMD = 0.0;
if(bapbiz != null){
	BUSINESSSUMD = bapbiz.getAttribute("BUSINESSSUM").getDouble();//金额（元）
}
if(BUSINESSSUMD == null) BUSINESSSUMD = 0.0;
String BUSINESSSUM = NumberHelper.keepTwoDecimalFormat(BUSINESSSUMD);
String VOUCHTYPEID = babiz.getAttribute("VOUCHTYPE").toString();
String VOUCHTYPE = "";//主要担保方式
if(VOUCHTYPEID != null){
	VOUCHTYPE = CodeCache.getItem("VouchType", VOUCHTYPEID).getItemName();
}
BizObject clbiz = JBOFactory.getFactory().getManager("jbo.cl.CL_INFO").createQuery("O.OBJECTTYPE = 'jbo.app.BUSINESS_APPROVE' and O.OBJECTNO = :OBJECTNO").setParameter("OBJECTNO",SERIALNO).getSingleResult();
String CLBEGINDATE = "";//额度起始日期
if(clbiz != null){
	CLBEGINDATE = clbiz.getAttribute("STARTDATE").toString();
}
int TERMMONTH = babiz.getAttribute("BUSINESSTERM").getInt();//期限（月）
int TERMDATE = babiz.getAttribute("BUSINESSTERMDAY").getInt();//期限（日）
BizObject ratebiz = JBOFactory.getFactory().getManager("jbo.acct.ACCT_RATE_SEGMENT").createQuery("O.OBJECTTYPE = 'jbo.app.BUSINESS_APPROVE' and O.OBJECTNO = :OBJECTNO and O.RateType='01' and O.Status='1' and RATETERMID = :loanratetermid").setParameter("OBJECTNO",SERIALNO).setParameter("loanratetermid",loanratetermid).getSingleResult();
String RATE = "";//利率
if(ratebiz != null){
	RATE = ratebiz.getAttribute("BUSINESSRATE").toString();
}
String DRAWINGTYPEID = babiz.getAttribute("DRAWDOWNTYPE").toString();//提款方式
if(DRAWINGTYPEID == null) DRAWINGTYPEID = "";
String DRAWINGTYPE = "";
if(DRAWINGTYPEID != null){
	DRAWINGTYPE = CodeCache.getItem("DrawdownType", DRAWINGTYPEID).getItemName();
}
BizObject rptbiz = JBOFactory.getFactory().getManager("jbo.acct.ACCT_RPT_SEGMENT").createQuery("O.OBJECTTYPE = 'jbo.app.BUSINESS_APPROVE' and O.OBJECTNO = :OBJECTNO and O.Status='1' and RPTTERMID = :RPTTERMID").setParameter("OBJECTNO",SERIALNO).setParameter("RPTTERMID",RPTTermID).getSingleResult();
String tempRTN_TYPE = "";
if(rptbiz != null){
	tempRTN_TYPE = rptbiz.getAttribute("RPTTERMID").toString();
}
String RTN_TYPE = SYSNameManager.getTermName(tempRTN_TYPE);//还款方式
String DIRECTIONID = babiz.getAttribute("DIRECTION").toString();
String DIRECTION = "";
if(DIRECTIONID != null){
	DIRECTION = CodeCache.getItem("IndustryType", DIRECTIONID).getItemName();//行业投向
}
String PURPOSETYPEID = "";
String PURPOSETYPE = "";
try{
	PURPOSETYPEID = babiz.getAttribute("PURPOSETYPE").toString();//用途
	if(PURPOSETYPEID == null) PURPOSETYPEID = "";
	PURPOSETYPE = CodeCache.getItem("CreditPurposeType", PURPOSETYPEID).getItemName();
}catch(NullPointerException e){
}

String PUTOUTCLAUSE = "";
if(bapbiz != null){
	PUTOUTCLAUSE = bapbiz.getAttribute("PUTOUTCLAUSE").toString();//前提条件
}
if(PUTOUTCLAUSE == null) PUTOUTCLAUSE = "";
int CHECKFREQUENCYTEMP = 0;
if(bapbiz != null){
	CHECKFREQUENCYTEMP = bapbiz.getAttribute("CHECKFREQUENCY").getInt();//检查频率
}
String CHECKFREQUENCY = "";
CHECKFREQUENCY = CHECKFREQUENCYTEMP+ " 月/一次";

String AFTERREQUIREMENT = "";
if(bapbiz != null){
	AFTERREQUIREMENT = bapbiz.getAttribute("AFTERREQUIREMENT").toString();//贷后管理要求
}
if(AFTERREQUIREMENT == null) AFTERREQUIREMENT = "";

String PhaseNo = Sqlca.getString("select PHASENO from flow_task where taskserialno = '"+TaskSerialNo+"'");
if(PhaseNo == null)  PhaseNo = "";
String APPROVEACTIONID = "";
try{
	ASResultSet rs_ba = null;
	String PhaseNoSubstr = PhaseNo.substring(0, 9);
	if("doublereg".equals(PhaseNoSubstr)){
		rs_ba = Sqlca.getASResultSet("select ft.phaseactiontype,ft.taskserialno from flow_task ft where ft.phaseno = '"+PhaseNo+"' and ft.flowserialno in (select min(fo.flowserialno) from flow_object fo where fo.ObjectType = 'jbo.app.BUSINESS_APPLY' and fo.objectno = '"+APPLYSERIALNO+"')");
		while(rs_ba.next()){
			APPROVEACTIONID = rs_ba.getString("phaseactiontype");
			if("03".equals(APPROVEACTIONID)){
				TaskSerialNo = rs_ba.getString("taskserialno");
				break;
			}
		}
	}else{
		APPROVEACTIONID = Sqlca.getString("select PHASEACTIONTYPE from flow_task where taskserialno = '"+TaskSerialNo+"'");
	}
}catch(NullPointerException e){
	e.printStackTrace();
}catch(StringIndexOutOfBoundsException se){
	se.printStackTrace();
}

String APPROVE_RESULT = Sqlca.getString(new SqlObject("select APPROVE_RESULT from intf_rds_out_message where objectno = :ObjectNo and ObjectType = 'jbo.app.BUSINESS_APPLY' and callType = '02' and flowStatus in ('1','2')").setParameter("ObjectNo", APPLYSERIALNO));

String PHASEOPINION = "";
if("DC".equals(APPROVE_RESULT)){
	PHASEOPINION = "系统自动拒绝";
	APPROVEACTIONID = "03";
}else{
	PHASEOPINION = Sqlca.getString("select PHASEOPINION from flow_task where taskserialno = '"+TaskSerialNo+"'");//意见说明
}
if(PHASEOPINION == null) PHASEOPINION = "";
String APPROVEACTION = "";
if(APPROVEACTIONID != null){
	APPROVEACTION = CodeCache.getItem("BPMPhaseActionType", APPROVEACTIONID).getItemName();//最终审批意见
}
if(APPROVEACTION == null) APPROVEACTION = "";

List<BizObject> list = JBOFactory.getFactory().getManager("jbo.app.APPLY_RELATIVE").createQuery("O.ObjectType = 'jbo.guaranty.GUARANTY_CONTRACT' and ApplySerialNo = :ApplySerialNo").setParameter("ApplySerialNo", APPLYSERIALNO).getResultList();
String objectNo = "";
String GUARANTYTYPEID = "";
String GUARANTYTYPE = "";
Double GUARANTYVALUED = 0.0;
String GUARANTYVALUE = "";
String CONTRACTTYPEID = "";
String CONTRACTTYPE = "";
for(BizObject biz: list){
	objectNo = biz.getAttribute("ObjectNo").toString();
	BizObject gcbiz = JBOFactory.getFactory().getManager("jbo.guaranty.GUARANTY_CONTRACT").createQuery("O.SERIALNO = :SERIALNO").setParameter("SERIALNO",objectNo).getSingleResult();
	try{
		GUARANTYTYPEID = gcbiz.getAttribute("GUARANTYTYPE").toString();
		GUARANTYTYPE += CodeCache.getItem("GuarantyType", GUARANTYTYPEID).getItemName()+",";//担保方式
	}catch(NullPointerException e){
	}
	try{
		GUARANTYVALUED = gcbiz.getAttribute("GUARANTYVALUE").getDouble();//担保总金额
		if(GUARANTYVALUED == null) GUARANTYVALUED = 0.0;
		GUARANTYVALUE += NumberHelper.keepTwoDecimalFormat(GUARANTYVALUED) + "  ,";
	}catch(NullPointerException e){
	}
	try{
		CONTRACTTYPEID = gcbiz.getAttribute("CONTRACTTYPE").toString();
		CONTRACTTYPE += CodeCache.getItem("GuarantyContractType", CONTRACTTYPEID).getItemName()+",";//担保合同类型
	}catch(NullPointerException e){
	}
}
try{
	GUARANTYTYPE = GUARANTYTYPE.substring(0, GUARANTYTYPE.length()-1);
	GUARANTYVALUE = GUARANTYVALUE.substring(0, GUARANTYVALUE.length()-1);
	CONTRACTTYPE = CONTRACTTYPE.substring(0, CONTRACTTYPE.length()-1);
}catch(StringIndexOutOfBoundsException ae){
}
%>
<style>
#table td{ border-right:none; border-bottom:none;}
#table{ border-left:none; border-top:none;} 
</style>
<body>
<div align="center">
<table width="598" border="1" cellpadding="3" bordercolor = "black" cellspacing = "0" id="table">
  <tr>
    <td colspan="4"><div align="center">
      <p >&nbsp;</p>
      <p align=center style='text-align:center;line-height:150%; layout-grid-mode:char;font-size: 15px'>对
      <span lang=EN-US style='font-size:11.0pt;text-decoration: underline;'>&nbsp;<%=CUSTOMERNAME%>
      </span>&nbsp;（借款人）授信申请的审批意见</p>
      </div></td>
  </tr>
  <tr>
    <td colspan="3" align="right" width="80%">&nbsp;通知书编号：</td>
    <td >&nbsp;<%=CONTRACTSERIALNO%></td>
  </tr>
  <tr>
    <td colspan="4"><p><strong>&nbsp;(业务呈报部门)：</strong></p></td>
  </tr>
  <tr>
    <td colspan="4" style = 'border-top:none;'><div align="center">
      <p><strong>你行上报的
      <span lang=EN-US style='font-size:10.0pt; text-decoration: underline;'>&nbsp;<%=CUSTOMERNAME%>
      </span>（借款人）授信的申请资料已收悉，经审查审批，批复意见如下：</strong></p>
      </div></td>
  </tr>
  <tr>
    <td width=20%><strong>&nbsp;最终审批意见：</strong></td>
    <td colspan="3">&nbsp;<%=APPROVEACTION %></td>
  </tr>
  <tr>
    <td><strong>&nbsp;意见说明：</strong></td>
    <td colspan="3">&nbsp;<%=PHASEOPINION %></td>
  </tr>
  <%if("01".equals(APPROVEACTIONID)){ %>
  <tr>
    <td><strong>&nbsp;客户信息</strong></td>
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;客户号：</td>
    <td>&nbsp;<%=MFCUSTOMERID %></td>
    <td>&nbsp;客户名称：</td>
    <td>&nbsp;<%=CUSTOMERNAME %></td>
  </tr>
  <tr>
    <td><strong>&nbsp;业务要素</strong></td>
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;业务种类：</td>
    <td>&nbsp;<%=BUSINESSTYPE%>&nbsp;</td>
    <td>&nbsp;币种：</td>
    <td>&nbsp;<%=BUSINESSCURRENCY %></td>
  </tr>
  <tr>
    <td>&nbsp;金额（元）：</td>
    <td>&nbsp;<%=BUSINESSSUM %></td>
    <td>&nbsp;主要担保方式：</td>
    <td>&nbsp;<%=VOUCHTYPE%>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;担保详情</td>
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <td width="15%">&nbsp;担保方式：</td>
    <td width="15%">&nbsp;<%=GUARANTYTYPE %></td>
    <td>&nbsp;担保金额(元)：</td>
    <td>&nbsp;<%=GUARANTYVALUE %></td>
  </tr>
  <tr>
    <td>&nbsp;担保状态：</td>
    <td colspan="3">&nbsp;<%=CONTRACTTYPE %></td>
  </tr>
  <tr>
    <td>&nbsp;额度起始日期：</td>
    <td colspan="3">&nbsp;<%=CLBEGINDATE %></td>
  </tr>
  <tr>
    <td>&nbsp;期限（月）：</td>
    <td>&nbsp;<%=TERMMONTH%></td>
    <td>&nbsp;期限（日）：</td>
    <td>&nbsp;<%=TERMDATE%></td>
  </tr>
  <tr>
    <td>&nbsp;利率（%）：</td>
    <td colspan="3">&nbsp;<%=RATE%></td>
  </tr>
  <tr>
    <td>&nbsp;提款方式：</td>
    <td colspan="3">&nbsp;<%=DRAWINGTYPE %></td>
  </tr>
  <tr>
    <td>&nbsp;还款方式：</td>
    <td colspan="3">&nbsp;<%=RTN_TYPE %></td>
  </tr>
  <tr>
    <td>&nbsp;行业投向：</td>
    <td colspan="3">&nbsp;<%=DIRECTION %></td>
  </tr>
  <tr>
    <td>&nbsp;用途：</td>
    <td colspan="3">&nbsp;<%=PURPOSETYPE %></td>
  </tr>
  <tr>
    <td><strong>&nbsp;前提条件：</strong></td>
    <td colspan="3">&nbsp;<%=PUTOUTCLAUSE%></td>
  </tr>
  <tr>
    <td width="15%"><strong>&nbsp;管理要求</strong></td>
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <td width="15%">&nbsp;检查频率：</td>
    <td width="15%">&nbsp;<%=CHECKFREQUENCY %> </td>
    <td width="15%">&nbsp;贷后管理要求：</td>
    <td width="15%">&nbsp;<%=AFTERREQUIREMENT %></td>
  </tr>
  <%} %>
</table>
<p>&nbsp; </p>
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
