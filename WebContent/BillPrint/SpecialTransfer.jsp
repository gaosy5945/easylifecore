<%@page import="com.amarsoft.app.als.sys.*"%><%@ page contentType="text/html; charset=GBK"%><%@ include file="/Frame/resources/include/include_begin.jspf"%><%String serialNo = CurPage.getParameter("SerialNo");if(serialNo == null)	serialNo = "";String occurDate = "",subOrgID = "",subOrgName="",reAcctNo = "";double amount=0d;ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select OccurDate,SubOrgID,sum(Amount) as Amount,count(*) as cnt from fund_transfer where SerialNo in('"+serialNo.replaceAll(",", "','")+"') group by OccurDate,SubOrgID order by OccurDate,SubOrgID"));while(rs.next()){	occurDate = rs.getString("OccurDate");	subOrgID = rs.getString("SubOrgID");	amount = rs.getDouble("Amount");String YEAR = occurDate.substring(0,4);//年String MONTH = occurDate.substring(5, 7);//月String DATE = occurDate.substring(8, 10);//日BusinessObject org = SystemDBConfig.getOrg(subOrgID);int cnt = rs.getInt("cnt");%>

<body lang=ZH-CN style='tab-interval:21.0pt;text-justify-trim:punctuation'>

<div class=Section1 style='layout-grid:15.6pt'>

<div align=center>

