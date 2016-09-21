<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@page import="com.amarsoft.are.jbo.JBOTransaction"%>

<%
	String CINO = DataConvert.toString(CurPage.getParameter("SerialNo"));//��ȡҳ�洫�����Ľ�ݺ�
	if(CINO == null)   CINO = "";//6501202110082701
	String biginDate = DataConvert.toString(CurPage.getParameter("BiginDate"));//��ݷ�������
	if(biginDate == null)   biginDate = "";
	String finishDate = DataConvert.toString(CurPage.getParameter("FinishDate"));//��ݵ�������
	if(finishDate == null)   finishDate = "";
	String StartDate = biginDate.replace("/", "");
	//StartDate = "20211222";
	String EndDate = finishDate.replace("/", "");
	//EndDate = "20300414";
	BizObject bdbiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_DUEBILL")
					.createQuery("O.serialNo = :CINO").setParameter("CINO", CINO).getSingleResult();
	//CINO = "1001201350008905";
	String putoutDate = bdbiz.getAttribute("PUTOUTDATE").toString();//��ݷ�������
	if(putoutDate == null)   putoutDate = "";
	String maturityDate = bdbiz.getAttribute("MATURITYDATE").toString();//��ݵ�������
	if(maturityDate == null)   maturityDate = "";
	int StartNum1 = bdbiz.getAttribute("CurrentPeriod").getInt();
	String curDate = StringFunction.getToday();
	int month = Integer.parseInt(curDate.substring(5, 7));
	int QueryNum1 = 12 - month;
	StartNum1 = 1;
	QueryNum1 = 20;
	//������
	String ORGID = Sqlca.getString("select OPERATEORGID from business_duebill where SerialNo = '"+CINO+"'");
	if(ORGID == null)     ORGID = "";
	//����
	String thisYear = StringFunction.getToday().substring(0, 4);
	if(thisYear == null)     thisYear = "";
	String CUSTNAME = Sqlca.getString("select CUSTOMERNAME from business_duebill where SerialNo = '"+CINO+"'");
	if(CUSTNAME == null)     CUSTNAME = "";
	String CUSTOMERID = Sqlca.getString("select CUSTOMERID from business_duebill where SerialNo = '"+CINO+"'");//�û����
	if(CUSTOMERID == null)     CUSTOMERID = "";
	String ADDRESSTYPE = Sqlca.getString("select BILLADDRESSTYPE from business_contract bc where bc.serialno in (select contractserialno from business_duebill bd where bd.serialno = '"+CINO+"')");
	if(ADDRESSTYPE == null) ADDRESSTYPE = "01";
	String POSTCODE = Sqlca.getString("select ZIPCODE from pub_address_info where ObjectNo = '"+CUSTOMERID+"' and objectType = 'jbo.customer.CUSTOMER_INFO' and AddressType = '"+ADDRESSTYPE+"'");//�ʱ�
	if(POSTCODE == null)     POSTCODE = "";
	String LNNAME = Sqlca.getString("select typename from business_type where typeno = (select BUSINESSTYPE from business_duebill where SerialNo = '"+CINO+"')");//����Ʒ��	
	if(LNNAME == null)     LNNAME = "";
	String LNAMT = DataConvert.toMoney(Sqlca.getString("select BUSINESSSUM from business_duebill where SerialNo = '"+CINO+"'"));//������
	if(LNAMT == null)     LNAMT = "";
	int months = (int)Math.ceil(DateHelper.getMonths(putoutDate, maturityDate));
	int iYear = months/12;
	int iMonth = months % 12;
	String RelativeDate = DateHelper.getRelativeDate(putoutDate, DateHelper.TERM_UNIT_MONTH, months);
	int iDay = DateHelper.getDays(RelativeDate, maturityDate);
	String TERM = iYear+"��"+iMonth+"��  "+iDay+"��";//��������
	
	String TOTPERI = Sqlca.getString("select TOTALPERIOD from business_duebill where SerialNo = '"+CINO+"'");//�����ڴ�
	if(TOTPERI == null)     TOTPERI = "";
	String RTNACTNO = "";
	RTNACTNO = Sqlca.getString("select ACCOUNTNO from ACCT_BUSINESS_ACCOUNT where ObjectNo = '"+CINO+"' and ObjectType = 'jbo.app.BUSINESS_DUEBILL' and ACCOUNTINDICATOR = '01'");//�����ʻ��ʺ�,չʾ���ͻ����ǿ��ţ�����ȡaccountno
	if(RTNACTNO == null)     RTNACTNO = "";
	String TEDATE = Sqlca.getString("select MATURITYDATE from business_duebill where SerialNo = '"+CINO+"'");//�������
	if(TEDATE == null)     TEDATE = "";
	String INTRATE = Sqlca.getString("select ACTUALBUSINESSRATE from business_duebill where SerialNo = '"+CINO+"'");//����ִ������
	if(INTRATE == null)     INTRATE = "";
	String PERI = Sqlca.getString("select CURRENTPERIOD from business_duebill where SerialNo = '"+CINO+"'");//�ڴ�
	if(PERI == null)     PERI = "";
	String RTNDATE = Sqlca.getString("select REPAYDATE from business_duebill where SerialNo = '"+CINO+"'");//��������
	if(RTNDATE == null)     RTNDATE = "";
	String RTNAMT = Sqlca.getString("select PAYEDBALANCE from business_duebill where SerialNo = '"+CINO+"'");//������
	if(RTNAMT == null)     RTNAMT = "";
	Double BALANCE = Sqlca.getDouble("select BALANCE from business_duebill where SerialNo = '"+CINO+"'");//������
	if (BALANCE == null) BALANCE = 0.0;
	
	String ADDRESS = Sqlca.getString("select ADDRESS1 || ADDRESS2 || ADDRESS3 || ADDRESS4 from pub_address_info where ObjectNo = '"+CUSTOMERID+"' and objectType = 'jbo.customer.CUSTOMER_INFO' and AddressType = '"+ADDRESSTYPE+"'");//��ַ
	if(ADDRESS == null)     ADDRESS = "";
	String BRNAME = Sqlca.getString("select getOrgName("+CurUser.getOrgID()+") from dual");//����
	if(BRNAME == null)     BRNAME = "";
	String BRADDR = Sqlca.getString("select ORGADD from org_info where ORGID = '"+ORGID+"'");//����
	if(BRADDR == null)     BRADDR = "";
	String BRPOST = Sqlca.getString("select ZIPCODE from org_info where ORGID = '"+ORGID+"'");//�ʱ�
	if(BRPOST == null)     BRPOST = "";
	String BRTEL = Sqlca.getString("select ORGTEL from org_info where ORGID = '"+ORGID+"'");//�绰
	if(BRTEL == null)     BRTEL = "";
	String YEAR = thisYear;//��Ȼ���ƻ�
	String DATE = StringFunction.getToday();//��ӡ����
	
