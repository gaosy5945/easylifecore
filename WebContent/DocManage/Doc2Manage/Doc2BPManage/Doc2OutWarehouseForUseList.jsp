<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sForUseType = (String)CurPage.getParameter("ForUseType");
	if(null==sForUseType) sForUseType="";
	String sWhereSql = "";
	ASObjectModel doTemp = new ASObjectModel("Doc2OutWarehouseForUseList");

	if(sForUseType == "0010" || "0010".equals(sForUseType)){
		sWhereSql = " AND  DFP.status in ('04','05') and O.STATUS='03'";//δ����
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	}
	if(sForUseType == "0020" || "0020".equals(sForUseType)){
		sWhereSql = " AND  DFP.status='06' and O.STATUS='03' "; //������
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","��������","����","add()","","","","btn_icon_add",""},
			{"true","","Button","��������","����","edit()","","","","btn_icon_detail",""},
			{"false","","Button","�¼�","�¼�","PullOfShelves()","","","","btn_icon_detail",""},
			//{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};

	if(sForUseType == "0020" || "0020".equals(sForUseType)){
		 sButtons[0][0] = "false";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 
			var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseInfoView.jsp";
			//����������ˮ�� 
			var sSerialNo = getItemValue(0,getRow(0),'SERIALNO');
			var sObjectType = getItemValue(0,getRow(0),'OBJECTTYPE');
			var sObjectNo = getItemValue(0,getRow(0),'OBJECTNO');
			if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0 ){
				alert("��������Ϊ�գ�");
				return ;
			} 
			var sOperationStatus = "04";
			var sRightType = "All";
			 var sApplyType = "<%=sForUseType%>";
			 if("0010"!=sApplyType){//������  ���ύ
				 sRightType = "ReadOnly";
			 }
			 AsControl.PopComp(sUrl,"SerialNo=" +sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType"+sObjectType+"&OperationType="+"0020"+"&OperationStatus="+sOperationStatus+"&RightType="+sRightType+"&DocType=02" ,'');
			 reloadSelf();
			  
	}
	function isUsePassword(){
		var sPassword = PopPage("/DocManage/Doc2Manage/Doc2BPManage/CheckDialog.jsp","","dialogWidth:350px;dialogHeight:150px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;");
        var retuStr = "false"; 
        retuStr = PopPage("/DocManage/Doc2Manage/Doc2BPManage/CheckDialogAction.jsp?Password="+sPassword,"","dialogWidth:320px;dialogHeight:270px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;");
		return retuStr;
		alert(sPassword+","+retuStr);
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
		 var sRightType = "All";
		 var sApplyType = "<%=sForUseType%>";
		 if("0010"!=sApplyType){//������  ���ύ
			 sRightType = "ReadOnly";
		 }
		 var sOperationStatus = "04";
		AsControl.PopComp(sUrl,"SerialNo=" +sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType"+sObjectType+"&OperationType="+"0020"+"&OperationStatus="+sOperationStatus+"&RightType="+sRightType+"&DocType=02" ,'');
		reloadSelf();
	}
	function PullOfShelves(){
			var sDOObjectType = getItemValue(0,getRow(0),'ObjectType');
			if(sDOObjectType == null) sObjesDOObjectTypectType = "";
			var sObjectNo = getItemValue(0,getRow(0),'ObjectNo');
			if(sObjectNo == null) sObjectNo = "";
			var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
			if(sDOSerialNo == null) sDOSerialNo = "";
			var sUserId = "<%=CurUser.getUserID()%>";
			var sOrgId = "<%=CurUser.getOrgID()%>";
			var sDate = "<%=StringFunction.getToday()%>";
			var sOperationType = "";//Ԥ�鵵
			var sRemark = "";
			var sPosition = "";//ȡ��ר�б���  ר�м�λ
			var sMsg = "";

			if(sDOSerialNo == null || sDOSerialNo == "" ||sDOSerialNo == "undefine" || sDOSerialNo.length == 0){
				alert("��ѡ��һ�����ݣ�");
				return;
			}
		if(confirm('ȷʵҪ�¼���?')) {//��λ����Ϊ��
			var sPara = "OperationType="+sOperationType+"&DOSerialNo="+sDOSerialNo+"&ObjectType="+sDOObjectType+"&ObjectNo="+sObjectNo+"&Position="+sPosition;
			//����һ����������
			var sReturn=PopPageAjax("/DocManage/Doc2Manage/Doc2BPManage/Doc2specialKeepingAjax.jsp?"+sPara+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");//
			if(sReturn || (typeof(sReturn)!="undefined" && sReturn=="true")){
					sMsg = "�¼ܳɹ�";
			} else {
				sMsg = "�¼�ʧ��";
			}
			alert(sMsg);
		}
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
