<%@ page contentType="text/html; charset=GBK"%><%@ include file="/Frame/resources/include/include_begin.jspf"%><%@ page import="com.amarsoft.app.als.common.util.DateHelper"%><%	String CINO = DataConvert.toString(CurPage.getParameter("SerialNo"));//获取页面传过来的借据号	String transSerialNo = DataConvert.toString(CurPage.getParameter("TransSerialNo"));//获取页面传过来的借据号		if(CINO == null)     CINO = "";//6501202110082701	String NAME = Sqlca.getString("select CUSTOMERNAME from business_duebill where serialno = '"+CINO+"'");// 申请人	if(NAME == null)     NAME = "";	String BRCODENO = Sqlca.getString("select MFORGID from business_duebill where serialno = '"+CINO+"'");// 营业机构号	if(BRCODENO == null)     BRCODENO = "";	String loantype = Sqlca.getString("select loantype from business_duebill where SERIALNO = '"+CINO+"'");	if(loantype == null)   loantype = "";	String BUSINESSTYPE = Sqlca.getString("select typename from business_type where typeno in (select BUSINESSTYPE from business_duebill where SERIALNO = '"+CINO+"') ");	if(BUSINESSTYPE == null)   BUSINESSTYPE = "";	String LNNAME = loantype +"-"+ BUSINESSTYPE;		String RTNBAL="",APPNO="",TXDATE="",THIRDPARTYACCOUNT="",ACCOUNTNAME="",PAYACCOUNTTYPE="";	String sSql = "select atp.PREPAYPRINCIPALAMT as RTNBAL,act.SERIALNO as APPNO,act.ACCOUNTINGDATE as TXDATE,atp.PAYACCOUNTNO as PAYACCOUNTNO ,atp.PAYACCOUNTNO1 as PAYACCOUNTNO1,"+			" atp.PAYACCOUNTNAME as PAYACCOUNTNAME, atp.PAYACCOUNTTYPE as PAYACCOUNTTYPE from ACCT_TRANS_PAYMENT atp,ACCT_TRANSACTION act where"+			" atp.SerialNo=act.DocumentObjectNo and act.RelativeObjectNo =:RelativeObjectNo and  act.DocumentObjectType='jbo.acct.ACCT_TRANS_PAYMENT'"+			" and act.TRANSACTIONCODE= '0020' and act.SerialNo=:TransSerialNo";		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("RelativeObjectNo", CINO).setParameter("TransSerialNo", transSerialNo));	while(rs.next()){		RTNBAL = DataConvert.toMoney(String.valueOf(rs.getDouble("RTNBAL")));//提前归还本金		APPNO = rs.getString("APPNO");//前台交易流水		APPNO= APPNO.substring(2, 8)+APPNO.substring(10, 16);		TXDATE = rs.getString("TXDATE");//交易日期		THIRDPARTYACCOUNT = rs.getString("PAYACCOUNTNO1");// 还账帐号		if(THIRDPARTYACCOUNT == null || "".equals(THIRDPARTYACCOUNT)) THIRDPARTYACCOUNT = rs.getString("PAYACCOUNTNO");// 还账帐号		ACCOUNTNAME = rs.getString("PAYACCOUNTNAME");// 账户名称		PAYACCOUNTTYPE = rs.getString("PAYACCOUNTTYPE");//还款账号类型	}	rs.getStatement().close();	if(RTNBAL == null)    RTNBAL = "";	if(APPNO == null)    APPNO = "";	if(TXDATE == null)    TXDATE = "";	if(THIRDPARTYACCOUNT == null)    THIRDPARTYACCOUNT = "";	if(ACCOUNTNAME == null)    ACCOUNTNAME = "";	if(PAYACCOUNTTYPE == null)    PAYACCOUNTTYPE = "";			String THIRDPARTYRTNMODE = Sqlca.getString("select itemname from code_library where codeno = 'PrepaymentType' "+						"and itemno =( select PREPAYTYPE from acct_trans_payment where serialno = '"+APPNO+"')");// 出账方式	if(THIRDPARTYRTNMODE == null)     THIRDPARTYRTNMODE = "0-按本金还款";	String THIRDPARTYTYPE = Sqlca.getString("select Attribute3||'-'|| case when itemno = '7' then itemname||'(对公账户)' else itemname end from code_library where codeno = 'AccountType' "+						"and itemno ='"+PAYACCOUNTTYPE+"'");//还款账号类型	if(THIRDPARTYTYPE == null)     THIRDPARTYTYPE = "";	String DATE = StringFunction.getToday();//打印日期%><style>*{font-size: 15px}</style>
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
  style='font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体'>个人贷款第三方账户提前还款通知书
  </span></b><span lang=EN-US style='font-size:12.0pt;font-family:宋体;
  mso-bidi-font-family:宋体'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1;height:16.5pt'>
  <td width=639 colspan=4 style='width:479.25pt;border-top:none;border-left:
  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:16.5pt'>
  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US
  style='font-size:11.0pt;font-family:宋体;mso-bidi-font-family:宋体'>&nbsp;</span><span
  lang=EN-US style='font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2;height:33.0pt'>
  <td width=639 colspan=4 style='width:479.25pt;border-top:none;border-left:
  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:33.0pt'>
  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US
  style='font-size:11.0pt;font-family:宋体;mso-bidi-font-family:宋体'>__________</span><span
  style='font-size:11.0pt;font-family:宋体;mso-bidi-font-family:宋体'>（部）会计部门：<span
  lang=EN-US>&nbsp;</span></span><span lang=EN-US style='font-size:12.0pt;
  font-family:宋体;mso-bidi-font-family:宋体'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;height:62.25pt'>
  <td width=639 colspan=4 style='width:479.25pt;border-top:none;border-left:
  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:62.25pt'>
  <p class=MsoNormal><u><span lang=EN-US style='font-family:宋体'><%=NAME%></span></u><span
  style='font-family:宋体'>（申请人）的<u><span lang=EN-US><%=LNNAME%></span></u>提前还款申请</span></p>
  <p class=MsoNormal><span style='font-family:宋体'>已经按我行业务审批程序报经有权审批人审批同意，请你部按照本通知书要求，办理提前还款<span
  class=GramE>入帐</span>手续：</span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;height:15.0pt'>
  <td width=639 colspan=4 style='width:479.25pt;border-top:none;border-left:
  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=left style='text-align:left'><span style='font-size:
  12.0pt;font-family:宋体;mso-bidi-font-family:宋体'>　<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;height:15.0pt'>
  <td width=136 style='width:101.85pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-family:宋体'>营业机构号</span></p>
  </td>
  <td width=157 style='width:118.1pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;
  mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-family:楷体_GB2312'><%=BRCODENO%></span></p>
  </td>
  <td width=133 style='width:99.55pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-family:宋体'></span></p>
  </td>
  <td width=213 style='width:159.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;
  mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-family:楷体_GB2312'></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;height:15.0pt'>
  <td width=136 style='width:101.85pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-family:宋体'>借据号</span></p>
  </td>
  <td width=157 style='width:118.1pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;
  mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-family:楷体_GB2312'><%=CINO%></span></p>
  </td>
  <td width=133 style='width:99.55pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-family:宋体'>提前归还本金</span></p>
  </td>
  <td width=213 style='width:159.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;
  mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-family:楷体_GB2312'><%=RTNBAL%></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;height:15.0pt'>
  <td width=136 style='width:101.85pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-family:宋体'>前台交易流水</span></p>
  </td>
  <td width=157 style='width:118.1pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;
  mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-family:楷体_GB2312'><%=APPNO%></span></p>
  </td>
  <td width=133 style='width:99.55pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-family:宋体'>交易日期</span></p>
  </td>
  <td width=213 style='width:159.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;
  mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-family:楷体_GB2312'><%=TXDATE%></span></p>
  </td>
 </tr>
