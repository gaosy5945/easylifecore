<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@page import="com.amarsoft.are.jbo.JBOTransaction"%>

<%
	String CINO = DataConvert.toString(CurPage.getParameter("SerialNo"));//获取页面传过来的借据号
	if(CINO == null)   CINO = "";//6501202110082701
	String biginDate = DataConvert.toString(CurPage.getParameter("BiginDate"));//借据发放日期
	if(biginDate == null)   biginDate = "";
	String finishDate = DataConvert.toString(CurPage.getParameter("FinishDate"));//借据到期日期
	if(finishDate == null)   finishDate = "";
	String StartDate = biginDate.replace("/", "");
	//StartDate = "20211222";
	String EndDate = finishDate.replace("/", "");
	//EndDate = "20300414";
	BizObject bdbiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_DUEBILL")
					.createQuery("O.serialNo = :CINO").setParameter("CINO", CINO).getSingleResult();
	//CINO = "1001201350008905";
	String putoutDate = bdbiz.getAttribute("PUTOUTDATE").toString();//借据发放日期
	if(putoutDate == null)   putoutDate = "";
	String maturityDate = bdbiz.getAttribute("MATURITYDATE").toString();//借据到期日期
	if(maturityDate == null)   maturityDate = "";
	int StartNum1 = bdbiz.getAttribute("CurrentPeriod").getInt();
	String curDate = StringFunction.getToday();
	int month = Integer.parseInt(curDate.substring(5, 7));
	int QueryNum1 = 12 - month;
	StartNum1 = 1;
	QueryNum1 = 20;
	//机构号
	String ORGID = Sqlca.getString("select OPERATEORGID from business_duebill where SerialNo = '"+CINO+"'");
	if(ORGID == null)     ORGID = "";
	//姓名
	String thisYear = StringFunction.getToday().substring(0, 4);
	if(thisYear == null)     thisYear = "";
	String CUSTNAME = Sqlca.getString("select CUSTOMERNAME from business_duebill where SerialNo = '"+CINO+"'");
	if(CUSTNAME == null)     CUSTNAME = "";
	String CUSTOMERID = Sqlca.getString("select CUSTOMERID from business_duebill where SerialNo = '"+CINO+"'");//用户编号
	if(CUSTOMERID == null)     CUSTOMERID = "";
	String ADDRESSTYPE = Sqlca.getString("select BILLADDRESSTYPE from business_contract bc where bc.serialno in (select contractserialno from business_duebill bd where bd.serialno = '"+CINO+"')");
	if(ADDRESSTYPE == null) ADDRESSTYPE = "01";
	String POSTCODE = Sqlca.getString("select ZIPCODE from pub_address_info where ObjectNo = '"+CUSTOMERID+"' and objectType = 'jbo.customer.CUSTOMER_INFO' and AddressType = '"+ADDRESSTYPE+"'");//邮编
	if(POSTCODE == null)     POSTCODE = "";
	String LNNAME = Sqlca.getString("select typename from business_type where typeno = (select BUSINESSTYPE from business_duebill where SerialNo = '"+CINO+"')");//贷款品种	
	if(LNNAME == null)     LNNAME = "";
	String LNAMT = DataConvert.toMoney(Sqlca.getString("select BUSINESSSUM from business_duebill where SerialNo = '"+CINO+"'"));//贷款金额
	if(LNAMT == null)     LNAMT = "";
	int months = (int)Math.ceil(DateHelper.getMonths(putoutDate, maturityDate));
	int iYear = months/12;
	int iMonth = months % 12;
	String RelativeDate = DateHelper.getRelativeDate(putoutDate, DateHelper.TERM_UNIT_MONTH, months);
	int iDay = DateHelper.getDays(RelativeDate, maturityDate);
	String TERM = iYear+"年"+iMonth+"月  "+iDay+"日";//贷款期限
	
	String TOTPERI = Sqlca.getString("select TOTALPERIOD from business_duebill where SerialNo = '"+CINO+"'");//还款期次
	if(TOTPERI == null)     TOTPERI = "";
	String RTNACTNO = "";
	RTNACTNO = Sqlca.getString("select ACCOUNTNO from ACCT_BUSINESS_ACCOUNT where ObjectNo = '"+CINO+"' and ObjectType = 'jbo.app.BUSINESS_DUEBILL' and ACCOUNTINDICATOR = '01'");//还款帐户帐号,展示给客户的是卡号，所以取accountno
	if(RTNACTNO == null)     RTNACTNO = "";
	String TEDATE = Sqlca.getString("select MATURITYDATE from business_duebill where SerialNo = '"+CINO+"'");//贷款到期日
	if(TEDATE == null)     TEDATE = "";
	String INTRATE = Sqlca.getString("select ACTUALBUSINESSRATE from business_duebill where SerialNo = '"+CINO+"'");//本年执行利率
	if(INTRATE == null)     INTRATE = "";
	String PERI = Sqlca.getString("select CURRENTPERIOD from business_duebill where SerialNo = '"+CINO+"'");//期次
	if(PERI == null)     PERI = "";
	String RTNDATE = Sqlca.getString("select REPAYDATE from business_duebill where SerialNo = '"+CINO+"'");//还款日期
	if(RTNDATE == null)     RTNDATE = "";
	String RTNAMT = Sqlca.getString("select PAYEDBALANCE from business_duebill where SerialNo = '"+CINO+"'");//还款金额
	if(RTNAMT == null)     RTNAMT = "";
	Double BALANCE = Sqlca.getDouble("select BALANCE from business_duebill where SerialNo = '"+CINO+"'");//还款金额
	if (BALANCE == null) BALANCE = 0.0;
	
	String ADDRESS = Sqlca.getString("select ADDRESS1 || ADDRESS2 || ADDRESS3 || ADDRESS4 from pub_address_info where ObjectNo = '"+CUSTOMERID+"' and objectType = 'jbo.customer.CUSTOMER_INFO' and AddressType = '"+ADDRESSTYPE+"'");//地址
	if(ADDRESS == null)     ADDRESS = "";
	String BRNAME = Sqlca.getString("select getOrgName("+CurUser.getOrgID()+") from dual");//名字
	if(BRNAME == null)     BRNAME = "";
	String BRADDR = Sqlca.getString("select ORGADD from org_info where ORGID = '"+ORGID+"'");//寄往
	if(BRADDR == null)     BRADDR = "";
	String BRPOST = Sqlca.getString("select ZIPCODE from org_info where ORGID = '"+ORGID+"'");//邮编
	if(BRPOST == null)     BRPOST = "";
	String BRTEL = Sqlca.getString("select ORGTEL from org_info where ORGID = '"+ORGID+"'");//电话
	if(BRTEL == null)     BRTEL = "";
	String YEAR = thisYear;//年度还款计划
	String DATE = StringFunction.getToday();//打印日期
	
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
  style='font-family:楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:
  宋体'>邮编<span lang=EN-US>:</span></span><span lang=EN-US style='font-size:10.0pt;
  mso-fareast-font-family:"Times New Roman"'><o:p></o:p></span></p>
  </td>
  <td width=264 valign=top style='width:198.0pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US
  style='font-size:10.0pt;font-family:楷体_GB2312;mso-hansi-font-family:宋体;
  mso-bidi-font-family:宋体'><%=POSTCODE%></span><span lang=EN-US style='font-size:
  10.0pt;mso-fareast-font-family:"Times New Roman"'><o:p></o:p></span></p>
  </td>
  <td width=84 valign=top style='width:63.0pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:楷体_GB2312;mso-hansi-font-family:
  宋体;mso-bidi-font-family:宋体;color:black'>贷款品种<span lang=EN-US>:</span></span></p>
  </td>
  <td width=238 colspan=2 valign=bottom style='width:178.65pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:
  宋体'><%=LNNAME%></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1;height:15.0pt'>
  <td width=53 valign=top style='width:39.6pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right'><span
  style='font-family:楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:
  宋体'>地址<span lang=EN-US>:</span></span><span lang=EN-US style='font-size:10.0pt;
  font-family:楷体_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=264 valign=top style='width:198.0pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US
  style='font-size:10.0pt;font-family:楷体_GB2312;mso-hansi-font-family:宋体;
  mso-bidi-font-family:宋体'><%=ADDRESS%></span><span lang=EN-US style='font-size:
  10.0pt;font-family:楷体_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=84 valign=top style='width:63.0pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;text-indent:10.5pt;
  mso-char-indent-count:1.0;line-height:16.0pt;mso-line-height-rule:exactly'><span
  style='font-family:楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:
  宋体;color:black'>借据号<span lang=EN-US>:</span></span><span lang=EN-US
  style='font-family:楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:
  宋体'><o:p></o:p></span></p>
  </td>
  <td width=238 colspan=2 valign=top style='width:178.65pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:
  宋体'><%=CINO%><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2;height:15.0pt'>
  <td width=53 valign=top style='width:39.6pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right'><span
  style='font-family:楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:
  宋体'>姓名<span lang=EN-US>:</span></span><span lang=EN-US style='font-size:10.0pt;
  font-family:楷体_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=264 valign=top style='width:198.0pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US
  style='font-size:10.0pt;font-family:楷体_GB2312;mso-hansi-font-family:宋体;
  mso-bidi-font-family:宋体'><%=CUSTNAME%></span><span lang=EN-US style='font-size:
  10.0pt;font-family:楷体_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=322 colspan=3 valign=top style='width:241.65pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal style='text-indent:5.25pt;mso-char-indent-count:.5;
  line-height:16.0pt;mso-line-height-rule:exactly'><span style='font-family:
  楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:宋体;color:black'>证件类型<span
  lang=EN-US>:</span></span><span lang=EN-US style='font-family:楷体_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;height:15.0pt'>
  <td width=317 colspan=2 rowspan=4 style='width:237.6pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:楷体_GB2312'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=322 colspan=3 valign=top style='width:241.65pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal style='text-indent:5.25pt;mso-char-indent-count:.5;
  line-height:16.0pt;mso-line-height-rule:exactly'><span style='font-family:
  楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:宋体;color:black'>证件编号<span
  lang=EN-US>:</span></span><span lang=EN-US style='font-family:楷体_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;height:15.0pt'>
  <td width=322 colspan=3 valign=top style='width:241.65pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal style='text-indent:15.75pt;mso-char-indent-count:1.5;
  line-height:16.0pt;mso-line-height-rule:exactly'><span style='font-family:
  楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:宋体;color:black'>新地址<span
  lang=EN-US>:</span></span><span lang=EN-US style='font-family:楷体_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;height:15.0pt'>
  <td width=322 colspan=3 valign=top style='width:241.65pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal style='text-indent:26.25pt;mso-char-indent-count:2.5;
  line-height:16.0pt;mso-line-height-rule:exactly'><span style='font-family:
  楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:宋体;color:black'>邮编<span
  lang=EN-US>:<span
  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>联系电话<span lang=EN-US>:</span></span><span lang=EN-US
  style='font-family:楷体_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;height:15.0pt'>
  <td width=322 colspan=3 style='width:241.65pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal style='text-indent:26.25pt;mso-char-indent-count:2.5;
  line-height:16.0pt;mso-line-height-rule:exactly'><span style='font-family:
  楷体_GB2312'>签名<span lang=EN-US>:<span
  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>年<span lang=EN-US><span
  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp; </span></span>月<span lang=EN-US><span
  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp; </span></span>日<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:7;height:15.0pt'>
  <td width=639 colspan=5 style='width:479.25pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=center style='text-align:center;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:楷体_GB2312;color:black'>如确认需更改邮寄地址，请尽快填妥以上各栏，沿此线剪下<span
  lang=EN-US>,</span></span><span lang=EN-US style='font-family:楷体_GB2312;
  mso-hansi-font-family:宋体;mso-bidi-font-family:宋体;color:black'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:8;mso-yfti-lastrow:yes;height:15.0pt'>
  <td width=53 valign=top style='width:39.6pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right'><span
  style='font-family:楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:
  宋体'>寄往<span lang=EN-US>:</span></span><span lang=EN-US style='font-size:10.0pt;
  font-family:楷体_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=264 valign=top style='width:198.0pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:
  宋体;color:black'><%=BRADDR%></span></p>
  </td>
  <td width=156 colspan=2 valign=top style='width:117.0pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal style='text-indent:31.5pt;mso-char-indent-count:3.0;
  line-height:16.0pt;mso-line-height-rule:exactly'><span style='font-family:
  楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:宋体;color:black'>邮编<span
  lang=EN-US>: <%=BRPOST%></span></span></p>
  </td>
  <td width=166 valign=top style='width:124.65pt;padding:0cm 0cm 0cm 0cm;
  height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  style='font-family:楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:
  宋体;color:black'>电话<span lang=EN-US>: </span></span><span lang=EN-US
  style='font-family:楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:
  宋体'><%=BRTEL%></span></p>
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
style='font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体'>

