<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String relaSerialNos = CurPage.getParameter("relaSerialNos");
	if(relaSerialNos == null) relaSerialNos = "";
	String relaTodoTypes = CurPage.getParameter("relaTodoTypes");
	if(relaTodoTypes == null) relaTodoTypes = "";
	String relaEndDates = CurPage.getParameter("relaEndDates");
	if(relaEndDates == null) relaEndDates = "";

	String sTempletNo = "CustomerListApproveOpinion";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","ȷ��","ȷ��","ensure()","","","",""},
		{"true","All","Button","ȡ��","ȡ��","self.close()","","","",""},
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
			alert("��ѡ�񸴺˽��ۣ�");
			return;
		}
		var sReturn = CustomerManage.updateTodoList(serialNos,phaseActionType,relaTodoTypes,relaEndDates);
		if(sReturn == "SUCCEED"){
			alert("���˳ɹ���");
			top.close();
		}else{
			alert("����ʧ�ܣ�");
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
