<%@ page contentType="text/html; charset=GBK"%><%@ include file="/Frame/resources/include/include_begin.jspf"%><%@ page import="com.amarsoft.app.base.util.DateHelper"%><%@ page import="com.amarsoft.app.accounting.util.LoanHelper" %><%String SERIALNO = DataConvert.toString(CurPage.getParameter("SerialNo"));//��ȡҳ�洫�����Ĵ���������ˮ��//��ݺ�String DSerialNo = Sqlca.getString("select objectno from coll_task where serialno = '"+SERIALNO+"'");if(DSerialNo == null)    DSerialNo = "";//��ͬ��String DContractSerialNo = Sqlca.getString("select ContractSerialNo from ACCT_LOAN where serialno = '"+DSerialNo+"'");if(DContractSerialNo == null)    DContractSerialNo = "";//�ͻ����String CUSTOMERID = Sqlca.getString("select CUSTOMERID from ACCT_LOAN where serialno = '"+DSerialNo+"'");if(CUSTOMERID == null)    CUSTOMERID = "";String billAddressType = Sqlca.getString("select BillAddressType from BUSINESS_CONTRACT where serialno = '"+DContractSerialNo+"'");if(billAddressType == null) billAddressType = "";//�ʱ�String POSTCODE1 = Sqlca.getString("select ZipCode from pub_address_info where objectno='"+CUSTOMERID+"' and objecttype='jbo.customer.CUSTOMER_INFO' and (addresstype='"+billAddressType+"' or '"+billAddressType+"' is null) order by isnew desc,updatedate desc,inputdate desc ");if(POSTCODE1 == null)    POSTCODE1 = "";//�˵����͵�ַString ADDRESS1 = Sqlca.getString("select getItemName('CountryCode',Country)||getItemName('AreaCode',city)||address1 from pub_address_info where objectno='"+CUSTOMERID+"' and objecttype='jbo.customer.CUSTOMER_INFO' and (addresstype='"+billAddressType+"' or '"+billAddressType+"' is null) order by isnew desc,updatedate desc,inputdate desc ");if(ADDRESS1 == null) ADDRESS1 = "";		//�ռ���String RECEIVER = Sqlca.getString("select customername from customer_info where customerid = '"+CUSTOMERID+"' ");if(RECEIVER == null)    RECEIVER = "";//������String ORGID = Sqlca.getString("select OPERATEORGID from ACCT_LOAN where SerialNo = '"+DSerialNo+"'");if(ORGID == null)    ORGID = "";//������ϵ��ַString ADDRESS2 = Sqlca.getString("select ORGADD from org_info where ORGID = '"+ORGID+"'");if(ADDRESS2 == null)    ADDRESS2 = "";//�ʱ�String POSTCODE2 = Sqlca.getString("select ZIPCODE from org_info where ORGID = '"+ORGID+"'");if(POSTCODE2 == null)    POSTCODE2 = "";//�绰String TEL2 = Sqlca.getString("select ORGTEL from org_info where ORGID = '"+ORGID+"'");if(TEL2 == null)    TEL2 = "";//������String BORROWER1 = Sqlca.getString("select CUSTOMERNAME from ACCT_LOAN where SerialNo = '"+DSerialNo+"'");//if(BORROWER1 == null)    BORROWER1 = "";//������ͬ���String GCSERIALNO = Sqlca.getString("select OBJECTNO from contract_relative where objecttype = 'jbo.guaranty.GUARANTY_CONTRACT' and contractserialno = '"+DContractSerialNo+"'");if(GCSERIALNO == null)    GCSERIALNO = "";//������String ASSURER1 = Sqlca.getString("select GUARANTORNAME from guaranty_contract where SerialNo = '"+GCSERIALNO+"'");if(ASSURER1 == null)    ASSURER1 = "";//ҵ�����ͻ��ͬ��String CONTRACTNAME1 = Sqlca.getString("select ProductName from PRD_PRODUCT_LIBRARY where productID = (select BUSINESSTYPE from ACCT_LOAN where SerialNo = '"+DSerialNo+"')");if(CONTRACTNAME1 == null)    CONTRACTNAME1 = "";//�����String LNAMT1 = DataConvert.toMoney(Sqlca.getString("select businesssum from ACCT_LOAN where serialno ='"+DSerialNo+"'"));if(LNAMT1 == null)    LNAMT1 = "";//��ֹ����String DATE4 = DateHelper.getRelativeDate(DateHelper.getBusinessDate(),"D",-1) ;if(DATE4 == null) DATE4 = "";//��String YEAR4 = "";//��String MONTH4 = "";//��String DAY4 = "";try{	YEAR4 = DATE4.substring(0, 4);	MONTH4 = DATE4.substring(5, 7);	DAY4 = DATE4.substring(8, 10);}catch(StringIndexOutOfBoundsException e){	e.printStackTrace();}//����Double LNAMT2d = LoanHelper.getSubledgerBalance("jbo.acct.ACCT_LOAN",DSerialNo,"Customer02");if(LNAMT2d == null) LNAMT2d = 0.0;//��Ϣ(������Ϣ)Double INTERESTd = LoanHelper.getSubledgerBalance("jbo.acct.ACCT_LOAN",DSerialNo,"Customer12") + LoanHelper.getSubledgerBalance("jbo.acct.ACCT_LOAN",DSerialNo,"Customer13");if(INTERESTd == null) INTERESTd = 0.0;//��ϢDouble PINTERESTd = LoanHelper.getSubledgerBalance("jbo.acct.ACCT_LOAN",SERIALNO,"Customer13");if(PINTERESTd == null) PINTERESTd = 0.0;double TOTAMTd = LNAMT2d + INTERESTd;//�ܹ�String TOTAMT = DataConvert.toMoney(TOTAMTd);String LNAMT2 = DataConvert.toMoney(LNAMT2d);String INTEREST = DataConvert.toMoney(INTERESTd);String PINTEREST = DataConvert.toMoney(PINTERESTd);//�Ϻ��ֶ���չ����String SUBBRNAME = Sqlca.getString("select ORGNAME from org_info where orgid in (select OPERATEORGID from coll_task where objecttype = 'jbo.app.BUSINESS_CONTRACT' and objectno = '"+DContractSerialNo+"')");if(SUBBRNAME == null) SUBBRNAME = "";//��������String DATE5 = com.amarsoft.app.base.util.DateHelper.getBusinessDate();if(DATE5 == null) DATE5 = "";//��String YEAR5 = "";//��String MONTH5 = "";//��String DAY5 = "";try{	YEAR5 = DATE5.substring(0, 4);	MONTH5 = DATE5.substring(5, 7);	DAY5 = DATE5.substring(8, 10);}catch(StringIndexOutOfBoundsException e){	e.printStackTrace();}%>
<body lang=ZH-CN style='tab-interval:21.0pt;text-justify-trim:punctuation'>

