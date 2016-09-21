<%@ page contentType="text/html; charset=GBK"%><%@ include file="/Frame/resources/include/include_begin.jspf"%><%@ page import="com.amarsoft.app.base.util.DateHelper"%><%@ page import="com.amarsoft.app.accounting.util.LoanHelper" %><%String SERIALNO = DataConvert.toString(CurPage.getParameter("SerialNo"));//获取页面传过来的催收任务流水号//借据号String DSerialNo = Sqlca.getString("select objectno from coll_task where serialno = '"+SERIALNO+"'");if(DSerialNo == null)    DSerialNo = "";//合同号String DContractSerialNo = Sqlca.getString("select ContractSerialNo from ACCT_LOAN where serialno = '"+DSerialNo+"'");if(DContractSerialNo == null)    DContractSerialNo = "";//客户编号String CUSTOMERID = Sqlca.getString("select CUSTOMERID from ACCT_LOAN where serialno = '"+DSerialNo+"'");if(CUSTOMERID == null)    CUSTOMERID = "";String billAddressType = Sqlca.getString("select BillAddressType from BUSINESS_CONTRACT where serialno = '"+DContractSerialNo+"'");if(billAddressType == null) billAddressType = "";//邮编String POSTCODE1 = Sqlca.getString("select ZipCode from pub_address_info where objectno='"+CUSTOMERID+"' and objecttype='jbo.customer.CUSTOMER_INFO' and (addresstype='"+billAddressType+"' or '"+billAddressType+"' is null) order by isnew desc,updatedate desc,inputdate desc ");if(POSTCODE1 == null)    POSTCODE1 = "";//账单寄送地址String ADDRESS1 = Sqlca.getString("select getItemName('CountryCode',Country)||getItemName('AreaCode',city)||address1 from pub_address_info where objectno='"+CUSTOMERID+"' and objecttype='jbo.customer.CUSTOMER_INFO' and (addresstype='"+billAddressType+"' or '"+billAddressType+"' is null) order by isnew desc,updatedate desc,inputdate desc ");if(ADDRESS1 == null) ADDRESS1 = "";		//收件人String RECEIVER = Sqlca.getString("select customername from customer_info where customerid = '"+CUSTOMERID+"' ");if(RECEIVER == null)    RECEIVER = "";//机构号String ORGID = Sqlca.getString("select OPERATEORGID from ACCT_LOAN where SerialNo = '"+DSerialNo+"'");if(ORGID == null)    ORGID = "";//银行联系地址String ADDRESS2 = Sqlca.getString("select ORGADD from org_info where ORGID = '"+ORGID+"'");if(ADDRESS2 == null)    ADDRESS2 = "";//邮编String POSTCODE2 = Sqlca.getString("select ZIPCODE from org_info where ORGID = '"+ORGID+"'");if(POSTCODE2 == null)    POSTCODE2 = "";//电话String TEL2 = Sqlca.getString("select ORGTEL from org_info where ORGID = '"+ORGID+"'");if(TEL2 == null)    TEL2 = "";//申请人String BORROWER1 = Sqlca.getString("select CUSTOMERNAME from ACCT_LOAN where SerialNo = '"+DSerialNo+"'");//if(BORROWER1 == null)    BORROWER1 = "";//担保合同编号String GCSERIALNO = Sqlca.getString("select OBJECTNO from contract_relative where objecttype = 'jbo.guaranty.GUARANTY_CONTRACT' and contractserialno = '"+DContractSerialNo+"'");if(GCSERIALNO == null)    GCSERIALNO = "";//出质人String ASSURER1 = Sqlca.getString("select GUARANTORNAME from guaranty_contract where SerialNo = '"+GCSERIALNO+"'");if(ASSURER1 == null)    ASSURER1 = "";//业务类型或合同名String CONTRACTNAME1 = Sqlca.getString("select ProductName from PRD_PRODUCT_LIBRARY where productID = (select BUSINESSTYPE from ACCT_LOAN where SerialNo = '"+DSerialNo+"')");if(CONTRACTNAME1 == null)    CONTRACTNAME1 = "";//贷款本金String LNAMT1 = DataConvert.toMoney(Sqlca.getString("select businesssum from ACCT_LOAN where serialno ='"+DSerialNo+"'"));if(LNAMT1 == null)    LNAMT1 = "";//截止日期String DATE4 = DateHelper.getRelativeDate(DateHelper.getBusinessDate(),"D",-1) ;if(DATE4 == null) DATE4 = "";//年String YEAR4 = "";//月String MONTH4 = "";//日String DAY4 = "";try{	YEAR4 = DATE4.substring(0, 4);	MONTH4 = DATE4.substring(5, 7);	DAY4 = DATE4.substring(8, 10);}catch(StringIndexOutOfBoundsException e){	e.printStackTrace();}//本金Double LNAMT2d = LoanHelper.getSubledgerBalance("jbo.acct.ACCT_LOAN",DSerialNo,"Customer02");if(LNAMT2d == null) LNAMT2d = 0.0;//利息(包含罚息)Double INTERESTd = LoanHelper.getSubledgerBalance("jbo.acct.ACCT_LOAN",DSerialNo,"Customer12") + LoanHelper.getSubledgerBalance("jbo.acct.ACCT_LOAN",DSerialNo,"Customer13");if(INTERESTd == null) INTERESTd = 0.0;//罚息Double PINTERESTd = LoanHelper.getSubledgerBalance("jbo.acct.ACCT_LOAN",SERIALNO,"Customer13");if(PINTERESTd == null) PINTERESTd = 0.0;double TOTAMTd = LNAMT2d + INTERESTd;//总共String TOTAMT = DataConvert.toMoney(TOTAMTd);String LNAMT2 = DataConvert.toMoney(LNAMT2d);String INTEREST = DataConvert.toMoney(INTERESTd);String PINTEREST = DataConvert.toMoney(PINTERESTd);//上海浦东发展银行String SUBBRNAME = Sqlca.getString("select ORGNAME from org_info where orgid in (select OPERATEORGID from coll_task where objecttype = 'jbo.app.BUSINESS_CONTRACT' and objectno = '"+DContractSerialNo+"')");if(SUBBRNAME == null) SUBBRNAME = "";//输入日期String DATE5 = com.amarsoft.app.base.util.DateHelper.getBusinessDate();if(DATE5 == null) DATE5 = "";//年String YEAR5 = "";//月String MONTH5 = "";//日String DAY5 = "";try{	YEAR5 = DATE5.substring(0, 4);	MONTH5 = DATE5.substring(5, 7);	DAY5 = DATE5.substring(8, 10);}catch(StringIndexOutOfBoundsException e){	e.printStackTrace();}%>
<body lang=ZH-CN style='tab-interval:21.0pt;text-justify-trim:punctuation'>

