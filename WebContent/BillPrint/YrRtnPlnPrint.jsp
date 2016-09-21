<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="com.amarsoft.app.als.common.util.DateHelper"%>
<%@page import="com.amarsoft.app.oci.bean.OCITransaction"%>
<%@page import="com.amarsoft.app.oci.instance.CoreInstance"%>
<%@page import="com.amarsoft.app.oci.bean.Message"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@page import="com.amarsoft.are.jbo.JBOTransaction"%>
<%@page import="com.amarsoft.app.als.common.util.NumberHelper"%>


<%
	String CINO = DataConvert.toString(CurPage.getParameter("SerialNo"));//��ȡҳ�洫�����Ľ�ݺ�
	if(CINO == null)   CINO = "";
	String biginDate = DataConvert.toString(CurPage.getParameter("BiginDate"));//��ݷ�������
	if(biginDate == null)   biginDate = "";
	String finishDate = DataConvert.toString(CurPage.getParameter("FinishDate"));//��ݵ�������
	if(finishDate == null)   finishDate = "";
	String StartDate = biginDate.replace("/", "");
	String EndDate = finishDate.replace("/", "");
	BizObject bdbiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_DUEBILL")
					.createQuery("O.serialNo = :CINO").setParameter("CINO", CINO).getSingleResult(true);
	String putoutDate = bdbiz.getAttribute("PUTOUTDATE").toString();//��ݷ�������
	if(putoutDate == null)   putoutDate = "";
	String maturityDate = bdbiz.getAttribute("MATURITYDATE").toString();//��ݵ�������
	if(maturityDate == null)   maturityDate = "";
	int StartNum1 = 1;
	int QueryNum1 = 99;
	double AcctBal = 0.0;
	OCITransaction oci = null;
	List<Message> imessage = new ArrayList<Message>();

