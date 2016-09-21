<%@page import="com.amarsoft.app.als.sys.rate.config.BaseRateConfig"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import ="com.amarsoft.app.base.util.DateHelper"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

  String Update = Sqlca.getString(new SqlObject("SELECT EFFECTDATE FROM PUB_RATE_INFO WHERE EFFECTDATE=(SELECT MAX(EFFECTDATE) FROM PUB_RATE_INFO)")).toString();// 获得最新的贷款利率日期
  double SixMonthRate = BaseRateConfig.getBaseRate("CNY", 360, "200", "01", DateHelper.TERM_UNIT_MONTH, 6, com.amarsoft.app.base.util.DateHelper.getBusinessDate());//获得最新6月利率
  double OneYearRate = BaseRateConfig.getBaseRate("CNY", 360, "200", "01", DateHelper.TERM_UNIT_MONTH, 12, com.amarsoft.app.base.util.DateHelper.getBusinessDate());//获得最新1年利率
  double ThreeYearRate = BaseRateConfig.getBaseRate("CNY", 360, "200", "01", DateHelper.TERM_UNIT_MONTH, 36, com.amarsoft.app.base.util.DateHelper.getBusinessDate());//获得最新3年利率
  double FiveYearRate = BaseRateConfig.getBaseRate("CNY", 360, "200", "01", DateHelper.TERM_UNIT_MONTH, 60, com.amarsoft.app.base.util.DateHelper.getBusinessDate());//获得最新5年利率
  double ThirtyYearRate = BaseRateConfig.getBaseRate("CNY", 360, "200", "01", DateHelper.TERM_UNIT_MONTH, 999, com.amarsoft.app.base.util.DateHelper.getBusinessDate());//获得最新30年利率
                                        
%>
<html>
<head>
<title>贷款期限试算</title> 
</head>
<table width=100% >
      <tr>
<td>
</td>
  </tr>
      </table>
<body class="pagebackground" leftmargin="0" topmargin="0" onload="" >
<form name=frm action="RateReference.jsp">
<h3 style="text-align:center;">个人贷款参考利率表</h3>
<h4 style="text-align:center;">调整日期：<%=StringEscapeUtils.escapeHtml(Update)%></h4>
<table border="1" align="center">	
	<tr>
		<td style="background-color:#23238E;text-align:center;color:white;"><b>贷款年限</b>></td>		
		<td style="background-color:#23238E;text-align:center;color:white;"> <b>年利率</b></td>  
	</tr>
	<tr>
		<td >0-6月（含6月）</td>		
		<td > <input  readonly=true type=text name="iSixMonthRate" style="background:transparent;text-align:right;border-style:groove">%</td>  
	</tr>	 
		<tr>
		<td style="background-color:#C0D9D9;">6月-1年（含1年）</td>		
		<td style="background-color:#C0D9D9;"> <input  readonly=true type=text name="iOneYearRate" style="background:transparent;text-align:right;border-style:groove">%</td>  
	</tr>	 
		<tr>
		<td >1-3年（含3年）</td>		
		<td > <input  readonly=true type=text name="iThreeYearRate" style="background:transparent;text-align:right;border-style:groove">%</td>  
	</tr>	 
		<tr>
		<td style="background-color:#C0D9D9;">3-5年（含5年）</td>		
		<td style="background-color:#C0D9D9;"> <input  readonly=true type=text name="iFiveYearRate" style="background:transparent;text-align:right;border-style:groove">%</td>  
	</tr>	 
		<tr>
		<td >5-30年（含30年）</td>		
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
