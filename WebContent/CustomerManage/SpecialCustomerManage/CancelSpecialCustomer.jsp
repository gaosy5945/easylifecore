<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String relaSerialNos = CurPage.getParameter("relaSerialNos");
	if(relaSerialNos == null) relaSerialNos = "";

	String sTempletNo = "CanCelSpecialCustomer";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	doTemp.setDefaultValue("INPUTUSERID", CurUser.getUserID());
	doTemp.setDefaultValue("INPUTUSERName", CurUser.getUserName());
	doTemp.setDefaultValue("INPUTORGID", CurOrg.getOrgID());
	doTemp.setDefaultValue("INPUTORGName", CurOrg.getOrgName());
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"false","All","Button","�ύ","�ύ","submit()","","","",""},
		{"true","All","Button","ȷ��","ȷ��","saveRecord()","","","",""},
		{"true","All","Button","����","����","top.close()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script><script type="text/javascript">
	function submit(){
		var objectType = "jbo.customer.CUSTOMER_LIST";
		var objectNo = "<%=relaSerialNos%>";
		var operateOrgID = getItemValue(0,getRow(0),"OPERATEORGID");
		var todoType = getItemValue(0,getRow(0),"TODOTYPE");
		var phaseOpinion = getItemValue(0,getRow(0),"PHASEOPINION");
		var operateUserID = getItemValue(0,getRow(0),"OPERATEUSERID");
		var memo = getItemValue(0,getRow(0),"MEMO");
		var status = getItemValue(0,getRow(0),"STATUS");
		var endDate = getItemValue(0,getRow(0),"ENDDATE");
		var inputDate = getItemValue(0,getRow(0),"INPUTDATE");
		var inputOrgID = getItemValue(0,getRow(0),"INPUTORGID");
		var inputUserID = getItemValue(0,getRow(0),"INPUTUSERID");
		if(typeof(operateOrgID) == "undefined" || operateOrgID.length == 0){
			alert("�������϶�������");
			return;
		}
		if(typeof(phaseOpinion) == "undefined" || phaseOpinion.length == 0){
			alert("������ȡ��ԭ��");
		}
		if(confirm('ȷʵҪ�ύ����������׶Ρ���?')){
			var sReturn = CustomerManage.importCancelTodoList(objectType, objectNo, todoType, status, phaseOpinion, memo, operateOrgID, operateUserID, inputDate, inputOrgID, inputUserID);
			if(sReturn == "SUCCEED"){
				alert("�ύ�ɹ���");
				top.close();
			}else{
				alert("�ύʧ�ܣ�");
			}
		}
	}
	function saveRecord(){
		if(!iV_all("myiframe0"))return;
		var SerialNos = "<%=relaSerialNos%>";
		var sReturn = CustomerManage.CancelSpecialCustomer(SerialNos);
		if(sReturn == "SUCCEED"){
			alert("ȡ���ɹ���");
			top.close();
		}else{
			alert("ȡ��ʧ�ܣ�");
		}
	}
	function initRow(){
		setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,0,"ENDDATE","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