<div class=Section1 style='layout-grid:15.6pt' align="center">

<table class=MsoTableGrid border=0 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;mso-yfti-tbllook:480;mso-padding-alt:0cm 5.4pt 0cm 5.4pt'>
 <tr style='mso-yfti-irow:0'>
  <td width=581 valign=top style='width:435.75pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=left style='text-align:left;line-height:200%;
  mso-layout-grid-align:none;text-autospace:none'><span style='mso-bidi-font-size:
  10.5pt;line-height:200%;font-family:楷体_GB2312;mso-bidi-font-family:华文楷体;
  mso-font-kerning:0pt;mso-ansi-language:ZH-CN'>邮编： </span><span lang=EN-US
  style='font-size:10.0pt;line-height:200%;font-family:华文楷体'><%=POSTCODE1%></span><span
  style='mso-bidi-font-size:10.5pt;line-height:200%;font-family:楷体_GB2312;
  mso-bidi-font-family:华文楷体;mso-font-kerning:0pt;mso-ansi-language:ZH-CN'><o:p></o:p></span></p>
  <p class=MsoNormal align=left style='text-align:left;line-height:200%;
  mso-layout-grid-align:none;text-autospace:none'><span style='mso-bidi-font-size:
  10.5pt;line-height:200%;font-family:楷体_GB2312;mso-bidi-font-family:华文楷体;
  mso-font-kerning:0pt;mso-ansi-language:ZH-CN'>地址： </span><span lang=EN-US
  style='font-size:10.0pt;line-height:200%;font-family:华文楷体'><%=ADDRESS1%></span><span
  style='mso-bidi-font-size:10.5pt;line-height:200%;font-family:楷体_GB2312;
  mso-bidi-font-family:华文楷体;mso-font-kerning:0pt;mso-ansi-language:ZH-CN'><o:p></o:p></span></p>
  <p class=MsoNormal align=left style='text-align:left;line-height:200%;
  mso-layout-grid-align:none;text-autospace:none'><span style='mso-bidi-font-size:
  10.5pt;line-height:200%;font-family:楷体_GB2312;mso-bidi-font-family:华文楷体;
  mso-font-kerning:0pt;mso-ansi-language:ZH-CN'>收件人：</span><span lang=EN-US
  style='font-size:10.0pt;line-height:200%;font-family:华文楷体'><%=RECEIVER%></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt;line-height:200%;font-family:
  楷体_GB2312;mso-bidi-font-family:华文楷体;mso-font-kerning:0pt;mso-ansi-language:
  ZH-CN'> <o:p></o:p></span></p>
  <p class=MsoNormal align=left style='text-align:left;mso-layout-grid-align:
  none;text-autospace:none'><span style='font-size:12.0pt;mso-bidi-font-size:
  14.0pt;font-family:楷体_GB2312;mso-hansi-font-family:华文楷体'>银行联系地址：</span><span
  lang=EN-US style='font-size:10.0pt;font-family:华文楷体'><%=ADDRESS2%> <o:p></o:p></span></p>
  <p class=MsoNormal align=left style='text-align:left;mso-layout-grid-align:
  none;text-autospace:none'><span style='font-size:12.0pt;mso-bidi-font-size:
  14.0pt;font-family:楷体_GB2312;mso-hansi-font-family:华文楷体;color:black'>邮编：</span><span
  lang=EN-US style='font-size:10.0pt;font-family:华文楷体'><%=POSTCODE2%></span><span
  lang=EN-US style='font-size:12.0pt;mso-bidi-font-size:14.0pt;font-family:
  楷体_GB2312;mso-hansi-font-family:华文楷体;color:black'> <o:p></o:p></span></p>
  <p class=MsoNormal align=left style='text-align:left;mso-layout-grid-align:
  none;text-autospace:none'><span style='font-size:12.0pt;mso-bidi-font-size:
  14.0pt;font-family:楷体_GB2312;mso-hansi-font-family:华文楷体;color:black'>电话：</span><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-bidi-font-family:
  华文楷体;mso-font-kerning:0pt;mso-ansi-language:ZH-CN'> </span><span lang=EN-US
  style='font-size:10.0pt;font-family:华文楷体'><%=TEL2%><o:p></o:p></span></p>
  <p class=MsoNormal align=left style='text-align:left;mso-layout-grid-align:
  none;text-autospace:none'><span style='mso-bidi-font-size:10.5pt;font-family:
  楷体_GB2312;mso-bidi-font-family:华文楷体;mso-font-kerning:0pt;mso-ansi-language:
  ZH-CN'>-------------------------------------------------------------------------<o:p></o:p></span></p>
  <p class=MsoNormal align=center style='text-align:center;line-height:150%;
  layout-grid-mode:char'><span style='font-size:11.0pt;mso-bidi-font-size:9.0pt;
  line-height:150%;font-family:华文楷体;mso-bidi-font-weight:bold'>逾期贷款催收通知书</span></span></p>
  <p class=MsoNormal><span style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";