<div class=Section1 style='layout-grid:15.6pt' align="center">

<table class=MsoTableGrid border=0 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;mso-yfti-tbllook:480;mso-padding-alt:0cm 5.4pt 0cm 5.4pt'>
 <tr style='mso-yfti-irow:0'>
  <td width=581 valign=top style='width:435.75pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=left style='text-align:left;line-height:200%;
  mso-layout-grid-align:none;text-autospace:none'><span style='mso-bidi-font-size:
  10.5pt;line-height:200%;font-family:����_GB2312;mso-bidi-font-family:���Ŀ���;
  mso-font-kerning:0pt;mso-ansi-language:ZH-CN'>�ʱࣺ </span><span lang=EN-US
  style='font-size:10.0pt;line-height:200%;font-family:���Ŀ���'><%=POSTCODE1%></span><span
  style='mso-bidi-font-size:10.5pt;line-height:200%;font-family:����_GB2312;
  mso-bidi-font-family:���Ŀ���;mso-font-kerning:0pt;mso-ansi-language:ZH-CN'><o:p></o:p></span></p>
  <p class=MsoNormal align=left style='text-align:left;line-height:200%;
  mso-layout-grid-align:none;text-autospace:none'><span style='mso-bidi-font-size:
  10.5pt;line-height:200%;font-family:����_GB2312;mso-bidi-font-family:���Ŀ���;
  mso-font-kerning:0pt;mso-ansi-language:ZH-CN'>��ַ�� </span><span lang=EN-US
  style='font-size:10.0pt;line-height:200%;font-family:���Ŀ���'><%=ADDRESS1%></span><span
  style='mso-bidi-font-size:10.5pt;line-height:200%;font-family:����_GB2312;
  mso-bidi-font-family:���Ŀ���;mso-font-kerning:0pt;mso-ansi-language:ZH-CN'><o:p></o:p></span></p>
  <p class=MsoNormal align=left style='text-align:left;line-height:200%;
  mso-layout-grid-align:none;text-autospace:none'><span style='mso-bidi-font-size:
  10.5pt;line-height:200%;font-family:����_GB2312;mso-bidi-font-family:���Ŀ���;
  mso-font-kerning:0pt;mso-ansi-language:ZH-CN'>�ռ��ˣ�</span><span lang=EN-US
  style='font-size:10.0pt;line-height:200%;font-family:���Ŀ���'><%=RECEIVER%></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt;line-height:200%;font-family:
  ����_GB2312;mso-bidi-font-family:���Ŀ���;mso-font-kerning:0pt;mso-ansi-language:
  ZH-CN'> <o:p></o:p></span></p>
  <p class=MsoNormal align=left style='text-align:left;mso-layout-grid-align:
  none;text-autospace:none'><span style='font-size:12.0pt;mso-bidi-font-size:
  14.0pt;font-family:����_GB2312;mso-hansi-font-family:���Ŀ���'>������ϵ��ַ��</span><span
  lang=EN-US style='font-size:10.0pt;font-family:���Ŀ���'><%=ADDRESS2%> <o:p></o:p></span></p>
  <p class=MsoNormal align=left style='text-align:left;mso-layout-grid-align:
  none;text-autospace:none'><span style='font-size:12.0pt;mso-bidi-font-size:
  14.0pt;font-family:����_GB2312;mso-hansi-font-family:���Ŀ���;color:black'>�ʱࣺ</span><span
  lang=EN-US style='font-size:10.0pt;font-family:���Ŀ���'><%=POSTCODE2%></span><span
  lang=EN-US style='font-size:12.0pt;mso-bidi-font-size:14.0pt;font-family:
  ����_GB2312;mso-hansi-font-family:���Ŀ���;color:black'> <o:p></o:p></span></p>
  <p class=MsoNormal align=left style='text-align:left;mso-layout-grid-align:
  none;text-autospace:none'><span style='font-size:12.0pt;mso-bidi-font-size:
  14.0pt;font-family:����_GB2312;mso-hansi-font-family:���Ŀ���;color:black'>�绰��</span><span
  style='mso-bidi-font-size:10.5pt;font-family:����_GB2312;mso-bidi-font-family:
  ���Ŀ���;mso-font-kerning:0pt;mso-ansi-language:ZH-CN'> </span><span lang=EN-US
  style='font-size:10.0pt;font-family:���Ŀ���'><%=TEL2%><o:p></o:p></span></p>
  <p class=MsoNormal align=left style='text-align:left;mso-layout-grid-align:
  none;text-autospace:none'><span style='mso-bidi-font-size:10.5pt;font-family:
  ����_GB2312;mso-bidi-font-family:���Ŀ���;mso-font-kerning:0pt;mso-ansi-language:
  ZH-CN'>-------------------------------------------------------------------------<o:p></o:p></span></p>
  <p class=MsoNormal align=center style='text-align:center;line-height:150%;
  layout-grid-mode:char'><span style='font-size:11.0pt;mso-bidi-font-size:9.0pt;
  line-height:150%;font-family:���Ŀ���;mso-bidi-font-weight:bold'>���ڴ������֪ͨ��</span></span></p>
  <p class=MsoNormal><span style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";
