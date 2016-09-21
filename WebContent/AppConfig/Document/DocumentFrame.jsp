<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%-- 页面说明: 上下框架页面 --%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">
	mytoptd.height = 260;
	AsControl.OpenComp("/AppConfig/Document/DocumentFrameMix.jsp","","rightdown");
	AsControl.OpenComp("/AppConfig/Document/DocumentList.jsp","","rightup","");
</script>
<%@ include file="/IncludeEnd.jsp"%>