try{
	while(true)
	{
		oci = CoreInstance.PrdPymtPlnQry("92261005", "2261", "",CINO,StartDate,EndDate,"0",StartNum1,QueryNum1, Sqlca.getConnection());
		if(oci != null){
			String 	AcctBalStr = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("AcctBal");
			AcctBal = Double.parseDouble(AcctBalStr);
		}
		List<Message> ims = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldByTag("LoanPrdInfo").getFieldArrayValue();
		
		imessage.addAll(ims);
		if(ims.size() >= QueryNum1)
		{
			StartNum1 += QueryNum1;
		}
		else
		{
			break;
		}
	}
}catch(Exception e){
	e.printStackTrace();
}
	
	//������
	String ORGID = bdbiz.getAttribute("OPERATEORGID").toString();//����
	String thisYear = StringFunction.getToday().substring(0, 4);
	int lastYearInt = Integer.parseInt(thisYear)-1;
	String lastYear = Integer.toString(lastYearInt); 
	String CUSTNAME = bdbiz.getAttribute("CUSTOMERNAME").toString();
	if(CUSTNAME == null)   CUSTNAME = "";
	String CUSTOMERID = bdbiz.getAttribute("CUSTOMERID").toString(); //�û����
	if(CUSTOMERID == null)   CUSTOMERID = "";
	String ADDRESSTYPE = Sqlca.getString("select BILLADDRESSTYPE from business_contract bc where bc.serialno in (select contractserialno from business_duebill bd where bd.serialno = '"+CINO+"')");
	if(ADDRESSTYPE == null) ADDRESSTYPE = "01";
	String POSTCODE = Sqlca.getString("select ZIPCODE from pub_address_info where ObjectNo = '"+CUSTOMERID+"' and objectType = 'jbo.customer.CUSTOMER_INFO' and AddressType = '"+ADDRESSTYPE+"'");//�ʱ�
	if(POSTCODE == null)   POSTCODE = "";
	String LNNAME = Sqlca.getString("select typename from business_type where typeno = (select BUSINESSTYPE from business_duebill where SerialNo = '"+CINO+"')");//����Ʒ��	
	if(LNNAME == null)   LNNAME = "";
	String LNAMT = DataConvert.toMoney(bdbiz.getAttribute("BUSINESSSUM").toString());//������
	if(LNAMT == null)   LNAMT = "";
	int months = DateHelper.getMonths(putoutDate, maturityDate);
	int iYear = months/12;
	int iMonth = months % 12;
	String RelativeDate = DateHelper.getRelativeDate(putoutDate, DateHelper.TERM_UNIT_MONTH, months);
	int iDay = DateHelper.getDays(RelativeDate, maturityDate);
	String TERM = iYear+"��"+iMonth+"��"+iDay+"��";//��������
	
	String TOTPERI = Sqlca.getString("select TOTALPERIOD from business_duebill where SerialNo = '"+CINO+"'");//�����ڴ�
	if(TOTPERI == null) TOTPERI = "";
	String RTNACTNO = "";
	try{
		RTNACTNO = Sqlca.getString("select ACCOUNTNO from ACCT_ACCOUNT_INFO where ObjectNo = '"+CINO+"' and ObjectType = 'jbo.app.BUSINESS_DUEBILL' and ACCOUNTINDICATOR = '01'");//�����ʻ��ʺţ�չʾ���ͻ������ǻ����
	}catch(NullPointerException e){
		e.printStackTrace();
	}
	if (RTNACTNO == null) RTNACTNO = "";
	String TEDATE = Sqlca.getString("select MATURITYDATE from business_duebill where SerialNo = '"+CINO+"'");//�������
	String INTRATE = Sqlca.getString("select ACTUALBUSINESSRATE from business_duebill where SerialNo = '"+CINO+"'");//����ִ������
	if (INTRATE == null) INTRATE = "";
	String LASTINTRATE = Sqlca.getString("select LASTLOANRATE from business_duebill where SerialNo = '"+CINO+"'");//����ִ������
	if (LASTINTRATE == null) LASTINTRATE = "";
	String RTNAMT = Sqlca.getString("select PAYEDBALANCE from business_duebill where SerialNo = '"+CINO+"'");//������
	if (RTNAMT == null) RTNAMT = "";
	Double BALANCE = Sqlca.getDouble("select BALANCE from business_duebill where SerialNo = '"+CINO+"'");//������
	if (BALANCE == null) BALANCE = 0.0;
	
	String ADDRESS = Sqlca.getString("select ADDRESS1 || ADDRESS2 || ADDRESS3 || ADDRESS4 from pub_address_info where ObjectNo = '"+CUSTOMERID+"' and objectType = 'jbo.customer.CUSTOMER_INFO' and AddressType = '"+ADDRESSTYPE+"'");//��ַ
	if (ADDRESS == null) ADDRESS = "";
	String BRNAME = Sqlca.getString("select getOrgName("+CurUser.getOrgID()+") from dual");//����
	if (BRNAME == null) BRNAME = "";
	String BRADDR = Sqlca.getString("select ORGADD from org_info where ORGID = '"+ORGID+"'");//����
	if (BRADDR == null) BRADDR = "";
	String BRPOST = Sqlca.getString("select ZIPCODE from org_info where ORGID = '"+ORGID+"'");//�ʱ�
	if (BRPOST == null) BRPOST = "";
	String BRTEL = Sqlca.getString("select ORGTEL from org_info where ORGID = '"+ORGID+"'");//�绰
	if (BRTEL == null) BRTEL = "";
	String YEAR = thisYear;//��Ȼ���ƻ�
	
%>
<body lang=ZH-CN style='tab-interval:21.0pt;text-justify-trim:punctuation'>
<div class=Section1 style='layout-grid:15.6pt' align="center">

