<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	ASObjectModel doTemp = new ASObjectModel("TestCustomerInfo"); //通过显示模板生成
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{"false","All","Button","返回","返回列表","returnList()","","","",""}
	};
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function beforeTabClose(){
		alert("返回值为undefined或布尔值为true允许关闭，否则阻止关闭！\n若flag布尔值为true，那么!flag == false");
		return confirm("确定关闭?");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>