mso-hansi-font-family:"Times New Roman"'>�������</span><span lang=EN-US>/</span><span
style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>�����ˣ�</span><span lang=EN-US style='font-size:10.0pt;
font-family:���Ŀ���'><%=BORROWER1%></span><span style='font-family:���Ŀ���;mso-ascii-font-family:
"Times New Roman";mso-hansi-font-family:"Times New Roman"'>��</span></p>

<p class=MsoNormal><span style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";
mso-hansi-font-family:"Times New Roman"'>����֤��</span><span lang=EN-US>/</span><span
style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>��Ѻ��</span><span lang=EN-US>/</span><span style='font-family:
���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>�����ˣ�</span><span
lang=EN-US style='font-size:10.0pt;font-family:���Ŀ���'><%=ASSURER1%></span><span
style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>��</span></p>

<p class=MsoNormal><span lang=EN-US><span
style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span
style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>���ݣ������</span><span lang=EN-US>/</span><span
style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>�����ˣ�</span><span lang=EN-US style='font-size:10.0pt;
font-family:���Ŀ���'><%=BORROWER1%></span><span style='font-family:���Ŀ���;mso-ascii-font-family:
"Times New Roman";mso-hansi-font-family:"Times New Roman"'>������ǩ����</span><span
lang=EN-US style='font-size:10.0pt;font-family:���Ŀ���'><%=CONTRACTNAME1%></span><span
style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>��������</span><span lang=EN-US style='font-size:
10.0pt;font-family:���Ŀ���'><%=BORROWER1%></span><span style='font-family:���Ŀ���;
mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>������ˣ��ṩ��</span><span
lang=EN-US style='font-size:10.0pt;font-family:���Ŀ���'><%=CONTRACTNAME1%></span><span
style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>������Ʒ�֣������</span><span lang=EN-US style='font-size:10.0pt;
font-family:���Ŀ���'><%=LNAMT1%></span><span style='font-family:���Ŀ���;mso-ascii-font-family:
"Times New Roman";mso-hansi-font-family:"Times New Roman"'>Ԫ����ֹ</span><span
lang=EN-US style='font-size:10.0pt;font-family:���Ŀ���'><%=YEAR4%></span><span
style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>��</span><span lang=EN-US style='font-size:10.0pt;font-family:
���Ŀ���'><%=MONTH4%></span><span style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";
mso-hansi-font-family:"Times New Roman"'>��</span><span lang=EN-US
style='font-size:10.0pt;font-family:���Ŀ���'><%=DAY4%></span><span style='font-family:
���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>��ֹ��������������</span><span
lang=EN-US style='font-size:10.0pt;font-family:���Ŀ���'><%=LNAMT2%></span><span
style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>Ԫ����</span><span lang=EN-US style='font-size:10.0pt;
font-family:���Ŀ���'><%=INTEREST%></span><span style='font-family:���Ŀ���;mso-ascii-font-family:
"Times New Roman";mso-hansi-font-family:"Times New Roman"'>Ԫ��Ϣ��<span
class=GramE>����Ϣ</span></span><span lang=EN-US style='font-size:10.0pt;
font-family:���Ŀ���'><%=PINTEREST%></span><span style='font-family:���Ŀ���;mso-ascii-font-family:
"Times New Roman";mso-hansi-font-family:"Times New Roman"'>Ԫ���ܹ�</span><span
lang=EN-US style='font-size:10.0pt;font-family:���Ŀ���'><%=TOTAMT%></span><span
style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>Ԫ����δ����</span></p>

