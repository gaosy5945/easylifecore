<%@ page contentType="text/html; charset=GBK"%><%@ include file="/Frame/resources/include/include_begin.jspf"%><%		String serialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));	String APPNO = "";	if(serialNo == null){		serialNo = "";	}else{	    APPNO = serialNo.substring(2, 8)+serialNo.substring(10, 16);	}	String TXDATE = Sqlca.getString(new SqlObject("select AccountingDate from ACCT_TRANSACTION where SerialNo = :SerialNo").setParameter("SerialNo", serialNo));	if(TXDATE == null)     TXDATE = "";	String CINO = Sqlca.getString(new SqlObject("select RELATIVEOBJECTNO from ACCT_TRANSACTION where SerialNo = :SerialNo").setParameter("SerialNo", serialNo));	if(CINO == null)     CINO = "";//6501202110082701	//������	BizObject bdbiz = JBOFactory.getFactory()			.getManager("jbo.app.BUSINESS_DUEBILL")			.createQuery("O.serialNo = :CINO")			.setParameter("CINO", CINO).getSingleResult();		String ORGID = bdbiz.getAttribute("OPERATEORGID").toString();//����	if(ORGID == null)     ORGID = "";	String NAME = bdbiz.getAttribute("CUSTOMERNAME").toString(); //������	if(NAME == null)     NAME = "";	String LNNAME = Sqlca.getString("select typename from business_type where typeno = (select BUSINESSTYPE from business_duebill where SerialNo = '"+CINO+"')");//������	if(LNNAME == null)     LNNAME = "";	String SPECIALLOANCARDNO = Sqlca.getString("select ACCOUNTNO from ACCT_BUSINESS_ACCOUNT where objecttype = 'jbo.app.BUSINESS_DUEBILL' and objectno = '"+CINO+"' and ACCOUNTINDICATOR = '04'");//����ר��������	if(SPECIALLOANCARDNO == null)     SPECIALLOANCARDNO = "";	/* String APPNO = bdbiz.getAttribute("CONTRACTSERIALNO").toString();//���ҵ����	if(APPNO == null)     APPNO = ""; */	/* String TXDATE = bdbiz.getAttribute("INPUTDATE").toString(); //������� 	*/	String DATE = StringFunction.getToday();//����	if(DATE == null)     DATE = "";%>
<style>*{font-size: 15px}</style>
<body lang=ZH-CN style='text-justify-trim:punctuation'>

<div class=Section1 style='layout-grid:15.6pt' align="center">

<p class=MsoNormal style='margin-left:-35.9pt;text-indent:35.9pt'><span
lang=EN-US>&nbsp;</span></p>

