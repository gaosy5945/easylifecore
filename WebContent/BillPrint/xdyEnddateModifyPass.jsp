<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="com.amarsoft.app.als.common.util.DateHelper"%>
<%

//������ˮ
String transSerialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));

BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();

BusinessObject transaction = bom.loadBusinessObject("jbo.acct.ACCT_TRANSACTION", transSerialNo);

BusinessObject bcChange = bom.loadBusinessObject(transaction.getString("DocumentObjectType"),transaction.getString("DocumentObjectNo"));

BusinessObject bc = bom.loadBusinessObject(transaction.getString("RelativeObjectType"),transaction.getString("RelativeObjectNo"));
//��ͬ��ˮ��
String contractserialNo = bc.getObjectNo();
//�͑�̖
String custno = bc.getString("CustomerID");
String MFCUSTNO = Sqlca.getString("select mfcustomerid from customer_info where customerid = '"+custno+"'");
if(MFCUSTNO == null) MFCUSTNO = "";
//�͑����Q
String custname = bc.getString("CustomerName");
String brcode = bc.getString("OperateOrgID");
String contractno = contractserialNo;
String cardno = Sqlca.getString("select accountno from ACCT_BUSINESS_ACCOUNT where objecttype='jbo.app.BUSINESS_CONTRACT' and objectno = '"+contractserialNo+"'");
if(cardno == null)  cardno = "";
//������ͬ��
String COCONTRACTNO = Sqlca.getString("select ObjectNo from CONTRACT_RELATIVE where objecttype='jbo.app.BUSINESS_CONTRACT' and ContractSerialNo = '"+contractserialNo+"' "); 
if(COCONTRACTNO == null)  COCONTRACTNO = "";
//�����ױ��ý��˺�
String RTNACTNO =  "";
//ԭ�����׶�ȵ�����
String OLD_TEDATE = bcChange.getString("OLDCLMATURITYDATE"); 
if(OLD_TEDATE == null)  OLD_TEDATE = "";
//�~�ȵ�������
String TEDATE = bcChange.getString("CLMATURITYDATE"); 
if(TEDATE == null)  TEDATE = "";
String TXDATE = StringFunction.getToday();//��ӡ�r�g
%> 
<style>
	inline_button { height:20px; };
    *{font-size: 15px;}
</style>

<body lang=ZH-CN style='tab-interval:21.0pt;text-justify-trim:punctuation'>

<div class=Section1 style='layout-grid:15.6pt' align="center">

