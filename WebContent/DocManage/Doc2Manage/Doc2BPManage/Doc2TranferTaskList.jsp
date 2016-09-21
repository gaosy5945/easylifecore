<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sTranferType = CurPage.getParameter("TranferType");
	if(sTranferType == null) sTranferType = "";
	String sWhereSql = "";
	ASObjectModel doTemp = new ASObjectModel("Doc2TranferTaskList");

	if("0010".equals(sTranferType) || "0010" == sTranferType){
		sWhereSql = " and O.status ='01' and O.OPERATEUSERID ='"+CurUser.getUserID()+"' ";//���ƿ�
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	}
	if("0020".equals(sTranferType) || "0020" == sTranferType){
		sWhereSql = " and O.status ='02' and O.OPERATEUSERID ='"+CurUser.getUserID()+"' ";//���ƿ�
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","","Button","�ƿ�","�ƿ�","tranferRecord()","","","","btn_icon_delete",""},
			{"true","","Button","ɾ��","ɾ��","deleteRecord()","","","","btn_icon_delete",""},
			{"true","","Button","��ӡ�ƿ��嵥","��ӡ�ƿ��嵥","printTranfer()","","","","btn_icon_detail",""},
		};

	if("0010".equals(sTranferType) || "0010" == sTranferType){
		sButtons[4][0] ="false";
	}else	if("0020".equals(sTranferType) || "0020" == sTranferType){
		sButtons[0][0] ="false";
		sButtons[2][0] ="false";
		sButtons[3][0] ="false";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var sPTISerialNo = getSerialNo("PUB_TASK_INFO","SerialNo","");
		var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2TranferTaskView.jsp";
		AsControl.OpenPage(sUrl,"PTISerialNo=" +sPTISerialNo ,'_self','');
		reloadSelf();
	}
	function edit(){
		 var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2TranferTaskView.jsp";
		 var sPTISerialNo = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPTISerialNo)=="undefined" || sPTISerialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.OpenPage(sUrl,"PTISerialNo=" +sPTISerialNo,'_self','');
	}
	function tranferRecord(){
		 var sPTISerialNo = getItemValue(0,getRow(0),'SerialNo');
		//1.��ǰ���ι�����ҵ�����ϣ�DOC_OPERATION,DOC_FILE_PACKAGE��  ��Ϊ�����ƿ⣬2.��ǰ���Σ�PUB_TASK_INFO�� ��Ϊ�����ƿ�
		if(confirm('ȷʵҪ�ƿ���?')){
			var sSql1 = "update pub_task_info  set status='02' where serialno='" +sPTISerialNo+"'";
			var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql1);//ɾ��DO��������ҵ��������Ϣ��
			if(sReturnValue > -1 ){
				//���������ҵ��������Ϣ��Ϊ���ƿ� 09 ���ƿ�  do��dfp
				//var sSql1 = "update doc_file_package  set status='09' where serialno='" +sPTISerialNo+"'";
				//var sReturnValue1 =  RunMethod("PublicMethod","RunSql",sSql1);//ɾ��DO��������ҵ��������Ϣ��
				//if(sReturnValue1 > -1 ){
					alert("�ƿ�ɹ���");
				//}
				reloadSelf();
			}
		}
	}
	function deleteRecord(){
		var sPTISerialNo = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPTISerialNo)=="undefined" || sPTISerialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		 if(confirm('ȷʵҪɾ����?')){
				var sSql1 = "delete doc_operation do where do.taskserialno='" +sPTISerialNo+"'";
				var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql1);//ɾ��DO��������ҵ��������Ϣ��
				if(sReturnValue > -1 ){
					as_delete(0);//ɾ����ǰ������Ϣ
					//alert("ɾ���ƿ�����ɹ���");
					reloadSelf();
				}
			}
	}
	function printTranfer(){
		alert("printTranfer");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
