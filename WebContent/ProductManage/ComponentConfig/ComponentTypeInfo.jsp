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
	
	//��ParaID��Ϊ����������ʾģ��
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save()","","","",""},
		{"true","","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	
	function returnList(){
		OpenPage("/ProductManage/ComponentConfig/ComponentTypeList.jsp", "_self");
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	$(document).ready(function(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			beforeInsert();
			bIsInsert = true;
		}
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>