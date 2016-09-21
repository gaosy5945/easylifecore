<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>

<%
	//���ղ���
	String projectStatus = DataConvert.toString(CurPage.getParameter("projectStatus"));//��Ŀ״̬
	

	ASObjectModel doTemp = new ASObjectModel("AssetTransfereeList");
	doTemp.setJboWhere("PROJECTTYPE='020' and status='"+projectStatus+"'");
	
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("SerialNo");
	
	String sButtons[][] = {
	{AssetProjectCodeConstant.AssetProjectStatus_010.equals(projectStatus)?"true":"false","","Button","����","����","add()","","","","btn_icon_add",""},
	{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
	{AssetProjectCodeConstant.AssetProjectStatus_010.equals(projectStatus)?"true":"false","","Button","ɾ��","ɾ��","del()","","","","btn_icon_delete",""},
	{AssetProjectCodeConstant.AssetProjectStatus_010.equals(projectStatus)?"true":"false","","Button","����","����","keepAccount()","","","","",""},
	
	{AssetProjectCodeConstant.AssetProjectStatus_020.equals(projectStatus)?"true":"false","","Button","��Ŀ��Ϣ����","��Ŀ��Ϣ����","infoAdjust()","","","","",""},
	{"false","","Button","�ʲ�����","�ʲ�����","assetAdjust()","","","","",""},
	{AssetProjectCodeConstant.AssetProjectStatus_020.equals(projectStatus)?"true":"false","","Button","�ʲ�׷��","�ʲ�׷��","append()","","","","",""},
	{"false","","Button","�ʲ��û�","�ʲ��û�","replacement()","","","","",""},
	{AssetProjectCodeConstant.AssetProjectStatus_020.equals(projectStatus)?"true":"false","","Button","�ʲ������","�ʲ������","ransom()","","","","",""},
	{AssetProjectCodeConstant.AssetProjectStatus_020.equals(projectStatus)?"true":"false","","Button","�ʲ��ַ�","�ʲ��ַ�","distribute()","","","","",""},
	{AssetProjectCodeConstant.AssetProjectStatus_020.equals(projectStatus)?"true":"false","","Button","������Ϣ����","������Ϣ����","repaymentInfoImport()","","","","",""},
	{AssetProjectCodeConstant.AssetProjectStatus_020.equals(projectStatus)?"true":"false","","Button","֧������õǼ�","֧������õǼ�","costRegister()","","","","",""},
	{AssetProjectCodeConstant.AssetProjectStatus_020.equals(projectStatus)?"true":"false","","Button","����","����","fanshou()","","","","",""},
	
	{AssetProjectCodeConstant.AssetProjectStatus_040.equals(projectStatus)?"true":"false","","Button","�鵵","�鵵","archive()","","","","",""},
	
	{AssetProjectCodeConstant.AssetProjectStatus_050.equals(projectStatus)?"true":"false","","Button","�˵�","�˵�","unarchive()","","","","",""},
	
		};
%> 
<script type="text/javascript">

	function add(){
		var sReturnValue = AsControl.PopComp("/AssetTransfer/AddAssetProjectDialog.jsp","AssetProjectType=020","resizable=yes;dialogWidth=550px;dialogHeight=210px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	
	function edit(){
        var serialNo = getItemValue(0,getRow(),"serialNo");
		var sAssetProjectType = getItemValue(0,getRow(),"PROJECTTYPE");
    	if(typeof(serialNo) == "undefined" || serialNo.length == 0){
   			alert("����ѡ��һ����¼");
   			return ;
        }
        
    	var viewID = "001";
		if(!<%=AssetProjectCodeConstant.AssetProjectStatus_010.equals(projectStatus)%>){
			viewID="002";
		}
        paramString = "ObjectNo=" + serialNo + "&ObjectType=AssetProject&AssetProjectType="+sAssetProjectType+"&ViewID="+viewID; 
		AsControl.OpenView("/AssetTransfer/AssetTransferView.jsp",paramString,"_blank");
    	//AsControl.OpenObjectTab(paramString);
    	//AsControl.OpenObject("AssetProject", serialNo, viewID , "");
    	reloadSelf();
    	return ;
	}
	
	//ɾ��
	function del(){
		if(confirm('ȷʵҪɾ����?')){
			as_delete(0);
		}
	}
	
	//����
	function keepAccount(){
		//������ش�������BC��BP���������Ϣ���ͺ���
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		var status = '<%=AssetProjectCodeConstant.AssetProjectStatus_020%>';
		if(typeof(sProjectNo) == 'undefined' || sProjectNo.length == 0){
			alert("����ѡ��һ����¼");
			return;
		}
		if(confirm('ȷ��Ҫ���д˲�����?')){
			RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.AssetTransferAction","changeProjectStatus","projectNo="+sProjectNo+",status="+status+",assetProjectType=020");
			reloadSelf();
		}
	}
	
	//��Ŀ��Ϣ����
	function infoAdjust(){
		var sObjectNo = getItemValue(0,getRow(),"SERIALNO");
		var sAssetProjectType = getItemValue(0,getRow(),"PROJECTTYPE");
		if(typeof(sObjectNo) == 'undefined' || sObjectNo.length == 0){
			alert("����ѡ��һ����¼");
			return;
		}
		AsControl.OpenView("/AssetTransfer/AssetTransferInfo.jsp","ObjectNo="+sObjectNo+"&AssetProjectType="+sAssetProjectType,"_blank");
	}
	
	//�ʲ�׷��
	function append(){
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(sProjectNo) == 'undefined' || sProjectNo.length == 0){
			alert("����ѡ��һ����¼");
			return;
		}
		AsControl.OpenView("/AssetTransfer/ProjectAssetAdjust.jsp","ObjectNo="+sProjectNo+"&isAppend=true","_blank");
	}
	
	//�ʲ��û�
	function replacement(){
		alert("��ʵ��");
	}
	
	//�ʲ����
	function ransom(){
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(sProjectNo) == 'undefined' || sProjectNo.length == 0){
			alert("����ѡ��һ����¼");
			return;
		}
		
		AsControl.OpenView("/AssetTransfer/ProjectAssetRelaList.jsp","isRansom=true&ObjectNo="+sProjectNo+"&AssetProjectType=010","_blank");
	}
	
	//�ʲ�����
	function assetAdjust(){
		var serialNo = getItemValue(0,getRow(),"serialNo");
		var sAssetProjectType = getItemValue(0,getRow(),"PROJECTTYPE");
    	var sTransferMethod = getItemValue(0,getRow(),"TransferMethod");
		 
        if(typeof(serialNo) != "undefined" && serialNo.length != 0){
        	var sCompID = "AssetTransfer";
        	var sCompURL = "/AssetTransfer/ProjectAssetRelaList.jsp";
        	var sParamString = "AssetProjectType="+sAssetProjectType+"&TransferMethod="+sTransferMethod+"&SerialNo="+serialNo+"&ViewID=001";
        	
        	OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
        }else{
        	alert("����ѡ��һ����¼");
        }
	}
	
	//�ʲ��ַ�
	function distribute(){
		
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		var sJavaClass = "com.amarsoft.app.als.assetTransfer.action.AssetTransferAction";
		var sJavaMethod = "getRalativeSerialNo";
		var relaSerialNos = RunJavaMethodTrans(sJavaClass,sJavaMethod,"projectNo=" + sProjectNo);
		if(typeof(relaSerialNos) == 'undefined' || relaSerialNos.length < 1){
			alert("����Ŀ�����ʲ��Ѿ��ַ���ϣ�");
			return;
		}
		if(confirm('��ǰ�������Ե�ǰ��Ŀ�µ������ʲ����зַ�,�Ƿ�ȷ�ϴ˲���?')){
			//�� �ʲ��ַ�����
			var sReturn = PopPage("/AssetTransfer/AssetDistributeInfo.jsp?isBatch=true&ProjectNo="+sProjectNo,"","resizable=yes;dialogWidth=400px;dialogHeight=110px;center:yes;status:no;statusbar:no");
			
			if(typeof(sReturn) != 'undefined' && sReturn.length >= 1){
				var sManageOrgId = sReturn.split("@")[0];
				var sManageUserId = sReturn.split("@")[1];
				
				sJavaMethod = "assetDistribute";
				var sParams = "serialNos="+relaSerialNos+",manageOrgId="+sManageOrgId+",manageUserId="+sManageUserId;
				
				var sResult = RunJavaMethodTrans(sJavaClass,sJavaMethod,sParams);
				if('true' == sResult){
					alert("�ʲ��ַ��ɹ�");
					reloadSelf();
				}else{
					alert("�ʲ��ַ�ʧ��");
				}
			}
		}
	}
	
	//������Ϣ����
	function repaymentInfoImport(){
		alert("��ʵ��");
	}
	
	//֧������õǼ�
	function costRegister(){
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(sProjectNo) == 'undefined' || sProjectNo.length == 0){
			alert("����ѡ��һ����¼");
			return;
		}
		
		AsControl.OpenView("/AssetTransfer/AcctFeeLogList.jsp","ObjectNo="+sProjectNo,"_blank");
	}
	
	//����
	function fanshou(){
		//�Իع�ʽ�Ĵ���������Ŀ�������������з��ۣ���ɺ���Ŀ�׶θ���Ϊ�ѽ��塣
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		var sTransferMethod = getItemValue(0,getRow(),"TransferMethod");
		if(typeof(sProjectNo) == 'undefined' || sProjectNo.length == 0){
			alert("����ѡ��һ����¼");
			return;
		}
		
		if("010" == sTransferMethod){
			AsControl.OpenView("/AssetTransfer/FanShouInfo.jsp","ProjectNo="+sProjectNo,"","resizable=yes;dialogWidth=500px;dialogHeight=400px;center:yes;status:no;statusbar:no");
		}else{
			alert("ֻ�����÷�ʽΪ�ع�ʽ����Ŀ���ܷ���");
		}
	}
	
	//�鵵
	function archive(){
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		var status = '<%=AssetProjectCodeConstant.AssetProjectStatus_050%>';
		if(typeof(sProjectNo) == 'undefined' || sProjectNo.length == 0){
			alert("����ѡ��һ����¼");
			return;
		}
		if(confirm('ȷ��Ҫ���д˲�����?')){
			RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.AssetTransferAction","changeProjectStatus","projectNo="+sProjectNo+",status="+status);
			reloadSelf();
		}
	}
	
	//�˵�
	function unarchive(){
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		var status = '<%=AssetProjectCodeConstant.AssetProjectStatus_040%>';
		if(typeof(sProjectNo) == 'undefined' || sProjectNo.length == 0){
			alert("����ѡ��һ����¼");
			return;
		}
		if(confirm('ȷ��Ҫ���д˲�����?')){
			RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.AssetTransferAction","changeProjectStatus","projectNo="+sProjectNo+",status="+status);
			reloadSelf();
		}
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
