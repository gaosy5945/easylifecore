<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>

<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_Info.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_List.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script>

 <%
	/*
		ҳ��˵��: ��Ʒ�����б�ҳ��
	 */
	String PG_TITLE = "�û���λ�б�";
 	BusinessObject inputparameter = BusinessObject.createBusinessObject();
 	inputparameter.setAttributeValue("UserID", CurPage.getParameter("UserID"));
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("UserRoleList", inputparameter, CurPage, request);
	dwTemp.ReadOnly="1";
	ASDataObject doTemp=dwTemp.getDataObject();
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@include file="/Frame/resources/include/include_end.jspf"%>