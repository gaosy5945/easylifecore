<%@ page contentType="text/html; charset=GBK"%><%@ include file="/Frame/resources/include/include_begin.jspf"%><%@ page import="com.amarsoft.app.base.util.DateHelper"%><%		String SERIALNO = DataConvert.toString(CurPage.getParameter("SerialNo"));//获取页面传过来的公积金资金划转信息流水号	if(SERIALNO == null)    SERIALNO = "";//2014121801110004	//姓名	String TEMPDIGITAL = Sqlca.getString("select AMOUNT from fund_transfer where serialno = '"+SERIALNO+"'");//小写	String DIGITAL = DataConvert.toMoney(TEMPDIGITAL);	String UPTXAMT = StringFunction.numberToChinese(Double.parseDouble(TEMPDIGITAL));//大写	String PUFAACTNO = "076402-4291025995";//我行收款账号	String FULLDATE = Sqlca.getString("select OCCURDATE from fund_transfer where serialno = '"+SERIALNO+"'");//日期	String YEAR = FULLDATE.substring(0, 4);//年	String MONTH = FULLDATE.substring(5, 7);//月	String DATE = FULLDATE.substring(8, 10);//日%>

<body lang=ZH-CN style='tab-interval:21.0pt;text-justify-trim:punctuation'>

<div class=Section1 style='layout-grid:15.6pt'>

<div align=center>

<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0
 style='margin-left:.5pt;border-collapse:collapse;mso-padding-alt:0cm 0cm 0cm 0cm'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal align=center style='text-align:center'><b
  style='mso-bidi-font-weight:normal'><span style='font-size:15.0pt;font-family:
  仿宋_GB2312'>收<span lang=EN-US><span style='mso-spacerun:yes'>&nbsp; </span></span>款<span
  lang=EN-US><span style='mso-spacerun:yes'>&nbsp; </span></span>通<span
  lang=EN-US><span style='mso-spacerun:yes'>&nbsp; </span></span>知<span
  lang=EN-US></span></span></b><span lang=EN-US style='font-size:15.0pt;
  font-family:仿宋_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>

 <tr style='mso-yfti-irow:2;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:仿宋_GB2312'>中国建设银行上海市卢湾支行：<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:仿宋_GB2312'>　　今收到贵方划入的住房补贴冲还住房贷款资金（大写）</span></p>
  </td>
 </tr>
  <tr style='mso-yfti-irow:3;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:仿宋_GB2312'><%=UPTXAMT%></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:仿宋_GB2312'>（小写）￥<span
  lang=EN-US><%=DIGITAL%></span>。特此通知！<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:仿宋_GB2312'>　　我行收款帐号： <span
  lang=EN-US><%=PUFAACTNO%></span></span></p>
  </td>
 </tr>
 
 <tr style='mso-yfti-irow:10;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right'><span
  style='font-size:15.0pt;font-family:仿宋_GB2312'>上海浦东发展银行上海市分行<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:11;mso-yfti-lastrow:yes;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right'><span lang=EN-US
  style='font-size:15.0pt;font-family:仿宋_GB2312'><%=YEAR%></span><span
  style='font-size:15.0pt;font-family:仿宋_GB2312'>年<span lang=EN-US><%=MONTH%></span>月<span
  lang=EN-US><%=DATE%></span>日<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
</table>

</div>

<p class=MsoNormal style='margin-right:61.5pt;line-height:150%'><span
lang=EN-US><o:p>&nbsp;</o:p></span></p>

</div>
<table align="center">	<tr>			<td id="print"><%=HTMLControls.generateButton("打印", "打印", "printPaper()", "") %></td>	</tr></table></body><script>   function printPaper(){	   var print = document.getElementById("print");	   if(window.confirm("是否确定要打印？")){		   //打印	  		   print.style.display = "none";		   window.print();			   window.close();	   }   }</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