mso-hansi-font-family:"Times New Roman"'>（借款人</span><span lang=EN-US>/</span><span
style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>申请人）</span><span lang=EN-US style='font-size:10.0pt;
font-family:华文楷体'><%=BORROWER1%></span><span style='font-family:华文楷体;mso-ascii-font-family:
"Times New Roman";mso-hansi-font-family:"Times New Roman"'>：</span></p>

<p class=MsoNormal><span style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";
mso-hansi-font-family:"Times New Roman"'>（保证人</span><span lang=EN-US>/</span><span
style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>抵押人</span><span lang=EN-US>/</span><span style='font-family:
华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>出质人）</span><span
lang=EN-US style='font-size:10.0pt;font-family:华文楷体'><%=ASSURER1%></span><span
style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>：</span></p>

<p class=MsoNormal><span lang=EN-US><span
style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span
style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>根据（借款人</span><span lang=EN-US>/</span><span
style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>申请人）</span><span lang=EN-US style='font-size:10.0pt;
font-family:华文楷体'><%=BORROWER1%></span><span style='font-family:华文楷体;mso-ascii-font-family:
"Times New Roman";mso-hansi-font-family:"Times New Roman"'>与我行签订的</span><span
lang=EN-US style='font-size:10.0pt;font-family:华文楷体'><%=CONTRACTNAME1%></span><span
style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>；我行向</span><span lang=EN-US style='font-size:
10.0pt;font-family:华文楷体'><%=BORROWER1%></span><span style='font-family:华文楷体;
mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>（借款人）提供了</span><span
lang=EN-US style='font-size:10.0pt;font-family:华文楷体'><%=CONTRACTNAME1%></span><span
style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>（贷款品种）贷款本金</span><span lang=EN-US style='font-size:10.0pt;
font-family:华文楷体'><%=LNAMT1%></span><span style='font-family:华文楷体;mso-ascii-font-family:
"Times New Roman";mso-hansi-font-family:"Times New Roman"'>元。截止</span><span
lang=EN-US style='font-size:10.0pt;font-family:华文楷体'><%=YEAR4%></span><span
style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>年</span><span lang=EN-US style='font-size:10.0pt;font-family:
华文楷体'><%=MONTH4%></span><span style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";
mso-hansi-font-family:"Times New Roman"'>月</span><span lang=EN-US
style='font-size:10.0pt;font-family:华文楷体'><%=DAY4%></span><span style='font-family:
华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>日止，上述贷款尚有</span><span
lang=EN-US style='font-size:10.0pt;font-family:华文楷体'><%=LNAMT2%></span><span
style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>元本金、</span><span lang=EN-US style='font-size:10.0pt;
font-family:华文楷体'><%=INTEREST%></span><span style='font-family:华文楷体;mso-ascii-font-family:
"Times New Roman";mso-hansi-font-family:"Times New Roman"'>元利息（<span
class=GramE>含罚息</span></span><span lang=EN-US style='font-size:10.0pt;
font-family:华文楷体'><%=PINTEREST%></span><span style='font-family:华文楷体;mso-ascii-font-family:
"Times New Roman";mso-hansi-font-family:"Times New Roman"'>元）总共</span><span
lang=EN-US style='font-size:10.0pt;font-family:华文楷体'><%=TOTAMT%></span><span
style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>元逾期未还。</span></p>

