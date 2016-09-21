<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

<%
	String PG_TITLE = "新增抵质押物"; 
	String serialNo = CurPage.getParameter("SerialNo");if(serialNo == null)serialNo = "";
	String gcSerialNo = CurPage.getParameter("GCSerialNo");if(gcSerialNo == null)gcSerialNo = "";
	String assetSerialNo = CurPage.getParameter("AssetSerialNo");if(assetSerialNo == null)assetSerialNo = "";
	String assetName = CurPage.getParameter("AssetName");if(assetName == null)assetName = "";
	
	ASObjectModel doTemp = new ASObjectModel("NewCollateralInfo");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置为freeform风格
	dwTemp.ReadOnly = "0"; //设置为只读

	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","All","Button","保存","保存","saveRecord()","","","",""},
		};
%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>

<script type="text/javascript">
	function saveRecord(){
		as_save("0",'');
		gcSerialNo = getItemValue(0,getRow(),"GCSerialNo");
		
	}
	
	function init(){
		if(getRowCount(0)==0){
			setItemValue(0,getRow(),"GCSerialNo","<%=gcSerialNo%>");
			setItemValue(0,getRow(),"AssetSerialNo","<%=assetSerialNo%>");
			setItemValue(0,getRow(),"AssetName","<%=assetName%>");
		}
	}
	
	init();
</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