%>
<style>
	*{ font-size:14px;}
</style>

<body lang=ZH-CN style='tab-interval:21.0pt;text-justify-trim:punctuation'>



<div class=Section1 style='layout-grid:15.6pt' align="center" >

<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=639
 style='width:479.25pt;margin-left:5.4pt;border-collapse:collapse;mso-padding-alt:
 0cm 0cm 0cm 0cm'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;height:15.0pt'>
  <td width=53 valign=top style='width:39.6pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right'><span
  style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'>�ʱ�<span lang=EN-US>:</span></span><span lang=EN-US style='font-size:10.0pt;
  mso-fareast-font-family:"Times New Roman"'><o:p></o:p></span></p>
  </td>
  <td width=264 valign=top style='width:198.0pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US
  style='font-size:10.0pt;font-family:����_GB2312;mso-hansi-font-family:����;
  mso-bidi-font-family:����'><%=POSTCODE%></span><span lang=EN-US style='font-size:
  10.0pt;mso-fareast-font-family:"Times New Roman"'><o:p></o:p></span></p>
  </td>
  <td width=84 valign=top style='width:63.0pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;mso-bidi-font-family:����;color:black'>����Ʒ��<span lang=EN-US>:</span></span></p>
  </td>
  <td width=238 colspan=2 valign=bottom style='width:178.65pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'><%=LNNAME%></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1;height:15.0pt'>
  <td width=53 valign=top style='width:39.6pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right'><span
  style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'>��ַ<span lang=EN-US>:</span></span><span lang=EN-US style='font-size:10.0pt;
  font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=264 valign=top style='width:198.0pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US
  style='font-size:10.0pt;font-family:����_GB2312;mso-hansi-font-family:����;
  mso-bidi-font-family:����'><%=ADDRESS%></span><span lang=EN-US style='font-size:
  10.0pt;font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=84 valign=top style='width:63.0pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;text-indent:10.5pt;
  mso-char-indent-count:1.0;line-height:16.0pt;mso-line-height-rule:exactly'><span
  style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����;color:black'>��ݺ�<span lang=EN-US>:</span></span><span lang=EN-US
  style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'><o:p></o:p></span></p>
  </td>
  <td width=238 colspan=2 valign=top style='width:178.65pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'><%=CINO%><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2;height:15.0pt'>
  <td width=53 valign=top style='width:39.6pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right'><span
  style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'>����<span lang=EN-US>:</span></span><span lang=EN-US style='font-size:10.0pt;
  font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=264 valign=top style='width:198.0pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US
  style='font-size:10.0pt;font-family:����_GB2312;mso-hansi-font-family:����;
  mso-bidi-font-family:����'><%=CUSTNAME%></span><span lang=EN-US style='font-size:
  10.0pt;font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=322 colspan=3 valign=top style='width:241.65pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal style='text-indent:5.25pt;mso-char-indent-count:.5;
  line-height:16.0pt;mso-line-height-rule:exactly'><span style='font-family:
  ����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:����;color:black'>֤������<span
  lang=EN-US>:</span></span><span lang=EN-US style='font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;height:15.0pt'>
  <td width=317 colspan=2 rowspan=4 style='width:237.6pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:����_GB2312'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=322 colspan=3 valign=top style='width:241.65pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal style='text-indent:5.25pt;mso-char-indent-count:.5;
  line-height:16.0pt;mso-line-height-rule:exactly'><span style='font-family:
  ����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:����;color:black'>֤�����<span
  lang=EN-US>:</span></span><span lang=EN-US style='font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;height:15.0pt'>
  <td width=322 colspan=3 valign=top style='width:241.65pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal style='text-indent:15.75pt;mso-char-indent-count:1.5;
  line-height:16.0pt;mso-line-height-rule:exactly'><span style='font-family:
  ����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:����;color:black'>�µ�ַ<span
  lang=EN-US>:</span></span><span lang=EN-US style='font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;height:15.0pt'>
  <td width=322 colspan=3 valign=top style='width:241.65pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal style='text-indent:26.25pt;mso-char-indent-count:2.5;
  line-height:16.0pt;mso-line-height-rule:exactly'><span style='font-family:
  ����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:����;color:black'>�ʱ�<span
  lang=EN-US>:<span
  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>��ϵ�绰<span lang=EN-US>:</span></span><span lang=EN-US
  style='font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;height:15.0pt'>
  <td width=322 colspan=3 style='width:241.65pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal style='text-indent:26.25pt;mso-char-indent-count:2.5;
  line-height:16.0pt;mso-line-height-rule:exactly'><span style='font-family:
  ����_GB2312'>ǩ��<span lang=EN-US>:<span
  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>��<span lang=EN-US><span
  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp; </span></span>��<span lang=EN-US><span
  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp; </span></span>��<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:7;height:15.0pt'>
  <td width=639 colspan=5 style='width:479.25pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=center style='text-align:center;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:����_GB2312;color:black'>��ȷ��������ʼĵ�ַ���뾡���������ϸ������ش��߼���<span
  lang=EN-US>,</span></span><span lang=EN-US style='font-family:����_GB2312;
  mso-hansi-font-family:����;mso-bidi-font-family:����;color:black'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:8;mso-yfti-lastrow:yes;height:15.0pt'>
  <td width=53 valign=top style='width:39.6pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right'><span
  style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'>����<span lang=EN-US>:</span></span><span lang=EN-US style='font-size:10.0pt;
  font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=264 valign=top style='width:198.0pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����;color:black'><%=BRADDR%></span></p>
  </td>
  <td width=156 colspan=2 valign=top style='width:117.0pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal style='text-indent:31.5pt;mso-char-indent-count:3.0;
  line-height:16.0pt;mso-line-height-rule:exactly'><span style='font-family:
  ����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:����;color:black'>�ʱ�<span
  lang=EN-US>: <%=BRPOST%></span></span></p>
  </td>
  <td width=166 valign=top style='width:124.65pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����;color:black'>�绰<span lang=EN-US>: </span></span><span lang=EN-US
  style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'><%=BRTEL%></span></p>
  </td>
 </tr>
 <![if !supportMisalignedColumns]>
 <tr height=0>
  <td width=53 style='border:none'></td>
  <td width=264 style='border:none'></td>
  <td width=84 style='border:none'></td>
  <td width=72 style='border:none'></td>
  <td width=166 style='border:none'></td>
 </tr>
 <![endif]>
