<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="com.amarsoft.app.als.common.util.DateHelper"%>
<%

String coSerialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));

BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();

BusinessObject co = bom.loadBusinessObject("jbo.cl.CL_OPERATE", coSerialNo);

BusinessObject bc = bom.loadBusinessObject(co.getString("ObjectType"),co.getString("ObjectNo"));

String contractserialNo = bc.getObjectNo();
if(contractserialNo == null) contractserialNo = "";//2014121600000001
//�͑�̖
String custno = bc.getString("CustomerID");
if(custno == null) custno = "";
String MFCUSTNO = Sqlca.getString("select mfcustomerid from customer_info where customerid = '"+custno+"'");
if(MFCUSTNO == null) MFCUSTNO = "";
//�͑����Q
String custname = bc.getString("CustomerName");
if(custname == null) custname = "";
String brcode = bc.getString("OperateOrgID");
if(brcode == null) brcode = "";
String contractno = contractserialNo;
if(contractno == null) contractno = "";
String cardno = Sqlca.getString("select accountno from ACCT_BUSINESS_ACCOUNT where objecttype='jbo.app.BUSINESS_CONTRACT' and objectno = '"+contractserialNo+"'");
if(cardno == null) cardno = "";
//������ͬ��
String cocontractno=Sqlca.getString("select ObjectNo from CONTRACT_RELATIVE where objecttype='jbo.app.BUSINESS_CONTRACT' and ContractSerialNo = '"+contractserialNo+"' ");
if(cocontractno == null) cocontractno = "";
//�����ױ��ý��˺�
String rtnactno = "";
String action = com.amarsoft.dict.als.cache.CodeCache.getItemName("CLOperateType", co.getString("OperateType")); //��ͣ�ָ�
if(action == null) action = "";
//��ӡ�r�g
SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy-MM-dd HH:mm");
String txdate = sdfTemp.format(new Date()); 
if(txdate == null) txdate = "";
%> 
<head>

<title>��������ͣ��ָ���֪ͨͨ��</title>

<!--[if gte mso 9]><xml>

 <o:DocumentProperties>

  <o:Author>WangLH</o:Author>

  <o:LastAuthor>huateng</o:LastAuthor>

  <o:Revision>14</o:Revision>

  <o:TotalTime>35</o:TotalTime>

  <o:Created>2006-08-18T07:42:00Z</o:Created>

  <o:LastSaved>2006-08-21T03:03:00Z</o:LastSaved>

  <o:Pages>1</o:Pages>

  <o:Words>65</o:Words>

  <o:Characters>375</o:Characters>

  <o:Company>SPDB</o:Company>

  <o:Lines>3</o:Lines>

  <o:Paragraphs>1</o:Paragraphs>

  <o:CharactersWithSpaces>439</o:CharactersWithSpaces>

  <o:Version>11.6568</o:Version>

 </o:DocumentProperties>

</xml><![endif]--><!--[if gte mso 9]><xml>

 <w:WordDocument>

  <w:View>Print</w:View>

  <w:DontDisplayPageBoundaries/>

  <w:SpellingState>Clean</w:SpellingState>

  <w:GrammarState>Clean</w:GrammarState>

  <w:PunctuationKerning/>

  <w:DrawingGridVerticalSpacing>7.8 ��</w:DrawingGridVerticalSpacing>

  <w:DisplayHorizontalDrawingGridEvery>0</w:DisplayHorizontalDrawingGridEvery>

  <w:DisplayVerticalDrawingGridEvery>2</w:DisplayVerticalDrawingGridEvery>

  <w:ValidateAgainstSchemas/>

  <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>

  <w:IgnoreMixedContent>false</w:IgnoreMixedContent>

  <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>

  <w:Compatibility>

   <w:SpaceForUL/>

   <w:BalanceSingleByteDoubleByteWidth/>

   <w:DoNotLeaveBackslashAlone/>

   <w:ULTrailSpace/>

   <w:DoNotExpandShiftReturn/>

   <w:AdjustLineHeightInTable/>

   <w:BreakWrappedTables/>

   <w:SnapToGridInCell/>

   <w:WrapTextWithPunct/>

   <w:UseAsianBreakRules/>

   <w:DontGrowAutofit/>

   <w:UseFELayout/>

  </w:Compatibility>

  <w:BrowserLevel>MicrosoftInternetExplorer4</w:BrowserLevel>

 </w:WordDocument>

