<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String status = CurPage.getParameter("Status"); 
	if(status == null || status == "nulll" || "null".equals(status))status = "";
	String sWhereSql = "";
	ASObjectModel doTemp = new ASObjectModel("Doc2ManageOutViewList");//Doc2OutOfWarehouseApplyList  Doc2ManageOutViewList  Doc2ManageViewList
	doTemp.setHeader("SERIALNO","������");
	sWhereSql = " O.SERIALNO=DO.OBJECTNO AND O.packageType='02'  and O.Status=:Status and do.status='01' and DO.transactioncode in('0020','0030') and DO.inputuserid ='"+ CurUser.getUserID() +"' ";//and DFP.POSITION is not null
	doTemp.setJboWhere(sWhereSql);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.MultiSelect = true;
	
	dwTemp.setParameter("Status", status);
	dwTemp.setParameter("OrgID", CurOrg.getOrgID());
	
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","�黹���","�黹���","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			//{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var sSerialNoList = "";
		var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("��û�й�ѡ�κ��У�");
			 return;
		 }else{
			 if(confirm("�Ƿ�黹���?")){//��ȷ����ѡ�еĵ����ѹ黹���
				for(var i=0;i<arr.length;i++){
				 var sDfpSerialNo = getItemValue(0, arr[i], "PACKAGESERIALNO");
					var sDOSerialNo = getItemValue(0, arr[i], "SERIALNO");
					if(typeof(sDfpSerialNo)=="undefined" || sDfpSerialNo.length==0 ){
							alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
							return ;
					}
					var sPara = "DFPSerialNo="+sDfpSerialNo+",DOSerialNo="+sDOSerialNo+",OutType=03,TransCode=0040,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
						var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.DocOutManageAction", "doOutWarehouse", sPara);
				
						if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != '_CANCEL_'){
						 	/* var serialNo = returnValue;
						 	var sOperationStatus = "04";
						 	AsControl.PopComp("/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseView.jsp","SerialNo=" +serialNo+"&OperationType=0020&OperationStatus="+sOperationStatus+"&RightType=All&DocType=02",'');
							 */
							sSerialNoList += sDOSerialNo + ","; 
						}
				 }
				if(sSerialNoList.split(",").length>0){
					 alert("�����ţ�"+sSerialNoList+"�ѳɹ��黹��⣡");
					 reloadSelf();	
				}else{
					alert("�黹���ʧ�ܣ�");
				} 
			 }
		 }
	}
	function edit(){
		var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseView.jsp";
		 var sSerialNo = getItemValue(0,getRow(0),'SerialNo');
		 var sObjectType = getItemValue(0,getRow(0),'ObjectType');
		 var sObjectNo = getItemValue(0,getRow(0),'ObjectNo');
		 if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		 var  sRightType = "ReadOnly";
		AsControl.PopComp(sUrl,"SerialNo=" +sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&OperationType=0020&DocType=02&RightType="+sRightType,'');
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
