<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String opStatus = CurPage.getParameter("OpStatus");//Ԥ�鵵״̬
	String flag = CurPage.getParameter("Flag");//�Ƿ�ר�б���
	if(opStatus == null) opStatus = "";
	if(flag ==  null) flag = "";
	String transactionCode = CurPage.getParameter("TransactionCode"); 
	String sExistsWhere = "";
	ASObjectModel doTemp = new ASObjectModel("Doc2BeforPigeonholeManageList");
	//��ʾ��ͬ����
	if("Y".equals(flag)){
		doTemp.appendJboWhere(" and dfp.position is not null ");
	} 
	//doTemp.setHtmlEvent("OBJECTTYPE", "OnChange", "selectDocType()","");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	
	dwTemp.setParameter("Status", opStatus);
	dwTemp.setParameter("OrgID", CurOrg.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"false","","Button","ר�б���","ר�б���","specialKeeping()","","","","btn_icon_add",""},
			{"true","","Button","Ӱ��ɨ��","Ӱ��ɨ��","imageScanning()","","","","btn_icon_add",""},
			{"true","","Button","ȡ��","ȡ��","cancleRecord()","","","","btn_icon_delete",""},
			{"false","","Button","Ԥ�鵵","Ԥ�鵵","submitRecord()","","","","",""}
		};
	if("03".equals(opStatus) && "N".equals(flag)){
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
	}else if("03".equals(opStatus) && "Y".equals(flag)){
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[5][0] = "false";
	}
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	//����
	function add(){
		 var sAddDialogUrl = "/DocManage/Doc2Manage/Doc2BPManage/DocOperationAddDialog.jsp";//+"OperationType=02";
		 var dialogStyle = "dialogWidth=450px;dialogHeight=300px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
		 var returnValue = AsControl.PopComp(sAddDialogUrl,"TransactionCode=0000",dialogStyle);
		 
		 if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != '_CANCEL_'){
			serialNo = returnValue;
		 	AsCredit.openFunction("BusinessDocInfo","SerialNo="+serialNo);
			reloadSelf();
		 } 
		 self.reloadSelf();
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

	function specialKeeping(){
		var sSerialNo = getItemValue(0,getRow(0),'SerialNo');
		if(sSerialNo == null) sSerialNo = "";
		var sObjectType = getItemValue(0,getRow(0),'ObjectType');
		if(sObjectType == null) sObjectType = "";
		var sObjectNo = getItemValue(0,getRow(0),'ObjectNo');
		if(sObjectNo == null) sObjectNo = "";
		var sParaValue = "SerialNo="+sSerialNo + "&ObjectType=" + sObjectType + "&ObjectNo=" + sObjectNo+"&KeepingType=0201";
		var returnValue = PopPage("/DocManage/Doc2Manage/Doc2BPManage/DocWarehouseAddDialog.jsp?"+sParaValue,"","resizable=yes;dialogWidth=500;dialogHeight=200;center:yes;status:no;statusbar:no");
		returnValue = returnValue.split("@");
		var returnSerialNo = returnValue[1];
		if(returnSerialNo == null || returnSerialNo == "undefine" || returnSerialNo == "null"){
			returnSerialNo = "";
		}
		if(returnValue[0] == "TRUE"){
			alert(returnSerialNo+"ר�б��ܳɹ���");
		}else {
			alert(returnSerialNo+"ר�б���ʧ�ܣ�");
		}
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
	
	function cancleRecord(){
		var opStatus = "<%=opStatus%>";
		var flag = "<%=flag%>";
		if(opStatus == "03"  && "Y" == flag) {
			if(confirm('ȷʵҪȡ��ר�б�����?')) {//ȡ��ר�б��ܣ���λ����Ϊ��
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
				var sPara = "OperationType="+sOperationType+"&DOSerialNo="+sDOSerialNo+"&ObjectType="+sDOObjectType+"&ObjectNo="+sObjectNo+"&Position="+sPosition+"&KeepingType=0101";
				var sReturn=PopPageAjax("/DocManage/Doc2Manage/Doc2BPManage/Doc2specialKeepingAjax.jsp?"+sPara+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");//
				if(sReturn || (typeof(sReturn)!="undefined" && sReturn=="true")){
					var sReturnValue =  RunMethod("PublicMethod","UpdateDocOperationSql","01,"+sRemark+","+sUserId+","+sDate+","+sDOSerialNo+"");
					if(sReturnValue >0){ 
						sMsg = "ȡ��ר�б��ܳɹ�";
					}else {
						sMsg = "ȡ��ר�б���ʧ��";	
					}
				} else {
					sMsg = "ȡ��ר�б���ʧ��";
				}
				alert(sMsg);
			}
		}
		else
		{
			if(confirm('ȷʵҪȡ����?')) {
				//as_delete(0,'alert(getRowCount(0))');
				var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
				if(sDOSerialNo == null) sDOSerialNo = "";
				var sSql = "  delete doc_operation_file dof where dof.operationserialno='"+sDOSerialNo+"'";
				var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
				if(sReturnValue > -1){ 
					as_delete(0);
					sMsg = "ȡ���ɹ���";
				}else {
					sMsg = "ȡ��ʧ�ܣ�";
				}
			}
		}
		reloadSelf();
	}

	//Ԥ�鵵
	function submitRecord(){
		var sDOObjectType = getItemValue(0,getRow(0),'ObjectType');
		if(sDOObjectType == null) sObjesDOObjectTypectType = "";
		var sObjectNo = getItemValue(0,getRow(0),'ObjectNo');
		if(sObjectNo == null) sObjectNo = "";
		var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		if(sDOSerialNo == null) sDOSerialNo = "";
		var sOperationType = "0010";//Ԥ�鵵
		var sPosition = "";//ȡ��ר�б���  ר�м�λ
		var sPara = "OperationType="+sOperationType+"&DOSerialNo="+sDOSerialNo+"&ObjectType="+sDOObjectType+"&ObjectNo="+sObjectNo+"&Position="+sPosition;
		//����һ����������
		var sReturn=PopPageAjax("/DocManage/Doc2Manage/Doc2BPManage/Doc2submitAjax.jsp?"+sPara+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");//
		if(sReturn || (typeof(sReturn)!="undefined" && sReturn=="true")){
			var sSql = "update doc_operation set status='0201' where serialno='" +sDOSerialNo+"'";
			var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
			if(sReturnValue >0){
				alert("Ԥ�鵵�ɹ�");
				reloadSelf();
			}
		}
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
