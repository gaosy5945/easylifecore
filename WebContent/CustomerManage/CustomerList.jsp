<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	//��ȡ�������
	String customerType = CurComp.getParameter("CustomerType");
	if(customerType == null) customerType = "";
	String templetNo = CurComp.getParameter("CustomerListTemplet");
	if(templetNo == null) templetNo = "";

	ASObjectModel doTemp = new ASObjectModel(templetNo);
	//doTemp.setHtmlEvent("", "ondblclick", "viewAndEdit");//���˫���鿴���鹦�� */
	doTemp.setJboWhere(doTemp.getJboWhere()+" and CB.InputOrgID = '"+CurOrg.getOrgID()+"' and CB.InputUserID = '"+CurUser.getUserID()+"'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.MultiSelect = true; //�����ѡ
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
   	dwTemp.setParameter("CustomerType", customerType+"%");
	dwTemp.genHTMLObjectWindow(customerType+"%");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","�ͻ���Ϣ�½�","�ͻ���Ϣ�½�","newCustomer()","","","","btn_icon_add",""},
			{"true","","Button","�ͻ���Ϣ����","�ͻ���Ϣ����","viewAndEdit()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ��","del()","","","","btn_icon_delete",""},
// 			{"03".equals(customerType)? "true":"false","All","Button","�����ҵĿͻ�","�����ҵĿͻ�","joinMyCustomer()","","","","",""},
			{"false","All","Button","��ѯECIF","��ѯECIF","ecifQuery()","","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
//�ͻ���Ϣ����
function newCustomer(){
	var customerType = "<%=customerType%>";
	var result = CustomerManage.newCustomer1(customerType);
 	if(result){
		result = result.split("@");
		if(result[0]=="true"){
			CustomerManage.editCustomer(result[1],result[3]);
		}
	}
    reloadSelf();
}

//�ͻ���Ϣ����
function viewAndEdit(){
	var customerID = getItemValue(0,getRow(0),"CUSTOMERID");
	var customerType = getItemValue(0,getRow(0),"CUSTOMERTYPE");
	if(typeof(customerID)=="undefined" || customerID.length==0){
		alert("��ѡ��һ����Ϣ��");
		return;
	}
	 CustomerManage.editCustomer(customerID,customerType);
	 reloadSelf();
}

function del(){
	var deleteCustomerIDs = '';
	var userID = "<%=CurUser.getUserID()%>";
	var inputOrgID = "<%=CurOrg.getOrgID()%>";
	var recordArray = getCheckedRows(0); //��ȡ��ѡ����
	if (typeof(recordArray)=="undefined" || recordArray.length==0){
		alert("������ѡ��һ����Ҫɾ����¼��");
		return;
	}
	for(var i = 1;i <= recordArray.length;i++){ //ͨ��ѭ����ȡcustomerID
		var customerID = getItemValue(0,recordArray[i-1],"CUSTOMERID");
		deleteCustomerIDs += customerID+"@";
	}
	if(confirm('ȷ��Ҫɾ����ѡ�ͻ���')){
		var sReturn = CustomerManage.deleteCustomer(deleteCustomerIDs, userID, inputOrgID);
		if(sReturn == "SUCCEED"){
			alert("ɾ���ɹ���");
			reloadSelf();
		}else{
			alert("ɾ��ʧ�ܣ�");
			reloadSelf();
		}

	}
}
//�����ҵĿͻ�
function joinMyCustomer(){
	var relaCustomerIDs = '';
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
	}
	var result = CustomerManage.importCustomer(recordArray, relaCustomerIDs, userID, inputDate, inputOrgID);
	if(result == "SUCCEED"){
		alert("�����ҵĿͻ��ɹ���");
	}else{
		alert("�����ҵĿͻ�ʧ�ܣ�");
	}
}


//��ѯECIF�ͻ���
function ecifQuery(){
	var sCustomerType = getItemValue(0,getRow(0),"CUSTOMERTYPE");
	var sCustomerID = getItemValue(0,getRow(0),"CUSTOMERID");
	var sCtfID = getItemValue(0,getRow(0),"CERTID");
	var sCtfType = getItemValue(0,getRow(0),"CERTTYPE");
	var sClientCHNName = getItemValue(0,getRow(0),"CUSTOMERNAME");
	
	//���˿ͻ���ѯECIF
	if(sCustomerType == "03"){
		if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		var temp = CustomerManage.getECIFCustomer1(sCustomerID, sCtfType, sCtfID, sClientCHNName);
		if(temp == 'success')
			alert("��ѯ�ɹ������ݿ��Ѹ�����ɣ�");
		else
			alert("��ѯʧ�ܣ�����ϵ����Ա������");
		reloadSelf();
	//��˾�ͻ���ѯECIF
	}else if(sCustomerType.indexOf("01") == "0"){
		if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		var temp = CustomerManage.getECIFCustomer2(sCustomerID, sCtfID, sClientCHNName);
		if(temp == 'success')
			alert("��ѯ�ɹ������ݿ��Ѹ�����ɣ�");
		else
			alert("��ѯʧ�ܣ�����ϵ����Ա������");
		reloadSelf();
	}
	
}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
