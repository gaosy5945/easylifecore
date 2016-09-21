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
	
	String sTempletNo = "ScaleCreditLineDownInfoOrg";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDefaultValue("DIVIDETYPE", divideType);
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
	function selectBusinessType(){
		var serialNo = "<%=prjSerialNo%>"; 
		var sParaString = "SerialNo"+","+serialNo;	
		setObjectValue("SelectOwnedBusinessType",sParaString,"@typeno@0@typename@1",0,0,"");
	    reloadSelf();
	}
	function selectOrg(){
		var serialNo = "<%=prjSerialNo%>"; 
		var sParaString = "SerialNo"+","+serialNo;	
		setObjectValue("SelectOwnedOrg",sParaString,"@orgid@0@orgname@1",0,0,"");
	    reloadSelf();
	}
	function initRow(){
		<% if( CurComp.getParameter("SerialNo") == null){%>
			setItemValue(0,0,"PARENTSERIALNO","<%=parentSerialNo%>");
			setItemValue(0,0,"OBJECTTYPE","jbo.prj.PRJ_BASIC_INFO");
			setItemValue(0,0,"OBJECTNO","<%=prjSerialNo%>");
		<%}%>
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
