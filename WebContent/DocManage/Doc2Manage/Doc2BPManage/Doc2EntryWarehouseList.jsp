<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String transactionCode = CurPage.getParameter("TransactionCode");
	String status = CurPage.getParameter("Status");
	
	ASObjectModel doTemp = new ASObjectModel("Doc2EntryWarehouseList");//Doc2OutOfWarehouseApplyList
	if(!"".equals(transactionCode)&&!"0000".equals(transactionCode)){
		doTemp.setHeader("SERIALNO","�����");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.MultiSelect = true;
	dwTemp.setPageSize(15);
	
	dwTemp.setParameter("TransactionCode", transactionCode);
	dwTemp.setParameter("Status", status);
	dwTemp.setParameter("OrgID", CurOrg.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"false","All","Button","Ӱ��ɨ��","Ӱ��ɨ��","imageScanning()","","","","btn_icon_add",""},
			{"true","","Button","ȡ��","ȡ��","cancelRecord()","","","","btn_icon_detail",""},
			{"true","All","Button","�嵥��ӡ","�嵥��ӡ","printList()","","","","btn_icon_add",""},
			{"true","All","Button","�ύ","���������������","entryWarehouse()","","","","btn_icon_add",""}
		};
	if("0040".equals(transactionCode)){
		sButtons[0][3] = "�黹���";
		sButtons[0][5] = "add3()";
		//sButtons[8][0] = "true";
	}else if("0015".equals(transactionCode)){
		sButtons[0][3] = "�������";
		sButtons[0][5] = "add1()";
	}else if("0010".equals(transactionCode)){
		sButtons[0][3] = "�������";
	}else{
		sButtons[0][0] = "false";
		sButtons[3][0] = "false";
		sButtons[5][0] = "true";
		sButtons[6][0] = "false";
		sButtons[7][0] = "true";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

	function add1(){//�������
		var sAddDialogUrl = "/DocManage/Doc2Manage/Doc2BPManage/DocOperationAddDialog.jsp";//+"OperationType=02";
		var dialogStyle = "dialogWidth=450px;dialogHeight=300px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
		var returnValue = AsControl.PopComp(sAddDialogUrl,"",dialogStyle);
		
		if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != '_CANCEL_'){
		 	var serialNo = returnValue;
		 	AsCredit.openFunction("BusinessDocInfo","SerialNo="+serialNo);
			reloadSelf();
		 }
		
		reloadSelf();
	}
	
	function add(){//�½����
		 var sAddDialogUrl = "/DocManage/Doc2Manage/Doc2BPManage/DocOperationAddDialog.jsp";//+"OperationType=02";
		 var dialogStyle = "dialogWidth=450px;dialogHeight=300px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
		 var returnValue = AsControl.PopComp(sAddDialogUrl,"",dialogStyle);
		 if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != '_CANCEL_'){
		 	var serialNo = returnValue;
		 	AsCredit.openFunction("BusinessDocInfo","SerialNo="+serialNo);
			reloadSelf();
		 }
	}

	function add3(){//�黹���
		var sAddDialogUrl = "/DocManage/Doc2Manage/Doc2BPManage/DocOperationAddDialog.jsp";//+"OperationType=02";
		var dialogStyle = "dialogWidth=450px;dialogHeight=300px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
		var returnValue = AsControl.PopComp(sAddDialogUrl,"",dialogStyle);
		if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != '_CANCEL_'){
			var serialNo = returnValue;
			AsCredit.openFunction("BusinessDocInfo","SerialNo="+serialNo);
			reloadSelf();
		}
		reloadSelf();
	}
	
	function edit(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		AsCredit.openFunction("BusinessDocInfo","SerialNo="+serialNo);
		reloadSelf();
	}
	
	function imageScanning(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		AsCredit.openFunction("ImageDocInfo","SerialNo="+serialNo);
		reloadSelf();
	}
	
	function cancelRecord(){
		if(confirm('ȷʵҪȡ����?'))as_delete(0);
	}
	
	function printList(){
		//�����tabҳ�棬��ҪУ���ѡ��ֻ�ܹ�ѡһ����
		if("0010"=="<%=transactionCode%>" || "0015"=="<%=transactionCode%>"){
			 var arr = new Array();
			 arr = getCheckedRows(0);
			 if(arr.length < 1){
				 alert("��û�й�ѡ�κ��У�");
				 return ;
			 }else if(arr.length > 1){
				 alert("ֻ��ѡ��һ��ҵ��������Ϣ���д�ӡ��������ѡ��");
				 return ;
			 }
		}
		
		 var sObjectNo = getItemValue(0, getRow(), "OBJECTNO");
		 if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0 ){
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return ;
		 }
		 var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2MaterialList.jsp";
		 AsControl.PopComp(sUrl,"SerialNo="+sObjectNo,"");
	}
	
	//������
	function entryWarehouse(){
		var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("��û�й�ѡ�κ��У�");
		 }else{
			if(confirm('�Ƿ�ȷ����� ?')){ 
				 for(var i=0;i<arr.length;i++){
					 var serialNo = getItemValue(0,arr[i],"SERIALNO");
					 var transactionCode = getItemValue(0,arr[i],"TransactionCode");
					 var opStatus = getItemValue(0,arr[i],"STATUS");
					 var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc2ManageAction","commit","SerialNo="+serialNo+",TransactionCode="+transactionCode+",Status="+opStatus);
				 
				 }
				 if(returnValue == "�ύ�ɹ���"){
						 alert("���ɹ���");
				 }else {
						 alert("���ʧ��!");
					     return;
			    }  
			 }
		  }
		 reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
