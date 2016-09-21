<%@ page contentType="text/html; charset=GBK"%><%@ include file="/Frame/resources/include/include_begin.jspf"%><%		String serialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));	String APPNO = "";	if(serialNo == null){		serialNo = "";	}else{	    APPNO = serialNo.substring(2, 8)+serialNo.substring(10, 16);	}	String TXDATE = Sqlca.getString(new SqlObject("select AccountingDate from ACCT_TRANSACTION where SerialNo = :SerialNo").setParameter("SerialNo", serialNo));	if(TXDATE == null)     TXDATE = "";	String CINO = Sqlca.getString(new SqlObject("select RELATIVEOBJECTNO from ACCT_TRANSACTION where SerialNo = :SerialNo").setParameter("SerialNo", serialNo));	if(CINO == null)     CINO = "";//6501202110082701	//机构号	BizObject bdbiz = JBOFactory.getFactory()			.getManager("jbo.app.BUSINESS_DUEBILL")			.createQuery("O.serialNo = :CINO")			.setParameter("CINO", CINO).getSingleResult();		String ORGID = bdbiz.getAttribute("OPERATEORGID").toString();//机构	if(ORGID == null)     ORGID = "";	String NAME = bdbiz.getAttribute("CUSTOMERNAME").toString(); //申请人	if(NAME == null)     NAME = "";	String LNNAME = Sqlca.getString("select typename from business_type where typeno = (select BUSINESSTYPE from business_duebill where SerialNo = '"+CINO+"')");//贷款名	if(LNNAME == null)     LNNAME = "";	String SPECIALLOANCARDNO = Sqlca.getString("select ACCOUNTNO from ACCT_BUSINESS_ACCOUNT where objecttype = 'jbo.app.BUSINESS_DUEBILL' and objectno = '"+CINO+"' and ACCOUNTINDICATOR = '04'");//贷款专户卡卡号	if(SPECIALLOANCARDNO == null)     SPECIALLOANCARDNO = "";	/* String APPNO = bdbiz.getAttribute("CONTRACTSERIALNO").toString();//审核业务编号	if(APPNO == null)     APPNO = ""; */	/* String TXDATE = bdbiz.getAttribute("INPUTDATE").toString(); //审核日期 	*/	String DATE = StringFunction.getToday();//日期	if(DATE == null)     DATE = "";%>
<style>*{font-size: 15px}</style>
<body lang=ZH-CN style='text-justify-trim:punctuation'>

<div class=Section1 style='layout-grid:15.6pt' align="center">

<p class=MsoNormal style='margin-left:-35.9pt;text-indent:35.9pt'><span
lang=EN-US>&nbsp;</span></p>

<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0
 style='width:639px;margin-left:5.4pt;border-collapse:collapse;border:medium none' height="727">
 <tr style='height:75.9pt'>
  <td colspan=4 style='border-left:1.5pt solid windowtext; border-right:1.5pt solid windowtext; border-top:1.5pt solid windowtext; width:621px;border-bottom:1.0pt solid windowtext;background:#aaaaaa;height:69px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm' align="center">
 <b>专户资金一次性转备用金通知书  </b>  </td>
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
  border-right:1.5pt solid windowtext;height:83px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal style='margin-left:0.0pt'>
	<span lang=EN-US
  style='font-family:宋体'><font style="font-size: c; text-decoration:underline"><%=NAME%></font></span><span
  style='font-family:宋体'><font style="font-size: c">（申请人）的<span lang=EN-US><%=LNNAME%></u>专户资金一次性转备用金</span></font></span></p>
	<p class=MsoNormal style='margin-left:0.0pt'>
	<span
  style='font-family:宋体'><font style="font-size: c">
	已经按我行业务审批程序报经有权审批人审批同意，请你部按照本通知书要求，办理专户资金一次性转备用金手续：</font></span></p>
  </td>
 </tr>
 <tr>
  <td colspan=4 style='width:621px;border-top:medium none;
  border-left:1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-right:1.5pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  　</td>
 </tr>
 <tr style='height:13.2pt'>
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
  <p class=MsoNormal><span style="font-family: 宋体">贷款专户卡卡号</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'>&nbsp;<%=SPECIALLOANCARDNO%></span></p>
  </td>
 </tr>
 <tr style='height:11.25pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: 宋体">审核业务编号</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'>&nbsp;<%=APPNO%></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:宋体'>审核日期</span></p>
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
  <p class=MsoNormal style='margin-left:9.0pt'>
	<span style='font-family:宋体'>是否须对转出资金办理该笔贷款的部分或全部提前还款操作： □是； □否。&nbsp; </span></p>
  <p class=MsoNormal><span lang=EN-US style='font-size:14.0pt;font-family:楷体_GB2312'>&nbsp;</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US
  style='font-size:14.0pt;font-family:楷体_GB2312'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span lang=EN-US
  style='font-size:11pt;font-family:楷体_GB2312'>&nbsp;&nbsp;</span><span
  lang=EN-US style='font-size:11pt;font-family:宋体'>&nbsp;</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'>
	<span style='font-family:宋体'>经办客户经理签字：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>
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
  style='font-size:11pt;font-family:宋体'>日期：<%=DATE%></span></p>
  </td>
 </tr>
 <tr style='height:38.1pt'>
  <td colspan=4 style='border-left:1.5pt solid windowtext; border-right:1.5pt solid windowtext; border-bottom:1.5pt solid windowtext; width:621px;border-top:medium none;height:107px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-size:10.0pt;font-family:宋体;color:black'>（通知书一式两份，运营部门、业务部门各保存一份）</span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal><span lang=EN-US style='font-size:12.0pt;font-family:楷体_GB2312'>&nbsp;</span></p>

</div>
<table align="center">	<tr>			<td id="print"><%=HTMLControls.generateButton("打印", "打印", "printPaper()", "") %></td>	</tr></table></body><script>   function printPaper(){	   var print = document.getElementById("print");	   if(window.confirm("是否确定要打印？")){		   //打印	  		   print.style.display = "none";		   window.print();			   window.close();	   }   }</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>