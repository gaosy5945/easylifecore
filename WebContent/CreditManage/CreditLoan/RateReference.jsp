<%@page import="com.amarsoft.app.als.sys.rate.config.BaseRateConfig"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import ="com.amarsoft.app.base.util.DateHelper"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

  String Update = Sqlca.getString(new SqlObject("SELECT EFFECTDATE FROM PUB_RATE_INFO WHERE EFFECTDATE=(SELECT MAX(EFFECTDATE) FROM PUB_RATE_INFO)")).toString();// ������µĴ�����������
  double SixMonthRate = BaseRateConfig.getBaseRate("CNY", 360, "200", "01", DateHelper.TERM_UNIT_MONTH, 6, com.amarsoft.app.base.util.DateHelper.getBusinessDate());//�������6������
  double OneYearRate = BaseRateConfig.getBaseRate("CNY", 360, "200", "01", DateHelper.TERM_UNIT_MONTH, 12, com.amarsoft.app.base.util.DateHelper.getBusinessDate());//�������1������
  double ThreeYearRate = BaseRateConfig.getBaseRate("CNY", 360, "200", "01", DateHelper.TERM_UNIT_MONTH, 36, com.amarsoft.app.base.util.DateHelper.getBusinessDate());//�������3������
  double FiveYearRate = BaseRateConfig.getBaseRate("CNY", 360, "200", "01", DateHelper.TERM_UNIT_MONTH, 60, com.amarsoft.app.base.util.DateHelper.getBusinessDate());//�������5������
  double ThirtyYearRate = BaseRateConfig.getBaseRate("CNY", 360, "200", "01", DateHelper.TERM_UNIT_MONTH, 999, com.amarsoft.app.base.util.DateHelper.getBusinessDate());//�������30������
                                        
%>
<html>
<head>
<title>������������</title> 
</head>
<table width=100% >
      <tr>
<td>
</td>
  </tr>
      </table>
<body class="pagebackground" leftmargin="0" topmargin="0" onload="" >
<form name=frm action="RateReference.jsp">
<h3 style="text-align:center;">���˴���ο����ʱ�</h3>
<h4 style="text-align:center;">�������ڣ�<%=StringEscapeUtils.escapeHtml(Update)%></h4>
<table border="1" align="center">	
	<tr>
		<td style="background-color:#23238E;text-align:center;color:white;"><b>��������</b>></td>		
		<td style="background-color:#23238E;text-align:center;color:white;"> <b>������</b></td>  
	</tr>
	<tr>
		<td >0-6�£���6�£�</td>		
		<td > <input  readonly=true type=text name="iSixMonthRate" style="background:transparent;text-align:right;border-style:groove">%</td>  
	</tr>	 
		<tr>
		<td style="background-color:#C0D9D9;">6��-1�꣨��1�꣩</td>		
		<td style="background-color:#C0D9D9;"> <input  readonly=true type=text name="iOneYearRate" style="background:transparent;text-align:right;border-style:groove">%</td>  
	</tr>	 
		<tr>
		<td >1-3�꣨��3�꣩</td>		
		<td > <input  readonly=true type=text name="iThreeYearRate" style="background:transparent;text-align:right;border-style:groove">%</td>  
	</tr>	 
		<tr>
		<td style="background-color:#C0D9D9;">3-5�꣨��5�꣩</td>		
		<td style="background-color:#C0D9D9;"> <input  readonly=true type=text name="iFiveYearRate" style="background:transparent;text-align:right;border-style:groove">%</td>  
	</tr>	 
		<tr>
		<td >5-30�꣨��30�꣩</td>		
		<td > <input  readonly=true type=text name="iThirtyYearRate" style="background:transparent;text-align:right;border-style:groove">%</td>  
	</tr>	 		
</table>
</form>
</body>
</html>

<script>

function Assignment()
{  

	
	document.frm.iSixMonthRate.value = <%=SixMonthRate%>;
	document.frm.iOneYearRate.value = <%=OneYearRate%>;
	document.frm.iThreeYearRate.value = <%=ThreeYearRate%>;
	document.frm.iFiveYearRate.value = <%=FiveYearRate%>;
	document.frm.iThirtyYearRate.value = <%=ThirtyYearRate%>;

}
Assignment()


</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
