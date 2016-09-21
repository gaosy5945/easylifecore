<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%
String month = DateHelper.getBusinessDate().substring(0,7);
String lastMonthDate = DateHelper.getEndDateOfMonth(DateHelper.getRelativeDate(DateHelper.getBusinessDate(), DateHelper.TERM_UNIT_MONTH, -1));
String orgID = "9800";
double lastBalance = DataConvert.toDouble(Sqlca.getString(new SqlObject("select balance from FUND_USE where OrgID=:OrgID and OccurDate = :OccurDate").setParameter("OccurDate", lastMonthDate).setParameter("OrgID", orgID)));
double btocAmt = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(nvl(Amount,0)) from FUND_TRANSFER where (OrgID=:OrgID or subOrgID=:OrgID) and OccurDate like :CurMonth and Direction=:Direction").setParameter("CurMonth", month+"%").setParameter("Direction", "4").setParameter("OrgID", orgID)));
double ctobAmt = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(nvl(Amount,0)) from FUND_TRANSFER where (OrgID=:OrgID or subOrgID=:OrgID) and OccurDate like :CurMonth and Direction=:Direction").setParameter("CurMonth", month+"%").setParameter("Direction", "3").setParameter("OrgID", orgID)));
double btosbAmt = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(nvl(Amount,0)) from FUND_TRANSFER where (OrgID=:OrgID or subOrgID=:OrgID) and OccurDate like :CurMonth and Direction=:Direction").setParameter("CurMonth", month+"%").setParameter("Direction", "1").setParameter("OrgID", orgID)));
double sbtobAmt = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(nvl(Amount,0)) from FUND_TRANSFER where (OrgID=:OrgID or subOrgID=:OrgID) and OccurDate like :CurMonth and Direction=:Direction").setParameter("CurMonth", month+"%").setParameter("Direction", "2").setParameter("OrgID", orgID)));

double balance = lastBalance - btocAmt+ctobAmt-btosbAmt+sbtobAmt;

int curCnt = DataConvert.toInt(Sqlca.getString(new SqlObject("select count(1) from FUND_TRANSFER where OccurDate = :OccurDate and Direction=:Direction and ObjectNo is not null").setParameter("OccurDate",SystemConfig.getBusinessDate()).setParameter("Direction", "1")));
double curAmt = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(nvl(Amount,0)) from FUND_TRANSFER where OccurDate = :OccurDate and Direction=:Direction and ObjectNo is not null").setParameter("OccurDate",SystemConfig.getBusinessDate()).setParameter("Direction", "1")));

%>

<body lang=ZH-CN style='tab-interval:21.0pt;text-justify-trim:punctuation'>

<div class=Section1 style='layout-grid:15.6pt'>

<div align=center>

