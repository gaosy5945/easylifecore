<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String COSerialNo = CurPage.getParameter("COSerialNo");
	if(COSerialNo == null) COSerialNo = "";

	String sTempletNo = "CLSubmitApproveInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			{"true","All","Button","ȷ��","ȷ��","ensure()","","","",""},
			{"true","All","Button","ȡ��","ȡ��","self.close()","","","",""},
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
		alert("��ǩ�����������");
		return;
	}
	var sReturn = CreditLineManage.updateCLAndTodoStatus(serialNo,TodoStatus,CLStatus,CLSerialNo,COSerialNo);
	if(sReturn == "SUCCEED" || sReturn == "REFUSED"){
		alert("�ύ�ɹ���");
		top.close();
	}else{
		alert("�ύʧ�ܣ�");
	}
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