<hr size=2 width="100%" align=center>

</span></div>

<p class=MsoNormal align=left style='text-align:left'><span lang=EN-US
style='font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体'><o:p>&nbsp;</o:p></span></p>

<div style="width:650px; margin:auto 0px">
<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=640
 style='width:480.0pt;margin-left:5.4pt;border-collapse:collapse;mso-padding-alt:
 0cm 0cm 0cm 0cm' height=100>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;height:15.0pt'>
  <td width=640 colspan=4 style='width:480.0pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=center style='text-align:center'><b><span
  style='font-size:15.0pt;font-family:楷体_GB2312;mso-hansi-font-family:宋体;
  mso-bidi-font-family:宋体;color:black'>上海浦东发展银行(<%=BRNAME%>)</span></b><span
  lang=EN-US style='font-size:14.0pt;font-family:楷体_GB2312;mso-hansi-font-family:
  宋体;mso-bidi-font-family:宋体'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1;height:15.0pt'>
  <td width=640 colspan=4 style='width:480.0pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal align=center style='text-align:center'><b><span
  style='font-size:14.0pt;font-family:楷体_GB2312;color:black'>个人贷款还款通知单（代回单）<span
  lang=EN-US><o:p></o:p></span></span></b></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2;height:15.0pt'>
  <td width=146 style='width:109.6pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:楷体_GB2312;mso-hansi-font-family:
  宋体;mso-bidi-font-family:宋体;color:black'>借款人姓名<span lang=EN-US>:</span></span></p>
  </td>
  <td width=169 style='width:127.1pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:
  宋体'><%=CUSTNAME%></span></p>
  </td>
  <td width=143 style='width:107.15pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:楷体_GB2312;mso-hansi-font-family:
  宋体;mso-bidi-font-family:宋体;color:black'>贷款金额<span lang=EN-US>:</span></span></p>
  </td>
  <td width=182 style='width:136.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:
  宋体'><%=LNAMT%></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;height:15.0pt'>
  <td width=146 style='width:109.6pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:楷体_GB2312;mso-hansi-font-family:
  宋体;mso-bidi-font-family:宋体;color:black'>贷款期限<span lang=EN-US>:</span></span></p>
  </td>
  <td width=169 style='width:127.1pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:
  宋体'><%=TERM%></span></p>
  </td>
  <td width=143 style='width:107.15pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:楷体_GB2312;mso-hansi-font-family:
  宋体;mso-bidi-font-family:宋体;color:black'>总期次<span lang=EN-US>:</span></span></p>
  </td>
  <td width=182 style='width:136.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:
  宋体'><%=TOTPERI%></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;height:15.0pt'>
  <td width=146 style='width:109.6pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:楷体_GB2312;mso-hansi-font-family:
  宋体;mso-bidi-font-family:宋体;color:black'>还款<span class=GramE>帐户帐号</span><span
  lang=EN-US>:</span></span><span lang=EN-US style='font-family:宋体'><o:p></o:p></span></p>
  </td>
  <td width=169 style='width:127.1pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:
  宋体'><%=RTNACTNO%></span><span lang=EN-US style='font-family:楷体_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=143 style='width:107.15pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:楷体_GB2312;mso-hansi-font-family:
  宋体;mso-bidi-font-family:宋体;color:black'>贷款到期日<span lang=EN-US>:</span></span><span
  lang=EN-US style='font-family:宋体'><o:p></o:p></span></p>
  </td>
  <td width=182 style='width:136.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=left style='text-align:left;line-height:16.0pt;
  mso-line-height-rule:exactly'><span lang=EN-US style='font-family:楷体_GB2312;
  mso-hansi-font-family:宋体;mso-bidi-font-family:宋体'><%=TEDATE%><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;mso-yfti-lastrow:yes;height:15.0pt'>
  <td width=146 style='width:109.6pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='text-align:right;line-height:16.0pt;
  mso-line-height-rule:exactly'><span style='font-family:楷体_GB2312;mso-hansi-font-family:
  宋体;mso-bidi-font-family:宋体;color:black'>贷款当前利率<span lang=EN-US>:</span></span><span
  lang=EN-US style='font-family:宋体'><o:p></o:p></span></p>
  </td>
  <td width=494 colspan=3 style='width:370.5pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:15.0pt'>
  <p class=MsoNormal style='line-height:16.0pt;mso-line-height-rule:exactly'><span
  lang=EN-US style='font-family:楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:
  宋体'><%=INTRATE%></span><span style='font-family:楷体_GB2312;mso-hansi-font-family:
  宋体;mso-bidi-font-family:宋体'>％（年利率）</span><span lang=EN-US style='font-family:
  楷体_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal align=left style='text-align:left'><span lang=EN-US