<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0
 style='margin-left:.5pt;border-collapse:collapse;mso-padding-alt:0cm 0cm 0cm 0cm'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;height:30.0pt'>
  <td width=532 colspan=2 style='width:448.95pt;border:none;border-bottom:solid windowtext 1.0pt;
  mso-border-bottom-alt:solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal align=center style='text-align:center'><b><span
  style='font-size:15.0pt;font-family:仿宋_GB2312'>公积金使用情况表</span></b><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312;mso-hansi-font-family:
  宋体'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2;height:30.0pt'>
  <td width=263 style='width:247.5pt;border:solid windowtext 1.0pt;border-top:
  none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:仿宋_GB2312'>上期结存基金</span><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312;mso-hansi-font-family:
  宋体'><o:p></o:p></span></p>
  </td>
  <td width=269 style='width:201.45pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 14.2pt 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right;word-break:break-all'><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312'><%=DataConvert.toMoney(lastBalance)%>元</span><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312;mso-hansi-font-family:
  宋体'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;height:30.0pt'>
  <td width=263 style='width:247.5pt;border:solid windowtext 1.0pt;border-top:
  none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:仿宋_GB2312'>已划市中心基金<span
  class=GramE>金额</span></span><span lang=EN-US style='font-size:15.0pt;
  font-family:仿宋_GB2312;mso-hansi-font-family:宋体'><o:p></o:p></span></p>
  </td>
  <td width=269 style='width:201.45pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 14.2pt 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right;word-break:break-all'><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312'><%=DataConvert.toMoney(btocAmt)%>元</span><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312;mso-hansi-font-family:
  宋体'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;height:30.0pt'>
  <td width=263 style='width:247.5pt;border:solid windowtext 1.0pt;border-top:
  none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:仿宋_GB2312'>实际收到基金<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=269 style='width:201.45pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 14.2pt 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right;word-break:break-all'><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312'><%=DataConvert.toMoney(ctobAmt)%>元</span><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312;mso-hansi-font-family:
  宋体'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;height:30.0pt'>
  <td width=263 style='width:247.5pt;border:solid windowtext 1.0pt;border-top:
  none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:仿宋_GB2312'>下划支行资金<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=269 style='width:201.45pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 14.2pt 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right;word-break:break-all'><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312'><%=DataConvert.toMoney(btosbAmt)%>元</span><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312;mso-hansi-font-family:
  宋体'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;height:30.0pt'>
  <td width=263 style='width:247.5pt;border:solid windowtext 1.0pt;border-top:
  none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:仿宋_GB2312'>支行上划资金</span><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312;mso-hansi-font-family:
  宋体'><o:p></o:p></span></p>
  </td>
  <td width=269 style='width:201.45pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 14.2pt 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right;word-break:break-all'><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312'><%=DataConvert.toMoney(sbtobAmt)%>元</span><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312;mso-hansi-font-family:
  宋体'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;height:30.0pt'>
  <td width=263 style='width:247.5pt;border:solid windowtext 1.0pt;border-top:
  none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:仿宋_GB2312'>本期结存资金</span><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312;mso-hansi-font-family:
  宋体'><o:p></o:p></span></p>
  </td>
  <td width=269 style='width:201.45pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 14.2pt 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right;word-break:break-all'><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312'><%=DataConvert.toMoney(balance)%>元</span><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312;mso-hansi-font-family:
  宋体'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;height:30.0pt'>
  <td width=263 style='width:247.5pt;border:solid windowtext 1.0pt;border-top:
  none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:仿宋_GB2312'>当日已确认资金划拨的公积金贷款笔数</span><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312;mso-hansi-font-family:
  宋体'><o:p></o:p></span></p>
  </td>
  <td width=269 style='width:201.45pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 14.2pt 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right;word-break:break-all'><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312'><%=curCnt%>笔</span><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312;mso-hansi-font-family:
  宋体'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;height:30.0pt'>
  <td width=263 style='width:247.5pt;border:solid windowtext 1.0pt;border-top:
  none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:仿宋_GB2312'>当日已确认资金划拨的公积金贷款金额</span><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312;mso-hansi-font-family:
  宋体'><o:p></o:p></span></p>
  </td>
  <td width=269 style='width:201.45pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 14.2pt 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right;word-break:break-all'><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312'><%=DataConvert.toMoney(curAmt)%>元</span><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312;mso-hansi-font-family:
  宋体'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;height:30.0pt'>
  <td width=263 style='width:247.5pt;border:solid windowtext 1.0pt;border-top:
  none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:仿宋_GB2312'>当前可用资金</span><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312;mso-hansi-font-family:
  宋体'><o:p></o:p></span></p>
  </td>
  <td width=269 style='width:201.45pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 14.2pt 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right;word-break:break-all'><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312'><%=DataConvert.toMoney(balance)%>元</span><span
  lang=EN-US style='font-size:15.0pt;font-family:仿宋_GB2312;mso-hansi-font-family:
  宋体'><o:p></o:p></span></p>
  </td> 
 </tr>
</table>

</div>

<p class=MsoNormal style='margin-right:61.5pt;line-height:150%'><span
lang=EN-US><o:p>&nbsp;</o:p></span></p>

</div>

</body>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
