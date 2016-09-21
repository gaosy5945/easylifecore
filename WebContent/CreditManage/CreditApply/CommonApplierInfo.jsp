<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "共同申请人详情"; 
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	
	/* BusinessObject param = BusinessObject.createBusinessObject();
	param.setAttributeValue("SerialNo", serialNo); */
	
	String sTempletNo="CommonApplierInfo";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	/* ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info("CommonApplierInfo", CurPage, request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject(); */
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置为freeform风格
	dwTemp.ReadOnly = "0"; //设置为只读

	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.genHTMLObjectWindow(objectType+","+objectNo);

	String sButtons[][] = 
	{
		{"true","All","Button","保存","保存","saveRecord()","","","",""},
	};
	%>
<%/*~END~*/%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>

	<script type="text/javascript">
		function saveRecord(){
			setItemValue(0,getRow(0),"ObjectType","<%=objectType%>");
			setItemValue(0,getRow(0),"ObjectNo","<%=objectNo%>");
			as_save(0);
		}
	</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
