 <%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";

	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("MyCustomerTagList",BusinessObject.createBusinessObject(),CurPage);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request);
	
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.MultiSelect = true; //�����ѡ
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow(serialNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����ά��","����ά��","alterTag()","","","","",""},
			{"true","All","Button","��������","��������","adjustTag()","","","","",""},
			{"true","","Button","�ͻ�����","�ͻ�����","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","����ͻ�","����ͻ�","importCustomer()","","","","",""},
			{"true","All","Button","ɾ���ͻ�","ɾ���ͻ�","del()","","","","btn_icon_delete",""},
			{"true","","Button","ˢ�¿ͻ�","ˢ�¿ͻ�","reloadCustomer()","","","","",""},
			{"true","All","Button","����","����","exportPage('"+sWebRootPath+"',0,'excel','')","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script><script type="text/javascript">
	function alterTag(){
		OpenPage("/CustomerManage/MyCustomerInfo.jsp?SerialNo="+"<%=serialNo%>","frameright","");
	}
	
	function adjustTag(){
		var relaCustomerIDs = '';
		var relaSerialNos = '';
		var recordArray = getCheckedRows(0);//��ȡ��ѡ����
		var userID = "<%=CurUser.getUserID()%>";
		var inputDate = "<%=StringFunction.getToday()%>";
		var inputOrgID = "<%=CurOrg.getOrgID()%>";
		if (typeof(recordArray)=="undefined" || recordArray.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		for(var i = 1;i <= recordArray.length;i++){//ͨ��ѭ����ȡcustomerID
			var customerID = getItemValue(0,recordArray[i-1],"CUSTOMERID");
			relaCustomerIDs += customerID+"@";
			var serialNo = getItemValue(0,recordArray[i-1],"OTLSERIALNO");
			relaSerialNos += serialNo+"@";
		}
		var result = CustomerManage.adjustTag(recordArray, relaCustomerIDs, userID, relaSerialNos, inputDate, inputOrgID);
		if(result == "SUCCEED"){
			alert("��������ɹ���");
			reloadSelf();
		}else{
			alert("�������ʧ�ܣ�");
		}
	}
	
	function edit(){
		var customerID = getItemValue(0,getRow(0),"CUSTOMERID");
		var customerType = getItemValue(0,getRow(0),"CUSTOMERTYPE");
 		if(typeof(customerID)=="undefined" || customerID.length==0){
			alert("��ѡ��һ����Ϣ��");
			return;
		} 

		CustomerManage.editCustomer(customerID,customerType);
	}
	
	function del(){
		var deleteCustomerIDs = '';
		var recordArray = getCheckedRows(0); //��ȡ��ѡ����
		if (typeof(recordArray)=="undefined" || recordArray.length==0){
			alert("������ѡ��һ����Ҫɾ����¼��");
			return;
		}
		for(var i = 1;i <= recordArray.length;i++){ //ͨ��ѭ����ȡcustomerID
			var customerID = getItemValue(0,recordArray[i-1],"CUSTOMERID");
			deleteCustomerIDs += customerID+"@";
		}
		if(confirm('ȷ��Ҫ����ѡ�ͻ��Ӹ÷�����ɾ����')){
			var sReturn = CustomerManage.deleteTagCustomer(deleteCustomerIDs);
			if(sReturn == "SUCCEED"){
				alert("ɾ���ɹ���");
				reloadSelf();
			}else{
				alert("ɾ��ʧ�ܣ�");
				reloadSelf();
			}
		}
	}
	function importCustomer(){
		 var sStyle = "dialogWidth:800px;dialogHeight:680px;resizable:yes;scrollbars:no;status:no;help:no";
         var returnValue = AsDialog.SelectGridValue('MyImportCustomer',"<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,03,<%=serialNo%>",'CUSTOMERID','',true,sStyle);
         if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
 			return ;
 		var OTCSerialNo = "<%=serialNo%>";
 		var InputUserID = "<%=CurUser.getUserID()%>";
 		var InputOrgID = "<%=CurOrg.getOrgID()%>";
 		var InputDate = "<%=StringFunction.getToday()%>";
 		var result = CustomerManage.importCustomerToTag(returnValue,OTCSerialNo,InputUserID,InputOrgID,InputDate);
 		if(result == "SUCCEED"){
 			alert("�ͻ�����ɹ���");
 		}else{
 			alert("�ͻ�����ʧ�ܣ�");
 		}
        reloadSelf();
	}
	
	function reloadCustomer(){
		OpenPage("/CustomerManage/MyCustomerTagList.jsp?SerialNo="+"<%=serialNo%>", "frameright"); 
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
