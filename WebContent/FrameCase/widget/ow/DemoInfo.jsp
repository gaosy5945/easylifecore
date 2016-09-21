<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String sSerialNo = CurPage.getParameter("SerialNo");
	if(sSerialNo == null) sSerialNo = "";
	ASObjectModel doTemp = new ASObjectModel("TestCustomerInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(sSerialNo);
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0,'getresult()')","","","","btn_icon_save"},
		{"true","All","Button","删除","删除当前记录","if(confirm('是否要删除'))as_delete(0,'getresult()')","","","","btn_icon_delete"},
	};
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function getresult(){
		//alert("返回结果：" + getResultInfo(0));
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>