<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0
 style='margin-left:5.4pt;border-collapse:collapse;mso-padding-alt:0cm 0cm 0cm 0cm'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;height:15.0pt'>
  <td width=53 valign=top style='width:39.6pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;mso-bidi-font-family:����'>�ʱ�<span lang=EN-US>:</span></span><span
  lang=EN-US><o:p></o:p></span></p>
  </td>
  <td width=263 style='width:197.6pt;padding:0cm 0cm 0cm 0cm;height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly;
  mso-char-indent-size:10.5pt'><span lang=EN-US style='font-family:����_GB2312;
  mso-hansi-font-family:����;mso-bidi-font-family:����'><%=POSTCODE%></span><span
  lang=EN-US><o:p></o:p></span></p>
  </td>
  <td width=85 valign=top style='width:63.4pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly;mso-char-indent-size:10.5pt'><span
  style='font-family:����_GB2312;mso-ascii-font-family:"Times New Roman"'>����Ʒ��</span><span
  lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����;color:black'>:</span><span lang=EN-US style='mso-fareast-font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=238 colspan=2 valign=bottom style='width:178.65pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����;color:black'><%=LNNAME%></span><span lang=EN-US style='mso-fareast-font-family:
  ����_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1;height:15.0pt'>
  <td width=53 valign=top style='width:39.6pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;mso-bidi-font-family:����'>��ַ<span lang=EN-US>:</span></span><span
  lang=EN-US style='font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=263 style='width:197.6pt;padding:0cm 0cm 0cm 0cm;height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly;
  mso-char-indent-size:10.5pt'><span lang=EN-US style='font-family:����_GB2312;
  mso-hansi-font-family:����;mso-bidi-font-family:����'><%=ADDRESS%></span><span
  lang=EN-US style='font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=85 valign=top style='width:63.4pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;text-indent:10.5pt;
  mso-char-indent-count:1.0;line-height:16.0pt;mso-line-height-rule:exactly;
  mso-char-indent-size:10.5pt'><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;mso-bidi-font-family:����;color:black'>��ݺ�<span lang=EN-US>:</span></span><span
  lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'><o:p></o:p></span></p>
  </td>
  <td width=238 colspan=2 style='width:178.65pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal align=left style='text-align:left;line-height:16.0pt;
  mso-line-height-rule:exactly'><span lang=EN-US style='font-family:����_GB2312;
  mso-hansi-font-family:����;mso-bidi-font-family:����'><%=CINO%><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2;height:15.0pt'>
  <td width=53 valign=top style='width:39.6pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;mso-bidi-font-family:����'>����<span lang=EN-US>:</span></span><span
  lang=EN-US style='font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=263 style='width:197.6pt;padding:0cm 0cm 0cm 0cm;height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'><%=CUSTNAME%></span><span lang=EN-US style='font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=323 colspan=3 style='width:242.05pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal style='text-indent:5.25pt;mso-char-indent-count:.5;
  line-height:16.0pt;mso-line-height-rule:exactly;mso-char-indent-size:10.5pt'><span
  style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����;color:black'>֤������<span lang=EN-US>:</span></span><span lang=EN-US
  style='font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;height:15.0pt'>
  <td width=316 colspan=2 rowspan=4 style='width:237.2pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='mso-ascii-font-family:����_GB2312;mso-fareast-font-family:
  ����_GB2312'>&nbsp;</span><span lang=EN-US style='font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=323 colspan=3 style='width:242.05pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal style='text-indent:5.25pt;mso-char-indent-count:.5;
  line-height:16.0pt;mso-line-height-rule:exactly;mso-char-indent-size:10.5pt'><span
  style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����;color:black'>֤�����<span lang=EN-US>:</span></span><span lang=EN-US
  style='font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;height:15.0pt'>
  <td width=323 colspan=3 style='width:242.05pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal style='text-indent:15.75pt;mso-char-indent-count:1.5;
  line-height:16.0pt;mso-line-height-rule:exactly;mso-char-indent-size:10.5pt'><span
  style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����;color:black'>�µ�ַ<span lang=EN-US>:</span></span><span lang=EN-US
  style='font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;height:15.0pt'>
  <td width=323 colspan=3 style='width:242.05pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal style='text-indent:26.25pt;mso-char-indent-count:2.5;
  line-height:16.0pt;mso-line-height-rule:exactly;mso-char-indent-size:10.5pt'><span
  style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����;color:black'>�ʱ�<span lang=EN-US>:<span
  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>��ϵ�绰��</span><span lang=EN-US style='font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;height:15.0pt'>
  <td width=323 colspan=3 style='width:242.05pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal style='text-indent:26.25pt;mso-char-indent-count:2.5;
  line-height:16.0pt;mso-line-height-rule:exactly;mso-char-indent-size:10.5pt'><span
  style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����;color:black'>ǩ��<span lang=EN-US>:<span
  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>��</span><span lang=EN-US style='font-family:����;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312;mso-bidi-font-family:����;
  color:black'>&nbsp;&nbsp;</span><span lang=EN-US style='font-family:����_GB2312;
  mso-hansi-font-family:����;mso-bidi-font-family:����;color:black'><span
  style='mso-spacerun:yes'>&nbsp; </span></span><span style='font-family:����_GB2312;
  mso-hansi-font-family:����;mso-bidi-font-family:����;color:black'>��</span><span
  lang=EN-US style='font-family:����;mso-ascii-font-family:����_GB2312;mso-fareast-font-family:
  ����_GB2312;mso-bidi-font-family:����;color:black'>&nbsp;&nbsp;</span><span
  lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����;color:black'><span style='mso-spacerun:yes'>&nbsp; </span></span><span
  style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����;color:black'>��</span><span lang=EN-US style='font-family:����_GB2312'><o:p></o:p></span></p>
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
  <td width=263 style='width:197.6pt;padding:0cm 0cm 0cm 0cm;height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����;color:black'><%=BRADDR%></span></p>
  </td>
  <td width=157 colspan=2 style='width:117.4pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal style='text-indent:31.5pt;mso-char-indent-count:3.0;
  line-height:16.0pt;mso-line-height-rule:exactly'><span style='font-family:
  ����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:����;color:black'>�ʱ�<span
  lang=EN-US>: <%=BRPOST%></span></span></p>
  </td>
  <td width=166 style='width:124.65pt;padding:0cm 0cm 0cm 0cm;height:15.0pt'>
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
  <td width=263 style='border:none'></td>
  <td width=85 style='border:none'></td>
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
style='font-size:12.0pt;font-family:����;mso-bidi-font-family:����'>&nbsp;<o:p></o:p></span></p>

