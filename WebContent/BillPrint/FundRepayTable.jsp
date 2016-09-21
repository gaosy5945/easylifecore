<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%
String month = com.amarsoft.app.base.util.DateHelper.getBusinessDate().substring(0,7);

Double fc_DRAW_AMOUNT = Sqlca.getDouble(new SqlObject("select sum(fc.PAYAMT) from fund_ctob fc where fc.INPUTDATE like :Month").setParameter("Month", month+"%"));

Double fz_DRAW_AMOUNT = Sqlca.getDouble(new SqlObject("select sum(fz.PAYAMT) from fund_ztob fz where fz.INPUTDATE like :Month").setParameter("Month", month+"%"));

String DRAW_AMOUNT = DataConvert.toMoney(fc_DRAW_AMOUNT + fz_DRAW_AMOUNT);//��������ȡ���

Double fu_REPAY_AMOUNT = Sqlca.getDouble(new SqlObject("select sum(fu.PAYAMT) from fund_update fu where fu.INPUTDATE like :Month").setParameter("Month", month.replaceAll("/", "")+"%"));
//Double fr_REPAY_AMOUNT = Sqlca.getDouble(new SqlObject("select sum(fr.PAYAMT) from fund_return fr where fr.INPUTDATE like :Month").setParameter("Month", month.replaceAll("/", "")+"%"));
String REPAY_AMOUNT = DataConvert.toMoney(fu_REPAY_AMOUNT);//������廹���

Double fu_FUND_AMOUNT = Sqlca.getDouble(new SqlObject("select sum(fu.PAYAMT) from fund_update fu where fu.INPUTDATE like :Month and fu.loanType IN('01','03') ").setParameter("Month", month.replaceAll("/", "")+"%"));
//Double fr_FUND_AMOUNT = Sqlca.getDouble(new SqlObject("select sum(fr.PAYAMT) from fund_return fr where fr.INPUTDATE like :Month and fr.loanType IN('01','03') ").setParameter("Month", month.replaceAll("/", "")+"%"));
String FUND_AMOUNT = DataConvert.toMoney(fu_FUND_AMOUNT);//�廹���������
Double BIZ_AMOUNT = fu_REPAY_AMOUNT - fu_FUND_AMOUNT ;//����ҵ����
Double dBALANCE = fc_DRAW_AMOUNT + fz_DRAW_AMOUNT - fu_REPAY_AMOUNT;
String BALANCE = DataConvert.toMoney(dBALANCE);//��ȡ���廹���
String thisDay = com.amarsoft.app.base.util.DateHelper.getBusinessDate();//��������
String YEAR = thisDay.substring(0, 4);//��
String MONTH = thisDay.substring(5, 7);//��
String DATE = thisDay.substring(8, 10);//��
%>

<body lang=ZH-CN style='tab-interval:21.0pt;text-justify-trim:punctuation'>

<div class=Section1 style='layout-grid:15.6pt'>

<div align=center>

