<%@ page contentType="text/html; charset=GBK"%><%@ include file="/Frame/resources/include/include_begin.jspf"%><%@ page import="com.amarsoft.app.als.common.util.DateHelper"%><%	String CINO = DataConvert.toString(CurPage.getParameter("SerialNo"));//��ȡҳ�洫�����Ľ�ݺ�	String transSerialNo = DataConvert.toString(CurPage.getParameter("TransSerialNo"));//��ȡҳ�洫�����Ľ�ݺ�		if(CINO == null)     CINO = "";//6501202110082701	String NAME = Sqlca.getString("select CUSTOMERNAME from business_duebill where serialno = '"+CINO+"'");// ������	if(NAME == null)     NAME = "";	String BRCODENO = Sqlca.getString("select MFORGID from business_duebill where serialno = '"+CINO+"'");// Ӫҵ������	if(BRCODENO == null)     BRCODENO = "";	String loantype = Sqlca.getString("select loantype from business_duebill where SERIALNO = '"+CINO+"'");	if(loantype == null)   loantype = "";	String BUSINESSTYPE = Sqlca.getString("select typename from business_type where typeno in (select BUSINESSTYPE from business_duebill where SERIALNO = '"+CINO+"') ");	if(BUSINESSTYPE == null)   BUSINESSTYPE = "";	String LNNAME = loantype +"-"+ BUSINESSTYPE;		String RTNBAL="",APPNO="",TXDATE="",THIRDPARTYACCOUNT="",ACCOUNTNAME="",PAYACCOUNTTYPE="";	String sSql = "select atp.PREPAYPRINCIPALAMT as RTNBAL,act.SERIALNO as APPNO,act.ACCOUNTINGDATE as TXDATE,atp.PAYACCOUNTNO as PAYACCOUNTNO ,atp.PAYACCOUNTNO1 as PAYACCOUNTNO1,"+			" atp.PAYACCOUNTNAME as PAYACCOUNTNAME, atp.PAYACCOUNTTYPE as PAYACCOUNTTYPE from ACCT_TRANS_PAYMENT atp,ACCT_TRANSACTION act where"+			" atp.SerialNo=act.DocumentObjectNo and act.RelativeObjectNo =:RelativeObjectNo and  act.DocumentObjectType='jbo.acct.ACCT_TRANS_PAYMENT'"+			" and act.TRANSACTIONCODE= '0020' and act.SerialNo=:TransSerialNo";		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("RelativeObjectNo", CINO).setParameter("TransSerialNo", transSerialNo));	while(rs.next()){		RTNBAL = DataConvert.toMoney(String.valueOf(rs.getDouble("RTNBAL")));//��ǰ�黹����		APPNO = rs.getString("APPNO");//ǰ̨������ˮ		APPNO= APPNO.substring(2, 8)+APPNO.substring(10, 16);		TXDATE = rs.getString("TXDATE");//��������		THIRDPARTYACCOUNT = rs.getString("PAYACCOUNTNO1");// �����ʺ�		if(THIRDPARTYACCOUNT == null || "".equals(THIRDPARTYACCOUNT)) THIRDPARTYACCOUNT = rs.getString("PAYACCOUNTNO");// �����ʺ�		ACCOUNTNAME = rs.getString("PAYACCOUNTNAME");// �˻�����		PAYACCOUNTTYPE = rs.getString("PAYACCOUNTTYPE");//�����˺�����	}	rs.getStatement().close();	if(RTNBAL == null)    RTNBAL = "";	if(APPNO == null)    APPNO = "";	if(TXDATE == null)    TXDATE = "";	if(THIRDPARTYACCOUNT == null)    THIRDPARTYACCOUNT = "";	if(ACCOUNTNAME == null)    ACCOUNTNAME = "";	if(PAYACCOUNTTYPE == null)    PAYACCOUNTTYPE = "";			String THIRDPARTYRTNMODE = Sqlca.getString("select itemname from code_library where codeno = 'PrepaymentType' "+						"and itemno =( select PREPAYTYPE from acct_trans_payment where serialno = '"+APPNO+"')");// ���˷�ʽ	if(THIRDPARTYRTNMODE == null)     THIRDPARTYRTNMODE = "0-�����𻹿�";	String THIRDPARTYTYPE = Sqlca.getString("select Attribute3||'-'|| case when itemno = '7' then itemname||'(�Թ��˻�)' else itemname end from code_library where codeno = 'AccountType' "+						"and itemno ='"+PAYACCOUNTTYPE+"'");//�����˺�����	if(THIRDPARTYTYPE == null)     THIRDPARTYTYPE = "";	String DATE = StringFunction.getToday();//��ӡ����%><style>*{font-size: 15px}</style>
<body lang=ZH-CN style='tab-interval:21.0pt;text-justify-trim:punctuation'>

