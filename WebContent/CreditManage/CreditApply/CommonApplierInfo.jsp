<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬ����������"; 
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	
	/* BusinessObject param = BusinessObject.createBusinessObject();
	param.setAttributeValue("SerialNo", serialNo); */
	
	String sTempletNo="CommonApplierInfo";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	/* ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info("CommonApplierInfo", CurPage, request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject(); */
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����Ϊfreeform���
	dwTemp.ReadOnly = "0"; //����Ϊֻ��

	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.genHTMLObjectWindow(objectType+","+objectNo);

	String sButtons[][] = 
	{
		{"true","All","Button","����","����","saveRecord()","","","",""},
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
