<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String parentSerialNo = CurPage.getParameter("ParentSerialNo");
	if(parentSerialNo == null) parentSerialNo = "";
	String prjSerialNo = CurPage.getParameter("PrjSerialNo");
	if(prjSerialNo == null) prjSerialNo = "";
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String divideType = CurPage.getParameter("DivideType");
	if(divideType == null) divideType = "";
	String guarantyPeriodFlag = CurComp.getParameter("guarantyPeriodFlag");
	if(guarantyPeriodFlag == null) guarantyPeriodFlag = "";

	String sTempletNo = "ProjectGuarantyDownInfoGuaranty";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDefaultValue("DIVIDETYPE", divideType);
	doTemp.setDefaultValue("VOUCHTYPE", guarantyPeriodFlag);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform	
	dwTemp.setParameter("SerialNo", serialNo);	
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
			{"true","All","Button","返回","返回列表","top.close()","","","",""}
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function initRow(){
		<% if( CurComp.getParameter("SerialNo") == null){%>
		setItemValue(0,0,"PARENTSERIALNO","<%=parentSerialNo%>");
		setItemValue(0,0,"OBJECTTYPE","jbo.guaranty.GUARANTY_CONTRACT");
		setItemValue(0,0,"OBJECTNO","<%=prjSerialNo%>");
	<%}%>
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