<div class=Section1 style='layout-grid:15.6pt' align="center">

<p class=MsoNormal style='margin-left:-35.9pt;text-indent:35.9pt'><span
lang=EN-US>&nbsp;<o:p></o:p></span></p>

<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=639
 style='width:479.25pt;margin-left:5.4pt;border-collapse:collapse;mso-padding-alt:
 0cm 0cm 0cm 0cm' height=727>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;height:51.75pt'>
  <td width=639 colspan=4 style='width:479.25pt;border:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;background:#AAAAAA;padding:0cm 5.4pt 0cm 5.4pt;
  height:51.75pt'>
  <p class=MsoNormal align=center style='text-align:center'><b><span
  style='font-size:12.0pt;font-family:����;mso-bidi-font-family:����'>���˴���������˻���ǰ����֪ͨ��
  </span></b><span lang=EN-US style='font-size:12.0pt;font-family:����;
  mso-bidi-font-family:����'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1;height:16.5pt'>
  <td width=639 colspan=4 style='width:479.25pt;border-top:none;border-left:
  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:16.5pt'>
  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US
  style='font-size:11.0pt;font-family:����;mso-bidi-font-family:����'>&nbsp;</span><span
  lang=EN-US style='font-size:12.0pt;font-family:����;mso-bidi-font-family:����'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2;height:33.0pt'>
  <td width=639 colspan=4 style='width:479.25pt;border-top:none;border-left:
  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:33.0pt'>
  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US
  style='font-size:11.0pt;font-family:����;mso-bidi-font-family:����'>__________</span><span
  style='font-size:11.0pt;font-family:����;mso-bidi-font-family:����'>��������Ʋ��ţ�<span
  lang=EN-US>&nbsp;</span></span><span lang=EN-US style='font-size:12.0pt;
  font-family:����;mso-bidi-font-family:����'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;height:62.25pt'>
  <td width=639 colspan=4 style='width:479.25pt;border-top:none;border-left:
  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:62.25pt'>
  <p class=MsoNormal><u><span lang=EN-US style='font-family:����'><%=NAME%></span></u><span
  style='font-family:����'>�������ˣ���<u><span lang=EN-US><%=LNNAME%></span></u>��ǰ��������</span></p>
  <p class=MsoNormal><span style='font-family:����'>�Ѿ�������ҵ���������򱨾���Ȩ����������ͬ�⣬���㲿���ձ�֪ͨ��Ҫ�󣬰�����ǰ����<span
  class=GramE>����</span>������</span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;height:15.0pt'>
  <td width=639 colspan=4 style='width:479.25pt;border-top:none;border-left:
  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=left style='text-align:left'><span style='font-size:
  12.0pt;font-family:����;mso-bidi-font-family:����'>��<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;height:15.0pt'>
  <td width=136 style='width:101.85pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-family:����'>Ӫҵ������</span></p>
  </td>
  <td width=157 style='width:118.1pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:����_GB2312;
  mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-family:����_GB2312'><%=BRCODENO%></span></p>
  </td>
  <td width=133 style='width:99.55pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-family:����'></span></p>
  </td>
  <td width=213 style='width:159.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:����_GB2312;
  mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-family:����_GB2312'></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;height:15.0pt'>
  <td width=136 style='width:101.85pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-family:����'>��ݺ�</span></p>
  </td>
  <td width=157 style='width:118.1pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:����_GB2312;
  mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-family:����_GB2312'><%=CINO%></span></p>
  </td>
  <td width=133 style='width:99.55pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-family:����'>��ǰ�黹����</span></p>
  </td>
  <td width=213 style='width:159.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:����_GB2312;
  mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-family:����_GB2312'><%=RTNBAL%></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;height:15.0pt'>
  <td width=136 style='width:101.85pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-family:����'>ǰ̨������ˮ</span></p>
  </td>
  <td width=157 style='width:118.1pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:����_GB2312;
  mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-family:����_GB2312'><%=APPNO%></span></p>
  </td>
  <td width=133 style='width:99.55pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-family:����'>��������</span></p>
  </td>
  <td width=213 style='width:159.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:����_GB2312;
  mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-family:����_GB2312'><%=TXDATE%></span></p>
  </td>
 </tr>
