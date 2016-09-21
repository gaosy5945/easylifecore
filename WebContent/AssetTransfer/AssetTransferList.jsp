<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	//���ղ���
	String projectStatus = DataConvert.toString(CurPage.getParameter("ProjectStatus"));//��Ŀ״̬
 	String isPack = DataConvert.toString(CurPage.getParameter("isPack"));//�Ƿ��ѷ��
	String isPool = DataConvert.toString(CurPage.getParameter("isPool"));//�Ƿ������ 
    
	ASObjectModel doTemp = null;
	doTemp = new ASObjectModel("ProjectTransferList");
	doTemp.setJboWhere("O.ProjectType like '02%' and O.status = :projectStatus");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	
	if("true".equals(isPack)||"true".equals(isPool)){
		dwTemp.MultiSelect = true;
	}else{
		dwTemp.MultiSelect = false;
	}
	
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(projectStatus);
	
	String sButtons[][] = {
		{"true".equals(isPack)&&"03".equals(projectStatus)?"true":"false","","Button","���","���","pack()","","","","",""},
		{"true".equals(isPool)?"true":"false","","Button","���","���","pool()","","","","",""},
		{"true".equals(isPack)&&"06".equals(projectStatus)?"true":"false","","Button","���·��","���·��","rePack()","","","","",""},
		{"true","","Button","��Ŀ����","��Ŀ����","check()","","","","btn_icon_detail",""},
	};
%> 
<script type="text/javascript">

	//��Ŀ����
	function check(){
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var sProjectType=getItemValue(0,getRow(),"ProjectType");
		var sProjectStatus=getItemValue(0,getRow(),"Status");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		AsCredit.openFunction("ProjectAssetDetail","SerialNo="+sSerialNo+"&RightType=ReadOnly&ProjectStatus="+sProjectStatus+"&ProjectType="+sProjectType);
	}

	//���
	function pack(){
		var recordArray = getCheckedRows(0);//��ȡ��ѡ����
 		var relaSerialNos = '';
 		var status = '06';//���
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
			if(confirm('ȷʵҪ�����?')){
				for(var i = 1;i <= recordArray.length;i++){
					var serialNo = getItemValue(0,recordArray[i-1],"SERIALNO");
					relaSerialNos += serialNo+"@";
				}
				var sResult = RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.AssetTransferAction","changeProjectStatus","serialNos="+relaSerialNos+",status="+status);
				if('true' == sResult){
					alert("����ɹ�");
					reloadSelf();
				}else{
					alert("���ʧ��");
				}
			}
		}else{
			alert("����ѡ��һ����¼");
		} 
	}
	
	//���·��
	function rePack(){
		var recordArray = getCheckedRows(0);//��ȡ��ѡ����
 		var relaSerialNos = '';
 		var status = '06';//���·��
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
			if(confirm('ȷʵҪ���·����?')){
				for(var i = 1;i <= recordArray.length;i++){
					var serialNo = getItemValue(0,recordArray[i-1],"SERIALNO");
					relaSerialNos += serialNo+"@";
				}
				var sResult = RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.AssetTransferAction","changeProjectStatus","serialNos="+relaSerialNos+",status="+status);
				if('true' == sResult){
					alert("���·���ɹ�");
					reloadSelf();
				}else{
					alert("���·��ʧ��");
				}
			}
		}else{
			alert("����ѡ��һ����¼");
		} 
	}
	
	// �ʲ����
	function pool(){
		var recordArray = getCheckedRows(0);//��ȡ��ѡ����
 		var relaSerialNos = '';
 		var status = '0605';//���
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
			if(confirm('ȷʵҪ�����?')){
				for(var i = 1;i <= recordArray.length;i++){
					var serialNo = getItemValue(0,recordArray[i-1],"SERIALNO");
					relaSerialNos += serialNo+"@";
				}
				var sResult = RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.AssetTransferAction","changeProjectStatus","serialNos="+relaSerialNos+",status="+status);
				if('true' == sResult){
					alert("��سɹ�");
					reloadSelf();
				}else{
					alert("���ʧ��");
				}
			}
		}else{
			alert("����ѡ��һ����¼");
		} 
	}
   	
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
