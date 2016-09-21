<%@page import="com.amarsoft.are.util.json.JSONDecoder"%>
<%@page import="com.amarsoft.are.util.json.JSONObject"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf" %>

<%
	String inputParameterString = CurPage.getParameter("InputParameters");
	JSONObject inputParameter = JSONDecoder.decode(inputParameterString);
	String objectType = (String)inputParameter.getValue("ObjectType");
	String objectNo = (String)inputParameter.getValue("ObjectNo");
	JSONObject attributes = (JSONObject)inputParameter.getValue("Attributes");
	BusinessObjectManager bomanager=BusinessObjectManager.createBusinessObjectManager();
	BusinessObject businessObject = bomanager.loadBusinessObject(objectType, objectNo);
	for(int i=0;i<attributes.size();i++){
		Element e = attributes.get(i);
		businessObject.setAttributeValue(e.getName(),e.getName());
	}
	bomanager.updateBusinessObject(businessObject);
	bomanager.updateDB();
%>

<script type="text/javascript">
	self.returnValue="true";
	self.close();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf" %>
