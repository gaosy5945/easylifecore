<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="com.amarsoft.app.als.common.util.DateHelper"%>

<%
	String month = com.amarsoft.app.base.util.DateHelper.getBusinessDate().substring(0,7);
	
	Double fu_REPAY_AMOUNT = Sqlca.getDouble(new SqlObject("select sum(fu.PAYAMT) from fund_update fu where fu.INPUTDATE like :Month and loanType IN('01','03') ").setParameter("Month", month.replaceAll("/", "")+"%"));
	//Double fr_REPAY_AMOUNT = Sqlca.getDouble(new SqlObject("select sum(fr.PAYAMT) from fund_return fr where fr.INPUTDATE like :Month").setParameter("Month", month+"%"));
	String TEMPDIGITAL = DataConvert.toMoney(fu_REPAY_AMOUNT);//������廹���

	String DIGITAL = DataConvert.toMoney(TEMPDIGITAL);
	String UPTXAMT = StringFunction.numberToChinese(fu_REPAY_AMOUNT);//��д
	
	Double fu_REPAY_BALAMOUNT = Sqlca.getDouble(new SqlObject("select sum(fu.PAYCORPUS) from fund_update fu where fu.INPUTDATE like :Month and loanType IN('01','03') ").setParameter("Month", month.replaceAll("/", "")+"%"));
	//Double fr_REPAY_BALAMOUNT = Sqlca.getDouble(new SqlObject("select sum(fr.PAYCORPUS) from fund_return fr where fr.INPUTDATE like :Month").setParameter("Month", month+"%"));
	String BALAMT = DataConvert.toMoney(fu_REPAY_BALAMOUNT );
	
	Double fu_REPAY_INTAMOUNT = Sqlca.getDouble(new SqlObject("select sum(fu.PAYINTE) from fund_update fu where fu.INPUTDATE like :Month and loanType IN('01','03') ").setParameter("Month", month.replaceAll("/", "")+"%"));
	//Double fr_REPAY_INTAMOUNT = Sqlca.getDouble(new SqlObject("select sum(fr.PAYINTE) from fund_return fr where fr.INPUTDATE like :Month").setParameter("Month", month+"%"));
	String PAYINT = DataConvert.toMoney(fu_REPAY_INTAMOUNT );
	
	Double fu_REPAY_PINTAMOUNT = Sqlca.getDouble(new SqlObject("select sum(fu.PAYFINEINTE) from fund_update fu where fu.INPUTDATE like :Month and loanType IN('01','03') ").setParameter("Month", month.replaceAll("/", "")+"%"));
	//Double fr_REPAY_PINTAMOUNT = Sqlca.getDouble(new SqlObject("select sum(fr.PAYFINEINTE) from fund_return fr where fr.INPUTDATE like :Month").setParameter("Month", month+"%"));
	String PAYPINT = DataConvert.toMoney(fu_REPAY_PINTAMOUNT);
	
	String FULLDATE =  com.amarsoft.app.base.util.DateHelper.getBusinessDate();//��������
	String YEAR = FULLDATE.substring(0, 4);//��
	String MONTH = FULLDATE.substring(5, 7);//��
	String DATE = FULLDATE.substring(8, 10);//��
%>

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
  lang=EN-US>1</span></span></b><span lang=EN-US style='font-size:15.0pt;
  font-family:����_GB2312'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-size:15.0pt;font-family:����_GB2312'>�����տ�ƾ֤��<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:����_GB2312'>�����ģ�<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:����_GB2312'>������������ң���д��<span
  lang=EN-US><%=UPTXAMT%><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:����_GB2312'>������<span
  lang=EN-US><%=DIGITAL%></span>���������ģ����տ<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:����_GB2312'>�������Ͽ���Ϊ����˹黹��ס����������˹������Ϣ�����У�<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;height:30.0pt'>
  <td width=46 style='width:34.8pt;padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:����_GB2312'>����</span><span
  lang=EN-US style='font-size:15.0pt;font-family:����_GB2312;mso-hansi-font-family:
  ����'><o:p></o:p></span></p>
  </td>
  <td width=156 style='width:117.0pt;padding:0cm 14.2pt 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right;word-break:break-all'><span
  lang=EN-US style='font-size:15.0pt;font-family:����_GB2312'><%=BALAMT%></span><span
  lang=EN-US style='font-size:15.0pt;font-family:����_GB2312;mso-hansi-font-family:
  ����'><o:p></o:p></span></p>
  </td>
  <td width=353 style='width:264.9pt;padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal style='word-break:break-all'><span style='font-size:15.0pt;
  font-family:����_GB2312'>Ԫ��</span><span lang=EN-US style='font-size:15.0pt;
  font-family:����_GB2312;mso-hansi-font-family:����'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:7;height:30.0pt'>
  <td width=46 style='width:34.8pt;padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:����_GB2312'>��Ϣ<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=156 style='width:117.0pt;padding:0cm 14.2pt 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right;word-break:break-all'><span
  lang=EN-US style='font-size:15.0pt;font-family:����_GB2312'><%=PAYINT%><o:p></o:p></span></p>
  </td>
  <td width=353 style='width:264.9pt;padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal style='word-break:break-all'><span style='font-size:15.0pt;
  font-family:����_GB2312'>Ԫ��<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:8;height:30.0pt'>
  <td width=46 style='width:34.8pt;padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:����_GB2312'>��Ϣ<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=156 style='width:117.0pt;padding:0cm 14.2pt 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right;word-break:break-all'><span
  lang=EN-US style='font-size:15.0pt;font-family:����_GB2312'><%=PAYPINT%><o:p></o:p></span></p>
  </td>
  <td width=353 style='width:264.9pt;padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal style='word-break:break-all'><span style='font-size:15.0pt;
  font-family:����_GB2312'>Ԫ���������Ϣ��ϸ��<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:9;height:30.0pt'>
  <td width=556 colspan=3 style='width:416.7pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal style='margin-right:30.0pt;word-break:break-all'><span
  style='font-size:15.0pt;font-family:����_GB2312'>�����ش�֪ͨ��<span lang=EN-US><o:p></o:p></span></span></p>
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

<table align="center">
	<tr>	
		<td id="print"><%=HTMLControls.generateButton("��ӡ", "��ӡ", "printPaper()", "") %></td>
	</tr>
</table>

</body>

<script>
   function printPaper(){
	   var print = document.getElementById("print");
	   if(window.confirm("�Ƿ�ȷ��Ҫ��ӡ��")){
		   //��ӡ	  
		   print.style.display = "none";
		   window.print();	
		   window.close();
	   }
   }
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