<tr style='mso-yfti-irow:7;height:15.0pt'>
  <td width=136 style='width:101.85pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-family:����;mso-ascii-font-family:"Times New Roman";
  mso-hansi-font-family:"Times New Roman"'>��ǰ����<span class=GramE>���˷�ʽ</span></span></p>
  </td>
  <td width=157 style='width:118.1pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:����_GB2312;
  mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-family:����_GB2312'><%=THIRDPARTYRTNMODE%></span><span lang=EN-US
  style='mso-bidi-font-size:10.0pt;font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=133 style='width:99.55pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-family:����;mso-ascii-font-family:"Times New Roman";
  mso-hansi-font-family:"Times New Roman";color:black'>�����˺�����</span></p>
  </td>
  <td width=213 style='width:159.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:����_GB2312;
  mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-family:����_GB2312'><%=THIRDPARTYTYPE%></span><span lang=EN-US
  style='mso-bidi-font-size:10.0pt;font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:7;height:15.0pt'>
  <td width=136 style='width:101.85pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-family:����;mso-ascii-font-family:"Times New Roman";
  mso-hansi-font-family:"Times New Roman"'>����<span class=GramE>�ʺ�</span></span></p>
  </td>
  <td width=157 style='width:118.1pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:����_GB2312;
  mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-family:����_GB2312'><%=THIRDPARTYACCOUNT%></span><span lang=EN-US
  style='mso-bidi-font-size:10.0pt;font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=133 style='width:99.55pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-family:����;mso-ascii-font-family:"Times New Roman";
  mso-hansi-font-family:"Times New Roman";color:black'>�˻�����</span></p>
  </td>
  <td width=213 style='width:159.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:����_GB2312;
  mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-family:����_GB2312'><%=ACCOUNTNAME%></span><span lang=EN-US
  style='mso-bidi-font-size:10.0pt;font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:8;height:15.0pt'>
  <td width=639 colspan=4 valign=top style='width:479.25pt;border-top:none;
  border-left:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;
  border-right:solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:12.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:9;height:169.5pt'>
  <td width=639 colspan=4 valign=top style='width:479.25pt;border-top:none;
  border-left:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;
  border-right:solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:169.5pt'>
  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:����;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>��</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:����;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>��</span></p>
  <p class=MsoNormal><span lang=EN-US style='font-size:14.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US
  style='font-size:14.0pt;mso-ascii-font-family:����_GB2312;mso-fareast-font-family:
  ����_GB2312'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span
  lang=EN-US style='font-size:14.0pt;font-family:����_GB2312'> </span><span
  lang=EN-US style='font-size:14.0pt;mso-ascii-font-family:����_GB2312;
  mso-fareast-font-family:����_GB2312'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span
  lang=EN-US style='font-size:11.0pt;mso-ascii-font-family:����_GB2312;
  mso-fareast-font-family:����_GB2312'>&nbsp;&nbsp;</span><span lang=EN-US
  style='font-size:11.0pt;font-family:����'>&nbsp;</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:����'>������ǩ�֣�<span
  lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span><span lang=EN-US style='font-size:11.0pt;font-family:����'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span><!--span style='font-size:11pt;font-family:����'>������Աǩ�֣�</span--></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US
  style='font-size:11.0pt;font-family:����'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:����;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>��</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:����;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>��</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:����;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>��</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US
  style='font-size:11.0pt;font-family:����'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span><span style='font-size:11.0pt;font-family:����'>���ڣ�<span lang=EN-US><%=DATE%></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:10;mso-yfti-lastrow:yes;height:80.25pt'>
  <td width=639 colspan=4 style='width:479.25pt;border:solid windowtext 1.5pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:80.25pt'>
  <p class=MsoNormal><span style='font-size:15.0px;font-family:����;color:black'>����֪ͨ�鹲���������ͻ�������ƺ��ĵ�����Ա��һ�ݣ�</span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal><span lang=EN-US style='font-size:12.0pt;mso-ascii-font-family:
����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span></p>

</div>
<table align="center">
	<tr>			<td id="print"><%=HTMLControls.generateButton("��ӡ", "��ӡ", "printPaper()", "") %></td>	</tr></table></body><script>   function printPaper(){	   var print = document.getElementById("print");	   if(window.confirm("�Ƿ�ȷ��Ҫ��ӡ��")){		   //��ӡ	  		   print.style.display = "none";		   window.print();			   window.close();	   }   }</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