<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=636
 style='width:477.0pt;margin-left:5.4pt;border-collapse:collapse;mso-padding-alt:
 0cm 0cm 0cm 0cm'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;height:51.9pt'>
  <td width=636 colspan=4 style='width:477.0pt;border:solid windowtext 1.0pt;
  background:#A0A0A0;padding:0cm 5.4pt 0cm 5.4pt;height:51.9pt'>
  <p class=MsoNormal align=center style='text-align:center;mso-pagination:widow-orphan;
  tab-stops:440.1pt'><b><span style='font-size:12.0pt;font-family:����;
  mso-font-kerning:0pt'>�����׶�ȵ����ձ��֪ͨ��</span></b><b><span lang=EN-US
  style='font-size:12.0pt;mso-font-kerning:0pt'><o:p></o:p></span></b></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1;height:29.85pt'>
  <td width=636 colspan=4 style='width:477.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:29.85pt'> 
  <p class=MsoNormal style='mso-pagination:widow-orphan'><u><span lang=EN-US
  style='font-size:11.0pt;font-family:����;mso-font-kerning:0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></u><span
  style='font-size:11.0pt;font-family:����;mso-font-kerning:0pt'>��������Ʋ���<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2;height:74.5pt'>
  <td width=636 colspan=4 style='width:477.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:74.5pt'>
  <p class=MsoNormal style='line-height:150%;mso-pagination:widow-orphan'><u><span
  lang=EN-US style='mso-bidi-font-size:10.5pt;line-height:150%;font-family:
  ����;mso-font-kerning:0pt'>&nbsp;&nbsp;&nbsp;&nbsp;<%=custname %>&nbsp;&nbsp;&nbsp;&nbsp;
  </span></u><span style='mso-bidi-font-size:10.5pt;line-height:150%;
  font-family:����;mso-font-kerning:0pt'>�������ˣ��������׶�ȵ����ձ��ҵ���Ѿ�������ҵ���������򱨾���Ȩ����������ͬ�⣬��ͨ���ſ�ල��ˣ����㲿���ձ�֪ͨ��Ҫ�󣬰��������׶�ȵ����ձ����ͨ���ס�<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3'>
  <td width=636 colspan=4 valign=top style='width:477.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;height:1.0cm;mso-height-rule:exactly'>
  <td width=127 style='width:95.2pt;border:solid windowtext 1.0pt;border-top:
  none;padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>�ͻ���<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=185 style='width:138.8pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><%=MFCUSTNO%><o:p></o:p></span></p>
  </td>
  <td width=132 style='width:99.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>�ͻ�����<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=192 style='width:144.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����'><%=custname %></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
 </tr>
   <tr style='mso-yfti-irow:4;height:1.0cm;mso-height-rule:exactly'>
  <td width=127 style='width:95.2pt;border:solid windowtext 1.0pt;border-top:
  none;padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>������<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=185 style='width:138.8pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><%=brcode %><o:p></o:p></span></p>
  </td>
  <td width=132 style='width:99.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=192 style='width:144.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����'></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
 </tr>
  <tr style='mso-yfti-irow:6;height:1.0cm;mso-height-rule:exactly'>
  <td width=127 style='width:95.2pt;border:solid windowtext 1.0pt;border-top:
  none;padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>���������ź�ͬ��<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=185 style='width:138.8pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><%=contractno %></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=132 style='width:99.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>������ͬ��<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=192 style='width:144.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><%=COCONTRACTNO %></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;height:1.0cm;mso-height-rule:exactly'>
  <td width=127 style='width:95.2pt;border:solid windowtext 1.0pt;border-top:
  none;padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>�����׿���<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=185 style='width:138.8pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><%=cardno %></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=132 style='width:99.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>�����ױ��ý��˺�<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=192 style='width:144.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><%=RTNACTNO %></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:7;height:1.0cm;mso-height-rule:exactly'>
  <td width=127 style='width:95.2pt;border:solid windowtext 1.0pt;border-top:
  none;padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>ԭ�����׶�ȵ�����<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=185 style='width:138.8pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����'><%=OLD_TEDATE %></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
  <td width=132 style='width:99.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>�������׶�ȵ�����<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width=192 style='width:144.0pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm;mso-height-rule:exactly'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����'><%=TEDATE %></span><span
  lang=EN-US style='mso-bidi-font-size:10.5pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:9;height:17.0pt'>
  <td width=636 colspan=4 valign=top style='width:477.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:17.0pt'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:10;height:112.9pt'>
  <td width=636 colspan=4 valign=top style='width:477.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:112.9pt'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='font-size:12.0pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='font-size:12.0pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>�ſ�ල��ǩ�֣�<span
  lang=EN-US><o:p></o:p></span></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span><span style='mso-bidi-font-size:10.5pt;font-family:����;mso-font-kerning:
  0pt'>�ſ�ר���£�<span lang=EN-US><o:p></o:p></span></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='font-size:12.0pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='font-size:12.0pt;font-family:����;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span lang=EN-US
  style='font-size:12.0pt;font-family:����;mso-font-kerning:0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span
  style='font-size:11.0pt;font-family:����;mso-font-kerning:0pt'>���ڣ�</span><span
  lang=EN-US style='font-size:11.0pt;font-family:����'><%=TXDATE %></span><span
  lang=EN-US style='font-size:11.0pt;font-family:����;mso-font-kerning:0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:11;mso-yfti-lastrow:yes;height:31.35pt'>
  <td width=636 colspan=4 style='width:477.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:31.35pt'>
  <p class=MsoNormal style='mso-pagination:widow-orphan'><span
  style='font-size:11.0pt;font-family:����;mso-font-kerning:0pt'>����֪ͨ�鹲���������ͻ�������ƺ��ĵ�����Ա��һ�ݣ�<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
</table>


<p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p>


	</div>

<table align="center">
	<tr>	
		<td id="print"><%=HTMLControls.generateButton("��ӡ", "��ӡ", "printPaper()", "") %></td>
	</tr>
</table>

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

</body>
<%@ include file="/Frame/resources/include/include_end.jspf"%>