<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0
 style='width:639px;margin-left:5.4pt;border-collapse:collapse;border:medium none' height="727">
 <tr style='height:75.9pt'>
  <td colspan=4 style='border-left:1.5pt solid windowtext; border-right:1.5pt solid windowtext; border-top:1.5pt solid windowtext; width:621px;border-bottom:1.0pt solid windowtext;background:#aaaaaa;height:69px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm' align="center">
 <b>ר���ʽ�һ����ת���ý�֪ͨ��  </b>  </td>
 </tr>
 <tr style='height:30.0pt'>
  <td colspan=4 style='width:621px;border-top:medium none;
  border-left:1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-right:1.5pt solid windowtext;height:22px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>


	<span
  lang=EN-US style="font-family: ����"><font style="font-size: 11pt">&nbsp;</font></span></td>
 </tr>
 <tr>
  <td colspan=4 style='width:621px;border-top:medium none;
  border-left:1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-right:1.5pt solid windowtext;height:44px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>


	<span style='font-family:����'>
	<font style="font-size: 11pt"></font></span></u><span style='font-family:����'><font style="font-size: 11pt">__________��������Ʋ��ţ�</font><span
  lang=EN-US><font style="font-size: 11pt">&nbsp;</font></span></span></td>
 </tr>
 <tr style='height:60.85pt'>
  <td colspan=4 style='width:621px;border-top:medium none;
  border-left:1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-right:1.5pt solid windowtext;height:83px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal style='margin-left:0.0pt'>
	<span lang=EN-US
  style='font-family:����'><font style="font-size: c; text-decoration:underline"><%=NAME%></font></span><span
  style='font-family:����'><font style="font-size: c">�������ˣ���<span lang=EN-US><%=LNNAME%></u>ר���ʽ�һ����ת���ý�</span></font></span></p>
	<p class=MsoNormal style='margin-left:0.0pt'>
	<span
  style='font-family:����'><font style="font-size: c">
	�Ѿ�������ҵ���������򱨾���Ȩ����������ͬ�⣬���㲿���ձ�֪ͨ��Ҫ�󣬰���ר���ʽ�һ����ת���ý�������</font></span></p>
  </td>
 </tr>
 <tr>
  <td colspan=4 style='width:621px;border-top:medium none;
  border-left:1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-right:1.5pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  ��</td>
 </tr>
 <tr style='height:13.2pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:����'>��ݺ�</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'>&nbsp;<%=CINO%></span></span></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: ����">����ר��������</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'>&nbsp;<%=SPECIALLOANCARDNO%></span></p>
  </td>
 </tr>
 <tr style='height:11.25pt'>
  <td width=132 style='width:99.0pt;border-top:medium none;border-left:
  1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;border-right:
  1.0pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style="font-family: ����">���ҵ����</span></p>
  </td>
  <td style='width:153px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'>&nbsp;<%=APPNO%></span></p>
  </td>
  <td style='width:129px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.0pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-family:����'>�������</span></p>
  </td>
  <td style='width:163px;border-top:medium none;border-left:
  medium none;border-bottom:1.0pt solid windowtext;border-right:1.5pt solid windowtext;
  height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-family:����_GB2312'>&nbsp;<%=TXDATE%></span></p>
  </td>
 </tr>
 <tr style='height:178.85pt'>
  <td colspan=4 valign=top style='width:621px;border-top:medium none;
  border-left:1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-right:1.5pt solid windowtext;height:20px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span lang=EN-US style='font-size:12.0pt;font-family:����_GB2312'>&nbsp;</span></p>
  </td>
 </tr>
 <tr>
  <td colspan=4 valign=top style='width:621px;border-top:medium none;
  border-left:1.5pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-right:1.5pt solid windowtext;height:226px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal style='margin-left:9.0pt'>��</p>
  <p class=MsoNormal style='margin-left:9.0pt'>
	<span style='font-family:����'>�Ƿ����ת���ʽ����ñʴ���Ĳ��ֻ�ȫ����ǰ��������� ���ǣ� ����&nbsp; </span></p>
  <p class=MsoNormal><span lang=EN-US style='font-size:14.0pt;font-family:����_GB2312'>&nbsp;</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US
  style='font-size:14.0pt;font-family:����_GB2312'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span lang=EN-US
  style='font-size:11pt;font-family:����_GB2312'>&nbsp;&nbsp;</span><span
  lang=EN-US style='font-size:11pt;font-family:����'>&nbsp;</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'>
	<span style='font-family:����'>����ͻ�����ǩ�֣�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>
	<span lang=EN-US
  style='font-size:11pt;font-family:����'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span><!--span style='font-size:11pt;font-family:����'>������Աǩ�֣�</span--></p>
  <p class=MsoNormal style='margin-left:9.0pt'>
	<span lang=EN-US
  style='font-size:11pt;font-family:����'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;</span></p>
	<p class=MsoNormal style='margin-left:9.0pt'>��</p>
	<p class=MsoNormal style='margin-left:9.0pt'>��</p>
	<p class=MsoNormal style='margin-left:9.0pt'>��</p>
	<p class=MsoNormal style='margin-left:9.0pt'><span lang="en-us">
	<font style="font-size: 11pt"><span style="font-family: ����">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	</span></font></span><span
  style='font-size:11pt;font-family:����'>���ڣ�<%=DATE%></span></p>
  </td>
 </tr>
 <tr style='height:38.1pt'>
  <td colspan=4 style='border-left:1.5pt solid windowtext; border-right:1.5pt solid windowtext; border-bottom:1.5pt solid windowtext; width:621px;border-top:medium none;height:107px; padding-left:5.4pt; padding-right:5.4pt; padding-top:0cm; padding-bottom:0cm'>
  <p class=MsoNormal><span style='font-size:10.0pt;font-family:����;color:black'>��֪ͨ��һʽ���ݣ���Ӫ���š�ҵ���Ÿ�����һ�ݣ�</span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal><span lang=EN-US style='font-size:12.0pt;font-family:����_GB2312'>&nbsp;</span></p>

</div>
<table align="center">	<tr>			<td id="print"><%=HTMLControls.generateButton("��ӡ", "��ӡ", "printPaper()", "") %></td>	</tr></table></body><script>   function printPaper(){	   var print = document.getElementById("print");	   if(window.confirm("�Ƿ�ȷ��Ҫ��ӡ��")){		   //��ӡ	  		   print.style.display = "none";		   window.print();			   window.close();	   }   }</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>