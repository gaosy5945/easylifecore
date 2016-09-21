<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
 	String objectNo = CurPage.getParameter("ObjectNo");
	if(StringX.isSpace(objectNo)) objectNo = "";
	String objectType = CurPage.getParameter("ObjectType");
	if(StringX.isSpace(objectType)) objectType = "";
	
	String sTabStrip[][] = {
		{"true", "联保体详情", "/CreditManage/CreditApply/UGBodyApplyFrame.jsp", "ObjectNo="+objectNo+"&ObjectType="+objectType}
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<script type="text/javascript">	
	function deleteTabListen(obj){
		var objectNo = "<%=objectNo%>";
		var objectType = "<%=objectType%>";
		OpenComp("TS0","/CreditManage/CreditApply/UGBodyApplyFrame.jsp","ObjectNo="+objectNo+"&ObjectType="+objectType,"tab_T01_iframe_TS0");
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>