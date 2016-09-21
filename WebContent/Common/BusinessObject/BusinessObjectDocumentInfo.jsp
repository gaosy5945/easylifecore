<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	//获得组件参数
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	String rightType = CurPage.getParameter("RightType");//权限
	String docNo = CurPage.getParameter("DocNo");
	if(objectType == null) objectType = "";
	if(objectNo == null) objectNo = "";
	if(docNo == null) docNo = "";
	
	String templeteNo =  CurPage.getParameter("InfoTempleteNo");//模板
	if(StringX.isEmpty(templeteNo)) templeteNo = "DocBusinessObjectDocumentInfo";
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType", objectType);
	inputParameter.setAttributeValue("ObjectNo", objectNo);
	inputParameter.setAttributeValue("DocNo", docNo);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(templeteNo, inputParameter, CurPage, request);
	ASDataObject doTemp = dwTemp.getDataObject();
	dwTemp.genHTMLObjectWindow("");
	//dwTemp.replaceColumn("AttechmentList", "<iframe type='iframe' name=\"frame_list_attechment\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\"\"></iframe>", CurPage.getObjectWindowOutput());

	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button","返回","返回","returnBack()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(sPostEvents){
		as_save("myiframe0",sPostEvents);
	}
	
	function returnBack(){
		AsControl.OpenPage("/Common/BusinessObject/BusinessObjectDocumentList.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&RightType=<%=rightType%>","_self","");
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>