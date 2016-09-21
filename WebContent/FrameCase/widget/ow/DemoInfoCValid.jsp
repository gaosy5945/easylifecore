<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	ASObjectModel doTemp = new ASObjectModel("TestCustomerInfo"); //通过显示模板生成
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{"true","All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "south";
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		 var sUrl = "/FrameCase/widget/ow/DemoListSimple.jsp";
		 OpenPage(sUrl,'_self','');
	}
	function beforeCheck(dwname){
		alert("beforeCheck");
		return true;
	}
	function afterCheck(dwname){
		alert("afterCheck");
		return true;
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>