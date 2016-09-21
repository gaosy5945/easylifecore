<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="com.amarsoft.app.als.common.util.DateHelper"%>
<%

//交易流水
String transSerialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));

BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();

BusinessObject transaction = bom.loadBusinessObject("jbo.acct.ACCT_TRANSACTION", transSerialNo);

BusinessObject bcChange = bom.loadBusinessObject(transaction.getString("DocumentObjectType"),transaction.getString("DocumentObjectNo"));

BusinessObject bc = bom.loadBusinessObject(transaction.getString("RelativeObjectType"),transaction.getString("RelativeObjectNo"));
//合同流水号
String contractserialNo = bc.getObjectNo();
//客戶號
String custno = bc.getString("CustomerID");
String MFCUSTNO = Sqlca.getString("select mfcustomerid from customer_info where customerid = '"+custno+"'");
if(MFCUSTNO == null) MFCUSTNO = "";
//客戶名稱
String custname = bc.getString("CustomerName");
String brcode = bc.getString("OperateOrgID");
String contractno = contractserialNo;
String cardno = Sqlca.getString("select accountno from ACCT_BUSINESS_ACCOUNT where objecttype='jbo.app.BUSINESS_CONTRACT' and objectno = '"+contractserialNo+"'");
if(cardno == null)  cardno = "";
//关联合同号
String COCONTRACTNO = Sqlca.getString("select ObjectNo from CONTRACT_RELATIVE where objecttype='jbo.app.BUSINESS_CONTRACT' and ContractSerialNo = '"+contractserialNo+"' "); 
if(COCONTRACTNO == null)  COCONTRACTNO = "";
//消贷易备用金账号
String RTNACTNO =  "";
//原消贷易额度到期日
String OLD_TEDATE = bcChange.getString("OLDCLMATURITYDATE"); 
if(OLD_TEDATE == null)  OLD_TEDATE = "";
//額度到期日期
String TEDATE = bcChange.getString("CLMATURITYDATE"); 
if(TEDATE == null)  TEDATE = "";
String TXDATE = StringFunction.getToday();//打印時間
%> 
<style>
	inline_button { height:20px; };
    *{font-size: 15px;}
</style>

<body lang=ZH-CN style='tab-interval:21.0pt;text-justify-trim:punctuation'>

<div class=Section1 style='layout-grid:15.6pt' align="center">

