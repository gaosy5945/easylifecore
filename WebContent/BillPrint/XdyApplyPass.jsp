<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="com.amarsoft.app.als.common.util.DateHelper"%>
<%
//传入的参数如果是合同流水号
String contractserialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));
if(contractserialNo == null) contractserialNo = "";//11712012300100111101
//还款方式
String RPTTermID = Sqlca.getString(new SqlObject("select rpttermid from BUSINESS_CONTRACT where SerialNo = :SerialNo").setParameter("SerialNo", contractserialNo));
if(RPTTermID == null) RPTTermID = "";
String loanratetermid = Sqlca.getString(new SqlObject("select loanratetermid from BUSINESS_CONTRACT where SerialNo = :SerialNo").setParameter("SerialNo", contractserialNo));
if(loanratetermid == null) loanratetermid = "";
//额度流水号
String CINO = Sqlca.getString("select serialno from cl_info where objecttype= 'jbo.app.BUSINESS_CONTRACT' and objectno='"+contractserialNo+"'");
if(CINO == null) CINO = "";
//客戶號
String CUSTNO = Sqlca.getString("select customerid from business_contract where serialno = '"+contractserialNo+"'");
if(CUSTNO == null) CUSTNO = "";
String MFCUSTNO = Sqlca.getString("select mfcustomerid from customer_info where customerid = '"+CUSTNO+"'");
if(MFCUSTNO == null) MFCUSTNO = "";
String CUSTNM = Sqlca.getString("select customername from business_contract where serialno = '"+contractserialNo+"'"); //客戶名稱
if(CUSTNM == null) CUSTNM = "";
String BRCODE = Sqlca.getString("select OPERATEORGID from business_contract where serialno = '"+contractserialNo+"'"); //机构号 
if(BRCODE == null) BRCODE = "";
String CONTRACTNO = Sqlca.getString("select CONTRACTARTIFICIALNO from business_contract where serialno = '"+contractserialNo+"'"); //授信合同号
if(CONTRACTNO == null) CONTRACTNO = "";
String CARDNO = Sqlca.getString("select accountno from ACCT_BUSINESS_ACCOUNT where objecttype='jbo.app.BUSINESS_CONTRACT' and objectno = '"+contractserialNo+"'"); //消贷易卡号
if(CARDNO == null) CARDNO = "";
//关联合同号
String COCONTRACTNO = Sqlca.getString("select CONTRACTARTIFICIALNO from business_contract where serialno =(select objectno from cl_info where serialno = (select parentserialno from cl_info where serialno = '"+CINO+"'))"); 
if(COCONTRACTNO == null) COCONTRACTNO = "";
//消贷易备用金账号
String RTNACTNO = "";
//消贷易授信额度
String TOTBAL = DataConvert.toMoney(Sqlca.getString("select BUSINESSAPPAMT from cl_info where serialno ='"+CINO+"'")); 
if(TOTBAL == null) TOTBAL = "";
String TEDATE = Sqlca.getString("select MATURITYDATE from cl_info where serialno = '"+CINO+"'");
if(TEDATE == null) TEDATE = "";
String AVBAL = DataConvert.toMoney(Sqlca.getString("select nvl(BUSINESSAVABALANCE,BUSINESSAPPAMT) from cl_info where serialno ='"+CINO+"'")); //可用额度
if(AVBAL == null) AVBAL = "";
String FREEZEAMT = DataConvert.toMoney(Sqlca.getString("select nvl(BUSINESSAPPAMT,0) from cl_info where objecttype= 'jbo.app.BUSINESS_CONTRACT' and CLType='0102' and status = '40' and objectno='"+contractserialNo+"'")); //冻结额度
if(FREEZEAMT == null || "".equals(FREEZEAMT)) FREEZEAMT = "0.00";
//消贷易占用额度
String LNAMT = DataConvert.toMoney(Sqlca.getString("select nvl(BALANCE,0) from BUSINESS_CONTRACT where SERIALNO='"+contractserialNo+"'")); 
if(LNAMT == null  ) LNAMT = "0.00" ;