</xml><![endif]--><!--[if gte mso 9]><xml>

 <w:LatentStyles DefLockedState="false" LatentStyleCount="156">

 </w:LatentStyles>

</xml><![endif]-->

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

  mso-font-kerning:0pt'>��������ͣ��ָ���֪ͨͨ��</span></b><b><span lang=EN-US

  style='font-size:12.0pt;mso-font-kerning:0pt'><o:p></o:p></span></b></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:1;height:29.85pt'>

  <td width=636 colspan=4 style='width:477.0pt;border:solid windowtext 1.0pt;

  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:29.85pt'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><u><span lang=EN-US

  style='font-size:11.0pt;font-family:����;mso-font-kerning:0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></u><span

  style='font-size:11.0pt;font-family:����;mso-font-kerning:0pt'>��������Ʋ���<span

  lang=EN-US><o:p></o:p></span></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:2;height:74.5pt'>

  <td width=636 colspan=4 style='width:477.0pt;border:solid windowtext 1.0pt;

  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:74.5pt'>

  <p class=MsoNormal style='line-height:150%;mso-pagination:widow-orphan'><u><span

  lang=EN-US style='mso-bidi-font-size:10.5pt;line-height:150%;font-family:

  ����;mso-font-kerning:0pt'>&nbsp;&nbsp;&nbsp;<%=custname %>&nbsp;&nbsp;&nbsp;&nbsp;

  </span></u><span style='mso-bidi-font-size:10.5pt;line-height:150%;

  font-family:����;mso-font-kerning:0pt'>�������ˣ�����������ͣ��ָ�ҵ���Ѿ�������ҵ���������򱨾���Ȩ����������ͬ�⣬��ͨ���ſ�ල��ˣ����㲿���ձ�֪ͨ��Ҫ�󣬰�����������ͣ��ָ���ͨ���ס�<span

  lang=EN-US><o:p></o:p></span></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:3'>

  <td width=636 colspan=4 valign=top style='width:477.0pt;border:solid windowtext 1.0pt;

  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US

  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

 </tr>

