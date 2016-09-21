<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>

<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_List.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script>

 <%
	/*
		页面说明: 产品参数列表页面
	 */
	String xmlFile = CurPage.getParameter("XMLFile");
	String xmlTags = CurPage.getParameter("XMLTags");
	String keys = CurPage.getParameter("Keys");
	String PG_TITLE = "产品参数列表";
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("PRD_ParameterList", BusinessObject.createBusinessObject(), CurPage, request);
	ASDataObject doTemp=dwTemp.getDataObject();
	doTemp.setBusinessProcess("com.amarsoft.app.als.businessobject.web.XMLBusinessObjectProcessor");
	
	dwTemp.ReadOnly = "1";
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","","Button","新增参数","新增参数","add()","","","","",""},
			{"true","","Button","编辑参数","编辑参数","edit()","","","","",""},
			{"true","","Button","删除参数","删除参数","if(confirm('确实要删除吗?'))ALSObjectWindowFunctions.deleteSelectRow(0)","","","","",""}
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	<%/*~[Describe=单击事件;InputParam=无;OutPutParam=无;]~*/%>
	function mySelectRow(){
		var parameterID = getItemValue(0,getRow(),"ParameterID");
		if(typeof(parameterID)=="undefined" || parameterID.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=请先选择相应的信息!","frameright","");
		}else{
			AsControl.OpenView("/ProductManage/ParameterConfig/ParameterInfo.jsp","XMLFile=<%=xmlFile%>&XMLTags=<%=xmlTags%>||ParameterID='"+parameterID+"'&Keys=<%=keys%>&RightType=ReadOnly","frameright","");
		}
	} 
	
	function add(){
		AsControl.OpenView("/ProductManage/ParameterConfig/ParameterInfo.jsp","XMLFile=<%=xmlFile%>&XMLTags=<%=xmlTags%>||ParameterID=''&Keys=<%=keys%>&RightType=All","frameright",""); 
	}
	
	function edit(){
		var parameterID = getItemValue(0,getRow(0),"parameterID");
		if(typeof(parameterID)=="undefined" || parameterID.length==0){
			AsControl.OpenView("/Blank.jsp","TextToShow=请先选择相应的信息!","frameright","");
		}else{
			AsControl.OpenView("/ProductManage/ParameterConfig/ParameterInfo.jsp","XMLFile=<%=xmlFile%>&XMLTags=<%=xmlTags%>||ParameterID='"+parameterID+"'&Keys=<%=keys%>&RightType=All","frameright",""); 
		}
	}
</script>	
<%@include file="/Frame/resources/include/include_end.jspf"%>