style='font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;display:none;
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
  style='font-family:楷体_GB2312'>还款日期</span></p>
  </td>
  <td width=68 valign=top style='width:51.05pt;border:solid windowtext 1.0pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.35pt;mso-height-rule:
  exactly'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-family:楷体_GB2312'>还款期次</span></p>
  </td>
  <td width=97 valign=top style='width:72.55pt;border:solid windowtext 1.0pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:11.35pt;mso-height-rule:
  exactly'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-family:楷体_GB2312'>还款金额<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=97 valign=top style='width:72.55pt;border:solid windowtext 1.0pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:11.35pt;mso-height-rule:
  exactly'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-family:楷体_GB2312'>本金<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=97 valign=top style='width:72.55pt;border:solid windowtext 1.0pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.35pt;mso-height-rule:
  exactly'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-family:楷体_GB2312'>利息<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=97 valign=top style='width:72.55pt;border:solid windowtext 1.0pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.35pt;mso-height-rule:
  exactly'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-family:楷体_GB2312'>罚息<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=97 valign=top style='width:72.6pt;border:solid windowtext 1.0pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.35pt;mso-height-rule:
  exactly'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-family:楷体_GB2312'>剩余本金<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
  <%
  
  List<BusinessObject> list = BusinessObjectManager.createBusinessObjectManager().loadBusinessObjects("jbo.acct.ACCT_PAYMENT_LOG", "select O.actualpaydate,aps.seqid,O.actualpayprincipalamt,O.actualpayinteamt,O.actualpayfineamt,bd.balance"
  +" from jbo.app.BUSINESS_DUEBILL bd,jbo.acct.ACCT_PAYMENT_SCHEDULE aps,O where aps.serialno = O.psserialno and bd.serialno = aps.duebillno and bd.serialno = :CINO order by O.actualpaydate,O.TRANSSERIALNO", "CINO="+CINO);
	  double leftbalance = 0.0;
	  double leftbalanceTmp = 0.0;//剩余本金
	  String ActualPayDate = "";
	  boolean flag = false;
	  String[] actualpaydate = new String[list.size()];
	  int[] seqid = new int[list.size()];
	  String[] paySum = new String[list.size()];//还款总金额
	  double[] actualpayprincipalamt = new double[list.size()];//本金
	  double[] actualpayinteamt = new double[list.size()];//利息
	  double[] actualpayfineamt = new double[list.size()];//罚息
	  double[] leftbalanceD = new double[list.size()];//剩余本金
  for(int i=list.size()-1; i>=0;i--){
	  flag = false;
	  BusinessObject boList = list.get(i);
	  ActualPayDate = boList.getString("actualPayDate");
	  //确保打印为选择日期区域
	  if( (ActualPayDate.compareTo(biginDate)>=0 ) && (ActualPayDate.compareTo(finishDate)<= 0) ){
		  flag = true;
	  }
	  if(i==list.size()-1){
		  //最后一期剩余本金为借据表余额，其他期倒序相加还款本金
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
  lang=EN-US style='font-family:楷体_GB2312;color:black'><%=actualpaydate[list.size()-1-i] %></span></p>
  </td>
  <td width=68 valign=top style='width:51.05pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.25pt'>
  <p class=MsoNormal align=right style='margin-right:5.25pt;text-align:right'><span
  lang=EN-US style='font-family:楷体_GB2312'><%=seqid[list.size()-1-i]%><o:p></o:p></span></p>
  </td>
  <td width=97 valign=top style='width:72.55pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:11.25pt'>
  <p class=MsoNormal align=right style='text-align:right'><span lang=EN-US
  style='font-family:楷体_GB2312;color:black'><%=paySum[list.size()-1-i]%></span><span lang=EN-US
  style='font-family:楷体_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=97 valign=top style='width:72.55pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:11.25pt'>
  <p class=MsoNormal align=right style='text-align:right;word-break:break-all'><span
  lang=EN-US style='font-family:楷体_GB2312'><%=DataConvert.toMoney(actualpayprincipalamt[list.size()-1-i])%><o:p></o:p></span></p>
  </td>
  <td width=97 valign=top style='width:72.55pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.25pt'>
  <p class=MsoNormal align=right style='margin-right:5.25pt;text-align:right'><span
  lang=EN-US style='font-family:楷体_GB2312'><%=DataConvert.toMoney(actualpayinteamt[list.size()-1-i])%><o:p></o:p></span></p>
  </td>
  <td width=97 valign=top style='width:72.55pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.25pt'>
  <p class=MsoNormal align=right style='margin-right:5.25pt;text-align:right'><span
  lang=EN-US style='font-family:楷体_GB2312'><%=DataConvert.toMoney(actualpayfineamt[list.size()-1-i])%><o:p></o:p></span></p>
  </td>
  <td width=97 valign=top style='width:72.6pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:11.25pt'>
  <p class=MsoNormal align=right style='margin-right:5.25pt;text-align:right'><span
  lang=EN-US style='font-family:楷体_GB2312;color:black'><%=DataConvert.toMoney(leftbalanceD[list.size()-1-i])%></span><span
  lang=EN-US style='font-family:楷体_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <%}}%>
 
</table>

<p style='margin-top:2.25pt;line-height:1.0pt;mso-line-height-rule:exactly'><span
lang=EN-US style='font-size:10.5pt;font-family:楷体_GB2312'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='line-height:12.0pt;mso-line-height-rule:exactly' align="left"><span
lang=EN-US style='mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span
lang=EN-US style='mso-ascii-font-family:楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span
lang=EN-US style='font-family:楷体_GB2312'> </span><span style='font-family:楷体_GB2312;
color:black'>敬告客户： </span><span lang=EN-US style='font-family:楷体_GB2312'><o:p></o:p></span></p>

<p class=MsoNormal style='text-indent:10.5pt;mso-char-indent-count:1.0;
line-height:12.0pt;mso-line-height-rule:exactly' align="left"><span lang=EN-US
style='font-family:楷体_GB2312;color:black'>1</span><span style='font-family:
楷体_GB2312;color:black'>、</span><span style='font-family:楷体_GB2312;mso-hansi-font-family:
宋体;color:black'>本行已根据委托<span class=GramE>办妥您本期转帐</span>还款。</span><span
lang=EN-US style='font-family:楷体_GB2312'><o:p></o:p></span></p>

<p class=MsoNormal style='text-indent:10.5pt;mso-char-indent-count:1.0;
line-height:12.0pt;mso-line-height-rule:exactly' align="left"><span lang=EN-US
style='font-family:楷体_GB2312;color:black'>2</span><span style='font-family:
楷体_GB2312;color:black'>、</span><span style='font-family:楷体_GB2312;mso-hansi-font-family:
宋体;color:black'>请适时留意您<span class=GramE>转帐帐户</span>上的可还款余额，以保证有足够的金额用于下期还款。</span><span
lang=EN-US style='font-family:楷体_GB2312'><o:p></o:p></span></p>

<p class=MsoNormal style='text-indent:10.5pt;mso-char-indent-count:1.0;
line-height:12.0pt;mso-line-height-rule:exactly' align="left"><span lang=EN-US
style='font-family:楷体_GB2312;color:black'>3</span><span style='font-family:
楷体_GB2312;color:black'>、</span><span style='font-family:楷体_GB2312;mso-hansi-font-family:
宋体;color:black'>委托<span class=GramE>转帐</span>还款的存款<span class=GramE>帐号</span>如有变更，请到贷款银行办理变更手续。</span><span
lang=EN-US style='font-family:楷体_GB2312'><o:p></o:p></span></p>

<p class=MsoNormal style='line-height:10.0pt;mso-line-height-rule:exactly'><span
lang=EN-US style='font-family:楷体_GB2312'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-left:357.0pt;text-indent:21.0pt;line-height:
10.0pt;mso-line-height-rule:exactly'><span style='font-family:楷体_GB2312'>打印日期</span><span
style='font-family:宋体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>：</span><span lang=EN-US style='font-family:楷体_GB2312'><%=DATE%></span><span
lang=EN-US style='font-family:楷体_GB2312;mso-hansi-font-family:宋体;mso-bidi-font-family:
宋体'><o:p></o:p></span></p>

<p style='margin:0cm;margin-bottom:.0001pt;line-height:10.0pt;mso-line-height-rule:
exactly' align="center"><span lang=EN-US style='font-size:10.5pt;mso-ascii-font-family:楷体_GB2312;
mso-fareast-font-family:楷体_GB2312'>&nbsp;&nbsp;</span><span lang=EN-US
style='font-size:10.5pt;font-family:楷体_GB2312'><span style='mso-tab-count:9'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span
style='font-size:10.5pt;font-family:楷体_GB2312;margin-right:250px'>（请注意背面内容）<span lang=EN-US><o:p></o:p></span></span></p>

<p class=MsoNormal><span lang=EN-US style='font-family:楷体_GB2312'><o:p>&nbsp;</o:p></span></p>
</div>
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
 