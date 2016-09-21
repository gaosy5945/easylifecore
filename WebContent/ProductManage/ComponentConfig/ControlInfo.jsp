<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");  //参数或组件流水
	String sceneType = CurPage.getParameter("SceneType");
	if(serialNo == null) serialNo = "";
	if(sceneType == null) sceneType = "";

	ASObjectModel doTemp = new ASObjectModel("ProductControlList");  //PRD_PRODUCT_CONTROL
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style="1";//设置为Grid风格
	dwTemp.ReadOnly = "0"; 
	dwTemp.genHTMLObjectWindow("jbo.prd.PRD_COMPONENT_PARAMETER,"+serialNo+","+sceneType);  //ObjectType, ObjectNo, SceneType
	
	String sButtons[][] = {
		{"true","","Button","保存","保存","saveRecord()","","","","",""},
	};
	//sButtonPosition = "south";
%>

<script type="text/javascript">

	function saveRecord(){
		as_save("0","");
	}
	
</script>
	
<%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>