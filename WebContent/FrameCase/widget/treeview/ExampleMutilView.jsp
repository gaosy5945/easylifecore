<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%CurPage.setAttribute("HideMinButton", "true");%>
<%@ include file="/Frame/page/jspf/include/jsp_frame_lrud.jspf"%>
<style>
	.leftright #Border {
		border-left-width: 0;
	}
</style>
<script type="text/javascript">	
	changeLayout(true, 150/($("body").height()-150));
	AsControl.OpenView("/FrameCase/widget/treeview/ExampleMutilLeft.jsp", "", Layout.getRegionName("FirstFrame"));
	AsControl.OpenView("/FrameCase/widget/treeview/ExampleMutilRight.jsp", "", Layout.getRegionName("SecondFrame"));
// ImageFrame right RightImage
</script>
<%@ include file="/IncludeEnd.jsp"%>