<p class=MsoNormal><span lang=EN-US><span
style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";
mso-hansi-font-family:"Times New Roman"'>在此我行严正通知借款人：你的逾期行为已违反了相关合同约定，你必须于接到本通知之日起</span><span
lang=EN-US>___5__</span><span class=GramE><span style='font-family:华文楷体;
mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>个</span></span><span
style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>工作日内履行所承担的还款责任，清偿所欠本金、利息和罚息。若继续逾期不还，在承担违约责任的同时，你的个人信用将受到影响。</span></p>

<p class=MsoNormal><span lang=EN-US><span
style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";
mso-hansi-font-family:"Times New Roman"'>根据（保证人</span><span lang=EN-US>/</span><span
style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>抵押人</span><span lang=EN-US>/</span><span style='font-family:
华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>出质人）</span><span
lang=EN-US style='font-size:10.0pt;font-family:华文楷体'><%=ASSURER1%></span><span
style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>与我行签订的</span><span lang=EN-US>________________________________</span><span
style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>（填担保合同名称），由担保人（保证人</span><span lang=EN-US>/</span><span
style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>抵押人</span><span lang=EN-US>/</span><span style='font-family:
华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>出质人）为</span><span
lang=EN-US style='font-size:10.0pt;font-family:华文楷体'><%=BORROWER1%></span><span
style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>（借款人</span><span lang=EN-US>/</span><span style='font-family:
华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>申请人）提供担保。我行在此促请担保人收到本通知后督促借款人按前述期限向我行归还逾期贷款本息，否则我行将依法要求担保人承担担保责任。</span></p>

<p class=MsoNormal><span lang=EN-US><span
style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";
mso-hansi-font-family:"Times New Roman"'>敬请关注！</span></p>

<p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span lang=EN-US><span
style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span><div align="right"><span
style='mso-spacerun:yes'></span></span><span
style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>上海浦东发展银行</span><span lang=EN-US style='font-size:10.0pt;
font-family:华文楷体'><%=SUBBRNAME%></span><span style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'></span></div></p><p class=MsoNormal align="right"><span lang=EN-US><span
style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span><span
style='mso-spacerun:yes'></span></span><span
lang=EN-US style='font-size:10.0pt;font-family:华文楷体'><%=YEAR5%></span><span
style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>年</span><span lang=EN-US style='font-size:10.0pt;font-family:
华文楷体'><%=MONTH5%></span><span style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";
mso-hansi-font-family:"Times New Roman"'>月</span><span lang=EN-US
style='font-size:10.0pt;font-family:华文楷体'><%=DAY5%></span><span style='font-family:
华文楷体;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>日</span></p>

<p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-family:华文楷体;mso-ascii-font-family:"Times New Roman";
mso-hansi-font-family:"Times New Roman"'>注：本通知一式三份，一份送借款人，一份送担保人，一份贷款行留档备查。</span></p>
 </td>
 </tr>
 
 
 <tr style='mso-yfti-irow:1;mso-yfti-lastrow:yes'>
  <td width=581 valign=top style='width:435.75pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=left style='text-align:left;line-height:200%;
  mso-layout-grid-align:none;text-autospace:none'><span style='mso-bidi-font-size:
  10.5pt;line-height:200%;font-family:楷体_GB2312;mso-bidi-font-family:华文楷体;
  mso-font-kerning:0pt;mso-ansi-language:ZH-CN'>..<o:p></o:p></span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p>

</div><table align="center">	<tr>			<td id="print"><%=HTMLControls.generateButton("打印", "打印", "printPaper()", "") %></td>	</tr></table></body><script>   function printPaper(){	   var print = document.getElementById("print");	   if(window.confirm("是否确定要打印？")){		   //打印	  		   print.style.display = "none";		   window.print();			   window.close();	   }   }</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
