<%@page import="com.amarsoft.app.als.prd.config.loader.ProductConfig"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String objectType = CurPage.getParameter("ObjectType");  //�����������ˮ
	String objectNo = CurPage.getParameter("ObjectNo");  //�����������ˮ
	if(objectType==null || objectType.equals("")){
		out.print("�봫��objectType����!");
		return ;
	}
	if(objectNo==null || objectNo.equals("")){
		out.print("�봫��objectNo����!");
		return ;
	}
	String sceneType = CurPage.getParameter("SceneType");
	if(sceneType == null) sceneType = "";
	
	ASObjectModel doTemp = new ASObjectModel("ProductControlList");  //PRD_PRODUCT_CONTROL
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style="1";//����ΪGrid���
	dwTemp.ReadOnly = "0"; 
	dwTemp.genHTMLObjectWindow(objectNo+","+sceneType);  //ObjectType, ObjectNo, SceneType
	
	String sButtons[][] = {
		//{"true","","Button","����","����","saveRecord()","","","","",""},
	};
	//sButtonPosition = "south";
%>

<script type="text/javascript">
$(document).ready(function(){
	
})
</script>
	
<%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>