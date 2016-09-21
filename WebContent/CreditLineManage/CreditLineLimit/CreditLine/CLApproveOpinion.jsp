<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String COSerialNo = CurPage.getParameter("COSerialNo");
	if(COSerialNo == null) COSerialNo = "";

	String sTempletNo = "CLSubmitApproveInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			{"true","All","Button","确定","确定","ensure()","","","",""},
			{"true","All","Button","取消","取消","self.close()","","","",""},
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditLineManage/CreditLineLimit/js/CreditLineManage.js"></script>
<script type="text/javascript">
function ensure(){
	var serialNo = "<%=serialNo%>";
	var COSerialNo = "<%=COSerialNo%>";
	var TodoStatus = getItemValue(0,getRow(0),"PHASEACTIONTYPE");
	var CLStatus = getItemValue(0,getRow(0),"OPERATETYPE");
	var CLSerialNo = getItemValue(0,getRow(0),"CLSERIALNO");
	if(typeof(TodoStatus) == "undefined" || TodoStatus.length == 0){
		alert("请签署审批意见！");
		return;
	}
	var sReturn = CreditLineManage.updateCLAndTodoStatus(serialNo,TodoStatus,CLStatus,CLSerialNo,COSerialNo);
	if(sReturn == "SUCCEED" || sReturn == "REFUSED"){
		alert("提交成功！");
		top.close();
	}else{
		alert("提交失败！");
	}
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
