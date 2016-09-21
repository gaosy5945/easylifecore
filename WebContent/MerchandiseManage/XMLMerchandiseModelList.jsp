<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>

<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_List.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script>

 <%
 
 	String xmlFile = CurPage.getParameter("XMLFile");
	String xmlTags = CurPage.getParameter("XMLTags");
	String keys = CurPage.getParameter("Keys");
	String PG_TITLE = "商品型号参数";
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("XMLMerchandiseList", BusinessObject.createBusinessObject(), CurPage, request);
	ASDataObject doTemp=dwTemp.getDataObject();
	doTemp.setBusinessProcess("com.amarsoft.app.als.businessobject.web.XMLBusinessObjectProcessor");
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","","Button","新增型号","新增型号","ALSObjectWindowFunctions.addRow(0)","","","","",""},
			{"true","","Button","保存型号","保存型号","as_save()","","","","",""},
			{"true","","Button","删除型号","删除型号","if(confirm('确实要删除吗?'))ALSObjectWindowFunctions.deleteSelectRow(0)","","","","",""}
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
</script>	
<%@include file="/Frame/resources/include/include_end.jspf"%>