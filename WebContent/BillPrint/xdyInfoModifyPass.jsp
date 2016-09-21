<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%

String transSerialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));

BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();

BusinessObject transaction = bom.loadBusinessObject("jbo.acct.ACCT_TRANSACTION", transSerialNo);

BusinessObject bcChange = bom.loadBusinessObject(transaction.getString("DocumentObjectType"),transaction.getString("DocumentObjectNo"));

BusinessObject bc = bom.loadBusinessObject(transaction.getString("RelativeObjectType"),transaction.getString("RelativeObjectNo"));

//����Ĳ�������Ǻ�ͬ��ˮ��
String contractserialNo = bc.getObjectNo();
if(contractserialNo == null) contractserialNo = "";//11712012300100111101
//�����ˮ��
String CINO = Sqlca.getString("select serialno from cl_info where objecttype= 'jbo.app.BUSINESS_CONTRACT' and CLType='0102' and objectno='"+contractserialNo+"'");
if(CINO == null) CINO = "";
//�͑�̖
String custno = bc.getString("customerid");
if(custno == null) custno = "";
String MFCUSTNO = Sqlca.getString("select mfcustomerid from customer_info where customerid = '"+custno+"'");
if(MFCUSTNO == null) MFCUSTNO = "";
String custnm = bc.getString("customername"); //�͑����Q
if(custnm == null) custnm = "";
String brcode = bc.getString("OPERATEORGID"); //������ 
if(brcode == null) brcode = "";
String contractno = contractserialNo; //���ź�ͬ��
if(contractno == null) contractno = "";
String cardno = Sqlca.getString("select accountno from ACCT_BUSINESS_ACCOUNT where objecttype='jbo.app.BUSINESS_CONTRACT' and objectno = '"+contractserialNo+"'"); //�����׿���
if(cardno == null) cardno = "";
//������ͬ��
String COCONTRACTNO = Sqlca.getString("select ObjectNo from CONTRACT_RELATIVE where objecttype='jbo.app.BUSINESS_CONTRACT' and ContractSerialNo = '"+contractserialNo+"' "); 
if(COCONTRACTNO == null) COCONTRACTNO = "";
//�����ױ��ý��˺�
String rtnactno = "";
//���������Ŷ��
String totbal = Sqlca.getString("select BUSINESSAPPAMT from cl_info where serialno ='"+CINO+"'"); 
if(totbal == null) totbal = "";
String tedate = Sqlca.getString("select MATURITYDATE from cl_info where serialno = '"+CINO+"'");
if(tedate == null) tedate = "";
String avbal = Sqlca.getString("select NVL(BUSINESSAVABALANCE,BUSINESSAPPAMT) from cl_info where serialno ='"+CINO+"'"); //���ö��
if(avbal == null) avbal = "";
String freeze_amt = Sqlca.getString("select FREEZEAMT from cl_info where objecttype= 'jbo.app.BUSINESS_CONTRACT' and CLType='0102' and objectno='"+contractserialNo+"'"); //������
if(freeze_amt == null) freeze_amt = "0.0";

String cash_amt=Sqlca.getString("select (nvl(CASHAMT,0) + nvl(POSUSEAMT,0)+nvl(POSFREEZEAMT,0.0)) from cl_info where objecttype= 'jbo.app.BUSINESS_CONTRACT' and CLType='0102' and objectno='"+contractserialNo+"'"); //����ռ�ö��
if(cash_amt == null) cash_amt = "0.0";
String lnamt=bc.getString("Balance"); //����ռ�ö��
if(lnamt == null ) lnamt = "0.0" ;

