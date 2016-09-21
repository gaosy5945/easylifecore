<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String relaSerialNos = CurPage.getParameter("relaSerialNos");
	if(relaSerialNos == null) relaSerialNos = "";
	String relaTodoTypes = CurPage.getParameter("relaTodoTypes");
	if(relaTodoTypes == null) relaTodoTypes = "";
	String relaEndDates = CurPage.getParameter("relaEndDates");
	if(relaEndDates == null) relaEndDates = "";

	String sTempletNo = "CustomerListApproveOpinion";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","确定","确定","ensure()","","","",""},
		{"true","All","Button","取消","取消","self.close()","","","",""},
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script><script type="text/javascript">
	function ensure(){
		var serialNos = "<%=relaSerialNos%>";
		var relaTodoTypes = "<%=relaTodoTypes%>";
		var relaEndDates = "<%=relaEndDates%>";
		var phaseActionType = getItemValue(0,getRow(0),"PHASEACTIONTYPE");
		if(typeof(phaseActionType) == "undefined" || phaseActionType.length == 0){
			alert("请选择复核结论！");
			return;
		}
		var sReturn = CustomerManage.updateTodoList(serialNos,phaseActionType,relaTodoTypes,relaEndDates);
		if(sReturn == "SUCCEED"){
			alert("复核成功！");
			top.close();
		}else{
			alert("复核失败！");
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