<tr style='mso-yfti-irow:4;height:1.0cm;mso-height-rule:exactly'>

  <td width=127 style='width:95.2pt;border:solid windowtext 1.0pt;border-top:

  none;padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span

  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>�ͻ���<span

  lang=EN-US><o:p></o:p></span></span></p>

  </td>

  <td width=185 style='width:138.8pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US

  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><%=MFCUSTNO %><o:p></o:p></span></p>

  </td>

  <td width=132 style='width:99.0pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span

  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>�ͻ�����<span

  lang=EN-US><o:p></o:p></span></span></p>

  </td>

  <td width=192 style='width:144.0pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US

  style='mso-bidi-font-size:10.5pt;font-family:����'><%=custname %></span><span

  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>

  </td>

 </tr>

  <tr style='mso-yfti-irow:4;height:1.0cm;mso-height-rule:exactly'>

  <td width=127 style='width:95.2pt;border:solid windowtext 1.0pt;border-top:

  none;padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span

  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>������<span

  lang=EN-US><o:p></o:p></span></span></p>

  </td>

  <td width=185 style='width:138.8pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US

  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><%=brcode %><o:p></o:p></span></p>

  </td>

  <td width=132 style='width:99.0pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span

  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><span

  lang=EN-US><o:p></o:p></span></span></p>

  </td>

  <td width=192 style='width:144.0pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US

  style='mso-bidi-font-size:10.5pt;font-family:����'></span><span

  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>

  </td>

 </tr>

  <tr style='mso-yfti-irow:6;height:1.0cm;mso-height-rule:exactly'>

  <td width=127 style='width:95.2pt;border:solid windowtext 1.0pt;border-top:

  none;padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span

  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>�����׺�ͬ��<span

  lang=EN-US><o:p></o:p></span></span></p>

  </td>

  <td width=185 style='width:138.8pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US

  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><%=contractno %></span><span

  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>

  </td>

  <td width=132 style='width:99.0pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span

  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>������ͬ��<span

  lang=EN-US><o:p></o:p></span></span></p>

  </td>

  <td width=192 style='width:144.0pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US

  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><%=cocontractno %></span><span

  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:6;height:1.0cm;mso-height-rule:exactly'>

  <td width=127 style='width:95.2pt;border:solid windowtext 1.0pt;border-top:

  none;padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span

  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>�����׿���<span

  lang=EN-US><o:p></o:p></span></span></p>

  </td>

  <td width=185 style='width:138.8pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US

  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><%=cardno %></span><span

  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>

  </td>

  <td width=132 style='width:99.0pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span

  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>�����ױ��ý��˺�<span

  lang=EN-US><o:p></o:p></span></span></p>

  </td>

  <td width=192 style='width:144.0pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US

  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><%=rtnactno %></span><span

  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>

  </td>

 </tr>

  <tr style='mso-yfti-irow:6;height:1.0cm;mso-height-rule:exactly'>

  <td width=127 style='width:95.2pt;border:solid windowtext 1.0pt;border-top:

  none;padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span

  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>��ͣ/�ָ�<span

  lang=EN-US><o:p></o:p></span></span></p>

  </td>

  <td width=185 style='width:138.8pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US

  style='mso-bidi-font-size:10.5pt;font-family:����'><%=action %></span><span

  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>

  </td>

  <td width=127 style='width:95.2pt;border:solid windowtext 1.0pt;border-top:

  none;padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span

  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><span

  lang=EN-US><o:p></o:p></span></span></p>

  </td>

  <td width=185 style='width:138.8pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US

  style='mso-bidi-font-size:10.5pt;font-family:����'></span><span

  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:9;height:17.0pt'>

  <td width=636 colspan=4 valign=top style='width:477.0pt;border:solid windowtext 1.0pt;

  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:17.0pt'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US

  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:10;height:112.9pt'>

  <td width=636 colspan=4 valign=top style='width:477.0pt;border:solid windowtext 1.0pt;

  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:112.9pt'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US

  style='font-size:12.0pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US

  style='font-size:12.0pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span

  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>�ſ�ල��ǩ�֣�<span

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

  0pt'>�ſ�ר���£�<span lang=EN-US><o:p></o:p></span></span></p>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US

  style='font-size:12.0pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US

  style='font-size:12.0pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US

  style='font-size:12.0pt;font-family:����;mso-font-kerning:0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span

  style='font-size:11.0pt;font-family:����;mso-font-kerning:0pt'>���ڣ�</span><span

  lang=EN-US style='font-size:11.0pt;font-family:����'><%=txdate %></span><span

  lang=EN-US style='font-size:11.0pt;font-family:����;mso-font-kerning:0pt'><o:p></o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:11;mso-yfti-lastrow:yes;height:31.35pt'>

  <td width=636 colspan=4 style='width:477.0pt;border:solid windowtext 1.0pt;

  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:31.35pt'>

  <p class=MsoNormal style='mso-pagination:widow-orphan'><span

  style='font-size:11.0pt;font-family:����;mso-font-kerning:0pt'>����֪ͨ�鹲���������ͻ�������ƺ��ĵ�����Ա��һ�ݣ�<span

  lang=EN-US><o:p></o:p></span></span></p>

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