String dispose_flg = Sqlca.getString("select getitemname('CLLoanGenerateType','"+bcChange.getString("loanGenerateType")+"') from dual "); //�������ɴ���ʽ
if(dispose_flg == null) dispose_flg = "";
int businessTerm=bcChange.getInt("businessterm");
int businessTermDay=bcChange.getInt("businesstermday");;
String con_term = (businessTerm/12 < 10 ? "0"+String.valueOf(businessTerm/12) : String.valueOf(businessTerm/12))//�����״�������
+ (businessTerm%12 < 10 ? "0"+String.valueOf(businessTerm%12) : String.valueOf(businessTerm%12))
+ (businessTermDay < 10 ? "0"+String.valueOf(businessTermDay) : String.valueOf(businessTermDay))
;
//������ˮ��
String replySerialNo = Sqlca.getString("select serialno from acct_rpt_segment where objecttype='"+bcChange.getObjectType()+"' and objectno='"+bcChange.getObjectNo()+"' and RPTTERMID ='"+bcChange.getString("RPTTERMID")+"'");
if(replySerialNo == null) replySerialNo = "";
String rtn_type = Sqlca.getString("select componentname from PRD_COMPONENT_LIBRARY where componentid in (select RPTTERMID from business_contract where serialno = '"+contractserialNo+"')"); //������ʽ
if(rtn_type == null) rtn_type = "";
String rtn_interval = Sqlca.getString("select getitemname('PaymentFrequencyType',PAYMENTFREQUENCYTYPE) from acct_rpt_segment where serialNo='"+replySerialNo+"'"); //������
if(rtn_interval == null) rtn_interval = "";
//������ȷ����ʽ
String rtn_date_type = Sqlca.getString("select getitemname('DefaultDueDayType',DefaultDueDayType) from acct_rpt_segment where serialNo='"+replySerialNo+"'"); // 0�������Ϊ������ 1��ָ����������
if(rtn_date_type == null) rtn_date_type = "";
String rtn_date = Sqlca.getString("select DEFAULTDUEDAY from acct_rpt_segment where serialNo='"+replySerialNo+"'");//������
if(rtn_date == null) rtn_date = "";
if(rtn_date_type == "" && rtn_date != "" && rtn_date != "0"){
	rtn_date_type = "ָ����������";
}
//���ʱ��
String rateSerialNo = Sqlca.getString("select serialno from acct_rate_segment where objecttype='"+bcChange.getObjectType()+"' and ratetype='01' and objectno='"+bcChange.getObjectNo()+"' and RATETERMID = '"+bcChange.getString("LOANRATETERMID")+"'"); 
if(rateSerialNo == null) rateSerialNo = "";
String intrate_adj = Sqlca.getString("select getitemname('RepriceType',repricetype) from acct_rate_segment where serialno  ='"+rateSerialNo+"'"); //���ʵ�����ʽ
if(intrate_adj == null) intrate_adj = "";
String int_year_adj_date = Sqlca.getString("select REPRICEDATE from acct_rate_segment where serialno  ='"+rateSerialNo+"'"); //���ʵ�������
if(int_year_adj_date == null) int_year_adj_date = "";
String fltintrate = Sqlca.getString("select RATEFLOAT from acct_rate_segment where serialno  ='"+rateSerialNo+"'");
if(fltintrate == null) fltintrate = "";
//��Ϣ������ˮ��
String prateSerialNo = Sqlca.getString("select serialno from acct_rate_segment where objecttype='"+bcChange.getObjectType()+"' and ratetype='02' and objectno='"+bcChange.getObjectNo()+"'");
if(prateSerialNo == null) prateSerialNo = "";
String pfltintrate_opt = Sqlca.getString("select getitemname('RateMode',RATEMODE) from acct_rate_segment where serialno  ='"+prateSerialNo+"'"); //��Ϣ����ѡ��
if(pfltintrate_opt == null) pfltintrate_opt = "";
String pfltintrate = Sqlca.getString("select RATEFLOAT from acct_rate_segment where serialno  ='"+prateSerialNo+"'");
if(pfltintrate == null) pfltintrate = "";
String mgrno = bc.getString("OPERATEUSERID");// �ͻ�����
if(mgrno == null) mgrno = "";
//��ӡʱ��
SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy-MM-dd HH:mm");
String txdate = sdfTemp.format(new Date());
if(txdate == null) txdate = "";
%>
<head>