<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0
 style='margin-left:.5pt;border-collapse:collapse;mso-padding-alt:0cm 0cm 0cm 0cm'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;height:30.0pt'>
  <td width=532 colspan=2 style='width:398.95pt;border:none;border-bottom:solid windowtext 1.0pt;
  mso-border-bottom-alt:solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;
  height:30.0pt'>
  <p class=MsoNormal align=center style='text-align:center'><b><span
  style='font-size:15.0pt;font-family:����_GB2312'>��ȡ������廹���������</span></b><span
  lang=EN-US style='font-size:15.0pt;font-family:����_GB2312;mso-hansi-font-family:
  ����'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1;height:30.0pt'>
  <td width=263 style='width:197.5pt;border:solid windowtext 1.0pt;border-top:
  none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-size:15.0pt;font-family:����_GB2312'>��<span lang=EN-US><span
  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp; </span><span
  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;</span></span>Ŀ</span><span
  lang=EN-US style='font-size:15.0pt;font-family:����_GB2312;mso-hansi-font-family:
  ����'><o:p></o:p></span></p>
  </td>
  <td width=269 style='width:201.45pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-size:15.0pt;font-family:����_GB2312'>����λ��Ԫ��</span><span
  lang=EN-US style='font-size:15.0pt;font-family:����_GB2312;mso-hansi-font-family:
  ����'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2;height:30.0pt'>
  <td width=263 style='width:197.5pt;border:solid windowtext 1.0pt;border-top:
  none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:����_GB2312'>��һ����������ȡ���</span><span
  lang=EN-US style='font-size:15.0pt;font-family:����_GB2312;mso-hansi-font-family:
  ����'><o:p></o:p></span></p>
  </td>
  <td width=269 style='width:201.45pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 14.2pt 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right;word-break:break-all'><span
  lang=EN-US style='font-size:15.0pt;font-family:����_GB2312'><%=DRAW_AMOUNT%></span><span
  lang=EN-US style='font-size:15.0pt;font-family:����_GB2312;mso-hansi-font-family:
  ����'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;height:30.0pt'>
  <td width=263 style='width:197.5pt;border:solid windowtext 1.0pt;border-top:
  none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:����_GB2312'>�������������<span
  class=GramE>�����</span></span><span lang=EN-US style='font-size:15.0pt;
  font-family:����_GB2312;mso-hansi-font-family:����'><o:p></o:p></span></p>
  </td>
  <td width=269 style='width:201.45pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 14.2pt 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right;word-break:break-all'><span
  lang=EN-US style='font-size:15.0pt;font-family:����_GB2312'><%=REPAY_AMOUNT%></span><span
  lang=EN-US style='font-size:15.0pt;font-family:����_GB2312;mso-hansi-font-family:
  ����'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;height:30.0pt'>
  <td width=263 style='width:197.5pt;border:solid windowtext 1.0pt;border-top:
  none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:����_GB2312'>�� ���У��廹���������<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=269 style='width:201.45pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 14.2pt 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right;word-break:break-all'><span
  lang=EN-US style='font-size:15.0pt;font-family:����_GB2312'><%=FUND_AMOUNT%></span><span
  lang=EN-US style='font-size:15.0pt;font-family:����_GB2312;mso-hansi-font-family:
  ����'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;height:30.0pt'>
  <td width=263 style='width:197.5pt;border:solid windowtext 1.0pt;border-top:
  none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:����_GB2312'>��<span
  lang=EN-US><span
  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span>��<span
  class=GramE>����ҵ</span>����<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=269 style='width:201.45pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 14.2pt 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right;word-break:break-all'><span
  lang=EN-US style='font-size:15.0pt;font-family:����_GB2312'><%=DataConvert.toMoney(BIZ_AMOUNT)%></span><span
  lang=EN-US style='font-size:15.0pt;font-family:����_GB2312;mso-hansi-font-family:
  ����'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;height:30.0pt'>
  <td width=263 style='width:197.5pt;border:solid windowtext 1.0pt;border-top:
  none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal><span style='font-size:15.0pt;font-family:����_GB2312'>��������ȡ���廹���</span><span
  lang=EN-US style='font-size:15.0pt;font-family:����_GB2312;mso-hansi-font-family:
  ����'><o:p></o:p></span></p>
  </td>
  <td width=269 style='width:201.45pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 14.2pt 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right;word-break:break-all'><span
  lang=EN-US style='font-size:15.0pt;font-family:����_GB2312'><%=BALANCE%></span><span
  lang=EN-US style='font-size:15.0pt;font-family:����_GB2312;mso-hansi-font-family:
  ����'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:7;height:30.0pt'>
  <td width=532 colspan=2 style='width:398.95pt;border:none;mso-border-top-alt:
  solid windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:30.0pt'>
  <p class=MsoNormal align=right style='text-align:right'><span
  style='font-size:15.0pt;font-family:����_GB2312'>�Ϻ��ֶ���չ�����Ϻ��з���<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:8;mso-yfti-lastrow:yes;height:30.0pt'>
  <td width=532 colspan=2 style='width:398.95pt;padding:0cm 0cm 0cm 0cm;
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
