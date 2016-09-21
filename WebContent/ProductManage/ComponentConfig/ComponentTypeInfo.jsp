<%@page import="com.amarsoft.are.lang.StringX"%>
<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%

	BusinessObject inputParameter=SystemHelper.getPageComponentParameters(CurPage);
	ASObjectWindow dwTemp =ObjectWindowHelper.createObjectWindow_Info("PRD_ComponentTypeInfo", inputParameter, CurPage, request);
	ASDataObject doTemp=dwTemp.getDataObject();
	doTemp.setBusinessProcess("com.amarsoft.app.als.businessobject.web.XMLBusinessObjectProcessor");
	
	//将ParaID作为参数传给显示模板
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save()","","","",""},
		{"true","","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	
	function returnList(){
		OpenPage("/ProductManage/ComponentConfig/ComponentTypeList.jsp", "_self");
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	$(document).ready(function(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			beforeInsert();
			bIsInsert = true;
		}
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>