<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=640
 style='width:480.0pt;margin-left:5.4pt;border-collapse:collapse;mso-padding-alt:
 0cm 0cm 0cm 0cm' height=100>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;height:15.0pt'>
  <td width=640 colspan=4 style='width:480.0pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=center style='text-align:center'><b><span
  style='font-size:14.0pt;mso-bidi-font-size:12.0pt;font-family:����_GB2312;
  mso-hansi-font-family:����;mso-bidi-font-family:����;color:black'>�Ϻ��ֶ���չ����<span
  lang=EN-US>(<%=BRNAME%>)</span></span></b><span lang=EN-US style='font-size:14.0pt;
  font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:����'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1;height:15.0pt'>
  <td width=640 colspan=4 style='width:480.0pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=center style='text-align:center'><b><span
  lang=EN-US style='font-size:14.0pt;mso-bidi-font-size:12.0pt;font-family:
  ����_GB2312;color:black'><%=YEAR%></span></b><b><span style='font-size:14.0pt;
  mso-bidi-font-size:12.0pt;font-family:����_GB2312;color:black'>��Ȼ���ƻ�</span></b><b><span
  lang=EN-US style='font-size:14.0pt;font-family:����_GB2312;color:black'><o:p></o:p></span></b></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2;height:15.0pt'>
  <td width=146 style='width:109.55pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;mso-bidi-font-family:����;color:black'>���������<span lang=EN-US>:</span></span></p>
  </td>
  <td width=169 style='width:127.0pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'><%=CUSTNAME%></span></p>
  </td>
  <td width=143 style='width:107.05pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;mso-bidi-font-family:����;color:black'>������<span lang=EN-US>:</span></span></p>
  </td>
  <td width=182 style='width:136.4pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'><%=LNAMT%></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;height:15.0pt'>
  <td width=146 style='width:109.55pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;mso-bidi-font-family:����;color:black'>��������<span lang=EN-US>:</span></span></p>
  </td>
  <td width=169 style='width:127.0pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'><%=TERM%></span></p>
  </td>
  <td width=143 style='width:107.05pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;mso-bidi-font-family:����;color:black'>�����ڴ�<span lang=EN-US>:</span></span></p>
  </td>
  <td width=182 style='width:136.4pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'><%=TOTPERI%></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;height:15.0pt'>
  <td width=146 style='width:109.55pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;mso-bidi-font-family:����;color:black'>�����ʻ��ʺ�<span lang=EN-US>:</span></span><span
  lang=EN-US style='font-family:����'><o:p></o:p></span></p>
  </td>
  <td width=169 style='width:127.0pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'><%=RTNACTNO%></span><span lang=EN-US style='font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=143 style='width:107.05pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;mso-bidi-font-family:����;color:black'>�������<span lang=EN-US>:</span></span><span
  lang=EN-US style='font-family:����'><o:p></o:p></span></p>
  </td>
  <td width=182 style='width:136.4pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=left style='text-align:left;line-height:16.0pt;
  mso-line-height-rule:exactly'><span lang=EN-US style='font-family:����_GB2312;
  mso-hansi-font-family:����;mso-bidi-font-family:����'><%=TEDATE%><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;mso-yfti-lastrow:yes;height:15.0pt'>
  <td width=146 style='width:109.55pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;color:black'>����ִ������<span lang=EN-US>:</span></span><span lang=EN-US
  style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����;color:black'><o:p></o:p></span></p>
  </td>
  <td width=169 style='width:127.0pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  class=MsoCommentReference><span lang=EN-US style='mso-ansi-font-size:10.5pt;
  font-family:����_GB2312;mso-hansi-font-family:"Courier New";color:black'><%=INTRATE%></span></span><span
  class=MsoCommentReference><span style='mso-ansi-font-size:10.5pt;font-family:
  ����_GB2312;mso-hansi-font-family:"Courier New";color:black'>��</span></span><span
  style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'>�������ʣ�</span></p>
  </td>
  <td width=143 style='width:107.05pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:����_GB2312;mso-hansi-font-family:
  ����;color:black'>����ִ������<span lang=EN-US>:</span></span><span lang=EN-US
  style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����;color:black'><o:p></o:p></span></p>
  </td>
  <td width=182 style='width:136.4pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span class=MsoCommentReference><span lang=EN-US
  style='mso-ansi-font-size:10.5pt;font-family:����_GB2312;mso-hansi-font-family:
  "Courier New";color:black'><%=LASTINTRATE%></span></span><span
  class=MsoCommentReference><span style='mso-ansi-font-size:10.5pt;font-family:
  ����_GB2312;mso-hansi-font-family:"Courier New";color:black'>��</span></span><span
  style='font-family:����_GB2312;mso-hansi-font-family:����;mso-bidi-font-family:
  ����'>�������ʣ�<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal align=left style='text-align:left'><span lang=EN-US
