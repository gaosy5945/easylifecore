<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="com.amarsoft.app.base.util.DateHelper"%>

<%
	String CINO = DataConvert.toString(CurPage.getParameter("SerialNo"));//获取页面传过来的借据号
	String transSerialNo = DataConvert.toString(CurPage.getParameter("TransSerialNo"));//获取页面传过来的借据号
	
	if(CINO == null)    CINO = "";//6501202110082701
	String NAME = Sqlca.getString("select CUSTOMERNAME from business_duebill where serialno = '"+CINO+"'");// 申请人
	if(NAME == null)    NAME = "";
	//String LNNAME = Sqlca.getString("select typename from business_type where typeno = (select BUSINESSTYPE from business_duebill where SerialNo = '"+CINO+"')");//贷款品种	
	
	String loantype = Sqlca.getString("select loantype from business_duebill where SERIALNO = '"+CINO+"'");
	if(loantype == null)   loantype = "";
	String BUSINESSTYPE = Sqlca.getString("select typename from business_type where typeno in (select BUSINESSTYPE from business_duebill where SERIALNO = '"+CINO+"') ");
	if(BUSINESSTYPE == null)   BUSINESSTYPE = "";
	String LNNAME = loantype +"-"+ BUSINESSTYPE;
	if(LNNAME == "-")    LNNAME = "";
	String BRCODENO = Sqlca.getString("select CUSTOMERNAME from business_duebill where serialno = '"+CINO+"'");// 营业机构号
	if(BRCODENO == null)    BRCODENO = "";

	String RTNBAL="",APPNO="",TXDATE="";
	String sSql = "select atp.PREPAYPRINCIPALAMT as RTNBAL,act.SERIALNO as APPNO,act.ACCOUNTINGDATE as TXDATE from ACCT_TRANS_PAYMENT atp,ACCT_TRANSACTION act where"+
			" atp.SerialNo=act.DocumentObjectNo and act.RelativeObjectNo =:RelativeObjectNo and  act.DocumentObjectType='jbo.acct.ACCT_TRANS_PAYMENT'"+
			" and act.TRANSACTIONCODE= '0010' and act.SerialNo=:TransSerialNo";
	
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("RelativeObjectNo", CINO).setParameter("TransSerialNo", transSerialNo));
	while(rs.next()){
		RTNBAL = DataConvert.toMoney(String.valueOf(rs.getDouble("RTNBAL")));//提前归还本金
		APPNO = rs.getString("APPNO");//前台交易流水
		APPNO= APPNO.substring(2, 8)+APPNO.substring(10, 16);
		TXDATE = rs.getString("TXDATE");//交易日期
	}
	rs.getStatement().close();
	if(RTNBAL == null)    RTNBAL = "";
	if(APPNO == null)    APPNO = "";
	if(TXDATE == null)    TXDATE = "";
	String DATE = StringFunction.getToday();//打印日期
	if(DATE == null) DATE = "";
%>
<style>
*{
font-size: 15px
}
</style>
<body lang=ZH-CN style='text-justify-trim:punctuation'>

<div class=Section1 style='layout-grid:15.6pt' align="center">

<p class=MsoNormal style='margin-left:-35.9pt;text-indent:35.9pt'><span
lang=EN-US>&nbsp;</span></p>

