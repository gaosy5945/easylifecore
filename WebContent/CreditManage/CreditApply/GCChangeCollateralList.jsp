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

	ASObjectModel doTemp = new ASObjectModel("GCChangeCollateralList");
	if(vouchType.startsWith("020")){
		doTemp.setColumnAttribute("AssetSerialNo", "ColHeader", "��Ѻ����");
		doTemp.setColumnAttribute("AssetName", "ColHeader", "��Ѻ������");
	}
	else{
		doTemp.setColumnAttribute("AssetSerialNo", "ColHeader", "��Ѻ����");
		doTemp.setColumnAttribute("AssetName", "ColHeader", "��Ѻ������");
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.ShowSummary = "1";
	dwTemp.setPageSize(10);
	dwTemp.setParameter("GCSerialNo", serialNo);
	dwTemp.genHTMLObjectWindow(serialNo);
	
	String sButtons[][] = {
			{"true","All","Button","������Ѻ��","������Ѻ��","newRecord()","","","",""},
			{"false","All","Button","�����Ѻ��","�����Ѻ��","importColl()","","","",""},
			{"true","","Button","����","�鿴������Ϣ����","viewAndEdit()","","","",""},
			{"true","All","Button","ɾ��","ɾ��������Ϣ(/ȡ����ɾ���ĵ�����Ϣ)","deleteChange()","","","",""}
	};
	if(vouchType.startsWith("040")){
		sButtons[0][3] = "������Ѻ��";
		sButtons[0][4] = "������Ѻ��";
		sButtons[1][3] = "������Ѻ��";
		sButtons[1][4] = "������Ѻ��";
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
			returnValue = selectObjectValue("SelectAssetType11","CodeNo,AssetType","",0,0,"");
		}
		else if("<%=vouchType%>" == "02060"){//������Ѻ
			returnValue = selectObjectValue("SelectAssetType12","CodeNo,AssetType","",0,0,"");
		}
		else if("<%=vouchType%>".substring(0,3) == "040"){//��Ѻ
			returnValue = selectObjectValue("SelectAssetType2","CodeNo,AssetType","",0,0,"");
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
		AsControl.PopComp("/CreditManage/CreditApply/GCChangeGuarantyCollateralInfo.jsp", "SerialNo=&GCSerialNo=<%=serialNo%>&VouchType=<%=vouchType%>&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&ObjNo=<%=objectNo%>&ObjType=<%=objectType%>&ChangeFlag=<%=changeFlag%>&ParentTransSerialNo=<%=transSerialNo%>&TemplateNo="+templateNo[1]+"&AssetType="+assetType+"&Mode=1", "");
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
		var changeFlag = getItemValue(0,getRow(),"ChangeFlag");
		var rightType = "ReadOnly";
		if("020"==changeFlag&&"All"=="<%=CurPage.getParameter("RightType")%>"){
			rightType="All";
		}
		AsCredit.openFunction("GCChangeCollateralRegisterHandle", "SerialNo="+serialNo+"&AssetSerialNo="+assetSerialNo+"&GCSerialNo=<%=serialNo%>&TemplateNo="+templateNo[1]+"&Mode=1&ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&RightType="+rightType);
		
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
			
		var changeFlag = getItemValue(0,getRow(),"ChangeFlag");
		if("020"==changeFlag){
			deleteRecord();
		}else{
			if(!confirm('ȷʵҪɾ����?')) return;		
			var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.GuarantyContractChange", "updateChangeFalg", "GRSerialNo="+serialNo+",ChangeFlag="+changeFlag);
			if("true"!=result){
				alert(result);
				return;
			}
		}
		reloadSelf();
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 