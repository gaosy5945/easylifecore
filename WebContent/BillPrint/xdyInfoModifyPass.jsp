<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%

String transSerialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));

BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();

BusinessObject transaction = bom.loadBusinessObject("jbo.acct.ACCT_TRANSACTION", transSerialNo);

BusinessObject bcChange = bom.loadBusinessObject(transaction.getString("DocumentObjectType"),transaction.getString("DocumentObjectNo"));

BusinessObject bc = bom.loadBusinessObject(transaction.getString("RelativeObjectType"),transaction.getString("RelativeObjectNo"));

//传入的参数如果是合同流水号
String contractserialNo = bc.getObjectNo();
if(contractserialNo == null) contractserialNo = "";//11712012300100111101
//额度流水号
String CINO = Sqlca.getString("select serialno from cl_info where objecttype= 'jbo.app.BUSINESS_CONTRACT' and CLType='0102' and objectno='"+contractserialNo+"'");
if(CINO == null) CINO = "";
//客戶號
String custno = bc.getString("customerid");
if(custno == null) custno = "";
String MFCUSTNO = Sqlca.getString("select mfcustomerid from customer_info where customerid = '"+custno+"'");
if(MFCUSTNO == null) MFCUSTNO = "";
String custnm = bc.getString("customername"); //客戶名稱
if(custnm == null) custnm = "";
String brcode = bc.getString("OPERATEORGID"); //机构号 
if(brcode == null) brcode = "";
String contractno = contractserialNo; //授信合同号
if(contractno == null) contractno = "";
String cardno = Sqlca.getString("select accountno from ACCT_BUSINESS_ACCOUNT where objecttype='jbo.app.BUSINESS_CONTRACT' and objectno = '"+contractserialNo+"'"); //消贷易卡号
if(cardno == null) cardno = "";
//关联合同号
String COCONTRACTNO = Sqlca.getString("select ObjectNo from CONTRACT_RELATIVE where objecttype='jbo.app.BUSINESS_CONTRACT' and ContractSerialNo = '"+contractserialNo+"' "); 
if(COCONTRACTNO == null) COCONTRACTNO = "";
//消贷易备用金账号
String rtnactno = "";
//消贷易授信额度
String totbal = Sqlca.getString("select BUSINESSAPPAMT from cl_info where serialno ='"+CINO+"'"); 
if(totbal == null) totbal = "";
String tedate = Sqlca.getString("select MATURITYDATE from cl_info where serialno = '"+CINO+"'");
if(tedate == null) tedate = "";
String avbal = Sqlca.getString("select NVL(BUSINESSAVABALANCE,BUSINESSAPPAMT) from cl_info where serialno ='"+CINO+"'"); //可用额度
if(avbal == null) avbal = "";
String freeze_amt = Sqlca.getString("select FREEZEAMT from cl_info where objecttype= 'jbo.app.BUSINESS_CONTRACT' and CLType='0102' and objectno='"+contractserialNo+"'"); //冻结额度
if(freeze_amt == null) freeze_amt = "0.0";

String cash_amt=Sqlca.getString("select (nvl(CASHAMT,0) + nvl(POSUSEAMT,0)+nvl(POSFREEZEAMT,0.0)) from cl_info where objecttype= 'jbo.app.BUSINESS_CONTRACT' and CLType='0102' and objectno='"+contractserialNo+"'"); //消费占用额度
if(cash_amt == null) cash_amt = "0.0";
String lnamt=bc.getString("Balance"); //贷款占用额度
if(lnamt == null ) lnamt = "0.0" ;