style='font-size:12.0pt;font-family:����;mso-bidi-font-family:����;display:none;
mso-hide:all'>&nbsp;<o:p></o:p></span></p>

<table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0
 style='margin-left:5.4pt;border-collapse:collapse;mso-table-layout-alt:fixed;
 border:none;mso-border-alt:solid windowtext .5pt;mso-padding-alt:0cm 0cm 0cm 0cm;
 mso-border-insideh:.5pt solid windowtext;mso-border-insidev:.5pt solid windowtext'
 id=table1>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;height:11.35pt'>
  <td width=100 valign=top style='width:75.2pt;border:solid windowtext 1.0pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.35pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-family:����_GB2312'>�ڴ�</span></p>
  </td>
  <td width=84 valign=top style='width:63.0pt;border:solid windowtext 1.0pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.35pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-family:����_GB2312'>��������</span></p>
  </td>
  <td width=120 valign=top style='width:90.0pt;border:solid windowtext 1.0pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:11.35pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-family:����_GB2312'>������<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=108 valign=top style='width:81.0pt;border:solid windowtext 1.0pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:11.35pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-family:����_GB2312'>����<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=108 valign=top style='width:81.0pt;border:solid windowtext 1.0pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.35pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-family:����_GB2312'>��Ϣ<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=118 valign=top style='width:88.85pt;border:solid windowtext 1.0pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.35pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-family:����_GB2312'>ʣ�౾��<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
  