</table>

<div class=MsoNormal align=center style='text-align:center'><span lang=EN-US
style='font-size:12.0pt;font-family:����;mso-bidi-font-family:����'>

<hr size=2 width="100%" align=center>

</span></div>

<p class=MsoNormal align=left style='text-align:left'><span lang=EN-US
style='font-size:12.0pt;font-family:����;mso-bidi-font-family:����'><o:p>&nbsp;</o:p></span></p>

<div style="width:650px; margin:auto 0px">
<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=640
 style='width:480.0pt;margin-left:5.4pt;border-collapse:collapse;mso-padding-alt:
 0cm 0cm 0cm 0cm' height=100>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;height:15.0pt'>
  <td width=640 colspan=4 style='width:480.0pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=center style='text-align:center'><b><span
  style='font-size:15.0pt;font-family:����_GB2312;mso-hansi-font-family:����;
  mso-bidi-font-family:����;color:black'>�Ϻ��ֶ���չ����(<%=BRNAME%>)</span></b><span
  lang=EN-US style='font-size:14.0pt;font-family:����_GB2312;mso-hansi-font-family:
  ����;mso-bidi-font-family:����'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1;height:15.0pt'>
  <td width=640 colspan=4 style='width:480.0pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=center style='text-align:center'><b><span
  style='font-size:14.0pt;font-family:����_GB2312;color:black'>���˴����֪ͨ�������ص���<span
  lang=EN-US><o:p></o:p></span></span></b></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2;height:15.0pt'>
  <td width=146 style='width:109.6pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;mso-bidi-font-family:����;color:black'>���������<span lang=EN-US>:</span></span></p>
  </td>
  <td width=169 style='width:127.1pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'><%=CUSTNAME%></span></p>
  </td>
  <td width=143 style='width:107.15pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;mso-bidi-font-family:����;color:black'>������<span lang=EN-US>:</span></span></p>
  </td>
  <td width=182 style='width:136.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'><%=LNAMT%></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;height:15.0pt'>
  <td width=146 style='width:109.6pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;mso-bidi-font-family:����;color:black'>��������<span lang=EN-US>:</span></span></p>
  </td>
  <td width=169 style='width:127.1pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'><%=TERM%></span></p>
  </td>
  <td width=143 style='width:107.15pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;mso-bidi-font-family:����;color:black'>���ڴ�<span lang=EN-US>:</span></span></p>
  </td>
  <td width=182 style='width:136.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'><%=TOTPERI%></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;height:15.0pt'>
  <td width=146 style='width:109.6pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;mso-bidi-font-family:����;color:black'>����<span class=GramE>�ʻ��ʺ�</span><span
  lang=EN-US>:</span></span><span lang=EN-US style='font-family:����'><o:p></o:p></span></p>
  </td>
  <td width=169 style='width:127.1pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'><%=RTNACTNO%></span><span lang=EN-US style='font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=143 style='width:107.15pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;mso-bidi-font-family:����;color:black'>�������<span lang=EN-US>:</span></span><span
  lang=EN-US style='font-family:����'><o:p></o:p></span></p>
  </td>
  <td width=182 style='width:136.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=left style='text-align:left;line-height:16.0pt;
  mso-line-height-rule:exactly'><span lang=EN-US style='font-family:����_GB2312;
  mso-hansi-font-family:����;mso-bidi-font-family:����'><%=TEDATE%><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;mso-yfti-lastrow:yes;height:15.0pt'>
  <td width=146 style='width:109.6pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;mso-bidi-font-family:����;color:black'>���ǰ����<span lang=EN-US>:</span></span><span
  lang=EN-US style='font-family:����'><o:p></o:p></span></p>
  </td>
  <td width=494 colspan=3 style='width:370.5pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'><%=INTRATE%></span><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;mso-bidi-font-family:����'>���������ʣ�</span><span lang=EN-US style='font-family:
  ����_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal align=left style='text-align:left'><span lang=EN-US
