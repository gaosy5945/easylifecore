<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sApplyType = CurPage.getParameter("ApplyType");
	if(sApplyType == null) sApplyType = "";
	String sWhereSql = "";
	String sOperationStatus = "";
	ASObjectModel doTemp = new ASObjectModel("Doc2OutOfWarehouseApplyList");

	if("0010".equals(sApplyType)){//������  ���ύ
		sWhereSql = " and O.status='01' and O.inputuserid ='"+ CurUser.getUserID() +"' ";//and DFP.POSITION is not null 
		sOperationStatus = "01";
	}else if("0020".equals(sApplyType)){//������  ������
		sWhereSql = " and O.status='02'  and O.inputuserid ='"+ CurUser.getUserID() +"' ";
		sOperationStatus = "02";
	}else if("0030".equals(sApplyType)){//�ѳ���  ����ͨ��
		sWhereSql = " and O.status='03' and O.inputuserid ='"+ CurUser.getUserID() +"' ";
		sOperationStatus = "03";
	}else if("0040".equals(sApplyType)){//�ѳ���-����
		sWhereSql = " and O.status='03' and O.inputuserid ='"+ CurUser.getUserID() +"' ";
		sOperationStatus = "04";
	}else if("0050".equals(sApplyType)){//�ѳ���-��ʽ����
		sWhereSql = " and O.status='03'  and O.inputuserid ='"+ CurUser.getUserID() +"' ";
		sOperationStatus = "04";
	}else if("0060".equals(sApplyType)){//���˻س�������
		sWhereSql = "  and O.status='04' and O.inputuserid ='"+ CurUser.getUserID() +"' ";
		sOperationStatus = "05";
	}
	doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"false","All","Button","��������","��������","add()","","","","btn_icon_add",""},
			{"true","","Button","��������","��������","edit()","","","","btn_icon_detail",""},
			{"false","All","Button","ȡ������","ȡ������","cancel()","","","","btn_icon_detail",""},
			{"false","All","Button","�ύ","�ύ","submit()","","","","btn_icon_detail",""},
			{"true","","Button","�鿴���","�鿴���","OpinionView()","","","","btn_icon_detail",""},
			{"false","All","Button","�ٴ��ύ","�ٴ��ύ","submitAgain()","","","","btn_icon_detail",""},
		};

	if("0010".equals(sApplyType)){//������  ���ύ
		sButtons[0][0] = "true";
		sButtons[2][0] = "true";
		sButtons[3][0] = "true";
		sButtons[4][0] = "false";
	}else if("0020".equals(sApplyType)){//������  ������
		sButtons[4][0] = "false";
	}else if("0030".equals(sApplyType)){//�ѳ���  ����ͨ��
	}else if("0040".equals(sApplyType)){//�ѳ���-����
	}else if("0050".equals(sApplyType)){//�ѳ���-��ʽ����
	}else if("0060".equals(sApplyType)){//���˻س�������
		sButtons[5][0] = "true";
	}
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript"> 
	function add(){
		
		var pkSerialNo = AsDialog.SetGridValue('Doc2ManageList1','<%=CurUser.getOrgID()%>,03','ss=SerialNo','');
		if(typeof(pkSerialNo)=="undefined" || pkSerialNo.length==0 || pkSerialNo == "_CLEAR_") return;
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc2ManageAction","createDo","SerialNo="+pkSerialNo+",TransactionCode=0020,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != '_CANCEL_'){
		 	var serialNo = returnValue;
		 	var sOperationStatus = "<%=sOperationStatus%>";
		 	AsControl.PopComp("/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseInfoView.jsp","SerialNo=" +serialNo+"&OperationType=0020&OperationStatus="+sOperationStatus+"&RightType=All&DocType=02",'');
			reloadSelf();
		}
	}
	
	function edit(){
		var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseInfoView.jsp";
		 var sSerialNo = getItemValue(0,getRow(0),'SerialNo');
		 var sObjectType = getItemValue(0,getRow(0),'ObjectType');
		 var sObjectNo = getItemValue(0,getRow(0),'ObjectNo');
		 if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		 var sOperationStatus = "<%=sOperationStatus%>";
		 var sRightType = " ";  
		 if("<%=sApplyType%>"!="0010"&&"<%=sApplyType%>"!="0060"){//������  ���ύ �� ���뱻�˻��ٴ��ύ
			 sRightType = "ReadOnly";
		 }else{
			 sRightType = "All";
		 }
		AsControl.PopComp(sUrl,"SerialNo=" +sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&OperationType=0020&OperationStatus="+sOperationStatus+"&DocType=02&RightType="+sRightType,'');
		reloadSelf();
	}
	function cancel(){
		var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		var sDOObjectType = getItemValue(0,getRow(0),'ObjectType');
		var sDOObjectNo = getItemValue(0,getRow(0),'ObjectNo');
		var sOperationType = getItemValue(0,getRow(0),'TRANSACTIONCODE');//���ⷽʽ
		var sPara = "OperationType="+sOperationType+"&DOSerialNo="+sDOSerialNo+"&ObjectType="+sDOObjectType+"&ObjectNo="+sDOObjectNo+"&DOSerialNo="+sDOSerialNo+"&Status="+"01";
		if(confirm("ȷ��Ҫȡ����")){
			var sSql = "delete doc_operation_file  where operationserialno='" +sDOSerialNo+"'";
			var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
			if(sReturnValue >-1){
				as_delete(0);
				reloadSelf();
			}else{
				alert("ȡ������ʧ�ܣ�");
			}
		}
		
	}
	function submit(){
		var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		var sDOObjectType = getItemValue(0,getRow(0),'ObjectType');
		var sDOObjectNo = getItemValue(0,getRow(0),'ObjectNo'); 
		var sOperationdescript = getItemValue(0,getRow(0),'OPERATEDESCRIPTION');
		if((typeof(sOperationdescript)!="undefined" && sOperationdescript.length==0)){
			alert("�뵽������Ϣ��¼���������ύ");
			return;
		}
		var sOperationType = getItemValue(0,getRow(0),'TRANSACTIONCODE');//���ⷽʽ
		var sPara = "OperationType="+sOperationType+"&DOSerialNo="+sDOSerialNo+"&ObjectType="+sDOObjectType+"&ObjectNo="+sDOObjectNo+"&DOSerialNo="+sDOSerialNo+"&Status="+"01";
		//����һ����������
		var sReturn=PopPageAjax("/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseSubmitAjax.jsp?"+sPara+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");//
		if((typeof(sReturn)!="undefined" && sReturn=="true")){
				alert("�����ύ�ɹ���");
				reloadSelf();
		}else{
			alert("�����ύʧ�ܣ�");
		}
	}
	function OpinionView(){
		var sOpinionUrl = "/DocManage/Doc1Manage/DocOutApproveOpinionInfo.jsp";
 		var sPTISerialNo = getItemValue(0,getRow(0),'TASKSERIALNO');
		 if(typeof(sPTISerialNo)=="undefined" || sPTISerialNo.length==0 || sPTISerialNo=="null"){
			alert("��������Ϊ�գ�");
			return ;
		 }
		var sPara = "PTISerialNo="+sPTISerialNo+"&RightType=ReadOnly";
		AsControl.PopComp(sOpinionUrl,sPara ,"dialogWidth=450px;dialogHeight=300px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;");
		reloadSelf();
	}
	function submitAgain(){
		var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		var sDOObjectType = getItemValue(0,getRow(0),'ObjectType');
		var sDOObjectNo = getItemValue(0,getRow(0),'ObjectNo');
		var sOperationType = getItemValue(0,getRow(0),'TRANSACTIONCODE');//���ⷽʽ
		if(typeof(sDOSerialNo)=="undefined" || sDOSerialNo.length==0){
			alert("��û��ѡ��Ҫ�ύ����Ϣ��");
			return ;
		 }
		var sPara = "OperationType="+sOperationType+"&DOSerialNo="+sDOSerialNo+"&ObjectType="+sDOObjectType+"&ObjectNo="+sDOObjectNo+"&DOSerialNo="+sDOSerialNo+"&Status="+"05";
		//����һ����������
		var sReturn=PopPageAjax("/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseSubmitAjax.jsp?"+sPara+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");//
		if(sReturn || (typeof(sReturn)!="undefined" && sReturn=="true")){
				alert("�����ύ�ɹ���");
				reloadSelf();
		}else{
			alert("�����ύʧ�ܣ�");
		}
	}
	 
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
