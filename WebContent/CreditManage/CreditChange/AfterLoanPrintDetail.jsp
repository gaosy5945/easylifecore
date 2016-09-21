<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	
	String ObjectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));//文件编号
	String ObjectType = DataConvert.toString(CurPage.getParameter("ObjectType"));
	String sTempletNo = "AfterLoanPrintDetail";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";
	dwTemp.genHTMLObjectWindow(ObjectNo+","+ObjectType);
	String sButtons[][] = {
		{"true","All","Button","返回","返回","back()","","","",""},
	};
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function back(){
		self.close();
	} 
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
