<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sApproveType = CurPage.getParameter("ApproveType");
	if(sApproveType==null) sApproveType ="";
	String sWhereSql = "";
	ASObjectModel doTemp = new ASObjectModel("Doc1OutOfWarehouseApplyList");
	if(sApproveType=="0010" || "0010".equals(sApproveType)){//���ύ
		sWhereSql =  "  and O.status='02' ";
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);	
	}else	if(sApproveType=="0020" || "0020".equals(sApproveType)){//���ύ
		sWhereSql =  "   and O.status='03' ";
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);	
	}
	doTemp.setDDDWJbo("TRANSACTIONCODE","jbo.ui.system.CODE_LIBRARY,itemno,ItemName,Isinuse='1' and CodeNo='DocumentTransactionCode' and ItemNo in('0020','0030') order by sortno");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//��������	ǩ�����	�鿴���	��ӡ����������	��ӡ������
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			//{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","��������","����","edit()","","","","btn_icon_detail",""},
			{"true","","Button","ǩ�����","ǩ�����","opinionAdd()","","","","btn_icon_detail",""},
			{"true","","Button","�鿴���","�鿴���","opinionView()","","","","btn_icon_detail",""},
			{"false","","Button","��ӡ����������","��ӡ����������","printApprove()","","","","btn_icon_detail",""},
			//{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};

	if(sApproveType=="0010" || "0010".equals(sApproveType)){//���ύ
		sButtons[2][0] = "false";
		sButtons[3][0] = "false"; 
	}else	if(sApproveType=="0020" || "0020".equals(sApproveType)){//���ύ
		sButtons[1][0] = "false";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		 var sUrl = "/DocManage/Doc1Manage/Doc1OutOfWarehouseView.jsp";
		 var sPara = "";
		 var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		 var sAISerialNo = getItemValue(0,getRow(0),'ASSETSERIALNO');
		 
		 if(typeof(sDOSerialNo)=="undefined" || sDOSerialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		 sPara = "DOSerialNo="+sDOSerialNo+"&AISerialNo="+sAISerialNo+"&ApproveType=<%=sApproveType%>&RightType=ReadOnly";
		 AsControl.PopComp(sUrl,sPara,'','');
		 reloadSelf();
	}
	function opinionAdd(){
		//��ȡ����
		var sPTISerialNo = getItemValue(0,getRow(0),'TASKSERIALNO');
		var sDOSerialNo =  getItemValue(0,getRow(0),'SERIALNO');//����������ˮ��
		var sTransactionCode =  getItemValue(0,getRow(0),'TRANSACTIONCODE');//���ⷽʽ
		var sObjectType = getItemValue(0,getRow(0),'OBJECTTYPE');
		var sObjectNo = getItemValue(0,getRow(0),'ASSETSERIALNO');
		if(typeof(sDOSerialNo)=="undefined" || sDOSerialNo.length==0 ){
			alert("��ѡ��һ����¼��");
			return ;
		 }
		//������ͼ�����м�ҳ��
		var sOpinionUrl = "/DocManage/Doc2Manage/Doc2BPManage/DocOutApproveOpinionInfoView.jsp";
		var sPara = "PTISerialNo="+sPTISerialNo+"&DOSerialNo="+sDOSerialNo+"&DocType=01"+
		            "&TransactionCode="+sTransactionCode+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		AsControl.PopComp(sOpinionUrl,sPara,"");
		self.reloadSelf();  
	}
	//�鿴�������
	function opinionView(){
		var sOpinionUrl = "/DocManage/Doc1Manage/DocOutApproveOpinionInfo.jsp";
 		var sPTISerialNo = getItemValue(0,getRow(0),'TASKSERIALNO');
		 if(typeof(sPTISerialNo)=="undefined" || sPTISerialNo.length==0 || sPTISerialNo=="null"){
			alert("��������Ϊ�գ�");
			return ;
		 }
		var sPara = "PTISerialNo="+sPTISerialNo+"&RightType=ReadOnly";
		AsControl.PopComp(sOpinionUrl,sPara ,"dialogWidth=450px;dialogHeight=300px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;");
	}
	function printApprove(){
		alert("printApprove");
	}
	function printPackageId(){
		alert("printPackageId");
	}
	function submitRecord(){
		var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		var sAISerialNo = getItemValue(0,getRow(0),'AISerialNo');
		var sPara = "AISerialNo="+sAISerialNo+"&DOSerialNo="+sDOSerialNo+"&ApplyType=02";
		var sReturn=PopPageAjax("/DocManage/Doc1Manage/Doc1OutOfWarehouseAjax.jsp?"+sPara+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
		if(sReturn || (typeof(sReturn)!="undefined" && sReturn=="true")){
			alert("�����ɹ���");
		}else {
			alert("����ʧ��!");
			return;
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
