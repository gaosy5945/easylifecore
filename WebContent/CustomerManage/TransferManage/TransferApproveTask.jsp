<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TransferApproveList");
	doTemp.appendJboWhere(" and TransferType='10'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "0";	 //�༭ģʽ
	//dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(CurUser.getUserID());
	
	String sButtons[][] = {
			{"true","","Button","ͬ��","ͬ��ת������","doSure()","","","","",""},
			{"true","","Button","�ܾ�","�ܾ�ת������","doReject()","","","","",""},
			{"true","","Button","�ͻ�����","�鿴�ͻ�����","view()","","","",""},
		};
%> 
<script type="text/javascript">
	/*~[Describe=ͬ��ת������;InputParam=��;OutPutParam=��;]~*/
	function doSure(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
		var operateType = getItemValue(0,getRow(),"UnOperateType");//����������
		var rightType = getItemValue(0,getRow(),"RightType");//Ȩ������
		var mainTainTime = getItemValue(0,getRow(),"MainTainTime");//ά��Ȩ����
		var customerID = getItemValue(0,getRow(),"CustomerID");//�ͻ����
		if(operateType == "20" && rightType == "20" && (typeof(mainTainTime)=="undefined" || mainTainTime.length==0)){//ת��ά��Ȩ
			alert("��ָ��ά��Ȩ����!");
			return;
		}
		var param = "serialNo="+serialNo+",customerID="+customerID+",manaTime="+mainTainTime+",userID=<%=CurUser.getUserID()%>"+
					",orgID=<%=CurUser.getOrgID()%>,rightType="+rightType;
		var result = RunJavaMethodTrans("com.amarsoft.app.als.customer.transfer.action.TransferAction","consentTransfer",param);
		if(result == "true"){
			alert("�ͻ�ת�Ƴɹ���");
			reloadSelf();
		}else{
			alert("�ͻ�ת��ʧ�ܣ�");
		}
	}
	/*~[Describe=�ܾ�ת������;InputParam=��;OutPutParam=��;]~*/
	function doReject(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
		var result = RunJavaMethodTrans("com.amarsoft.app.als.customer.transfer.action.TransferAction","rejectTransfer","serialNo="+serialNo);
		if(result == "true"){
			alert("�ѳɹ��ܾ��ͻ�ת�ƣ�");
			reloadSelf();
		}else{
			alert("�ܾ��ͻ�ת��ʧ�ܣ�");
		}
	}

	/*~[Describe=�鿴�ͻ�����;InputParam=��;OutPutParam=��;]~*/
	function view(){
		var customerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(customerID)=="undefined" || customerID.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
    	AsCredit.openFunction("CustomerDetail","CustomerID="+customerID,"");
		//AsControl.OpenObject("Customer",customerID,"001");
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
