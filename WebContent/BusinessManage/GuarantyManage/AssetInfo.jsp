<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%	
	String PG_TITLE = "押品信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String assetSerialNo = CurPage.getParameter("AssetSerialNo");
	if(assetSerialNo == null) assetSerialNo = "";
	String templetNo = CurPage.getParameter("TemplateNo");
	if(templetNo == null) templetNo = "";
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("AssetSerialNo", assetSerialNo);
	
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel(templetNo,inputParameter,CurPage);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(doTemp, CurPage, request);
	
	dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setParameter("AssetSerialNo", assetSerialNo);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"false","All","Button","保存","保存","saveRecord()","","","",""}
	};

%> 
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	
	function saveRecord(){

	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 