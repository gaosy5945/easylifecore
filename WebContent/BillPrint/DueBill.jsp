<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="com.amarsoft.app.base.util.DateHelper"%>
<%
	//传入的参数如果是出账流水号
	String serialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));
	if(serialNo == null) serialNo = ""; 
	String customerID = "",mfCustomerID="",customerName="",putoutDate="",maturityDate="",bigBusinessSum="",year="",month="",day="",duebillSerialNo="";
	int businessTerm=0,businessTermDay=0;
	double businessSum=0d;
	String BusinessSumStr = "";
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
	BusinessObject bp = bom.loadBusinessObject("jbo.app.BUSINESS_PUTOUT", serialNo);
	if(bp != null)
	{
		customerID = bp.getAttribute("CUSTOMERID").getString();//客户号
		mfCustomerID = Sqlca.getString(new SqlObject("select MFCUSTOMERID from CUSTOMER_INFO where customerid = :CustomerID").setParameter("CustomerID", customerID));
		customerName = bp.getAttribute("CUSTOMERNAME").getString();//名称
		duebillSerialNo = bp.getAttribute("DuebillSerialNo").getString();//借据号
		putoutDate = bp.getAttribute("PUTOUTDATE").getString();//借据发放日期
		maturityDate = bp.getAttribute("MATURITYDATE").getString();//借据到期日期
		businessTerm = bp.getAttribute("BUSINESSTERM").getInt();//期限月
		businessTermDay = bp.getAttribute("BUSINESSTERMDAY").getInt();//期限月
		businessSum = bp.getAttribute("BUSINESSSUM").getDouble();//小写
		bigBusinessSum = StringFunction.numberToChinese(businessSum);//大写
		BusinessSumStr = DataConvert.toMoney(businessSum);
		year = putoutDate.substring(0, 4);//年
		month = putoutDate.substring(5, 7);//月
		day = putoutDate.substring(8, 10);//日
	}

	String settleAcctNo = "",settleAcctName="",dvlprAcctNo = "",dvlprAcctName="";
	List<BusinessObject> accountList = bom.loadBusinessObjects("jbo.acct.ACCT_BUSINESS_ACCOUNT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo", "ObjectType="+bp.getObjectType()+";ObjectNo="+bp.getObjectNo());
	for(BusinessObject account:accountList)
	{
		
		if("01".equals(account.getString("AccountIndIcator")))
		{
			settleAcctNo = account.getString("ACCOUNTNO1");
			if(settleAcctNo == null || "".equals(settleAcctNo))
				settleAcctNo = account.getString("ACCOUNTNO");
			settleAcctName = account.getString("ACCOUNTNAME");
		}
		else if("04".equals(account.getString("AccountIndIcator")))
		{
			dvlprAcctNo = account.getString("ACCOUNTNO1");
			if(dvlprAcctNo == null || "".equals(dvlprAcctNo))
				dvlprAcctNo = account.getString("ACCOUNTNO");
			dvlprAcctName = account.getString("ACCOUNTNAME");
		}
	}
	
	if("0".equals(bp.getString("PaymentType")))//收款人为借款人（备用金）
	{
		dvlprAcctNo=settleAcctNo;
		dvlprAcctName = settleAcctName;
	}
	
	if(dvlprAcctName == null || "".equals(dvlprAcctName))
	{
		try{
			com.amarsoft.app.oci.bean.OCITransaction oci = com.amarsoft.app.oci.instance.CoreInstance.CorpCrnClntNameQryByAcctNo("92261005", "2261", dvlprAcctNo, "01", Sqlca.getConnection());
			dvlprAcctName = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("ClientCHNName");
		}catch(Exception ex)
		{
			ex.printStackTrace();
		}
	}
	
	String term = String.valueOf(businessTerm/12)
			+"年"+ String.valueOf(businessTerm%12) +"月"
			+ String.valueOf(businessTermDay)+"天"
			;//贷款期限
	
	double intRate = 0d;
	List<BusinessObject> rateList = bom.loadBusinessObjects("jbo.acct.ACCT_RATE_SEGMENT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo and RateType=:RateType and RateTermID=:RateTermID order by SEGTOSTAGE", "ObjectType="+bp.getObjectType()+";ObjectNo="+bp.getObjectNo()+";RateType=01;RateTermID="+bp.getString("LoanRateTermID"));
	for(BusinessObject rate:rateList)
	{
		intRate = rate.getDouble("BUSINESSRATE");
		break;
	}
