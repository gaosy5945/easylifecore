<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

<%
	String PG_TITLE = "押品信息"; 
	String serialNo = CurPage.getParameter("SerialNo");if(serialNo == null)serialNo = "";
	String vouchType = CurPage.getParameter("VouchType");if(vouchType == null)vouchType = "";
	
	ASObjectModel doTemp = new ASObjectModel("CollateralInfo");
	
	if(vouchType.startsWith("020")){
		doTemp.setColumnAttribute("SerialNo", "ColHeader", "抵押编号");
		doTemp.setColumnAttribute("AssetSerialNo", "ColHeader", "抵押物编号");
		doTemp.setColumnAttribute("AssetName", "ColHeader", "抵押物名称");
	}
	else{
		doTemp.setColumnAttribute("SerialNo", "ColHeader", "质押编号");
		doTemp.setColumnAttribute("AssetSerialNo", "ColHeader", "质押物编号");
		doTemp.setColumnAttribute("AssetName", "ColHeader", "质押物名称");
	}
	
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
	}
	

</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
