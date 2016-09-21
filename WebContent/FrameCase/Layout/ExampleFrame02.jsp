<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	页面说明: 示例左右框架页面
 */
%><%@include file="/Resources/CodeParts/Frame03.jsp"%>
<script type="text/javascript">	
	AsControl.OpenView("/FrameCase/widget/dw/ExampleList.jsp","","frameleft","");
	AsControl.OpenView("/FrameCase/widget/dw/ExampleList.jsp","","frameright","");
</script>
<%@ include file="/IncludeEnd.jsp"%>