String CASHAMT = LNAMT;//消费暂用额度

String DISPOSE_FLG = Sqlca.getString("select itemname from code_library where codeno = 'CLLoanGenerateType' and itemno in (select LOANGENERATETYPE from cl_info where serialno ='"+CINO+"')"); //贷款生成处理方式
if(DISPOSE_FLG == null) DISPOSE_FLG = "";
int businessTerm=Integer.parseInt(Sqlca.getString("select CLTerm from cl_info where serialno = '"+CINO+"'")) ;
int businessTermDay=Integer.parseInt(Sqlca.getString("select CLTERMDAY from cl_info where serialno = '"+CINO+"'")) ;
String CON_TERM = (businessTerm/12 < 10 ? "0"+String.valueOf(businessTerm/12) : String.valueOf(businessTerm/12))//消贷易贷款期限
+ (businessTerm%12 < 10 ? "0"+String.valueOf(businessTerm%12) : String.valueOf(businessTerm%12))
+ (businessTermDay < 10 ? "0"+String.valueOf(businessTermDay) : String.valueOf(businessTermDay))
;
//还款流水号
String replySerialNo = Sqlca.getString("select serialno from acct_rpt_segment where objecttype='jbo.app.BUSINESS_CONTRACT' and objectno='"+contractserialNo+"' and RPTTermID = '"+RPTTermID+"'");
if(replySerialNo == null) replySerialNo = "";
String RTN_TYPE = Sqlca.getString("select componentname from PRD_COMPONENT_LIBRARY where componenttype like 'PRD0301%' and status='1' and componentid in (select RPTTERMID from acct_rpt_segment where serialno = '"+replySerialNo+"')"); //偿还方式
if(RTN_TYPE == null) RTN_TYPE = "";
String RTN_INTERVAL = Sqlca.getString("select getitemname('PaymentFrequencyType',PAYMENTFREQUENCYTYPE) from acct_rpt_segment where serialNo='"+replySerialNo+"'"); //还款间隔
if(RTN_INTERVAL == null) RTN_INTERVAL = "";
//还款日确定方式   DefaultDueDayType
String RTN_DATE_TYPE = Sqlca.getString("select getitemname('DefaultDueDayType',DefaultDueDayType) from acct_rpt_segment where serialNo='"+replySerialNo+"'"); // 0－借款日为还款日 1－指定还款日期
if(RTN_DATE_TYPE == null) RTN_DATE_TYPE = "";
String RTN_DATE = Sqlca.getString("select DEFAULTDUEDAY from acct_rpt_segment where serialNo='"+replySerialNo+"'");//还款日
if(RTN_DATE == null) RTN_DATE = "";
if(RTN_DATE_TYPE == "" && RTN_DATE != "" && RTN_DATE != "0"){
	RTN_DATE_TYPE = "指定还款日期";
}
//利率编号
String rateSerialNo = Sqlca.getString("select serialno from acct_rate_segment where objecttype='jbo.app.BUSINESS_CONTRACT' and ratetype='01' and objectno='"+contractserialNo+"' and RATETERMID = '"+loanratetermid+"'"); 
if(rateSerialNo == null) rateSerialNo = "";
String INTRATE_ADJ = Sqlca.getString("select getitemname('RepriceType',repricetype) from acct_rate_segment where serialno  ='"+rateSerialNo+"'"); //利率调整方式
if(INTRATE_ADJ == null) INTRATE_ADJ = "";
String INT_YEAR_ADJ_DATE = Sqlca.getString("select REPRICEDATE from acct_rate_segment where serialno  ='"+rateSerialNo+"'"); //利率调整日期
if(INT_YEAR_ADJ_DATE == null) INT_YEAR_ADJ_DATE = "";
String FLTINTRATE = Sqlca.getString("select RATEFLOAT from acct_rate_segment where serialno  ='"+rateSerialNo+"'");
if(FLTINTRATE == null) FLTINTRATE = "";
//罚息利率流水号
String prateSerialNo = Sqlca.getString("select serialno from acct_rate_segment where objecttype='jbo.app.BUSINESS_CONTRACT' and ratetype='02' and objectno='"+contractserialNo+"'");
if(prateSerialNo == null) prateSerialNo = "";
String PFLTINTRATE_OPT = Sqlca.getString("select getitemname('RateMode',RATEMODE) from acct_rate_segment where serialno  ='"+prateSerialNo+"'"); //罚息浮动选项
if(PFLTINTRATE_OPT == null) PFLTINTRATE_OPT = "";
String PFLTINTRATE = Sqlca.getString("select RATEFLOAT from acct_rate_segment where serialno  ='"+prateSerialNo+"'");
if(PFLTINTRATE == null) PFLTINTRATE = "";
String MGRNM = Sqlca.getString("select OPERATEUSERID from business_contract where serialno = '"+contractserialNo+"'");// 客户经理
if(MGRNM == null) MGRNM = "";
//打印时间
SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy-MM-dd HH:mm");
String TXDATE = sdfTemp.format(new Date());
if(TXDATE == null) TXDATE = "";
%>