<table class=MsoTableGrid border=0 cellspacing=0 cellpadding=0 width=579
 style='width:434.45pt;border-collapse:collapse;mso-yfti-tbllook:480;
 mso-padding-alt:0cm 5.4pt 0cm 5.4pt'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes'>
  <td width=579 colspan=13 style='width:434.45pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center'><b
  style='mso-bidi-font-weight:normal'><u><span style='font-size:14.0pt;
  font-family:楷体_GB2312;mso-ascii-font-family:Arial'>特种<span class=GramE>转帐</span>借方传票</span></u></b><b
  style='mso-bidi-font-weight:normal'><u><span lang=EN-US style='font-size:
  14.0pt;font-family:Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:
  "Times New Roman"'><o:p></o:p></span></u></b></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1'>
  <td width=350 colspan=7 style='width:262.25pt;border:none;border-bottom:solid windowtext 1.0pt;
  mso-border-bottom-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=right style='text-align:right'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:Arial;mso-fareast-font-family:
  楷体_GB2312;mso-bidi-font-family:"Times New Roman"'><%=YEAR %></span><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-ascii-font-family:
  Arial'>年</span><span lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:
  Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:"Times New Roman"'><%=MONTH %></span><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-ascii-font-family:
  Arial'>月</span><span lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:
  Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:"Times New Roman"'><%=DATE %></span><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-ascii-font-family:
  Arial'>日</span><span lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:
  Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:"Times New Roman"'><o:p></o:p></span></p>
  </td>
  <td width=230 colspan=6 valign=top style='width:172.2pt;border:none;
  border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;
  mso-ascii-font-family:Arial'>号码：</span><span lang=EN-US style='mso-bidi-font-size:
  10.5pt;font-family:Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:
  "Times New Roman"'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2'>
  <td width=28 rowspan=3 style='width:21.3pt;border:solid windowtext 1.0pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-ascii-font-family:
  Arial'>付款单位</span><span lang=EN-US style='mso-bidi-font-size:10.5pt;
  font-family:Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:
  "Times New Roman"'><o:p></o:p></span></p>
  </td>
  <td width=80 colspan=2 style='width:59.85pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-ascii-font-family:
  Arial'>全</span><span lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:
  Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:"Times New Roman"'><span
  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp; </span></span><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-ascii-font-family:
  Arial'>称</span><span lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:
  Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:"Times New Roman"'><o:p></o:p></span></p>
  </td>
  <td width=183 colspan=2 style='width:137.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;
  mso-ascii-font-family:Arial'>上海市公积金管理中心<span class=GramE>个</span>贷基金</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:Arial;mso-fareast-font-family:
  楷体_GB2312;mso-bidi-font-family:"Times New Roman"'>(</span><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-ascii-font-family:
  Arial'>浦发</span><span lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:
  Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:"Times New Roman"'>)</span><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-ascii-font-family:
  Arial'>专户</span><span lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:
  Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:"Times New Roman"'><o:p></o:p></span></p>
  </td>
  <td width=28 rowspan=3 style='width:21.3pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-ascii-font-family:
  Arial'>收款单位</span><span lang=EN-US style='mso-bidi-font-size:10.5pt;
  font-family:Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:
  "Times New Roman"'><o:p></o:p></span></p>
  </td>
  <td width=83 colspan=3 style='width:62.3pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-ascii-font-family:
  Arial'>全</span><span lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:
  Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:"Times New Roman"'><span
  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp; </span></span><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-ascii-font-family:
  Arial'>称</span><span lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:
  Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:"Times New Roman"'><o:p></o:p></span></p>
  </td>
  <td width=176 colspan=4 style='width:132.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:
  楷体_GB2312;mso-ascii-font-family:Arial'>待划转代理公积金贷款</span><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:Arial;mso-fareast-font-family:
  楷体_GB2312;mso-bidi-font-family:"Times New Roman"'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;height:6.0pt'>
  <td width=80 colspan=2 style='width:59.85pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:6.0pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-ascii-font-family:
  Arial'>帐</span><span lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:
  Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:"Times New Roman"'><span
  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp; </span></span><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-ascii-font-family:
  Arial'>号</span><span lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:
  Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:"Times New Roman"'><o:p></o:p></span></p>
  </td>
  <td width=183 colspan=2 style='width:137.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:6.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-bidi-font-size:10.5pt;
  font-family:Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:
  "Times New Roman"'>0764024291025721<o:p></o:p></span></p>
  </td>
  <td width=83 colspan=3 style='width:62.3pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:6.0pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-ascii-font-family:
  Arial'>帐</span><span lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:
  Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:"Times New Roman"'><span
  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp; </span></span><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-ascii-font-family:
  Arial'>号</span><span lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:
  Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:"Times New Roman"'><o:p></o:p></span></p>
  </td>
  <td width=176 colspan=4 style='width:132.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:6.0pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-bidi-font-size:10.5pt;
  font-family:Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:
  "Times New Roman"'><%=org.getString("FUNDACCTNO") %><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4'>
  <td width=80 colspan=2 style='width:59.85pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-ascii-font-family:
  Arial'>开户银行</span><span lang=EN-US style='mso-bidi-font-size:10.5pt;
  font-family:Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:
  "Times New Roman"'><o:p></o:p></span></p>
  </td>
  <td width=183 colspan=2 style='width:137.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-bidi-font-size:10.5pt;
  font-family:Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:
  "Times New Roman"'>浦发银行</span>  <span lang=EN-US style='mso-bidi-font-size:10.5pt;  font-family:Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:  "Times New Roman"'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=83 colspan=3 style='width:62.3pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-ascii-font-family:
  Arial'>开户银行</span><span lang=EN-US style='mso-bidi-font-size:10.5pt;
  font-family:Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:
  "Times New Roman"'><o:p></o:p></span></p>
  </td>
  <td width=176 colspan=4 style='width:132.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;
  mso-hansi-font-family:Arial'><%=org.getString("OrgName") %>&nbsp;<%= org.getString("OrgID") %></span>
  <span lang=EN-US style='mso-bidi-font-size:10.5pt;
  font-family:Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:
  "Times New Roman"'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5'>
  <td width=51 colspan=2 style='width:38.3pt;border:solid windowtext 1.0pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-ascii-font-family:
  Arial'>金</span><span lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:
  Arial;mso-fareast-font-family:楷体_GB2312;mso-hansi-font-family:"Times New Roman";
  mso-bidi-font-family:"Times New Roman"'><span style='mso-spacerun:yes'>&nbsp;
  </span></span><span style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;
  mso-ascii-font-family:Arial'>额</span><span lang=EN-US style='mso-bidi-font-size:
  10.5pt;font-family:Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:
  "Times New Roman"'><o:p></o:p></span></p>
  </td>
  <td width=67 colspan=2 style='width:50.15pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312'>人民币</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-hansi-font-family:
  Arial'>(</span><span style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312'>大写</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-hansi-font-family:
  Arial'>)<o:p></o:p></span></p>
  </td>
  <td width=285 colspan=5 style='width:213.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-bidi-font-size:10.5pt;
  font-family:楷体_GB2312;mso-hansi-font-family:Arial'><%=StringFunction.numberToChinese(amount) %><o:p></o:p></span></p>
  </td>
  <td width=65 colspan=2 style='width:49.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312'>人民币</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-hansi-font-family:
  Arial'>(</span><span style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312'>小写</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-hansi-font-family:
  Arial'>)<o:p></o:p></span></p>
  </td>
  <td width=111 colspan=2 style='width:83.3pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;
  mso-ascii-font-family:Arial'>￥</span><span lang=EN-US style='mso-bidi-font-size:
  10.5pt;font-family:Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:
  "Times New Roman"'><%=DataConvert.toMoney(amount) %><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;height:20.75pt'>
  <td width=28 rowspan=3 style='width:21.3pt;border:solid windowtext 1.0pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:20.75pt'>
  <p class=MsoNormal align=center style='text-align:center'><span class=GramE><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-ascii-font-family:
  Arial'>转帐</span></span><span style='mso-bidi-font-size:10.5pt;font-family:
  楷体_GB2312;mso-ascii-font-family:Arial'>原因</span><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:Arial;mso-fareast-font-family:
  楷体_GB2312;mso-bidi-font-family:"Times New Roman"'><o:p></o:p></span></p>
  </td>
  <td width=263 colspan=4 rowspan=3 style='width:197.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:20.75pt'>
  <p class=MsoNormal><span lang=EN-US style='mso-bidi-font-size:10.5pt;
  font-family:楷体_GB2312;mso-hansi-font-family:Arial'><%=org.getString("OrgID")+"-"+org.getString("OrgName") %></span><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312'>共</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:Arial;mso-fareast-font-family:
  楷体_GB2312;mso-bidi-font-family:"Times New Roman"'><%=cnt %></span><span
  style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-ascii-font-family:
  Arial'>笔</span><span lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:
  Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:"Times New Roman"'><o:p></o:p></span></p>
  </td>
  <td width=288 colspan=8 style='width:215.9pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:20.75pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312'>科目：</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-hansi-font-family:
  Arial'>(</span><span style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312'>借</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-hansi-font-family:
  Arial'>)<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:7;height:20.75pt'>
  <td width=288 colspan=8 style='width:215.9pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:20.75pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312'>对方科目：</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-hansi-font-family:
  Arial'>(</span><span style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312'>贷</span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;mso-hansi-font-family:
  Arial'>)<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:8;mso-yfti-lastrow:yes;height:20.75pt'>
  <td width=72 colspan=3 style='width:53.95pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:20.75pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;
  mso-ascii-font-family:Arial'>会计</span><span lang=EN-US style='mso-bidi-font-size:
  10.5pt;font-family:Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:
  "Times New Roman"'><o:p></o:p></span></p>
  </td>
  <td width=72 colspan=2 style='width:54.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:20.75pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;
  mso-ascii-font-family:Arial'>复核</span><span lang=EN-US style='mso-bidi-font-size:
  10.5pt;font-family:Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:
  "Times New Roman"'><o:p></o:p></span></p>
  </td>
  <td width=72 colspan=2 style='width:53.95pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:20.75pt'>
  <p class=MsoNormal><span class=GramE><span style='mso-bidi-font-size:10.5pt;
  font-family:楷体_GB2312;mso-ascii-font-family:Arial'>记帐</span></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt;font-family:Arial;mso-fareast-font-family:
  楷体_GB2312;mso-bidi-font-family:"Times New Roman"'><o:p></o:p></span></p>
  </td>
  <td width=72 style='width:54.0pt;border-top:none;border-left:none;border-bottom:
  solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;mso-border-top-alt:
  solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:20.75pt'>
  <p class=MsoNormal><span style='mso-bidi-font-size:10.5pt;font-family:楷体_GB2312;
  mso-ascii-font-family:Arial'>制单</span><span lang=EN-US style='mso-bidi-font-size:
  10.5pt;font-family:Arial;mso-fareast-font-family:楷体_GB2312;mso-bidi-font-family:
  "Times New Roman"'><o:p></o:p></span></p>
  </td>
 </tr>
 <![if !supportMisalignedColumns]>
 <tr height=0>
  <td width=28 style='border:none'></td>
  <td width=23 style='border:none'></td>
  <td width=57 style='border:none'></td>
  <td width=10 style='border:none'></td>
  <td width=173 style='border:none'></td>
  <td width=28 style='border:none'></td>
  <td width=30 style='border:none'></td>
  <td width=14 style='border:none'></td>
  <td width=40 style='border:none'></td>
  <td width=32 style='border:none'></td>
  <td width=33 style='border:none'></td>
  <td width=39 style='border:none'></td>
  <td width=72 style='border:none'></td>
 </tr>
 <![endif]>
</table>

</div>

<p class=MsoNormal align=center style='text-align:center'><span lang=EN-US><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal align=center style='text-align:center'><span lang=EN-US><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal align=center style='text-align:center'><span lang=EN-US><o:p>&nbsp;</o:p></span></p>

</div></body><%}rs.close();%><script>   function printPaper(){	   var print = document.getElementById("print");	   if(window.confirm("是否确定要打印？")){		   //打印	  		   print.style.display = "none";		   window.print();			   window.close();	   }   }</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
