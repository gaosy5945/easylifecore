<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	Double balanceSum = Sqlca.getDouble(new SqlObject("SELECT SUM(BC.BALANCE) FROM PRJ_RELATIVE PR,BUSINESS_CONTRACT BC WHERE PR.OBJECTNO=BC.SERIALNO AND PR.OBJECTTYPE='jbo.app.BUSINESS_CONTRACT' AND PR.PROJECTSERIALNO=:PROJECTSERILANO").setParameter("PROJECTSERILANO",serialNo));
	Double individualPercent = Sqlca.getDouble(new SqlObject("SELECT INDIVIDUALPERCENT FROM CLR_MARGIN_INFO WHERE OBJECTTYPE='jbo.prj.PRJ_BASIC_INFO' AND OBJECTNO=:OBJECTNO").setParameter("OBJECTNO",serialNo));

	String sTempletNo = "ProjectMarginCaculate";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
	};
%>
<HEAD>
<title>保证金测算</title>
</HEAD>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
function caculateBalance(){
	var	balanceSum = "<%=balanceSum%>";
	var individualPercent = "<%=individualPercent%>";
	if(individualPercent == "null"){
		alert("请确认保证金比例！");
		return;
	}
	var marginNeedSum = FormatKNumber(parseFloat(balanceSum)*parseFloat(individualPercent)/100.00,2);
	setItemValue(0,0,"MARGINNEEDSUM", marginNeedSum);
}
caculateBalance();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
