<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sStatus = CurPage.getParameter("Status");
	if(StringX.isEmpty(sStatus)||sStatus==null) sStatus = "";
	String sWhereSql = "";
	//��ȡǰ�˴���Ĳ���
    //String sTemplateNo = DataConvert.toString(CurPage.getParameter("TestCustomerList"));//ģ���
	//ASObjectModel doTemp = new ASObjectModel("OutsourcingCollectionList");
    //O.status:0-δ�������Ĵ��գ�1-���������δ�Ǽ�������ս���Ĵ��գ�2-�ѵǼ�������ս���Ĵ���
    BusinessObject inputParameter =BusinessObject.createBusinessObject();
	ASObjectModel doTemp = new ASObjectModel("OutsourcingCollectionList"); 
	//ObjectWindowHelper.createObjectModel("OutsourcingCollectionList",inputParameter,CurPage);

	//doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
   if(StringX.isEmpty(sStatus)||sStatus==null){
    	sWhereSql = " and O.Status is null";
    }else{
    	sWhereSql = " and O.Status='" + sStatus + "'";
    }
    sWhereSql+=" AND O.COLLECTIONMETHOD='5' ";  
    String sRoleInfo []={"PLBS0014"};
	if(CurUser.hasRole(sRoleInfo)){
		sWhereSql+=" and exists (select 1 from v.org_belong where v.belongorgid=AL.OperateOrgID and v.OrgID='"+CurUser.getOrgID()+"') ";
	}else{
		sWhereSql+=" and AL.OperateUserID='"+CurUser.getUserID()+"' ";
	}
    doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	 
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);

	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","���ݵ���","���ݵ���","exportExcel()","","","",""},
			{"true","All","Button","���ս������","���ս������","inExcel()","","","","",""},
			{"true","All","Button","������յǼ�","������յǼ�","exertinsert()","","","","",""},
			{"false","","Button","��������","��������","CollectionInfo()","","","","",""},
		};
	if("2".equals(sStatus)){
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "true";
	}
	%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>

<script type="text/javascript">
	function exportExcel(){
		/* var sExportUrl = "/CreditManage/Collection/OutsourcingExportList.jsp";
		var sBatchNoList = "";
		var sBDSerialNoList = "";
		var sBatchNoOneFlag = "";
		 var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("�����뵱ǰ����������Ϣ��");
		 }else{
			for(var i=0;i<arr.length;i++){
				var sBDSerialNo = getItemValue(0,arr[i],'SERIALNO');
				if(sBDSerialNo == null) sBDSerialNo = "";
				var sTaskBatchNo = getItemValue(0,arr[i],'TASKBATCHNO');
				if(sTaskBatchNo == null) sTaskBatchNo = "";
				if(i==0 || (i>0 && sBatchNoOneFlag == sTaskBatchNo)){
					sBatchNoOneFlag = sTaskBatchNo;
				}else{
					alert("��ֻѡ��һ�������µô�������");
					return;
				}
				sBDSerialNoList += sBDSerialNo + ",";
				sBatchNoList += sTaskBatchNo + ",";
			 }
		 }
		 AsControl.PopComp(sExportUrl,'BatchNoList=' +sBatchNoList+'&BDSerialNoList='+sBDSerialNoList,'');
		 reloadSelf(); */
		 if(confirm("�Ƿ񵼳���ǰ���ε�ǰ������Ϣ��")){
				exportPage('<%=sWebRootPath%>',0,'excel','<%=dwTemp.getArgsValue()%>'); 
				 //export2Excel("myiframe0");
				 //amarExport("myiframe0");
		}
	}
	
	function inExcel(){
		//������ս��excel����
		
		var pageURL = "/CreditManage/Collection/CollExcelImport.jsp";
	    var parameter = "clazz=jbo.import.excel.OUT_COLL_IMPORT&InputUserId=<%=CurUser.getUserID()%>";
	    var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
	    var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
	    reloadSelf();
	}
	
	function exertinsert(){
		//������ս���Ǽ�
		var sResUrl = "/CreditManage/Collection/OutCollRegistrateInfo.jsp";
		var sTaskBatchNo = "";
		var sCTSerialNo = "";
		var sOperateUserID="";
		var sOperateUserName="";
		//��ȡ��ˮ��
		sTaskBatchNo=getItemValue(0,getRow(),"TASKBATCHNO");
		sCTSerialNo=getItemValue(0,getRow(),"SERIALNO");
		sOperateUserID=getItemValue(0,getRow(),"OPERATEUSERID");
		sOperateUserName=getItemValue(0,getRow(),"OPERATEUSERNAME");
		if (typeof(sTaskBatchNo)=="undefined" || sTaskBatchNo.length==0 || typeof(sCTSerialNo)=="undefined" || sCTSerialNo.length==0){
			alert("��ѡ��һ����¼");
			return;
		}
		AsControl.PopComp(sResUrl,"TaskBatchNo="+sTaskBatchNo+"&CTSerialNo="+sCTSerialNo+"&OperateUserID="+sOperateUserID+"&OperateUserName="+sOperateUserName,'');
		reloadSelf();
	}
	
	function exertdetal(){
		//�����������
		var sResListUrl = "/CreditManage/Collection/CollTaskProcessResultList.jsp";
		var sPTISerialNo = "";
		var sCTSerialNo = "";
		//��ȡ��ˮ��
		 var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1 || arr.length>1){
			 alert("��ѡ��һ�����ݣ�");
			 return;
		 }else{
			sPTISerialNo=getItemValue(0,arr[0],'TASKBATCHNO');
			sCTSerialNo=getItemValue(0,arr[0],'SERIALNO');
		 }
			//�ж���ˮ���Ƿ�Ϊ��
		if (typeof(sPTISerialNo)=="undefined" || sPTISerialNo.length==0 || typeof(sCTSerialNo)=="undefined" || sCTSerialNo.length==0){
			alert('��ѡ��һ����¼');
			return;
		}
		AsControl.PopComp(sResListUrl,'PTISerialNo=' +sPTISerialNo+'&CTSerialNo=' +sCTSerialNo+'&RightType=ReadOnly','');
		reloadSelf();
	}

	function CollectionInfo(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
	 	var duebillSerialNo = getItemValue(0,getRow(0),'ObjectNo');
		var contractSerialNo = getItemValue(0,getRow(0),'ContractSerialNo');
	 	var customerID = getItemValue(0, getRow(0), 'CUSTOMERID');
	 	if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
	 	}
	 	
		AsCredit.openFunction("CollTaskInfo","DoFlag=check&ObjcetNo="+duebillSerialNo+"&SerialNo="+serialNo+"&CustomerID="+customerID+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo+"&RightType=ReadOnly");
	}
	
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