String dispose_flg = Sqlca.getString("select getitemname('CLLoanGenerateType','"+bcChange.getString("loanGenerateType")+"') from dual "); //贷款生成处理方式
if(dispose_flg == null) dispose_flg = "";
int businessTerm=bcChange.getInt("businessterm");
int businessTermDay=bcChange.getInt("businesstermday");;
String con_term = (businessTerm/12 < 10 ? "0"+String.valueOf(businessTerm/12) : String.valueOf(businessTerm/12))//消贷易贷款期限
+ (businessTerm%12 < 10 ? "0"+String.valueOf(businessTerm%12) : String.valueOf(businessTerm%12))
+ (businessTermDay < 10 ? "0"+String.valueOf(businessTermDay) : String.valueOf(businessTermDay))
;
//还款流水号
String replySerialNo = Sqlca.getString("select serialno from acct_rpt_segment where objecttype='"+bcChange.getObjectType()+"' and objectno='"+bcChange.getObjectNo()+"' and RPTTERMID ='"+bcChange.getString("RPTTERMID")+"'");
if(replySerialNo == null) replySerialNo = "";
String rtn_type = Sqlca.getString("select componentname from PRD_COMPONENT_LIBRARY where componentid in (select RPTTERMID from business_contract where serialno = '"+contractserialNo+"')"); //偿还方式
if(rtn_type == null) rtn_type = "";
String rtn_interval = Sqlca.getString("select getitemname('PaymentFrequencyType',PAYMENTFREQUENCYTYPE) from acct_rpt_segment where serialNo='"+replySerialNo+"'"); //还款间隔
if(rtn_interval == null) rtn_interval = "";
//还款日确定方式
String rtn_date_type = Sqlca.getString("select getitemname('DefaultDueDayType',DefaultDueDayType) from acct_rpt_segment where serialNo='"+replySerialNo+"'"); // 0－借款日为还款日 1－指定还款日期
if(rtn_date_type == null) rtn_date_type = "";
String rtn_date = Sqlca.getString("select DEFAULTDUEDAY from acct_rpt_segment where serialNo='"+replySerialNo+"'");//还款日
if(rtn_date == null) rtn_date = "";
if(rtn_date_type == "" && rtn_date != "" && rtn_date != "0"){
	rtn_date_type = "指定还款日期";
}
//利率编号
String rateSerialNo = Sqlca.getString("select serialno from acct_rate_segment where objecttype='"+bcChange.getObjectType()+"' and ratetype='01' and objectno='"+bcChange.getObjectNo()+"' and RATETERMID = '"+bcChange.getString("LOANRATETERMID")+"'"); 
if(rateSerialNo == null) rateSerialNo = "";
String intrate_adj = Sqlca.getString("select getitemname('RepriceType',repricetype) from acct_rate_segment where serialno  ='"+rateSerialNo+"'"); //利率调整方式
if(intrate_adj == null) intrate_adj = "";
String int_year_adj_date = Sqlca.getString("select REPRICEDATE from acct_rate_segment where serialno  ='"+rateSerialNo+"'"); //利率调整日期
if(int_year_adj_date == null) int_year_adj_date = "";
String fltintrate = Sqlca.getString("select RATEFLOAT from acct_rate_segment where serialno  ='"+rateSerialNo+"'");
if(fltintrate == null) fltintrate = "";
//罚息利率流水号
String prateSerialNo = Sqlca.getString("select serialno from acct_rate_segment where objecttype='"+bcChange.getObjectType()+"' and ratetype='02' and objectno='"+bcChange.getObjectNo()+"'");
if(prateSerialNo == null) prateSerialNo = "";
String pfltintrate_opt = Sqlca.getString("select getitemname('RateMode',RATEMODE) from acct_rate_segment where serialno  ='"+prateSerialNo+"'"); //罚息浮动选项
if(pfltintrate_opt == null) pfltintrate_opt = "";
String pfltintrate = Sqlca.getString("select RATEFLOAT from acct_rate_segment where serialno  ='"+prateSerialNo+"'");
if(pfltintrate == null) pfltintrate = "";
String mgrno = bc.getString("OPERATEUSERID");// 客户经理
if(mgrno == null) mgrno = "";
//打印时间
SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy-MM-dd HH:mm");
String txdate = sdfTemp.format(new Date());
if(txdate == null) txdate = "";
%>
<head>

<title>消贷易额度及生成贷款规则信息表</title>

<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:宋体;
	panose-1:2 1 6 0 3 1 1 1 1 1;
	mso-font-alt:SimSun;
	mso-font-charset:134;
	mso-generic-font-family:auto;
	mso-font-pitch:variable;
	mso-font-signature:3 135135232 16 0 262145 0;}
