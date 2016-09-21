<%@page import="com.amarsoft.app.awe.config.query.ASHtmlTableHandler"%>
<%@page import="com.amarsoft.are.jbo.*"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin.jspf"%><%
	String sMajorObjClass = CurPage.getParameter("MajorObjClass");
	String sJBOQL = CurPage.getParameter("JBOQL");
	String sExportFields = CurPage.getParameter("ExportFields");
	String sSumFields = CurPage.getParameter("SumFields");
	String sParameters = CurPage.getParameter("Parameters");
	String sRowLimitChecked = CurPage.getParameter("RowLimitChecked");
	String sRowLimit = CurPage.getParameter("RowLimit");
	if(sMajorObjClass == null) sMajorObjClass = "";
	if(sJBOQL == null) sJBOQL = "";
	if(sExportFields == null) sExportFields = "*";
	if(sSumFields == null) sSumFields = "";
	if(sParameters == null) sParameters = "";
	if(sRowLimit == null) sRowLimit = "0";
	int iRowLimit = Integer.valueOf(sRowLimit);
	
	//从JBO列表画出简易的html列表
	BizObjectQuery q = JBOFactory.getFactory().getManager(sMajorObjClass).createQuery(sJBOQL);
	//给query的参数赋值
	if (sParameters.indexOf("@") != -1) {
		sParameters = sParameters.substring(1);
		String [] as = sParameters.split(",");
		for (int i =0 ; i < as.length; i++) {
			String [] v = as[i].split("@");
			if (v.length > 1) {
				q.setParameter(v[0].trim(), v[1].trim());
			}
		}
	}
	//有设定行数限制的，置上query的最大结果集
	if(sRowLimitChecked.equals("true")){
		q.setMaxResults(iRowLimit);
	}
	//取得JBO列表
	List list = q.getResultList(false);
	//渲染出html
	ASHtmlTableHandler ht = new ASHtmlTableHandler(list);
	ht.setTableAttribute("class='mdftbl'");
	ht.setHeaderAttribute("class='alce'");
	ht.setExportFields(sExportFields);
	if(!"".equals(sSumFields)){
		ht.setSumFields(sSumFields);
		ht.setIncludeSum(true);
	}
	ht.setIncludeRowNumber(true);
	//out.println(ht.getHtmlText());
	
	String sButtons[][] = {
		{"true","","Button","导出Excel","导出Excel","exportPage()","","","",""},
	};
%>
<style>
table.mdftbl{margin:0;border-collapse:collapse;width:90%; }
table.mdftbl td{font-size:12px;border:1px solid #bebebe; padding:4px; color:#222222}
tr.alce{ text-align:center; background:#dcdcdc}
tr.alce b{ font-size:14px; color:#435868}
table.mdftbl a{color:red; float:right}
</style>
<body style="overflow-y:hidden;">
<div align="left" style="margin-top:6px;"><%@ include file="/Frame/resources/include/ui/include_buttonset.jspf" %></div>
<div id="resultDiv" style="overflow: auto;width: 100%;height: 100%;"><%=ht.getHtmlText()%></div>
<form name=formexport method=post action="<%=request.getContextPath()%>/servlet/view/stream?CompClientID=<%=sCompClientID%>" target=iframehide >
	<div style="display:none">
		<input name=stream value="">
		<input name=viewtype value=save>
		<input name=contenttype value="text/html">
		<input name=encodingfrom value="GBK">
		<input name=encodingto value="GBK">
		<input name=filename value="<%=sMajorObjClass+"_"+StringFunction.replace(StringFunction.getTodayNow(),"/","")+".xls" %>">		
	</div>
</form>
<iframe name="iframehide" src="<%=com.amarsoft.awe.util.Escape.getBlankHtml(sWebRootPath)%>" style="display:none" width=0 height=0 frameborder=0></iframe>
</body>
<script type="text/javascript">
setDialogTitle("查询结果");
function exportPage(){
	var sContent = $("#resultDiv").html();
	formexport.stream.value=sContent;
	formexport.submit();
}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>