style='font-size:12.0pt;font-family:����;mso-bidi-font-family:����;display:none;
mso-hide:all'><o:p>&nbsp;</o:p></span></p>

<table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0
 style='margin-left:5.4pt;border-collapse:collapse;mso-table-layout-alt:fixed;
 border:none;mso-border-alt:solid windowtext .5pt;mso-padding-alt:0cm 0cm 0cm 0cm;
 mso-border-insideh:.5pt solid windowtext;mso-border-insidev:.5pt solid windowtext'
 id=table1>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;height:11.35pt;mso-height-rule:
  exactly'>
  <td width=87 valign=top style='width:65.2pt;border:solid windowtext 1.0pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.35pt;
  mso-height-rule:exactly'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-family:����_GB2312'>��������</span></p>
  </td>
  <td width=68 valign=top style='width:51.05pt;border:solid windowtext 1.0pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.35pt;mso-height-rule:
  exactly'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-family:����_GB2312'>�����ڴ�</span></p>
  </td>
  <td width=97 valign=top style='width:72.55pt;border:solid windowtext 1.0pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:11.35pt;mso-height-rule:
  exactly'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-family:����_GB2312'>������<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=97 valign=top style='width:72.55pt;border:solid windowtext 1.0pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:11.35pt;mso-height-rule:
  exactly'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-family:����_GB2312'>����<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=97 valign=top style='width:72.55pt;border:solid windowtext 1.0pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.35pt;mso-height-rule:
  exactly'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-family:����_GB2312'>��Ϣ<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=97 valign=top style='width:72.55pt;border:solid windowtext 1.0pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.35pt;mso-height-rule:
  exactly'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-family:����_GB2312'>��Ϣ<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=97 valign=top style='width:72.6pt;border:solid windowtext 1.0pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.35pt;mso-height-rule:
  exactly'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-family:����_GB2312'>ʣ�౾��<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
  <%
  
  List<BusinessObject> list = BusinessObjectManager.createBusinessObjectManager().loadBusinessObjects("jbo.acct.ACCT_PAYMENT_LOG", "select O.actualpaydate,aps.seqid,O.actualpayprincipalamt,O.actualpayinteamt,O.actualpayfineamt,bd.balance"
  +" from jbo.app.BUSINESS_DUEBILL bd,jbo.acct.ACCT_PAYMENT_SCHEDULE aps,O where aps.serialno = O.psserialno and bd.serialno = aps.duebillno and bd.serialno = :CINO order by O.actualpaydate,O.TRANSSERIALNO", "CINO="+CINO);
	  double leftbalance = 0.0;
	  double leftbalanceTmp = 0.0;//ʣ�౾��
	  String ActualPayDate = "";
	  boolean flag = false;
	  String[] actualpaydate = new String[list.size()];
	  int[] seqid = new int[list.size()];
	  String[] paySum = new String[list.size()];//�����ܽ��
	  double[] actualpayprincipalamt = new double[list.size()];//����
	  double[] actualpayinteamt = new double[list.size()];//��Ϣ
	  double[] actualpayfineamt = new double[list.size()];//��Ϣ
	  double[] leftbalanceD = new double[list.size()];//ʣ�౾��
  for(int i=list.size()-1; i>=0;i--){
	  flag = false;
	  BusinessObject boList = list.get(i);
	  ActualPayDate = boList.getString("actualPayDate");
	  //ȷ����ӡΪѡ����������
	  if( (ActualPayDate.compareTo(biginDate)>=0 ) && (ActualPayDate.compareTo(finishDate)<= 0) ){
		  flag = true;
	  }
	  if(i==list.size()-1){
		  //���һ��ʣ�౾��Ϊ��ݱ��������ڵ�����ӻ����
		  leftbalance = boList.getDouble("balance");
		  leftbalanceTmp = leftbalance + boList.getDouble("actualpayprincipalamt");
	  }else{
		  leftbalance = leftbalanceTmp;
		  leftbalanceTmp += boList.getDouble("actualpayprincipalamt");
	  } 
  if(flag == true){
	  actualpaydate[i] = boList.getString("actualpaydate");
	  seqid[i] = boList.getInt("seqid");
	  paySum[i] = DataConvert.toMoney(boList.getDouble("actualpayprincipalamt")+boList.getDouble("actualpayinteamt")+boList.getDouble("actualpayfineamt"));
	  actualpayprincipalamt[i] = boList.getDouble("actualpayprincipalamt");
	  actualpayinteamt[i] = boList.getDouble("actualpayinteamt");
	  actualpayfineamt[i] = boList.getDouble("actualpayfineamt");
	  leftbalanceD[i] = leftbalance;
  }
  }
  for(int i=list.size()-1; i>=0;i--){
	  if(actualpaydate[list.size()-1-i] != null){
  %>
  
 <tr style='mso-yfti-irow:1;mso-yfti-lastrow:yes;height:11.25pt'>
  <td width=87 valign=top style='width:65.2pt;border:solid windowtext 1.0pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 0cm 0cm 0cm;height:11.25pt'>
  <p class=MsoNormal align=right style='margin-right:5.25pt;text-align:right'><span
  lang=EN-US style='font-family:����_GB2312;color:black'><%=actualpaydate[list.size()-1-i] %></span></p>
  </td>
  <td width=68 valign=top style='width:51.05pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.25pt'>
  <p class=MsoNormal align=right style='margin-right:5.25pt;text-align:right'><span
  lang=EN-US style='font-family:����_GB2312'><%=seqid[list.size()-1-i]%><o:p></o:p></span></p>
  </td>
  <td width=97 valign=top style='width:72.55pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:11.25pt'>
  <p class=MsoNormal align=right style='text-align:right'><span lang=EN-US
  style='font-family:����_GB2312;color:black'><%=paySum[list.size()-1-i]%></span><span lang=EN-US
  style='font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=97 valign=top style='width:72.55pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:11.25pt'>
  <p class=MsoNormal align=right style='text-align:right;word-break:break-all'><span
  lang=EN-US style='font-family:����_GB2312'><%=DataConvert.toMoney(actualpayprincipalamt[list.size()-1-i])%><o:p></o:p></span></p>
  </td>
  <td width=97 valign=top style='width:72.55pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.25pt'>
  <p class=MsoNormal align=right style='margin-right:5.25pt;text-align:right'><span
  lang=EN-US style='font-family:����_GB2312'><%=DataConvert.toMoney(actualpayinteamt[list.size()-1-i])%><o:p></o:p></span></p>
  </td>
  <td width=97 valign=top style='width:72.55pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.25pt'>
  <p class=MsoNormal align=right style='margin-right:5.25pt;text-align:right'><span
  lang=EN-US style='font-family:����_GB2312'><%=DataConvert.toMoney(actualpayfineamt[list.size()-1-i])%><o:p></o:p></span></p>
  </td>
  <td width=97 valign=top style='width:72.6pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.25pt'>
  <p class=MsoNormal align=right style='margin-right:5.25pt;text-align:right'><span
  lang=EN-US style='font-family:����_GB2312;color:black'><%=DataConvert.toMoney(leftbalanceD[list.size()-1-i])%></span><span
  lang=EN-US style='font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <%}}%>
 
</table>

<p style='margin-top:2.25pt;line-height:1.0pt;mso-line-height-rule:exactly'><span
lang=EN-US style='font-size:10.5pt;font-family:����_GB2312'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='line-height:12.0pt;mso-line-height-rule:exactly' align="left"><span
lang=EN-US style='mso-fareast-font-family:����_GB2312'>&nbsp;</span><span
lang=EN-US style='mso-ascii-font-family:����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span
lang=EN-US style='font-family:����_GB2312'> </span><span style='font-family:����_GB2312;
color:black'>����ͻ��� </span><span lang=EN-US style='font-family:����_GB2312'><o:p></o:p></span></p>

<p class=MsoNormal style='text-indent:10.5pt;mso-char-indent-count:1.0;
line-height:12.0pt;mso-line-height-rule:exactly' align="left"><span lang=EN-US
style='font-family:����_GB2312;color:black'>1</span><span style='font-family:
����_GB2312;color:black'>��</span><span style='font-family:����_GB2312;mso-hansi-font-family:
����;color:black'>�����Ѹ���ί��<span class=GramE>����������ת��</span>���</span><span
lang=EN-US style='font-family:����_GB2312'><o:p></o:p></span></p>

<p class=MsoNormal style='text-indent:10.5pt;mso-char-indent-count:1.0;
line-height:12.0pt;mso-line-height-rule:exactly' align="left"><span lang=EN-US
style='font-family:����_GB2312;color:black'>2</span><span style='font-family:
����_GB2312;color:black'>��</span><span style='font-family:����_GB2312;mso-hansi-font-family:
����;color:black'>����ʱ������<span class=GramE>ת���ʻ�</span>�ϵĿɻ������Ա�֤���㹻�Ľ���������ڻ��</span><span
lang=EN-US style='font-family:����_GB2312'><o:p></o:p></span></p>

<p class=MsoNormal style='text-indent:10.5pt;mso-char-indent-count:1.0;
line-height:12.0pt;mso-line-height-rule:exactly' align="left"><span lang=EN-US
style='font-family:����_GB2312;color:black'>3</span><span style='font-family:
����_GB2312;color:black'>��</span><span style='font-family:����_GB2312;mso-hansi-font-family:
����;color:black'>ί��<span class=GramE>ת��</span>����Ĵ��<span class=GramE>�ʺ�</span>���б�����뵽�������а�����������</span><span
lang=EN-US style='font-family:����_GB2312'><o:p></o:p></span></p>

<p class=MsoNormal style='line-height:10.0pt;mso-line-height-rule:exactly'><span
lang=EN-US style='font-family:����_GB2312'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-left:357.0pt;text-indent:21.0pt;line-height:
10.0pt;mso-line-height-rule:exactly'><span style='font-family:����_GB2312'>��ӡ����</span><span
style='font-family:����;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>��</span><span lang=EN-US style='font-family:����_GB2312'><%=DATE%></span><span
lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
����'><o:p></o:p></span></p>

<p style='margin:0cm;margin-bottom:.0001pt;line-height:10.0pt;mso-line-height-rule:
exactly' align="center"><span lang=EN-US style='font-size:10.5pt;mso-ascii-font-family:����_GB2312;
mso-fareast-font-family:����_GB2312'>&nbsp;&nbsp;</span><span lang=EN-US
style='font-size:10.5pt;font-family:����_GB2312'><span style='mso-tab-count:9'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span
style='font-size:10.5pt;font-family:����_GB2312;margin-right:250px'>����ע�ⱳ�����ݣ�<span lang=EN-US><o:p></o:p></span></span></p>

<p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'><o:p>&nbsp;</o:p></span></p>
</div>
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
 