<head>

<title>消贷易额度及生成贷款规则信息表</title>

<script language="javascript">
	function domReady() {

		//消贷易转账时隐藏贷款生成处理方式

		var rzyType = "@RZY_TYPE";

		if (rzyType == "2") {

			document.getElementById('loanGenTr').style.display = "none";

		}

	}
</script>

<style>
<!-- /* Font Definitions */
@font-face {
	font-family: 宋体;
	panose-1: 2 1 6 0 3 1 1 1 1 1;
	mso-font-alt: SimSun;
	mso-font-charset: 134;
	mso-generic-font-family: auto;
	mso-font-pitch: variable;
	mso-font-signature: 3 135135232 16 0 262145 0;
}

@font-face {
	font-family: "Cambria Math";
	panose-1: 2 4 5 3 5 4 6 3 2 4;
	mso-font-charset: 1;
	mso-generic-font-family: roman;
	mso-font-format: other;
	mso-font-pitch: variable;
	mso-font-signature: 0 0 0 0 0 0;
}

@font-face {
	font-family: Calibri;
	panose-1: 2 15 5 2 2 2 4 3 2 4;
	mso-font-charset: 0;
	mso-generic-font-family: swiss;
	mso-font-pitch: variable;
	mso-font-signature: -1610611985 1073750139 0 0 159 0;
}

@font-face {
	font-family: 楷体_GB2312;
	panose-1: 2 1 6 9 3 1 1 1 1 1;
	mso-font-charset: 134;
	mso-generic-font-family: modern;
	mso-font-pitch: fixed;
	mso-font-signature: 1 135135232 16 0 262144 0;
}

@font-face {
	font-family: "\@宋体";
	panose-1: 2 1 6 0 3 1 1 1 1 1;
	mso-font-charset: 134;
	mso-generic-font-family: auto;
	mso-font-pitch: variable;
	mso-font-signature: 3 135135232 16 0 262145 0;
}

@font-face {
	font-family: "\@楷体_GB2312";
	panose-1: 2 1 6 9 3 1 1 1 1 1;
	mso-font-charset: 134;
	mso-generic-font-family: modern;
	mso-font-pitch: fixed;
	mso-font-signature: 1 135135232 16 0 262144 0;
}

/* Style Definitions */
p.MsoNormal,li.MsoNormal,div.MsoNormal {
	mso-style-unhide: no;
	mso-style-qformat: yes;
	mso-style-parent: "";
	margin: 0cm;
	margin-bottom: .0001pt;
	text-align: justify;
	text-justify: inter-ideograph;
	mso-pagination: widow-orphan;
	font-size: 10.5pt;
	font-family: "Times New Roman", "serif";
	mso-fareast-font-family: 宋体;
}