<tr style='mso-yfti-irow:7;height:15.0pt'>
  <td width=136 style='width:101.85pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-family:宋体;mso-ascii-font-family:"Times New Roman";
  mso-hansi-font-family:"Times New Roman"'>提前还款<span class=GramE>出账方式</span></span></p>
  </td>
  <td width=157 style='width:118.1pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;
  mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-family:楷体_GB2312'><%=THIRDPARTYRTNMODE%></span><span lang=EN-US
  style='mso-bidi-font-size:10.0pt;font-family:楷体_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=133 style='width:99.55pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-family:宋体;mso-ascii-font-family:"Times New Roman";
  mso-hansi-font-family:"Times New Roman";color:black'>还款账号类型</span></p>
  </td>
  <td width=213 style='width:159.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;
  mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-family:楷体_GB2312'><%=THIRDPARTYTYPE%></span><span lang=EN-US
  style='mso-bidi-font-size:10.0pt;font-family:楷体_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:7;height:15.0pt'>
  <td width=136 style='width:101.85pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-family:宋体;mso-ascii-font-family:"Times New Roman";
  mso-hansi-font-family:"Times New Roman"'>还账<span class=GramE>帐号</span></span></p>
  </td>
  <td width=157 style='width:118.1pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;
  mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-family:楷体_GB2312'><%=THIRDPARTYACCOUNT%></span><span lang=EN-US
  style='mso-bidi-font-size:10.0pt;font-family:楷体_GB2312'><o:p></o:p></span></p>
  </td>
  <td width=133 style='width:99.55pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-family:宋体;mso-ascii-font-family:"Times New Roman";
  mso-hansi-font-family:"Times New Roman";color:black'>账户名称</span></p>
  </td>
  <td width=213 style='width:159.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;
  mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-family:楷体_GB2312'><%=ACCOUNTNAME%></span><span lang=EN-US
  style='mso-bidi-font-size:10.0pt;font-family:楷体_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:8;height:15.0pt'>
  <td width=639 colspan=4 valign=top style='width:479.25pt;border-top:none;
  border-left:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;
  border-right:solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:12.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:9;height:169.5pt'>
  <td width=639 colspan=4 valign=top style='width:479.25pt;border-top:none;
  border-left:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;
  border-right:solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:169.5pt'>
  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:宋体;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>　</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:宋体;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>　</span></p>
  <p class=MsoNormal><span lang=EN-US style='font-size:14.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US
  style='font-size:14.0pt;mso-ascii-font-family:楷体_GB2312;mso-fareast-font-family:
  楷体_GB2312'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span
  lang=EN-US style='font-size:14.0pt;font-family:楷体_GB2312'> </span><span
  lang=EN-US style='font-size:14.0pt;mso-ascii-font-family:楷体_GB2312;
  mso-fareast-font-family:楷体_GB2312'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span
  lang=EN-US style='font-size:11.0pt;mso-ascii-font-family:楷体_GB2312;
  mso-fareast-font-family:楷体_GB2312'>&nbsp;&nbsp;</span><span lang=EN-US
  style='font-size:11.0pt;font-family:宋体'>&nbsp;</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:宋体'>经办人签字：<span
  lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span><span lang=EN-US style='font-size:11.0pt;font-family:宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span><!--span style='font-size:11pt;font-family:宋体'>审批人员签字：</span--></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US
  style='font-size:11.0pt;font-family:宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:宋体;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>　</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:宋体;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>　</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:宋体;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>　</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US
  style='font-size:11.0pt;font-family:宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span><span style='font-size:11.0pt;font-family:宋体'>日期：<span lang=EN-US><%=DATE%></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:10;mso-yfti-lastrow:yes;height:80.25pt'>
  <td width=639 colspan=4 style='width:479.25pt;border:solid windowtext 1.5pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:80.25pt'>
  <p class=MsoNormal><span style='font-size:15.0px;font-family:宋体;color:black'>（此通知书共三联，交客户经理、会计和文档管理员各一份）</span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal><span lang=EN-US style='font-size:12.0pt;mso-ascii-font-family:
楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span></p>

</div>
<table align="center">
	<tr>			<td id="print"><%=HTMLControls.generateButton("打印", "打印", "printPaper()", "") %></td>	</tr></table></body><script>   function printPaper(){	   var print = document.getElementById("print");	   if(window.confirm("是否确定要打印？")){		   //打印	  		   print.style.display = "none";		   window.print();			   window.close();	   }   }</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
