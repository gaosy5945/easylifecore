<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String objectNo = CurPage.getParameter("ContractArtificialNo");
	String objectType = CurPage.getParameter("ObjectType");
	if(objectType == null){
		objectType = "jbo.app.BUSINESS_CONTRACT";
	}
    String sStatus = CurPage.getParameter("Status");
    String sTransActionCode = CurPage.getParameter("TransActionCode");
	String sFlag = CurPage.getParameter("flag"); 
	String sRightType = CurPage.getParameter("RightType"); 
	String sApplyType = CurPage.getParameter("ApplyType");
	ASObjectModel doTemp = new ASObjectModel("DocFileInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	if("approve".equals(sFlag)||"03".equals(sApplyType)){
		dwTemp.MultiSelect = true;
	} 
	if("ReadOnly".equals(sRightType) || "ReadOnly" == sRightType){
		dwTemp.MultiSelect = false;
	}else{
		dwTemp.MultiSelect = true; //�����ѡ
	}
	/* if("01".equals(sStatus)||"01".equals(sStatus)){
		dwTemp.MultiSelect = true;//�����׶�
	}else{
		dwTemp.MultiSelect = false;//
	} */
	dwTemp.setPageSize(100);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.genHTMLObjectWindow(objectNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","",""},
			{"true","All","Button","ɾ��","ɾ��","del()","","","","",""},
			{"false","All","Button","����","����","update()","","","","",""},
		};
	//�����������е�ҵ�����ϲ���������ҵ������
	if("approve".equals(sFlag)||"03".equals(sApplyType)){
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "true";
	}
	if("03".equals(sStatus)){
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
	}
	sButtons[2][0] = "false";//���γ��ⰴť��modify by liuzq 20150320
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var objectNo = "<%=objectNo%>";
		var objectType = "<%=objectType%>";
		var returnValue = "";
		var inputParameters={"ObjectNo":objectNo};
		if(objectType == "jbo.app.BUSINESS_CONTRACT" || objectType == "jbo.app.BUSINESS_APPLY"){
			returnValue = AsCredit.selectJavaMethodTree("com.amarsoft.app.als.prd.web.ui.SelectDocFileConfig",inputParameters,"","Y");
		}else{
			returnValue = AsCredit.selectMultipleTree("SelectDocFileConfig", "ObjectNo,"+objectNo, ",", "");
		}
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == null) return;
		
		if(returnValue["ID"] == null || returnValue["ID"].length == 0 || returnValue["ID"] == "_NONE_" || returnValue["ID"] == "_CANCEL_") return;
		var fileID = returnValue["ID"];
		fileID = fileID.split(",");
		for(var i in fileID){
			if(typeof fileID[i] ==  "string" && fileID.length > 0 ){
				var ID = fileID[i];
        	AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.DocFileInfo", "insertDFI", "ID="+ID+",ObjectNo="+objectNo);
			}
		}
		reloadSelf();
	}
	
	function del(){
		var objectNo = "<%=objectNo%>";
		var fileIDs = "";
		var recordArray = getCheckedRows(0);//��ȡ��ѡ����
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1){
			if(!confirm('ȷʵҪɾ����?')) return;
			for(var i = 1;i <= recordArray.length;i++){
				var ID = getItemValue(0,recordArray[i-1],"FileID");
				var status = getItemValue(0,recordArray[i-1],"STATUS");
				if(status=="03")
				{
					alert("�����ϲ���ɾ����");
					continue;
				}
				var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.DocFileInfo", "ifCanDelete", "FileID="+ID+",ContractNo="+objectNo);
				if(returnValue.split("@")[0] == "false"){
					alert("��"+returnValue.split("@")[1]+"��Ϊ��ѡ�����ɾ��!");
					continue;
				}else{
					fileIDs += (ID+"@");
				}
			}
		}else{
			alert("��ѡ��Ҫɾ�������ϣ�");
		}
		AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.DocFileInfo", "delFiles", "ObjectNo="+objectNo+",FileIDs="+fileIDs);
		reloadSelf();
	}
	
	//���ϳ���ʱ���ҵ������״̬
	function update(){
		var sTransActionCode = "<%=sTransActionCode%>";
		var sContractSerialNo = "<%=objectNo%>";
		var sStatus  = "";//ҵ������״̬
		if("0020"==sTransActionCode){//����ʱ
			sStatus = "08";//�黹�ͻ�
		}else if("0030"==sTransActionCode){//����ʱ
			sStatus = "04";//���
		}
		var arr = new Array();//�������飺�������ѡ���Ҫ�����ҵ�����ϱ��
		arr = getCheckedRows(0);//��ѡ�е��д浽������
		if(arr.length < 1){
			 alert("��û�й�ѡ�κ��У�");
		}else{
			 for(var i=0;i<arr.length;i++){
				 var sFileID =  getItemValue(0,arr[i],'FILEID');//ҵ�����ϱ�� 
				 //�����б�
				 sDFIInfoList = "Status="+sStatus +",ContractSerialNo="+sContractSerialNo+",FileID="+sFileID;
				 //ִ�б��״̬�ķ���
				 AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.DocFileInfo", "updateFileInfoStatus", sDFIInfoList);
			}
		}
	}
	
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