%>

<body lang=ZH-CN style='tab-interval:21.0pt;text-justify-trim:punctuation'>

<div class=Section1 style='layout-grid:15.6pt' align="center">

<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=551
 style='width:413.2pt;border-collapse:collapse;border:none;mso-border-alt:solid windowtext .5pt;
 mso-padding-alt:0cm 5.4pt 0cm 5.4pt;mso-border-insideh:.5pt solid windowtext;
 mso-border-insidev:.5pt solid windowtext'>
 <tr style='mso-yfti-irow:0;page-break-inside:avoid;height:14.65pt;mso-yfti-firstrow:yes'>
  <td width=551 colspan=9 style='width:413.2pt;border:none;padding:0cm 5.4pt 0cm 5.4pt;
  height:14.65pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-ascii-font-family:"Times New Roman";
  mso-hansi-font-family:"Times New Roman"' id = "id1">上海浦东发展银行</span><span lang=EN-US
  style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1;page-break-inside:avoid;height:14.65pt'>
  <td width=551 colspan=9 style='width:413.2pt;border:none;padding:0cm 5.4pt 0cm 5.4pt;
  height:14.65pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-ascii-font-family:"Times New Roman";
  mso-hansi-font-family:"Times New Roman"'id = "id2">个人贷款借款凭证（借据）</span><span lang=EN-US
  style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2;page-break-inside:avoid;height:14.65pt'>
  <td width=183 colspan=3 style='width:137.15pt;border:none;border-bottom:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:14.65pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:宋体;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"' id = "id3">客户号</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'> <%=mfCustomerID%><o:p></o:p></span></p>
  </td>
  <td width=198 colspan=3 style='width:148.8pt;border:none;border-bottom:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:14.65pt'>
  <p class=MsoNormal align=center style='text-align:center'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt'><%=year%></span><span style='mso-bidi-font-size:
  10.5pt;font-family:宋体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
  "Times New Roman"'>年</span><span lang=EN-US style='mso-bidi-font-size:10.5pt'><%=month%></span><span
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-ascii-font-family:"Times New Roman";
  mso-hansi-font-family:"Times New Roman"'>月</span><span lang=EN-US
  style='mso-bidi-font-size:10.5pt'><%=day%></span><span style='mso-bidi-font-size:
  10.5pt;font-family:宋体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
  "Times New Roman"'>日</span><span lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=170 colspan=3 style='width:127.25pt;border:none;border-bottom:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:14.65pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:宋体;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"' id = "id4">借据号</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'> <%=duebillSerialNo%><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;page-break-inside:avoid;height:14.65pt'>
  <td width=28 rowspan=3 style='width:21.3pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext 1.5pt;mso-border-top-alt:1.5pt;
  mso-border-left-alt:1.5pt;mso-border-bottom-alt:.75pt;mso-border-right-alt:
  .75pt;mso-border-color-alt:windowtext;mso-border-style-alt:solid;padding:
  0cm 5.4pt 0cm 5.4pt;height:14.65pt'>
  <p class=MsoNormal align=center style='text-align:center;mso-line-height-alt:
  10.0pt'><span style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-ascii-font-family:
  "Times New Roman";mso-hansi-font-family:"Times New Roman"' id = "id5">借</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  <p class=MsoNormal align=center style='text-align:center;mso-line-height-alt:
  10.0pt'><span style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-ascii-font-family:
  "Times New Roman";mso-hansi-font-family:"Times New Roman"' id = "id6">款</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  <p class=MsoNormal align=center style='text-align:center;mso-line-height-alt:
  10.0pt'><span style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-ascii-font-family:
  "Times New Roman";mso-hansi-font-family:"Times New Roman"' id = "id7">人</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=91 style='width:68.05pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext 1.5pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-top-alt:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:14.65pt'>
  <p class=MsoNormal style='mso-line-height-alt:10.0pt'><span style='mso-bidi-font-size:
  10.5pt;font-family:宋体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
  "Times New Roman"'>名称</span><span lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=144 colspan=2 style='width:108.25pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext 1.5pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-top-alt:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:14.65pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-bidi-font-size:10.5pt'><%=customerName%><o:p></o:p></span></p>
  </td>
  <td width=23 rowspan=3 style='width:17.6pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext 1.5pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-top-alt:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:14.65pt'>
  <p class=MsoNormal align=center style='text-align:center;line-height:25%'><span
  style='mso-bidi-font-size:10.5pt;line-height:25%;font-family:宋体;mso-ascii-font-family:
  "Times New Roman";mso-hansi-font-family:"Times New Roman"' id = "id8">收</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt;line-height:25%'><o:p></o:p></span></p>
  <p class=MsoNormal align=center style='text-align:center;line-height:25%'><span
  style='mso-bidi-font-size:10.5pt;line-height:25%;font-family:宋体;mso-ascii-font-family:
  "Times New Roman";mso-hansi-font-family:"Times New Roman"' id = "id9">款</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt;line-height:25%'><o:p></o:p></span></p>
  <p class=MsoNormal align=center style='text-align:center;line-height:25%'><span
  style='mso-bidi-font-size:10.5pt;line-height:25%;font-family:宋体;mso-ascii-font-family:
  "Times New Roman";mso-hansi-font-family:"Times New Roman"' id = "id10">人</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt;line-height:25%'><o:p></o:p></span></p>
  </td>
  <td width=110 colspan=2 style='width:82.65pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext 1.5pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-top-alt:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:14.65pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:宋体;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"' id = "id11">名称</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=154 colspan=2 style='width:115.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  mso-border-top-alt:solid windowtext 1.5pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-top-alt:1.5pt;mso-border-left-alt:.75pt;mso-border-bottom-alt:
  .75pt;mso-border-right-alt:1.5pt;mso-border-color-alt:windowtext;mso-border-style-alt:
  solid;padding:0cm 5.4pt 0cm 5.4pt;height:14.65pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-bidi-font-size:10.5pt'><%=dvlprAcctName%><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;page-break-inside:avoid;height:14.85pt'>
  <td width=91 style='width:68.05pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0cm 5.4pt 0cm 5.4pt;height:
  14.85pt'>
  <p class=MsoNormal style='mso-line-height-alt:10.0pt'><span style='mso-bidi-font-size:
  10.5pt;font-family:宋体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
  "Times New Roman"' id = "id12">贷款帐号</span><span lang=EN-US style='mso-bidi-font-size:
  10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=144 colspan=2 style='width:108.25pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0cm 5.4pt 0cm 5.4pt;height:
  14.85pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=110 colspan=2 style='width:82.65pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0cm 5.4pt 0cm 5.4pt;height:
  14.85pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:宋体;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'  id = "id13">收款帐号</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=154 colspan=2 style='width:115.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-right-alt:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:14.85pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-bidi-font-size:10.5pt'><%=dvlprAcctNo%><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;page-break-inside:avoid;height:14.3pt'>
  <td width=91 style='width:68.05pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0cm 5.4pt 0cm 5.4pt;height:
  14.3pt'>
  <p class=MsoNormal style='mso-line-height-alt:10.0pt'><span style='mso-bidi-font-size:
  10.5pt;font-family:宋体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
  "Times New Roman"'><span id = "id14">开户银行</span></span><span lang=EN-US style='mso-bidi-font-size:
  10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=144 colspan=2 style='width:108.25pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0cm 5.4pt 0cm 5.4pt;height:
  14.3pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:宋体;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>上海浦东发展银行</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=110 colspan=2 style='width:82.65pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0cm 5.4pt 0cm 5.4pt;height:
  14.3pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:宋体;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'><span  id = "id16">开户银行</span></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=154 colspan=2 style='width:115.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-right-alt:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:14.3pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:宋体;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>上海浦东发展银行</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;page-break-inside:avoid;height:12.0pt'>
  <td width=119 colspan=2 style='width:89.35pt;border-top:none;border-left:
  solid windowtext 1.5pt;border-bottom:none;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-top-alt:solid windowtext .75pt;
  mso-border-left-alt:solid windowtext 1.5pt;mso-border-right-alt:solid windowtext .75pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:12.0pt'>
  <p class=MsoNormal align=center style='text-align:center;line-height:12.0pt;
  mso-line-height-rule:exactly'><span style='mso-bidi-font-size:10.5pt;
  font-family:宋体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
  "Times New Roman"'><span id = "id18">借款期限</span></span><span lang=EN-US style='mso-bidi-font-size:
  10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=144 colspan=2 rowspan=2 style='width:108.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0cm 5.4pt 0cm 5.4pt;height:
  12.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-bidi-font-size:10.5pt'><%=term%>(<%=maturityDate%>)<o:p></o:p></span></p>
  </td>
  <td width=134 colspan=3 rowspan=2 style='width:100.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0cm 5.4pt 0cm 5.4pt;height:
  12.0pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:宋体;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'><span id = "id19">执行利率</span></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=154 colspan=2 rowspan=2 style='width:115.35pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-right-alt:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:12.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-bidi-font-size:10.5pt'><%=intRate%>%<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:7;page-break-inside:avoid;height:12.0pt'>
  <td width=119 colspan=2 style='width:89.35pt;border-top:none;border-left:
  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.0pt;mso-border-left-alt:solid windowtext 1.5pt;mso-border-bottom-alt:
  solid windowtext .75pt;mso-border-right-alt:solid windowtext .75pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:12.0pt'>
  <p class=MsoNormal align=center style='text-align:center;line-height:12.0pt;
  mso-line-height-rule:exactly'><span style='mso-bidi-font-size:10.5pt;
  font-family:宋体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
  "Times New Roman"'><span id = "id20">（最后还款日）</span></span><span lang=EN-US style='mso-bidi-font-size:
  10.5pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:8;page-break-inside:avoid;height:32.75pt'>
  <td width=119 colspan=2 style='width:89.35pt;border-top:none;border-left:
  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .75pt;mso-border-alt:
  solid windowtext .75pt;mso-border-left-alt:solid windowtext 1.5pt;padding:
  0cm 5.4pt 0cm 5.4pt;height:32.75pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:宋体;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'><span id = "id21">银行核定金额</span></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=278 colspan=5 style='width:208.5pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0cm 5.4pt 0cm 5.4pt;height:
  32.75pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-bidi-font-size:10.5pt'>(</span><span
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-ascii-font-family:"Times New Roman";
  mso-hansi-font-family:"Times New Roman"'>大写</span><span lang=EN-US
  style='mso-bidi-font-size:10.5pt'>)</span><span style='mso-bidi-font-size:
  10.5pt;font-family:宋体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
  "Times New Roman"'>人民币</span><span lang=EN-US style='mso-bidi-font-size:10.5pt'><%=bigBusinessSum%><o:p></o:p></span></p>
  </td>
  <td width=154 colspan=2 style='width:115.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-right-alt:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:32.75pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-bidi-font-size:10.5pt'>(</span><span
  style='mso-bidi-font-size:10.5pt;font-family:宋体;mso-ascii-font-family:"Times New Roman";
  mso-hansi-font-family:"Times New Roman"'>小写</span><span lang=EN-US
  style='mso-bidi-font-size:10.5pt'>)<%=BusinessSumStr%>元<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:9;page-break-inside:avoid;height:48.25pt'>
  <td width=119 colspan=2 rowspan=2 valign=top style='width:89.35pt;border-top:
  none;border-left:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;
  border-right:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .75pt;
  mso-border-top-alt:.75pt;mso-border-left-alt:1.5pt;mso-border-bottom-alt:
  1.5pt;mso-border-right-alt:.75pt;mso-border-color-alt:windowtext;mso-border-style-alt:
  solid;padding:0cm 5.4pt 0cm 5.4pt;height:48.25pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:宋体;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'><span id = "id22">借款人签章</span></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=262 colspan=4 valign=top style='width:196.6pt;border:none;
  border-right:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .75pt;
  mso-border-left-alt:solid windowtext .75pt;mso-border-top-alt:solid windowtext .75pt;
  mso-border-left-alt:solid windowtext .75pt;mso-border-right-alt:solid windowtext .75pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:48.25pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:宋体;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'><span id = "id23">放款专用章</span></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=170 colspan=3 valign=top style='width:127.25pt;border:none;
  border-right:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext .75pt;
  mso-border-left-alt:solid windowtext .75pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:48.25pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:10;mso-yfti-lastrow:yes;page-break-inside:avoid;
  height:12.9pt'>
  <td width=262 colspan=4 valign=top style='width:196.6pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.5pt;border-right:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-bottom-alt:solid windowtext 1.5pt;mso-border-right-alt:solid windowtext .75pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:12.9pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:宋体;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'><span id = "id24">放款监督人（或质押贷款审批人）</span></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=85 colspan=2 valign=top style='width:63.6pt;border:none;border-bottom:
  solid windowtext 1.5pt;mso-border-left-alt:solid windowtext .75pt;padding:
  0cm 5.4pt 0cm 5.4pt;height:12.9pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:宋体;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'><span id = "id25">授权</span></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=85 valign=top style='width:63.65pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.5pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:12.9pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:宋体;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'><span id = "id26">记账</span></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <![if !supportMisalignedColumns]>
 <tr height=0>
  <td width=28 style='border:none'></td>
  <td width=89 style='border:none'></td>
  <td width=64 style='border:none'></td>
  <td width=81 style='border:none'></td>
  <td width=28 style='border:none'></td>
  <td width=92 style='border:none'></td>
  <td width=16 style='border:none'></td>
  <td width=68 style='border:none'></td>
  <td width=84 style='border:none'></td>
 </tr>
 <![endif]>
</table>
</div>

</body>

<script>
   function printPaper(){
	   var print = document.getElementById("print");
	   id1.style.display = "none";
	   id2.style.display = "none";
	   id3.style.display = "none";
	   id4.style.display = "none";
	   id5.style.display = "none";
	   id6.style.display = "none";
	   id7.style.display = "none";
	   id8.style.display = "none";
	   id9.style.display = "none";
	   id10.style.display = "none";
	   id11.style.display = "none";
	   id12.style.display = "none";
	   id13.style.display = "none";
	   id14.style.display = "none";
	   //id15.style.display = "none";
	   id16.style.display = "none";
	  // id17.style.display = "none";
	   id18.style.display = "none";
	   id19.style.display = "none";
	   id20.style.display = "none";
	   id21.style.display = "none";
	   id22.style.display = "none";
	   id23.style.display = "none";
	   id24.style.display = "none";
	   id25.style.display = "none";
	   id26.style.display = "none";

	   if(window.confirm("是否确定要打印？")){
		   //打印	  
		   print.style.display = "none";
		   window.print();	
		   window.close();
	   }
   }
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
