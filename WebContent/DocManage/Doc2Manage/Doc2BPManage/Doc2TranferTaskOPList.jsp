<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sPTISerialNo = (String)CurPage.getParameter("PTISerialNo");
	if(null==sPTISerialNo) sPTISerialNo="";
	ASObjectModel doTemp = new ASObjectModel("Doc2TranferTaskOPList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.MultiSelect = true;
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sPTISerialNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","�������ҵ������","�������ҵ������","add()","","","","btn_icon_add",""},
			{"true","","Button","ҵ����������","ҵ����������","edit()","","","","btn_icon_detail",""},
			{"true","","Button","ɾ������","ɾ������","deleteRecord()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		if(checkHavePTI()){//����Ƿ񱣴棬����������ˮ���Ƿ��д���pti��
			var sPTISerialNo = "<%=sPTISerialNo%>";
			 var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2TranferTaskOPAddList.jsp";
			 AsControl.OpenView(sUrl,'PTISerialNo='+sPTISerialNo,'_self','');
		}else {
			alert("���ȱ����������Ϣ��");
		}
		 reloadSelf();
	}
	function checkHavePTI(){
		var sPTISerialNo = "<%=sPTISerialNo%>";
		var returnValue = false;
		if(sPTISerialNo != "" || sPTISerialNo != null){
			//RunMethod("PublicMethod","UpdateDocOperationSql","01,"+sRemark+","+sUserId+","+sDate+","+sDOSerialNo+"");
			var sSql ="select count(serialNo) as cnt from Pub_task_info pti where pti.serialno='"+sPTISerialNo+"'";
			var sReturn = RunMethod("PublicMethod","RunSql",sSql);
			if(sReturn == 1 || sReturn == "1"){
				returnValue = true;
			}else{
				returnValue = false;
			}
		}else {
			returnValue = false;
		}
		return returnValue;
	}
	function edit(){
		 var sPTISerialNo = "<%=sPTISerialNo%>";
		 var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/DocFilePackageInfo.jsp";
		 var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("��û�й�ѡ�κ��У�");
		 }else if(arr.length >1){
			 alert("��ѡ���˶��У�");
		 }else{
			 for(var i=0;i<arr.length;i++){
				 var sDOSerialNo = getItemValue(0,arr[i],'SERIALNO');
				 var sPara = getItemValue(0,arr[i],'DFPSERIALNO');
				 alert(sDOSerialNo+","+sPara);
				 AsControl.OpenPage(sUrl,'DFPSerialNo=' +sPara +"&PTISerialNo="+sPTISerialNo ,'_self','');
			 }
		 }
	}
	
	function deleteRecord(){
		if(confirm('ȷʵҪɾ����?')){
			as_delete(0);
		}
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