<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0
 style='width:639px;margin-left:5.4pt;border-collapse:collapse;border:medium none' height="727">
 <tr style='height:75.9pt'>
  <td colspan=4 style='border-left:1.5pt solid windowtext; border-right:1.5pt solid windowtext; border-top:1.5pt solid windowtext; width:621px;border-bottom:1.0pt solid windowtext;background:#aaaaaa;height:69px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm' align="center">
 <b>个人贷款提前还款通知书  </b>  </td>
 </tr>
 <tr style='height:30.0pt'>
  <td colspan=4 style='width:621px;border-top:medium none;
  border-left:1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-right:1.5pt solid windowtext;height:22px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>


	<span
  lang=EN-US style="font-family: 宋体"><font style="font-size: 11pt">&nbsp;</font></span></td>
 </tr>
 <tr>
  <td colspan=4 style='width:621px;border-top:medium none;
  border-left:1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-right:1.5pt solid windowtext;height:44px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>


	<span style='font-family:宋体'>
	<font style="font-size: 11pt"></font></span></u><span style='font-family:宋体'><font style="font-size: 11pt">__________（部）会计部门：</font><span
  lang=EN-US><font style="font-size: 11pt">&nbsp;</font></span></span></td>
 </tr>
 <tr style='height:60.85pt'>
  <td colspan=4 style='width:621px;border-top:medium none;
  border-left:1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-right:1.5pt solid windowtext;height:83px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm;font-size: 15px'>
  <p class=MsoNormal style='margin-left:0.0pt'>
	<span lang=EN-US
  style='font-family:宋体'><font style="font-size: c; text-decoration:underline"><%=NAME%></font></span><span
  style='font-family:宋体'><font style="font-size: c">（申请人）的<span lang=EN-US><u><%=LNNAME%></u>提前还款申请</span></font></span></p>
	<p class=MsoNormal style='margin-left:0.0pt'>
	<span
  style='font-family:宋体'><font style="font-size: c">
	已经按我行业务审批程序报经有权审批人审批同意，请你部按照本通知书要求，办理提前还款入帐手续：</font></span></p>
  </td>
 </tr>
 <tr>
  <td colspan=4 style='width:621px;border-top:medium none;
  border-left:1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-right:1.5pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  　</td>
 </tr>
 <tr style='height:13.2pt;font-size: 15px'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:宋体'>借据号</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'>&nbsp;<%=CINO%></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: 宋体">提前归还本金</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'>&nbsp;<%=RTNBAL%></span></p>
  </td>
 </tr>
 <tr style='height:11.25pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: 宋体">前台交易流水</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'>&nbsp;<%=APPNO%></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:宋体'>交易日期</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'>&nbsp;<%=TXDATE%></span></p>
  </td>
 </tr>
 <tr style='height:178.85pt'>
  <td colspan=4 valign=top style='width:621px;border-top:medium none;
  border-left:1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-right:1.5pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-size:12.0pt;font-family:楷体_GB2312'>&nbsp;</span></p>
  </td>
 </tr>
 <tr>
  <td colspan=4 valign=top style='width:621px;border-top:medium none;
  border-left:1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-right:1.5pt solid windowtext;height:226px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal style='margin-left:9.0pt'>　</p>
	<p class=MsoNormal style='margin-left:9.0pt'>　</p>
  <p class=MsoNormal><span lang=EN-US style='font-size:14.0pt;font-family:楷体_GB2312'>&nbsp;</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US
  style='font-size:14.0pt;font-family:楷体_GB2312'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span lang=EN-US
  style='font-size:11pt;font-family:楷体_GB2312'>&nbsp;&nbsp;</span><span
  lang=EN-US style='font-size:11pt;font-family:宋体'>&nbsp;</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'>
	<span style='font-family:宋体'>经办人签字：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>
	<span lang=EN-US
  style='font-size:11pt;font-family:宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span><!--span style='font-size:11pt;font-family:宋体'>审批人员签字：</span--></p>
  <p class=MsoNormal style='margin-left:9.0pt'>
	<span lang=EN-US
  style='font-size:11pt;font-family:宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;</span></p>
	<p class=MsoNormal style='margin-left:9.0pt'>　</p>
	<p class=MsoNormal style='margin-left:9.0pt'>　</p>
	<p class=MsoNormal style='margin-left:9.0pt'>　</p>
	<p class=MsoNormal style='margin-left:9.0pt'><span lang="en-us">
	<font style="font-size: 11pt"><span style="font-family: 宋体">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	</span></font></span><span
  style='font-size:11pt;font-family:宋体'>日期：<%="".equals(DATE)?"&nbsp;&nbsp;1111&nbsp;":DATE%></span></p>
  </td>
 </tr>
 <tr style='height:38.1pt'>
  <td colspan=4 style='border-left:1.5pt solid windowtext; border-right:1.5pt solid windowtext; border-bottom:1.5pt solid windowtext; width:621px;border-top:medium none;height:107px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-size:10.0pt;font-family:宋体;color:black'>（此通知书共三联，交客户经理、会计和文档管理员各一份）</span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal><span lang=EN-US style='font-size:12.0pt;font-family:楷体_GB2312'>&nbsp;</span></p>

</div>

</body>

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