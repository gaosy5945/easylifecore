<%@ page contentType="text/html; charset=GBK"%><%@ include file="/Frame/resources/include/include_begin.jspf"%><%@ page import="com.amarsoft.app.base.util.DateHelper"%><%		String SERIALNO = DataConvert.toString(CurPage.getParameter("SerialNo"));//��ȡҳ�洫�����Ĺ������ʽ�ת��Ϣ��ˮ��	if(SERIALNO == null)    SERIALNO = "";//2014121801110004	//����	String TEMPDIGITAL = Sqlca.getString("select AMOUNT from fund_transfer where serialno = '"+SERIALNO+"'");//Сд	String DIGITAL = DataConvert.toMoney(TEMPDIGITAL);	String UPTXAMT = StringFunction.numberToChinese(Double.parseDouble(TEMPDIGITAL));//��д	String PUFAACTNO = "076402-4291025995";//�����տ��˺�	String FULLDATE = Sqlca.getString("select OCCURDATE from fund_transfer where serialno = '"+SERIALNO+"'");//����	String YEAR = FULLDATE.substring(0, 4);//��	String MONTH = FULLDATE.substring(5, 7);//��	String DATE = FULLDATE.substring(8, 10);//��%>

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
  ����_GB2312'>��<span lang=EN-US><span style='mso-spacerun:yes'>&nbsp; </span></span>��<span
  lang=EN-US><span style='mso-spacerun:yes'>&nbsp; </span></span>ͨ<span
  lang=EN-US><span style='mso-spacerun:yes'>&nbsp; </span></span>֪<span
  lang=EN-US></span></span></b><span lang=EN-US style='font-size:15.0pt;
  font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>

 <tr style='mso-yfti-irow:2;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:����_GB2312'>�й����������Ϻ���¬��֧�У�<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:����_GB2312'>�������յ��󷽻����ס�������廹ס�������ʽ𣨴�д��</span></p>
  </td>
 </tr>
  <tr style='mso-yfti-irow:3;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:����_GB2312'><%=UPTXAMT%></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:����_GB2312'>��Сд����<span
  lang=EN-US><%=DIGITAL%></span>���ش�֪ͨ��<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:����_GB2312'>���������տ��ʺţ� <span
  lang=EN-US><%=PUFAACTNO%></span></span></p>
  </td>
 </tr>
 
 <tr style='mso-yfti-irow:10;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right'><span
  style='font-size:15.0pt;font-family:����_GB2312'>�Ϻ��ֶ���չ�����Ϻ��з���<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:11;mso-yfti-lastrow:yes;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right'><span lang=EN-US
  style='font-size:15.0pt;font-family:����_GB2312'><%=YEAR%></span><span
  style='font-size:15.0pt;font-family:����_GB2312'>��<span lang=EN-US><%=MONTH%></span>��<span
  lang=EN-US><%=DATE%></span>��<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
</table>

</div>

<p class=MsoNormal style='margin-right:61.5pt;line-height:150%'><span
lang=EN-US><o:p>&nbsp;</o:p></span></p>

</div>
<table align="center">	<tr>			<td id="print"><%=HTMLControls.generateButton("��ӡ", "��ӡ", "printPaper()", "") %></td>	</tr></table></body><script>   function printPaper(){	   var print = document.getElementById("print");	   if(window.confirm("�Ƿ�ȷ��Ҫ��ӡ��")){		   //��ӡ	  		   print.style.display = "none";		   window.print();			   window.close();	   }   }</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