<p class=MsoNormal><span lang=EN-US><span
style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";
mso-hansi-font-family:"Times New Roman"'>�ڴ���������֪ͨ����ˣ����������Ϊ��Υ������غ�ͬԼ����������ڽӵ���֪֮ͨ����</span><span
lang=EN-US>___5__</span><span class=GramE><span style='font-family:���Ŀ���;
mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>��</span></span><span
style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>���������������е��Ļ������Σ��峥��Ƿ������Ϣ�ͷ�Ϣ�����������ڲ������ڳе�ΥԼ���ε�ͬʱ����ĸ������ý��ܵ�Ӱ�졣</span></p>

<p class=MsoNormal><span lang=EN-US><span
style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";
mso-hansi-font-family:"Times New Roman"'>���ݣ���֤��</span><span lang=EN-US>/</span><span
style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>��Ѻ��</span><span lang=EN-US>/</span><span style='font-family:
���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>�����ˣ�</span><span
lang=EN-US style='font-size:10.0pt;font-family:���Ŀ���'><%=ASSURER1%></span><span
style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>������ǩ����</span><span lang=EN-US>________________________________</span><span
style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>�������ͬ���ƣ����ɵ����ˣ���֤��</span><span lang=EN-US>/</span><span
style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>��Ѻ��</span><span lang=EN-US>/</span><span style='font-family:
���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>�����ˣ�Ϊ</span><span
lang=EN-US style='font-size:10.0pt;font-family:���Ŀ���'><%=BORROWER1%></span><span
style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>�������</span><span lang=EN-US>/</span><span style='font-family:
���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>�����ˣ��ṩ�����������ڴ˴��뵣�����յ���֪ͨ�󶽴ٽ���˰�ǰ�����������й黹���ڴ��Ϣ���������н�����Ҫ�󵣱��˳е��������Ρ�</span></p>

