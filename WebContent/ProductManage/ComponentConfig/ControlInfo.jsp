<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");  //�����������ˮ
	String sceneType = CurPage.getParameter("SceneType");
	if(serialNo == null) serialNo = "";
	if(sceneType == null) sceneType = "";

	ASObjectModel doTemp = new ASObjectModel("ProductControlList");  //PRD_PRODUCT_CONTROL
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style="1";//����ΪGrid���
	dwTemp.ReadOnly = "0"; 
	dwTemp.genHTMLObjectWindow("jbo.prd.PRD_COMPONENT_PARAMETER,"+serialNo+","+sceneType);  //ObjectType, ObjectNo, SceneType
	
	String sButtons[][] = {
		{"true","","Button","����","����","saveRecord()","","","","",""},
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