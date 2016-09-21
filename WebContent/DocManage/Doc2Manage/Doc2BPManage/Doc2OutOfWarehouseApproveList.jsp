<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sApproveType = CurPage.getParameter("ApproveType");
	if(sApproveType == null) sApproveType = "";
	String sWhereSql = "";
	ASObjectModel doTemp = new ASObjectModel("Doc2OutOfWarehouseApproveList");
	if(sApproveType == "0010" || "0010".equals(sApproveType)){
		sWhereSql = " and O.status='02' and O.OPERATEUSERID ='"+ CurUser.getUserID() +"' ";//and DFP.POSITION is not null 
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	}
	if(sApproveType == "0020" || "0020".equals(sApproveType)){
		sWhereSql = " and O.status='03'  and O.OPERATEUSERID ='"+ CurUser.getUserID() +"' ";
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			//{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","��������","��������","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","ǩ�����","ǩ�����","addOpinion()","","","","btn_icon_detail",""},
			{"false","","Button","�鿴���","�鿴���","opinionView()","","","","btn_icon_detail",""},
			//{"true","","Button","�ύ","�ύ","submitRecord()","","","","btn_icon_detail",""},
			//{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
	if(sApproveType == "0020" || "0020".equals(sApproveType)){
		sButtons[1][0] = "false";
		sButtons[2][0] = "true";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 var sUrl = "";
		 AsControl.PopComp(sUrl,'','');
	}
	function edit(){
		var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseInfoView.jsp";
		 var sSerialNo = getItemValue(0,getRow(0),'SERIALNO');
		 var sObjectType = getItemValue(0,getRow(0),'ObjectType');
		 var sObjectNo = getItemValue(0,getRow(0),'ObjectNo');
		 if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		 var sOperationStatus = "02";
		 var sRightType = "ReadOnly";
		AsControl.PopComp(sUrl,"SerialNo=" +sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType"+sObjectType+"&OperationType="+"0020"+"&OperationStatus="+sOperationStatus+"&DocType=02&RightType="+sRightType ,'');
		reloadSelf();
	}
	function addOpinion(){
		//��ȡ����
		var sPTISerialNo = getItemValue(0,getRow(0),'TASKSERIALNO');
		var sDOSerialNo =  getItemValue(0,getRow(0),'SERIALNO');//����������ˮ��
		var sTransactionCode =  getItemValue(0,getRow(0),'TRANSACTIONCODE');//���ⷽʽ
		var sObjectType = getItemValue(0,getRow(0),'OBJECTTYPE');
		var sObjectNo = getItemValue(0,getRow(0),'OBJECTNO');
		if(typeof(sDOSerialNo)=="undefined" || sDOSerialNo.length==0 ){
			alert("��ѡ��һ����¼��");
			return ;
		 }
		//������ͼ�����м�ҳ��
		var sOpinionUrl = "/DocManage/Doc2Manage/Doc2BPManage/DocOutApproveOpinionInfoView.jsp";
		var sPara = "PTISerialNo="+sPTISerialNo+"&DOSerialNo="+sDOSerialNo+"&DocType=02"+
		            "&TransactionCode="+sTransactionCode+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		AsControl.PopComp(sOpinionUrl,sPara,"");
		reloadSelf(); 
		
		//var sOpinionUrl = "/DocManage/Doc1Manage/DocOutApproveOpinionInfo.jsp";
		 
	}
	function opinionView(){
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
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