p.MsoHeader,li.MsoHeader,div.MsoHeader {
	mso-style-unhide: no;
	mso-style-link: "页眉 Char";
	margin: 0cm;
	margin-bottom: .0001pt;
	text-align: center;
	mso-pagination: widow-orphan;
	tab-stops: center 207.65pt right 415.3pt;
	layout-grid-mode: char;
	border: none;
	mso-border-bottom-alt: solid windowtext .75pt;
	padding: 0cm;
	mso-padding-alt: 0cm 0cm 1.0pt 0cm;
	font-size: 9.0pt;
	font-family: "Times New Roman", "serif";
	mso-fareast-font-family: 宋体;
}

p.MsoFooter,li.MsoFooter,div.MsoFooter {
	mso-style-unhide: no;
	mso-style-link: "页脚 Char";
	margin: 0cm;
	margin-bottom: .0001pt;
	mso-pagination: widow-orphan;
	tab-stops: center 207.65pt right 415.3pt;
	layout-grid-mode: char;
	font-size: 9.0pt;
	font-family: "Times New Roman", "serif";
	mso-fareast-font-family: 宋体;
}

span.MsoCommentReference {
	mso-style-unhide: no;
	color: fuchsia;
}

span.sodafield {
	mso-style-name: sodafield;
	mso-style-unhide: no;
	color: blue;
}

span.msonormal0 {
	mso-style-name: msonormal;
	mso-style-unhide: no;
}

span.Char {
	mso-style-name: "页眉 Char";
	mso-style-unhide: no;
	mso-style-locked: yes;
	mso-style-link: 页眉;
	mso-ansi-font-size: 9.0pt;
	mso-bidi-font-size: 9.0pt;
	font-family: 宋体;
	mso-fareast-font-family: 宋体;
}

span.Char0 {
	mso-style-name: "页脚 Char";
	mso-style-unhide: no;
	mso-style-locked: yes;
	mso-style-link: 页脚;
	mso-ansi-font-size: 9.0pt;
	mso-bidi-font-size: 9.0pt;
	font-family: 宋体;
	mso-fareast-font-family: 宋体;
}

.MsoChpDefault {
	mso-style-type: export-only;
	mso-default-props: yes;
	font-size: 10.0pt;
	mso-ansi-font-size: 10.0pt;
	mso-bidi-font-size: 10.0pt;
	mso-ascii-font-family: "Times New Roman";
	mso-hansi-font-family: "Times New Roman";
	mso-font-kerning: 0pt;
}

/* Page Definitions */
@page {
	mso-footnote-separator: url("RzyApplyPass.files/header.htm") fs;
	mso-footnote-continuation-separator:
		url("RzyApplyPass.files/header.htm") fcs;
	mso-endnote-separator: url("RzyApplyPass.files/header.htm") es;
	mso-endnote-continuation-separator: url("RzyApplyPass.files/header.htm")
		ecs;
}

@page Section1 {
	size: 595.3pt 841.9pt;
	margin: 72.0pt 90.0pt 72.0pt 81.0pt;
	mso-header-margin: 42.55pt;
	mso-footer-margin: 49.6pt;
	mso-paper-source: 0;
	layout-grid: 15.6pt;
}

div.Section1 {
	page: Section1;
}
-->
</style>


<meta http-equiv=expires content=-1>


</head>



<body lang=ZH-CN style='tab-interval:21.0pt;text-justify-trim:punctuation'>



<div class=Section1 style='layout-grid:15.6pt' align="center">



<p class=MsoNormal style='margin-left:-35.9pt;text-indent:35.9pt'><span

lang=EN-US>&nbsp;<o:p></o:p></span></p>



