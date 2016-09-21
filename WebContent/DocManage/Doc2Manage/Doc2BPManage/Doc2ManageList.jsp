<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String status = CurPage.getParameter("Status"); 
	if(status == null || status == "nulll" || "null".equals(status))status = "";
	
	ASObjectModel doTemp = new ASObjectModel("Doc2ManageViewList");//Doc2OutOfWarehouseList
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	
	dwTemp.setParameter("Status", status);
	dwTemp.setParameter("OrgID", CurOrg.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","Ӱ��ɨ��","Ӱ��ɨ��","imageScanning()","","","","btn_icon_add",""},
			{"true","All","Button","�嵥��ӡ","�嵥��ӡ","printList()","","","","btn_icon_add",""},
			{"true","","Button","��ӡ��⽻�ӵ�","��ӡ��⽻�ӵ�","printEntryList()","","","","btn_icon_detail",""},
			{"false","","Button","�ϼ�","�ϼ�","EntryOfShelves()","","","","",""},
			{"false","","Button","����","����","OutOfShelves()","","","","btn_icon_add",""},
		};
	if("03".equals(status)){
		sButtons[1][0] = "false";
		sButtons[3][0] = "false";
		sButtons[5][0] = "true";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

	
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
		 var sObjectNo = getItemValue(0, getRow(), "OBJECTNO");
		 if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0 ){
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return ;
		 }
		 var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2MaterialList.jsp";
		 AsControl.PopComp(sUrl,"SerialNo="+sObjectNo,"");
	}
	function OutOfShelves(){
		var sDfpSerialNo = getItemValue(0, getRow(), "PACKAGESERIALNO");
		var sDOSerialNo = getItemValue(0, getRow(), "SERIALNO");
		if(typeof(sDfpSerialNo)=="undefined" || sDfpSerialNo.length==0 ){
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return ;
		}
		var sPara = "DFPSerialNo="+sDfpSerialNo+",DOSerialNo="+sDOSerialNo+",OutType=02,TransCode=0020,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.DocOutManageAction", "doOutWarehouse", sPara);

		if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != '_CANCEL_'){
		 	var serialNo = returnValue;
			var sOperationStatus = "04";
			AsControl.PopComp("/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseView.jsp","SerialNo="+serialNo+"&DoSerialNo="+sDOSerialNo+"&DFPSerialNo="+sDfpSerialNo+"&OperationType=0020&OperationStatus="+sOperationStatus+"&RightType=All&DocType=02",'');
			reloadSelf();
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
