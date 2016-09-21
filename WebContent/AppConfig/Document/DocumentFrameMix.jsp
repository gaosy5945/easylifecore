<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	--页面说明: 左右框架页面,左侧为文档基本信息，右侧为附件信息--
 */
%><%@include file="/Resources/CodeParts/Frame03.jsp"%>
<script type="text/javascript">
	myleft.width=480;//设置左边区域宽度
	AsControl.OpenComp("/AppConfig/Document/DocumentInfo.jsp","","frameleft","");
	AsControl.OpenComp("/AppConfig/Document/AttachmentFrame.jsp", "", "frameright");
</script>
<%@ include file="/IncludeEnd.jsp"%>