</tr>
 <%if(imessage == null){}
 else{
 	for(int i = 0; i < imessage.size() ; i ++){
			Message message = imessage.get(i);%>
 <tr style='mso-yfti-irow:1;mso-yfti-lastrow:yes;height:11.25pt'>
  <td width=100 valign=top style='width:75.2pt;border:solid windowtext 1.0pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 0cm 0cm 0cm;height:11.25pt'>
  <p class=MsoNormal align=center style='margin-right:5.25pt;text-align:center'><span
  lang=EN-US style='font-family:����_GB2312'><%=message.getFieldValue("CrnTerm")%></span></p>
  </td>
  <td width=84 valign=top style='width:63.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.25pt'>
  <p class=MsoNormal align=right style='margin-right:5.25pt;text-align:right'><span
  lang=EN-US style='font-family:����_GB2312;color:black'><%=message.getFieldValue("ExpiredDate")%></span><span
  lang=EN-US style='font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
  <%Double RENTSUM = DataConvert.toDouble(message.getFieldValue("RepymtPrncpl"))+DataConvert.toDouble(message.getFieldValue("Interest")); 
 	 RENTSUM =	NumberHelper.keepTwoDecimalFraction(RENTSUM);%>
  <td width=120 valign=top style='width:90.0pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:11.25pt'>
  <p class=MsoNormal align=right style='text-align:right'><span lang=EN-US
  style='font-family:����_GB2312;color:black'><%=RENTSUM%></span><span lang=EN-US
  style='font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=108 valign=top style='width:81.0pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:11.25pt'>
  <p class=MsoNormal align=right style='text-align:right;word-break:break-all'><span
  lang=EN-US style='font-family:����_GB2312'><%=DataConvert.toMoney(message.getFieldValue("RepymtPrncpl"))%><o:p></o:p></span></p>
  </td>
  <td width=108 valign=top style='width:81.0pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.25pt'>
  <p class=MsoNormal align=right style='margin-right:5.25pt;text-align:right'><span
  lang=EN-US style='font-family:����_GB2312'><%=DataConvert.toMoney(message.getFieldValue("Interest"))%><o:p></o:p></span></p>
  </td>
  <%
  Double returnBalance = DataConvert.toDouble(message.getFieldValue("RepymtPrncpl"));
  if(AcctBal > 0){
	  AcctBal -= returnBalance;
  }else{
	  AcctBal = 0.0;
  }
  %>
  <td width=118 valign=top style='width:88.85pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.25pt'>
  <p class=MsoNormal align=right style='margin-right:5.25pt;text-align:right'><span
  lang=EN-US style='font-family:����_GB2312;color:black'><%=DataConvert.toMoney(AcctBal) %></span><span
  lang=EN-US style='font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <% } 
 	}%> 
</table>

<p style='margin-top:2.25pt;line-height:1.0pt;mso-line-height-rule:exactly'><span
lang=EN-US style='mso-bidi-font-family:����'>&nbsp;</span><span lang=EN-US>&nbsp;</span><span
lang=EN-US style='mso-hansi-font-family:"Times New Roman"'><o:p></o:p></span></p>

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