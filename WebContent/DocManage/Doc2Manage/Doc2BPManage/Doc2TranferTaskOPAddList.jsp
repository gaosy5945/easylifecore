<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
/**
ҵ�������ƿ� ���� ҵ�����ϣ�����Ϣ
*/
	String sPTISerialNo = (String)CurComp.getParameter("PTISerialNo");
	if(null==sPTISerialNo) sPTISerialNo="";
	String sWhereSql = "";	

	ASObjectModel doTemp = new ASObjectModel("Doc2TranferTaskOPAddList");
	
	//sWhereSql = "";
	//doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.MultiSelect = true;
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","ȷ��","����","add()","","","","btn_icon_add",""},
			//{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			//{"true","","Button","ȡ��","ȡ��","deleteRecord()","","","","btn_icon_delete",""},
			{"true","","Button","ȡ��","����","goBack()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 //var sMultiSelect = getItemValue(0,getRow(0),"MultiSelectionFlag");
		 var sPTISerialNo = "<%=sPTISerialNo%>";
		 var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("��û�й�ѡ�κ��У�");
		 }else{
			 alert("�Ѿ�ѡ����"+arr.length+" �У�");
			 for(var i=0;i<arr.length;i++){
				 //alert("���ǵ�:"+arr[i]+"�У�");
				 var sDFPSerialNo =  getItemValue(0,arr[i],'SERIALNO');
	    		 var sObjectType = getItemValue(0,arr[i],'OBJECTTYPE');
	    		 var sObjectNo = getItemValue(0,arr[i],'OBJECTNO');
	    		 var sOperationType = "";//�ƿ�������
	    		 //alert("["+sDFPSerialNo +"],["+sObjectType +"]<["+sObjectNo +"]"); 
	    		 var sFlag = checkIsInUse(sPTISerialNo,sObjectType,sObjectNo);
	    		 if(!sFlag){
	    			 var sReturn=PopPageAjax("/DocManage/Doc2Manage/Doc2BPManage/Doc2TranferTaskObjectAddAjax.jsp?OperationType="+sOperationType+"&PTISerialNo="+sPTISerialNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
	    			if(typeof(sReturn)!="undefined" && sReturn=="true"){
	    					//self.returnValue = "TRUE@" + sSerialNo + "@" + sObjectType + "@" + sObjectNo + "@";
	    					//self.close();
	    					alert("�ƿ�����ɹ�!");
	    			}else {
	    				alert("�ƿ����ʧ�ܣ�");
	    			}
	    		 }else{
	    			 alert("��ҵ�����ϣ�"+sDFPSerialNo+" �Ѿ������������ˣ�");
	    		 }
			 }
		 }
		 
		 //self.close();
		 //var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2TranferTaskOPList.jsp";
		 //AsControl.OpenPage(sUrl,'rightdown','');
	}
	
	function checkIsInUse(sPTISerialNo,sObjectType,sObjectNo){
		var sReturn = false;
		var sSql = "select count(serialNo) as cnt from doc_operation  where transactioncode='0080' and status='01' and  ObjectType='"+sObjectType+"' and ObjectNo ='"+sObjectNo+"'";
		var sReturnValue = RunMethod("PublicMethod","RunSql",sSql);
		//var sReturnValue = RunMethod("PublicMethod","SelectTranferObjectSql",sPTISerialNo+","+sObjectType+","+sObjectNo);
		if(sReturnValue > 0 && sReturnValue != null){
			sReturn = true;
		}
		return sReturn;
	}
	
	function edit(){
		 var sUrl = "";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.OpenPage(sUrl,'SerialNo=' +sPara ,'_self','');
	}
	function deleteRecord(){
		if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))');
	}
	function goBack(){
		var sPTISerialNo = "<%=sPTISerialNo%>";
		//self.close();
		//sUrl ="/DocManage/Doc2Manage/Doc2BPManage/Doc2TranferTaskOPList.jsp";
		//AsControl.OpenPage(sUrl,'_self','');
		AsControl.OpenView("/DocManage/Doc2Manage/Doc2BPManage/Doc2TranferTaskOPList.jsp","PTISerialNo="+sPTISerialNo+"","rightdown","");

	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