<p class=MsoNormal><span lang=EN-US><span
style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";
mso-hansi-font-family:"Times New Roman"'>�����ע��</span></p>

<p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span lang=EN-US><span
style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span><div align="right"><span
style='mso-spacerun:yes'></span></span><span
style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>�Ϻ��ֶ���չ����</span><span lang=EN-US style='font-size:10.0pt;
font-family:���Ŀ���'><%=SUBBRNAME%></span><span style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'></span></div></p><p class=MsoNormal align="right"><span lang=EN-US><span
style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span><span
style='mso-spacerun:yes'></span></span><span
lang=EN-US style='font-size:10.0pt;font-family:���Ŀ���'><%=YEAR5%></span><span
style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:
"Times New Roman"'>��</span><span lang=EN-US style='font-size:10.0pt;font-family:
���Ŀ���'><%=MONTH5%></span><span style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";
mso-hansi-font-family:"Times New Roman"'>��</span><span lang=EN-US
style='font-size:10.0pt;font-family:���Ŀ���'><%=DAY5%></span><span style='font-family:
���Ŀ���;mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>��</span></p>

<p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-family:���Ŀ���;mso-ascii-font-family:"Times New Roman";
mso-hansi-font-family:"Times New Roman"'>ע����֪ͨһʽ���ݣ�һ���ͽ���ˣ�һ���͵����ˣ�һ�ݴ������������顣</span></p>
 </td>
 </tr>
 
 
 <tr style='mso-yfti-irow:1;mso-yfti-lastrow:yes'>
  <td width=581 valign=top style='width:435.75pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=left style='text-align:left;line-height:200%;
  mso-layout-grid-align:none;text-autospace:none'><span style='mso-bidi-font-size:
  10.5pt;line-height:200%;font-family:����_GB2312;mso-bidi-font-family:���Ŀ���;
  mso-font-kerning:0pt;mso-ansi-language:ZH-CN'>..<o:p></o:p></span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p>

</div><table align="center">	<tr>			<td id="print"><%=HTMLControls.generateButton("��ӡ", "��ӡ", "printPaper()", "") %></td>	</tr></table></body><script>   function printPaper(){	   var print = document.getElementById("print");	   if(window.confirm("�Ƿ�ȷ��Ҫ��ӡ��")){		   //��ӡ	  		   print.style.display = "none";		   window.print();			   window.close();	   }   }</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