@font-face
	{font-family:"\@宋体";
	panose-1:2 1 6 0 3 1 1 1 1 1;
	mso-font-charset:134;
	mso-generic-font-family:auto;
	mso-font-pitch:variable;
	mso-font-signature:3 135135232 16 0 262145 0;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{mso-style-parent:"";
	margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	mso-pagination:none;
	font-size:10.5pt;
	mso-bidi-font-size:12.0pt;
	font-family:"Times New Roman";
	mso-fareast-font-family:宋体;
	mso-font-kerning:1.0pt;}
span.GramE
	{mso-style-name:"";
	mso-gram-e:yes;}
 /* Page Definitions */
 @page
	{mso-page-border-surround-header:no;
	mso-page-border-surround-footer:no;}
@page Section1
	{size:595.3pt 841.9pt;
	margin:72.0pt 89.85pt 72.0pt 81.1pt;
	mso-header-margin:42.55pt;
	mso-footer-margin:49.6pt;
	mso-paper-source:0;
	layout-grid:15.6pt;}
div.Section1
	{page:Section1;}
-->
</style>
<!--[if gte mso 10]>
<style>
 /* Style Definitions */
 table.MsoNormalTable
	{mso-style-name:普通表格;
	mso-tstyle-rowband-size:0;
	mso-tstyle-colband-size:0;
	mso-style-noshow:yes;
	mso-style-parent:"";
	mso-padding-alt:0cm 5.4pt 0cm 5.4pt;
	mso-para-margin:0cm;
	mso-para-margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:10.0pt;
	font-family:"Times New Roman";
	mso-fareast-font-family:"Times New Roman";
	mso-ansi-language:#0400;
	mso-fareast-language:#0400;
	mso-bidi-language:#0400;}
</style>
<![endif]-->
</head>

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
  mso-font-kerning:0pt'>消贷易额度及生成贷款规则信息表</span></b><b><span lang=EN-US
  style='font-size:12.0pt;mso-font-kerning:0pt'><o:p></o:p></span></b></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2;height:74.5pt'>
  <td width=636 colspan=4 style='width:477.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:74.5pt'> 
  <p class=MsoNormal style='line-height:150%;mso-pagination:widow-orphan'>
  <span style='mso-bidi-font-size:10.5pt;line-height:150%;
  font-family:宋体;mso-font-kerning:0pt'>客户号为<u><span  lang=EN-US style='mso-bidi-font-size:10.5pt;line-height:150%;font-family:
  宋体;mso-font-kerning:0pt'>&nbsp;&nbsp; <%=MFCUSTNO %> &nbsp;&nbsp;</span></u>的
  <u><span  lang=EN-US style='mso-bidi-font-size:10.5pt;line-height:150%;font-family:
  宋体;mso-font-kerning:0pt'>&nbsp;&nbsp; <%=custnm %> &nbsp;&nbsp;</span></u>客户名下卡号为
  <u><span  lang=EN-US style='mso-bidi-font-size:10.5pt;line-height:150%;font-family:
  宋体;mso-font-kerning:0pt'>&nbsp;&nbsp; <%=cardno %> &nbsp;&nbsp;</span></u>
  的当前消贷易额度及生成消贷易贷款规则等信息如下：
  </span> </p>  
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;height:15.0pt'>
  <td width=639 colspan=4 style='width:479.25pt;border-top:none;border-left:
  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
 <p class=MsoNormal><span style='font-family:宋体'></span></p>
  </td>
 </tr>
  <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:宋体'>客户号</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=MFCUSTNO %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: 宋体">客户姓名</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=custnm %></span></p>
  </td>
 </tr>
  <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:宋体'>机构号</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=brcode %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: 宋体"></span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'></span></p>
  </td>
 </tr>
  <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:宋体'>消贷易授信合同号</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=contractno %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: 宋体">关联合同号</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=COCONTRACTNO %></span></p>
  </td>
 </tr>
   <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:宋体'>消贷易卡号</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=cardno %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: 宋体">消贷易备用金账号</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=rtnactno %></span></p>
  </td>
 </tr>
  <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:宋体'>消贷易授信额度</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;
  mso-fareast-font-family:楷体_GB2312'>&yen;</span><span lang=EN-US style='font-family:楷体_GB2312'><%=DataConvert.toMoney(totbal) %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: 宋体">消贷易额度到期日</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=tedate%></span></p>
  </td>
 </tr>
 
 
 
 <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:宋体'>可用额度</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;
  mso-fareast-font-family:楷体_GB2312'>&yen;</span><span lang=EN-US style='font-family:楷体_GB2312'><%=DataConvert.toMoney(avbal) %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: 宋体">冻结额度</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;
  mso-fareast-font-family:楷体_GB2312'>&yen;</span><span lang=EN-US style='font-family:楷体_GB2312'><%=DataConvert.toMoney(freeze_amt) %></span></p>
  </td>
 </tr>
 
 <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:宋体'>消费占用额度</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;
  mso-fareast-font-family:楷体_GB2312'>&yen;</span><span lang=EN-US style='font-family:楷体_GB2312'><%=DataConvert.toMoney(cash_amt) %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: 宋体">贷款占用额度</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;
  mso-fareast-font-family:楷体_GB2312'>&yen;</span><span lang=EN-US style='font-family:楷体_GB2312'><%=DataConvert.toMoney(lnamt) %></span></p>
  </td>
 </tr>
 
 
   <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:宋体'>贷款生成处理方式</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=dispose_flg %></span></span></span></p>
  </td>
  
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: 宋体">消贷易贷款期限</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=con_term %></span></p>
  </td>  
 </tr>
  <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:宋体'>还款方式</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=rtn_type %></span></span></span></p>
  </td>   
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: 宋体">还款间隔</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=rtn_interval %></span></p>
  </td>  
 </tr> 
  <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:宋体'>还款日确定方式</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=rtn_date_type %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: 宋体">还款日</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=rtn_date%></span></p>
  </td>
 </tr>
  <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:宋体'>利率调整方式</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=intrate_adj %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: 宋体">利率调整日期</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=int_year_adj_date%></span></p>
  </td>
 </tr> 
    <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:宋体'>利率浮动率%</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=fltintrate %>%</span></span></span></p>
  </td>  
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: 宋体"></span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'></span></p>
  </td>  
 </tr>
 <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:宋体'>罚息浮动选项</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=pfltintrate_opt %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: 宋体">罚息浮动率%</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=pfltintrate %>%</span></p>
  </td>
 </tr>
 <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:宋体'>客户经理</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><%=mgrno %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: 宋体"></span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'></span></p>
  </td>
 </tr> 
 <tr style='mso-yfti-irow:4;height:15.0pt'>
  <td width=639 colspan=4 style='width:479.25pt;border-top:none;border-left:
  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
 <p class=MsoNormal><span style='font-family:宋体'></span></p>
  </td>
 </tr>
 
 <tr style='mso-yfti-irow:10;height:112.9pt'>
  <td width=636 colspan=4 valign=top style='width:477.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:112.9pt'>
  <p class=MsoNormal><span style='font-family:宋体'>备注：相关额度均为截至上一个工作日情况。</span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='font-size:12.0pt;font-family:宋体;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='font-size:12.0pt;font-family:宋体;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  
  <P style="TEXT-ALIGN: right; MARGIN-RIGHT: 12pt" class=MsoNormal align=right>
  <SPAN style="FONT-FAMILY: 宋体;  FONT-SIZE: 12pt">打印时间：</SPAN>  
  <SPAN style="FONT-FAMILY: 宋体; FONT-SIZE: 12pt"><%=txdate %></SPAN>
  <span lang=EN-US style='font-size:11.0pt;font-family:宋体;mso-font-kerning:0pt'><o:p></o:p></span></p>
  
  <p class=MsoNormal style='mso-pagination:widow-orphan; TEXT-ALIGN: right;' align=right ><span
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-font-kerning:0pt'><span
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
  0pt'><span lang=EN-US><o:p></o:p></span></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='font-size:12.0pt;font-family:宋体;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='font-size:12.0pt;font-family:宋体;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='font-size:12.0pt;font-family:宋体;mso-font-kerning:0pt'>&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;</span>
  <span style='font-size:11.0pt;font-family:宋体;mso-font-kerning:0pt'></span>
  <span lang=EN-US style='font-size:11.0pt;font-family:宋体'></span><span
  lang=EN-US style='font-size:11.0pt;font-family:宋体;mso-font-kerning:0pt'><o:p></o:p></span></p>
 
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

