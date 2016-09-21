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
			{"true","","Button","新增品牌","新增品牌","ALSObjectWindowFunctions.addRow(0)","","","","",""},
			{"true","","Button","保存品牌","保存品牌","as_save()","","","","",""},
			{"true","","Button","删除品牌","删除品牌","if(confirm('确实要删除吗?'))ALSObjectWindowFunctions.deleteSelectRow(0)","","","","",""}
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function mySelectRow(){
		var parameterID = getItemValue(0,getRow(),"ID");
		if(typeof(parameterID)=="undefined" || parameterID.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=请先选择相应的信息!","frameright","");
		}else{
			AsControl.OpenView("/MerchandiseManage/XMLMerchandiseModelList.jsp","XMLFile=<%=xmlFile%>&XMLTags=<%=xmlTags%>||ID='"+parameterID+"'//merchandise&Keys=<%=keys%>&RightType=All","frameright","");
		}
	} 
</script>	
<%@include file="/Frame/resources/include/include_end.jspf"%>