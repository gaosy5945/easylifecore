<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "����Ѻ���б�"; // ��������ڱ��� <title> PG_TITLE </title>

	String serialNo = CurPage.getParameter("GCSerialNo");
	if(serialNo == null) serialNo = "";
	String vouchType = CurPage.getParameter("VouchType");
	if(vouchType == null) vouchType = "02010";
	String changeFlag = CurPage.getParameter("ChangeFlag");
	if(changeFlag == null) changeFlag = "";
	String transSerialNo = CurPage.getParameter("TransSerialNo"); //����ܽ�����ˮ��	
	if(transSerialNo == null) transSerialNo = "";
	String objectType =  CurComp.getParameter("ObjectType");
	if(objectType == null) objectType = "";
	String objectNo = CurPage.getParameter("ObjectNo"); 
	if(objectNo == null) objectNo = "";
	String contractStatus =  CurPage.getParameter("CStatus");
	if(contractStatus == null) contractStatus = "";
	String contractType = CurPage.getParameter("ContractType"); 
	if(contractType == null) contractType = "";
	String mode = CurPage.getParameter("Mode"); 
	if(mode == null) mode = "";
	String rightType = CurPage.getParameter("RightType");
	if(rightType == null) rightType = "";
	
	ASObjectModel doTemp = new ASObjectModel("CollateralList");
	if(vouchType.startsWith("020")){
		doTemp.setColumnAttribute("AssetSerialNo", "ColHeader", "��Ѻ����");
		doTemp.setColumnAttribute("AssetName", "ColHeader", "��Ѻ������");
	}
	else{
		doTemp.setColumnAttribute("AssetSerialNo", "ColHeader", "��Ѻ����");
		doTemp.setColumnAttribute("AssetName", "ColHeader", "��Ѻ������");
	}
	if(!"".equals(changeFlag))
		doTemp.setVisible( "ChangeFlag", true);
	
	if(("02".equals(contractStatus) && "020".equals(contractType)) || mode.equals("ReadOnly")){//��߶�����Чʱ���ѯģʽ
		doTemp.setVisible( "Status", true);
	}else if("jbo.app.BUSINESS_CONTRACT".equals(objectType)&&"ReadOnly".equals(rightType)){
		doTemp.setVisible( "Status", true);
	}
	
	//��߶����ͬ�����ѯģʽ��������ѺƷ��Ϣ��Ϊֻ����
	if("ReadOnly".equals(mode)){
		rightType = mode;
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.ShowSummary = "1";
	dwTemp.setPageSize(100);
	dwTemp.setParameter("GCSerialNo", serialNo);
	dwTemp.genHTMLObjectWindow(serialNo);
	
	String sButtons[][] = {
			{"true","All","Button","������Ѻ��","������Ѻ��","newRecord()","","","",""},
			{"false","All","Button","�����Ѻ��","�����Ѻ��","importColl()","","","",""},
			{"true","","Button","����","�鿴����","viewAndEdit()","","","",""},
			{"true","All","Button","ɾ��","ɾ����Ϣ","deleteRecord()","","","",""},
			{"false","All","Button","ɾ��","ɾ����Ϣ","deleteChange()","","","",""},
	};
	if(vouchType.startsWith("040")){
		sButtons[0][3] = "������Ѻ��";
		sButtons[0][4] = "������Ѻ��";
		sButtons[1][3] = "������Ѻ��";
		sButtons[1][4] = "������Ѻ��";
	}
	if(changeFlag.indexOf("����")>=0 || changeFlag.indexOf("ԭ��¼")>=0){
		sButtons[3][0] = "false";
		sButtons[4][0] = "true";
	}
	if(("02".equals(contractStatus) && "020".equals(contractType)) || mode.equals("ReadOnly")){//��߶�����Чʱ���ѯģʽ
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[3][0] = "false";
	}
	
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
		var returnValue = null;
		<%-- if("<%=vouchType%>".substring(0,3) == "020"){//��Ѻ
			returnValue = selectObjectValue("SelectAssetType1","CodeNo,AssetType","",0,0,"");
		} --%>
		if("<%=vouchType%>" == "02010"){//���ز���Ѻ
			returnValue = selectObjectValue("SelectAssetType11","CodeNo,AssetType","");
		}
		else if("<%=vouchType%>" == "02060"){//������Ѻ
			returnValue = selectObjectValue("SelectAssetType12","CodeNo,AssetType","");
		}
		else if("<%=vouchType%>".substring(0,3) == "040"){//��Ѻ
			returnValue = selectObjectValue("SelectAssetType2","CodeNo,AssetType","");
		}
		else{}
		//var returnValue = selectObjectValue("SelectAssetType","CodeNo,AssetType","",0,0,"");
		if(typeof(returnValue) == "undefined" || returnValue == "" || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_")  return;
		var assetType = returnValue.split("@")[0];
		var templateNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CollateralTemplate", "getTemplate", "ItemNo="+assetType);
		templateNo = templateNo.split("@");
		if(templateNo[0]=="false"){
			alert("δ����"+returnValue[1]+"��ģ�壡");
			return;
		}
		AsControl.PopComp("/CreditManage/CreditApply/GuarantyCollateralInfo.jsp", "SerialNo=&GCSerialNo=<%=serialNo%>&VouchType=<%=vouchType%>&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&ObjNo=<%=objectNo%>&ObjType=<%=objectType%>&ChangeFlag=<%=changeFlag%>&ParentTransSerialNo=<%=transSerialNo%>&TemplateNo="+templateNo[1]+"&AssetType="+assetType+"&Mode=1", "");
		reloadSelf();
	}
	
	function importColl(){
		var assetSource = "SelectAsset";
		if("<%=vouchType%>".substring(0,3) == "020"){
			assetSource = "SelectAsset1";//��Ѻ��
		}
		else if("<%=vouchType%>" == "040"){
			assetSource = "SelectAsset2";//��Ѻ��
		}
		else{}
		var returnValue =AsDialog.SelectGridValue(assetSource, "", "SERIALNO@ASSETTYPE@ASSETNAME@ASSETSTATUS@CONFIRMVALUE", "", false);
		if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
		var parameter = returnValue.split("@");
		var templateNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CollateralTemplate", "getTemplate", "ItemNo="+parameter[1]);
		templateNo = templateNo.split("@");
		if(templateNo[0]=="false"){
			alert("δ����"+returnValue[1]+"��ģ�壡");
			return;
		}
		var sReturn =AsControl.PopComp("/CreditManage/CreditApply/GuarantyCollateralInfo.jsp", "SerialNo=&GCSerialNo=<%=serialNo%>"+
				"&VouchType=<%=vouchType%>&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&ChangeFlag=<%=changeFlag%>"+
				"&ParentTransSerialNo=<%=transSerialNo%>&TemplateNo="+templateNo[1]+"&AssetType="+parameter[1]+"&AssetSerialNo="+parameter[0], "");
		//if(typeof(sReturn) == "undefined" || sReturn.length == 0)  return;
		reloadSelf();
	}
	
	function viewAndEdit(){
		var serialNo=getItemValue(0,getRow(),"SerialNo");	
		if(typeof(serialNo)=="undefined" || serialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		var assetType=getItemValue(0,getRow(),"AssetType");	
		var templateNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CollateralTemplate", "getTemplate", "ItemNo="+assetType);
		templateNo = templateNo.split("@");
		if(templateNo[0]=="false"){
			alert("δ����"+returnValue[1]+"��ģ�壡");
			return;
		}
		var assetSerialNo=getItemValue(0,getRow(),"AssetSerialNo");
		<%-- AsControl.PopComp("/CreditManage/CreditApply/GuarantyCollateralInfo.jsp", "SerialNo="+serialNo+"&AssetSerialNo="+assetSerialNo+"&VouchType=<%=vouchType%>&TemplateNo="+templateNo[1], ""); --%>
		AsCredit.openFunction("CollateralRegisterHandle", "SerialNo="+serialNo+"&AssetSerialNo="+assetSerialNo+"&GCSerialNo=<%=serialNo%>&TemplateNo="+templateNo[1]+"&Mode=1&ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&RightType=<%=rightType%>");
		reloadSelf();
	}
	
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		if(!confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			return ;
		}
		as_delete('0','');
	}

	function deleteChange(){	
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		if(!confirm('ȷʵҪɾ����?')) return;			
		var gcSerialNo = "<%=serialNo%>";
		var objectNo = "<%=objectNo%>";
		var objectType = "jbo.app.BUSINESS_CONTRACT";
		var documentObjectNo = getItemValue(0,getRow(),"AssetSerialNo");//ȡ��������Ѻ����ˮ��
		var parentTransSerialNo = "<%=transSerialNo%>";
		var documentObjectType ="jbo.app.ASSET_INFO";
		var changeAssetFlag = getItemValue(0,getRow(),"ChangeFlag");
		if(changeAssetFlag == "ԭ��¼"){
			var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",DocumentObjectType="+documentObjectType+",DocumentObjectNo="+documentObjectNo+",TransSerialNo="+parentTransSerialNo+",TransCode=003004,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,Flag=Y";
			AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CreateTransaction","create",para);
			reloadSelf();
		}else if(changeAssetFlag.indexOf("����") >=0){
			var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",DocumentObjectType="+documentObjectType+",DocumentObjectNo="+documentObjectNo+",GCSerialNo="+gcSerialNo+",TransSerialNo="+parentTransSerialNo+",TransCode=003003,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
			var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.DeleteTransaction","delete",para);
			alert(result);	
			reloadSelf();
		}else if(changeAssetFlag.indexOf("����") >=0){
			var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",DocumentObjectType="+documentObjectType+",DocumentObjectNo="+documentObjectNo+",TransSerialNo="+parentTransSerialNo+",TransCode=003004,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
			var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.DeleteTransaction","delete",para);
			alert(result);
			reloadSelf();
		}
	}
	
	
	/*~[Describe=ȡ������;InputParam=��;OutPutParam=��;]~*/
	function cancel(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var assetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		var assetEvaInfo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva", "getEvaInfo","AssetSerialNo="+assetSerialNo);
		if(assetEvaInfo=="false") {
			alert("û�й�ֵ����");
			return;
		}
		
		var flowSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva",
				"getEvaFlow","SerialNo="+assetSerialNo);
		
		if(flowSerialNo == "false"){
			var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva",
					"delEva","SerialNo="+assetSerialNo);
			
			alert("����ȡ���ɹ�!");
			return;
		}
		
		if(!confirm("ȡ������󲻿ɻָ�����ȷ�ϣ�")) return;
		var returnValue = AsControl.RunASMethod("WorkFlowEngine","DeleteBusiness",flowSerialNo);
	
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		if(returnValue == "true")
		{
			alert("����ȡ���ɹ�!");
			reloadSelf();
		}
		else
		{
			alert(returnValue.split("@")[1]);
		}
	}
	
	function taskQry(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var assetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		var assetEvaInfo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva", "viewEva","AssetSerialNo="+assetSerialNo);
		if(assetEvaInfo=="false") {
			alert("û�й�ֵ����");
			return;
		}
		
		var flowSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva",
				"getEvaFlow","SerialNo="+assetSerialNo);
		
		if(flowSerialNo == "false"){
			alert("����û���ύ����!");
			return;
		}
		
		
		AsControl.PopView("/Common/WorkFlow/QueryFlowTaskList.jsp", "FlowSerialNo="+flowSerialNo,"dialogWidth:1300px;dialogHeight:590px;");
	}
	
	function updateEva(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var assetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.AssetEvaCheck","updateInfoEva","SerialNo="+assetSerialNo);
		if(sReturn=="false") {
			alert("����û�й�ֵ��");
			return;
		}else if(sReturn=="") {
			alert("��ֵ����δ������");
			return;
		}else {
			alert("���³ɹ���");
		}
		
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 