<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=639

 style='width:479.25pt;margin-left:5.4pt;border-collapse:collapse;mso-yfti-tbllook:

 1184;mso-padding-alt:0cm 0cm 0cm 0cm' height=727>

 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;height:51.75pt'>

  <td width=633 colspan=4 style='width:474.45pt;border:solid windowtext 1.5pt;

  border-bottom:solid windowtext 1.0pt;background:#AAAAAA;padding:0cm 5.4pt 0cm 5.4pt;

  height:51.75pt'>

  <p class=MsoNormal align=center style='text-align:center'><b><span

  style='font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体'>消贷易额度及生成贷款规则信息表</span></b><span

  lang=EN-US style='font-family:"Calibri","sans-serif";mso-bidi-font-family:

  宋体'><o:p></o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:1;height:62.25pt'>

  <td width=633 colspan=4 style='width:474.45pt;border-top:none;border-left:

  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:

  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:62.25pt'>

  <p class=MsoNormal><span style='font-size:12.0pt;font-family:宋体;mso-bidi-font-family:

  宋体;color:black'>客户号为</span><u><span lang=EN-US style='font-size:12.0pt;

  font-family:"Calibri","sans-serif";mso-bidi-font-family:宋体;color:black'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span

  style='mso-spacerun:yes'>&nbsp; </span><%=MFCUSTNO%><span

  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>&nbsp;&nbsp;</span></u><span

  style='font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black'>的</span><u><span

  lang=EN-US style='font-size:12.0pt;font-family:"Calibri","sans-serif";

  mso-bidi-font-family:宋体;color:black'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></u><u><span

  lang=EN-US style='font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;

  color:black'><span

  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

  </span><%=CUSTNM%><span

  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

  </span></span></u><u><span lang=EN-US style='font-size:12.0pt;font-family:

  "Calibri","sans-serif";mso-bidi-font-family:宋体;color:black'>&nbsp; </span></u><span

  style='font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black'>客户名下卡号为</span><u><span

  lang=EN-US style='font-size:12.0pt;font-family:"Calibri","sans-serif";

  mso-bidi-font-family:宋体;color:black'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span

  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

  </span><%=CARDNO%><span

  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

  </span>&nbsp;<span style='mso-spacerun:yes'>&nbsp; </span></span></u><span

  style='font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black'>的当前消贷易额度及生成消贷易贷款规则等信息如下：</span><span

  class=msonormal0><span lang=EN-US style='font-family:"Calibri","sans-serif";

  mso-bidi-font-family:宋体;color:black'><o:p></o:p></span></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:2;height:15.0pt'>

  <td width=633 colspan=4 style='width:474.45pt;border-top:none;border-left:

  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:

  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span style='font-size:

  12.0pt;font-family:宋体;mso-bidi-font-family:宋体'>　<span lang=EN-US><o:p></o:p></span></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:3;height:15.0pt'>

  <td width=148 style='width:110.85pt;border-top:none;border-left:solid windowtext 1.5pt;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>客户号</span></p>

  </td>

  <td width=135 style='width:100.9pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=MFCUSTNO%></span></p>

  </td>

  <td width=153 style='width:115.1pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>客户姓名</span></p>

  </td>

  <td width=197 style='width:147.6pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=CUSTNM%></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:4;height:15.0pt'>

  <td width=148 style='width:110.85pt;border-top:none;border-left:solid windowtext 1.5pt;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>机构号</span></p>

  </td>

  <td width=135 style='width:100.9pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=BRCODE%></span></p>

  </td>

  <td width=153 style='width:115.1pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-size:10.0pt;mso-fareast-font-family:

  "Times New Roman"'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td width=197 style='width:147.6pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-size:10.0pt;mso-fareast-font-family:

  "Times New Roman"'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:5;height:15.0pt'>

  <td width=148 style='width:110.85pt;border-top:none;border-left:solid windowtext 1.5pt;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>消贷易合同号</span></p>

  </td>

  <td width=135 style='width:100.9pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=CONTRACTNO%></span></p>

  </td>

  <td width=153 style='width:115.1pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>关联合同号</span></p>

  </td>

  <td width=197 style='width:147.6pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=COCONTRACTNO%></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:6;height:15.0pt'>

  <td width=148 style='width:110.85pt;border-top:none;border-left:solid windowtext 1.5pt;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>消贷易卡号</span></p>

  </td>

  <td width=135 style='width:100.9pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=CARDNO%></span></p>

  </td>

  <td width=153 style='width:115.1pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>消贷易备用金账号</span></p>

  </td>

  <td width=197 style='width:147.6pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=RTNACTNO%></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:7;height:15.0pt'>

  <td width=148 style='width:110.85pt;border-top:none;border-left:solid windowtext 1.5pt;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>消贷易授信额度</span></p>

  </td>

  <td width=135 style='width:100.9pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:宋体'>&yen;</span><span

  lang=EN-US style='font-family:楷体_GB2312'><%=TOTBAL%></span></p>

  </td>

  <td width=153 style='width:115.1pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>消贷易额度到期日</span></p>

  </td>

  <td width=197 style='width:147.6pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=TEDATE%></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:8;height:15.0pt'>

  <td width=148 style='width:110.85pt;border-top:none;border-left:solid windowtext 1.5pt;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>可用额度</span><span lang=EN-US

  style='font-family:"Calibri","sans-serif";mso-bidi-font-family:宋体'><o:p></o:p></span></p>

  </td>

  <td width=135 style='width:100.9pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:宋体'>&yen;</span><span

  lang=EN-US style='font-family:楷体_GB2312'><%=AVBAL%></span><span lang=EN-US

  style='font-family:宋体'><o:p></o:p></span></p>

  </td>

  <td width=153 style='width:115.1pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>冻结额度<span lang=EN-US><o:p></o:p></span></span></p>

  </td>

  <td width=197 style='width:147.6pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:宋体'>&yen;</span><span

  lang=EN-US style='font-family:楷体_GB2312'><%=FREEZEAMT%></span><span lang=EN-US

  style='font-family:宋体'><o:p></o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:9;height:15.0pt'>

  <td width=148 style='width:110.85pt;border-top:none;border-left:solid windowtext 1.5pt;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>消费占用额度</span><span

  lang=EN-US style='font-family:"Calibri","sans-serif";mso-bidi-font-family:

  宋体'><o:p></o:p></span></p>

  </td>

  <td width=135 style='width:100.9pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:宋体'>&yen;</span><span

  lang=EN-US style='font-family:楷体_GB2312'><%=CASHAMT%></span><span lang=EN-US

  style='font-family:宋体'><o:p></o:p></span></p>

  </td>

  <td width=153 style='width:115.1pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>贷款占用额度<span lang=EN-US><o:p></o:p></span></span></p>

  </td>

  <td width=197 style='width:147.6pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:宋体'>&yen;</span><span

  lang=EN-US style='font-family:楷体_GB2312'><%=LNAMT%></span><span lang=EN-US

  style='font-family:宋体'><o:p></o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:10;height:15.0pt'>

  <td width=148 style='width:110.85pt;border-top:none;border-left:solid windowtext 1.5pt;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>贷款生成处理方式</span></p>

  </td>

  <td width=135 style='width:100.9pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=DISPOSE_FLG%></span></p>

  </td>

  <td width=153 style='width:115.1pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>消贷易贷款期限</span></p>

  </td>

  <td width=197 style='width:147.6pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=CON_TERM%></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:11;height:15.0pt'>

  <td width=148 style='width:110.85pt;border-top:none;border-left:solid windowtext 1.5pt;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>还款方式</span></p>

  </td>

  <td width=135 style='width:100.9pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=RTN_TYPE%></span></p>

  </td>

  <td width=153 style='width:115.1pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>还款间隔</span><span lang=EN-US

  style='font-size:10.0pt;mso-fareast-font-family:"Times New Roman"'><o:p></o:p></span></p>

  </td>

  <td width=197 style='width:147.6pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=RTN_INTERVAL%></span><span

  lang=EN-US style='font-size:10.0pt;mso-fareast-font-family:"Times New Roman"'><o:p></o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:12;height:15.0pt'>

  <td width=148 style='width:110.85pt;border-top:none;border-left:solid windowtext 1.5pt;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>还款日确定方式</span></p>

  </td>

  <td width=135 style='width:100.9pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=RTN_DATE_TYPE%></span></p>

  </td>

  <td width=153 style='width:115.1pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>还款日</span></p>

  </td>

  <td width=197 style='width:147.6pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=RTN_DATE%></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:13;height:15.0pt'>

  <td width=148 style='width:110.85pt;border-top:none;border-left:solid windowtext 1.5pt;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>利率调整方式</span></p>

  </td>

  <td width=135 style='width:100.9pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=INTRATE_ADJ%></span></p>

  </td>

  <td width=153 style='width:115.1pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>利率调整日期</span></p>

  </td>

  <td width=197 style='width:147.6pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=INT_YEAR_ADJ_DATE%></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:14;height:15.0pt'>

  <td width=148 style='width:110.85pt;border-top:none;border-left:solid windowtext 1.5pt;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>利率浮动率<span lang=EN-US>%</span></span></p>

  </td>

  <td width=135 style='width:100.9pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=FLTINTRATE%>%</span></p>

  </td>

  <td width=153 style='width:115.1pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'></td>

  <td width=197 style='width:147.6pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'></td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:15;height:15.0pt'>

  <td width=148 style='width:110.85pt;border-top:none;border-left:solid windowtext 1.5pt;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>罚息浮动选项</span></p>

  </td>

  <td width=135 style='width:100.9pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=PFLTINTRATE_OPT%></span></p>

  </td>

  <td width=153 style='width:115.1pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>罚息浮动率<span lang=EN-US>%</span></span></p>

  </td>

  <td width=197 style='width:147.6pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=PFLTINTRATE%>%</span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:16;height:15.0pt'>

  <td width=148 style='width:110.85pt;border-top:none;border-left:solid windowtext 1.5pt;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>客户经理</span></p>

  </td>

  <td width=135 style='width:100.9pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=MGRNM%></span></p>

  </td>

  <td width=153 style='width:115.1pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-size:10.0pt;mso-fareast-font-family:

  "Times New Roman"'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td width=197 style='width:147.6pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-size:10.0pt;mso-fareast-font-family:

  "Times New Roman"'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:17;height:15.0pt'>

  <td width=633 colspan=4 style='width:474.45pt;border-top:none;border-left:

  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:

  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span style='font-size:

  12.0pt;font-family:宋体;mso-bidi-font-family:宋体'>　<span lang=EN-US><o:p></o:p></span></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:18;mso-yfti-lastrow:yes;height:120.9pt'>

  <td width=633 colspan=4 valign=top style='width:474.45pt;border-top:none;

  border-left:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;

  border-right:solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:120.9pt'>

  <p class=MsoNormal><span style='font-family:宋体;mso-hansi-font-family:"Times New Roman";

  mso-bidi-font-family:宋体;color:black;mso-ansi-language:ZH-CN'>备注：相关额度均为截至上一个工作日情况。</span><span

  style='font-family:宋体'>　<span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<o:p></o:p></span></span></p>

  <p class=MsoNormal align=right style='margin-right:6.75pt;text-align:right'><span

  lang=EN-US style='font-family:宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<o:p></o:p></span></p>

  <p class=MsoNormal align=right style='margin-right:24.75pt;text-align:right'><span

  style='font-family:宋体'>打印时间：</span><span lang=EN-US> <%=TXDATE%></span><span

  lang=EN-US style='font-family:宋体'><o:p></o:p></span></p>

  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US

  style='font-family:宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

  &nbsp;&nbsp;&nbsp;&nbsp;<o:p></o:p></span></p>

  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:宋体'>　 <span

  lang=EN-US><o:p></o:p></span></span></p>

  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:宋体'>　 <span

  lang=EN-US><o:p></o:p></span></span></p>

  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:宋体'>　<span

  lang=EN-US><o:p></o:p></span></span></p>

  <p class=MsoNormal><span lang=EN-US style='font-family:宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

  <o:p></o:p></span></p>

  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US

  style='font-family:宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

  <o:p></o:p></span></p>

  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US

  style='font-family:宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

  </span><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; </span><span

  lang=EN-US style='font-family:宋体'><o:p></o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:120.9pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:120.9pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:120.9pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

  <td style='padding:0cm 0cm 0cm 0cm;height:120.9pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

 </tr>

</table>



<p class=MsoNormal><span lang=EN-US style='font-size:12.0pt;mso-ascii-font-family:

楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span></p>



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