<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=636
 style='width:477.0pt;margin-left:5.4pt;border-collapse:collapse;mso-padding-alt:
 0cm 0cm 0cm 0cm'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;height:51.9pt'>
  <td width=636 colspan=4 style='width:477.0pt;border:solid windowtext 1.0pt;
  background:#A0A0A0;padding:0cm 5.4pt 0cm 5.4pt;height:51.9pt'>
  <p class=MsoNormal align=center style='text-align:center;mso-pagination:widow-orphan;
  tab-stops:440.1pt'><b><span style='font-size:12.0pt;font-family:宋体;
  mso-font-kerning:0pt'>消贷易额度到期日变更通知书</span></b><b><span lang=EN-US
  style='font-size:12.0pt;mso-font-kerning:0pt'><o:p></o:p></span></b></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1;height:29.85pt'>
  <td width=636 colspan=4 style='width:477.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:29.85pt'> 
  <p class=MsoNormal style='mso-pagination:widow-orphan'><u><span lang=EN-US
  style='font-size:11.0pt;font-family:宋体;mso-font-kerning:0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></u><span
  style='font-size:11.0pt;font-family:宋体;mso-font-kerning:0pt'>（部）会计部门<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2;height:74.5pt'>
  <td width=636 colspan=4 style='width:477.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:74.5pt'>
  <p class=MsoNormal style='line-height:150%;mso-pagination:widow-orphan'><u><span
  lang=EN-US style='mso-bidi-font-size:10.5pt;line-height:150%;font-family:
  宋体;mso-font-kerning:0pt'>&nbsp;&nbsp;&nbsp;&nbsp;<%=custname %>&nbsp;&nbsp;&nbsp;&nbsp;
  </span></u><span style='mso-bidi-font-size:10.5pt;line-height:150%;
  font-family:宋体;mso-font-kerning:0pt'>（申请人）的消贷易额度到期日变更业务，已经按我行业务审批程序报经有权审批人审批同意，并通过放款监督审核，请你部按照本通知书要求，办理消贷易额度到期日变更开通交易。<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3'>
  <td width=636 colspan=4 valign=top style='width:477.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;height:1.0cm;mso-height-rule:exactly'>
  <td width=127 style='width:95.2pt;border:solid windowtext 1.0pt;border-top:
  none;padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'>客户号<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=185 style='width:138.8pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'><%=MFCUSTNO%><o:p></o:p></span></p>
  </td>
  <td width=132 style='width:99.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'>客户姓名<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=192 style='width:144.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:宋体'><%=custname %></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
 </tr>
   <tr style='mso-yfti-irow:4;height:1.0cm;mso-height-rule:exactly'>
  <td width=127 style='width:95.2pt;border:solid windowtext 1.0pt;border-top:
  none;padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'>机构号<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=185 style='width:138.8pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'><%=brcode %><o:p></o:p></span></p>
  </td>
  <td width=132 style='width:99.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'><span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=192 style='width:144.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:宋体'></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
 </tr>
  <tr style='mso-yfti-irow:6;height:1.0cm;mso-height-rule:exactly'>
  <td width=127 style='width:95.2pt;border:solid windowtext 1.0pt;border-top:
  none;padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'>消贷易授信合同号<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=185 style='width:138.8pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'><%=contractno %></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=132 style='width:99.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'>关联合同号<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=192 style='width:144.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'><%=COCONTRACTNO %></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;height:1.0cm;mso-height-rule:exactly'>
  <td width=127 style='width:95.2pt;border:solid windowtext 1.0pt;border-top:
  none;padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'>消贷易卡号<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=185 style='width:138.8pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'><%=cardno %></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=132 style='width:99.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'>消贷易备用金账号<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=192 style='width:144.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'><%=RTNACTNO %></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:7;height:1.0cm;mso-height-rule:exactly'>
  <td width=127 style='width:95.2pt;border:solid windowtext 1.0pt;border-top:
  none;padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'>原消贷易额度到期日<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=185 style='width:138.8pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:宋体'><%=OLD_TEDATE %></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=132 style='width:99.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'>新消贷易额度到期日<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=192 style='width:144.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:宋体'><%=TEDATE %></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:9;height:17.0pt'>
  <td width=636 colspan=4 valign=top style='width:477.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:17.0pt'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:10;height:112.9pt'>
  <td width=636 colspan=4 valign=top style='width:477.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:112.9pt'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='font-size:12.0pt;font-family:宋体;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='font-size:12.0pt;font-family:宋体;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'>放款监督人签字：<span
  lang=EN-US><o:p></o:p></span></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span><span style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:
  0pt'>放款专用章：<span lang=EN-US><o:p></o:p></span></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='font-size:12.0pt;font-family:宋体;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='font-size:12.0pt;font-family:宋体;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='font-size:12.0pt;font-family:宋体;mso-font-kerning:0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span
  style='font-size:11.0pt;font-family:宋体;mso-font-kerning:0pt'>日期：</span><span
  lang=EN-US style='font-size:11.0pt;font-family:宋体'><%=TXDATE %></span><span
  lang=EN-US style='font-size:11.0pt;font-family:宋体;mso-font-kerning:0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:11;mso-yfti-lastrow:yes;height:31.35pt'>
  <td width=636 colspan=4 style='width:477.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:31.35pt'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='font-size:11.0pt;font-family:宋体;mso-font-kerning:0pt'>（此通知书共三联，交客户经理、会计和文档管理员各一份）<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
</table>


<p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p>


	</div>

<table align="center">
	<tr>	
		<td id="print"><%=HTMLControls.generateButton("打印", "打印", "printPaper()", "") %></td>
	</tr>
</table>

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

</body>
<%@ include file="/Frame/resources/include/include_end.jspf"%>