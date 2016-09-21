<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	页面说明: 上下联动,上部是组合页面对象，下部为明细项
 */
 	String sSearchType = CurPage.getParameter("SearchType");
	String sSearch = CurPage.getParameter("Search");
	String sClassifyID = CurPage.getParameter("ClassifyID");
	String sGroupID = CurPage.getParameter("GroupID");
	if(sSearchType == null) sSearchType = "";
	if(sGroupID == null) sGroupID = "";
	if(sSearch == null) sSearch = "";
	if(sClassifyID == null) sClassifyID = "";
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">
	AsControl.OpenView("/AppConfig/PageMode/GroupPage/GroupPageCatalogList.jsp","SearchType=<%=sSearchType%>&Search=<%=sSearch%>&ClassifyID=<%=sClassifyID%>&GroupID=<%=sGroupID%>","rightup","");
</script>
<%@ include file="/IncludeEnd.jsp"%>