<title>�����׶�ȼ����ɴ��������Ϣ��</title>

<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:����;
	panose-1:2 1 6 0 3 1 1 1 1 1;
	mso-font-alt:SimSun;
	mso-font-charset:134;
	mso-generic-font-family:auto;
	mso-font-pitch:variable;
	mso-font-signature:3 135135232 16 0 262145 0;}
@font-face
	{font-family:"\@����";
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
	mso-fareast-font-family:����;
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
	{mso-style-name:��ͨ���;
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
  tab-stops:440.1pt'><b><span style='font-size:12.0pt;font-family:����;
  mso-font-kerning:0pt'>�����׶�ȼ����ɴ��������Ϣ��</span></b><b><span lang=EN-US
  style='font-size:12.0pt;mso-font-kerning:0pt'><o:p></o:p></span></b></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2;height:74.5pt'>
  <td width=636 colspan=4 style='width:477.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:74.5pt'> 
  <p class=MsoNormal style='line-height:150%;mso-pagination:widow-orphan'>
  <span style='mso-bidi-font-size:10.5pt;line-height:150%;
  font-family:����;mso-font-kerning:0pt'>�ͻ���Ϊ<u><span  lang=EN-US style='mso-bidi-font-size:10.5pt;line-height:150%;font-family:
  ����;mso-font-kerning:0pt'>&nbsp;&nbsp; <%=MFCUSTNO %> &nbsp;&nbsp;</span></u>��
  <u><span  lang=EN-US style='mso-bidi-font-size:10.5pt;line-height:150%;font-family:
  ����;mso-font-kerning:0pt'>&nbsp;&nbsp; <%=custnm %> &nbsp;&nbsp;</span></u>�ͻ����¿���Ϊ
  <u><span  lang=EN-US style='mso-bidi-font-size:10.5pt;line-height:150%;font-family:
  ����;mso-font-kerning:0pt'>&nbsp;&nbsp; <%=cardno %> &nbsp;&nbsp;</span></u>
  �ĵ�ǰ�����׶�ȼ����������״���������Ϣ���£�
  </span> </p>  
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;height:15.0pt'>
  <td width=639 colspan=4 style='width:479.25pt;border-top:none;border-left:
  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
 <p class=MsoNormal><span style='font-family:����'></span></p>
  </td>
 </tr>
  <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:����'>�ͻ���</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><%=MFCUSTNO %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: ����">�ͻ�����</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><%=custnm %></span></p>
  </td>
 </tr>
  <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:����'>������</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><%=brcode %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: ����"></span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'></span></p>
  </td>
 </tr>
  <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:����'>���������ź�ͬ��</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><%=contractno %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: ����">������ͬ��</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><%=COCONTRACTNO %></span></p>
  </td>
 </tr>
   <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:����'>�����׿���</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><%=cardno %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: ����">�����ױ��ý��˺�</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><%=rtnactno %></span></p>
  </td>
 </tr>
  <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:����'>���������Ŷ��</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:����_GB2312;
  mso-fareast-font-family:����_GB2312'>&yen;</span><span lang=EN-US style='font-family:����_GB2312'><%=DataConvert.toMoney(totbal) %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: ����">�����׶�ȵ�����</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><%=tedate%></span></p>
  </td>
 </tr>
 
 
 
 <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:����'>���ö��</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:����_GB2312;
  mso-fareast-font-family:����_GB2312'>&yen;</span><span lang=EN-US style='font-family:����_GB2312'><%=DataConvert.toMoney(avbal) %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: ����">������</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:����_GB2312;
  mso-fareast-font-family:����_GB2312'>&yen;</span><span lang=EN-US style='font-family:����_GB2312'><%=DataConvert.toMoney(freeze_amt) %></span></p>
  </td>
 </tr>
 
 <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:����'>����ռ�ö��</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:����_GB2312;
  mso-fareast-font-family:����_GB2312'>&yen;</span><span lang=EN-US style='font-family:����_GB2312'><%=DataConvert.toMoney(cash_amt) %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: ����">����ռ�ö��</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:����_GB2312;
  mso-fareast-font-family:����_GB2312'>&yen;</span><span lang=EN-US style='font-family:����_GB2312'><%=DataConvert.toMoney(lnamt) %></span></p>
  </td>
 </tr>
 
 
   <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:����'>�������ɴ���ʽ</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><%=dispose_flg %></span></span></span></p>
  </td>
  
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: ����">�����״�������</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><%=con_term %></span></p>
  </td>  
 </tr>
  <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:����'>���ʽ</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><%=rtn_type %></span></span></span></p>
  </td>   
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: ����">������</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><%=rtn_interval %></span></p>
  </td>  
 </tr> 
  <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:����'>������ȷ����ʽ</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><%=rtn_date_type %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: ����">������</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><%=rtn_date%></span></p>
  </td>
 </tr>
  <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:����'>���ʵ�����ʽ</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><%=intrate_adj %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: ����">���ʵ�������</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><%=int_year_adj_date%></span></p>
  </td>
 </tr> 
    <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:����'>���ʸ�����%</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><%=fltintrate %>%</span></span></span></p>
  </td>  
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: ����"></span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'></span></p>
  </td>  
 </tr>
 <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:����'>��Ϣ����ѡ��</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><%=pfltintrate_opt %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: ����">��Ϣ������%</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><%=pfltintrate %>%</span></p>
  </td>
 </tr>
 <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:����'>�ͻ�����</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><%=mgrno %></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: ����"></span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'></span></p>
  </td>
 </tr> 
 <tr style='mso-yfti-irow:4;height:15.0pt'>
  <td width=639 colspan=4 style='width:479.25pt;border-top:none;border-left:
  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
 <p class=MsoNormal><span style='font-family:����'></span></p>
  </td>
 </tr>
 
 <tr style='mso-yfti-irow:10;height:112.9pt'>
  <td width=636 colspan=4 valign=top style='width:477.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:112.9pt'>
  <p class=MsoNormal><span style='font-family:����'>��ע����ض�Ⱦ�Ϊ������һ�������������</span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='font-size:12.0pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='font-size:12.0pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  
  <P style="TEXT-ALIGN: right; MARGIN-RIGHT: 12pt" class=MsoNormal align=right>
  <SPAN style="FONT-FAMILY: ����;  FONT-SIZE: 12pt">��ӡʱ�䣺</SPAN>  
  <SPAN style="FONT-FAMILY: ����; FONT-SIZE: 12pt"><%=txdate %></SPAN>
  <span lang=EN-US style='font-size:11.0pt;font-family:����;mso-font-kerning:0pt'><o:p></o:p></span></p>
  
  <p class=MsoNormal style='mso-pagination:widow-orphan; TEXT-ALIGN: right;' align=right ><span
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><span
  lang=EN-US><o:p></o:p></span></span></p>
    
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span><span style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:
  0pt'><span lang=EN-US><o:p></o:p></span></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='font-size:12.0pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='font-size:12.0pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='font-size:12.0pt;font-family:����;mso-font-kerning:0pt'>&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;</span>
  <span style='font-size:11.0pt;font-family:����;mso-font-kerning:0pt'></span>
  <span lang=EN-US style='font-size:11.0pt;font-family:����'></span><span
  lang=EN-US style='font-size:11.0pt;font-family:����;mso-font-kerning:0pt'><o:p></o:p></span></p>
 
  </td>
 </tr>

</table>

<p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p>

</div>
<table align="center">
	<tr>	
		<td id="print"><%=HTMLControls.generateButton("��ӡ", "��ӡ", "printPaper()", "") %></td>
	</tr>
</table>

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
</body>
<%@ include file="/Frame/resources/include/include_end.jspf"%>

