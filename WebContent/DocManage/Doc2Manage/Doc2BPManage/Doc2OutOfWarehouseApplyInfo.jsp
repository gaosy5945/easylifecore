<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sSerialNo = CurPage.getParameter("DOSerialNo");
	if(sSerialNo == null) sSerialNo = "";
	String sBeforeDOSerialNo = CurPage.getParameter("BeforeDOSerialNo");
	if(sBeforeDOSerialNo == null) sBeforeDOSerialNo = "";
	String sDfpSerialNo = CurPage.getParameter("DFPSerialNo");
	if(null==sDfpSerialNo) sDfpSerialNo="";
	String sRightType = CurPage.getParameter("RightType");
	if(sRightType == null) sRightType = "";
	String sDocType =  DataConvert.toRealString((String)CurPage.getParameter("DocType"));
	String sTempletNo = " ";//--ģ���--
	if("01".equals(sDocType)){
		sTempletNo = "DOC1OpinionDetails";
	}else if("02".equals(sDocType)){
		sTempletNo = "Doc2OutOfWarehouseApplyInfo";
	}
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDefaultValue("TRANSACTIONCODE", "0020");
	doTemp.setHtmlEvent("TRANSACTIONCODE", "onClick", "transactionCodeChange");
	String  whereSql = "";
	whereSql = " AND O.OBJECTTYPE='jbo.doc.DOC_FILE_PACKAGE' ";
	doTemp.setJboWhere(doTemp.getJboWhere()+whereSql);
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform 
	dwTemp.genHTMLObjectWindow(sSerialNo);
	String sButtons[][] = {
	{"true","All","Button","�ύ����","���������޸�","saveRecord()","","","",""},
	{"false","All","Button","�ύ","���������޸Ĳ��ύ","submit()","","","",""},
		//{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "north";
	  if(sRightType.equals("ReadOnly")){
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
	}
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

	function saveRecord()
	{
		var sPara = "SerialNo=<%=sDfpSerialNo%>,Status=04";
		var sPara1 = "SerialNo=<%=sSerialNo%>,BeforeDOSerialNo=<%=sBeforeDOSerialNo%>,Status=01";
		if(!iV_all(0)) return;
		
		if(confirm("�Ƿ��ύ���⣿")){
			var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.DocOutManageAction", "updateFilePackage1", sPara);
			var returnValue1 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.DocOutManageAction", "updateOperation1", sPara1);
			if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != '_CANCEL_'
				&& typeof(returnValue1) != "undefined" && returnValue1.length != 0 && returnValue1 != '_CANCEL_'){
				as_save(0,"setReturnValue()");	
				self.close();
			}
		}
	}
	
	function setReturnValue()
	{
		var obj = parent.document.getElementById("FirstFrame"); //�ж��Ƿ����½ṹ 
		var sTransActionCode = getItemValue(0,getRow(),"TRANSACTIONCODE"); 
		if(obj != null && typeof(obj) != "undefined")
		{
			var ContractArtificialNo = getItemValue(0,getRow(),"CONTRACTARTIFICIALNO");
			if(sTransActionCode != "") {
				var sParamers = "ContractArtificialNo="+ContractArtificialNo+"&flag=approve&TransActionCode="+sTransActionCode;
				AsControl.OpenView("/CreditManage/CreditApply/CreditDocFileList.jsp",sParamers,"rightdown","");
			}
			else
			{
				AsControl.OpenView("/Blank.jsp","","rightdown","");
			}
		}
		self.returnValue = sTransActionCode; 
	}

	setReturnValue();

	function submit(){
		if(!iV_all(0)){
			alert("���ȱ������ݣ�");
			return;
		}
		if(as_isPageChanged()){
			alert("�ύǰ�����ȱ������ݣ�");
			return;
		}
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		var sDOObjectType = getItemValue(0,getRow(0),'ObjectType');
		var sDOObjectNo = getItemValue(0,getRow(0),'ObjectNo'); 
		var transactionCode = getItemValue(0,getRow(),"TransactionCode");
		var opStatus = getItemValue(0,getRow(),"STATUS");
        var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc2ManageAction","commit","SerialNo="+serialNo+",TransactionCode="+transactionCode+",Status="+opStatus);
		  if(returnValue || (typeof(returnValue)!="undefined" && returnValue=="true")){
				alert(returnValue);
				self.close(); //�ύ�ɹ���رյ�ǰ����
		}else{
			alert("�����ύʧ�ܣ�");
		}
		
	}
	

 	function setTranCode(){
 		var sOperationReason = getItemValue(0,getRow(0),'OPERATEDESCRIPTION');
 		var sTranCode = "";
 		
 		if(sOperationReason > 0 && sOperationReason<=10){
 			sTranCode = "0030";
 		}else if(sOperationReason > 10 && sOperationReason<=18){
 			sTranCode = "0020";
 		}
		setItemValue(0,getRow(0),'TRANSACTIONCODE',sTranCode);
 	}
 	
 	 
 	/* 
 	 * ���ݳ��ⷽʽ�Ĳ�ͬ��ʾ��ͬ��Ҫ�أ� yjhou  2015.03.03
 	 * �����ⷽʽΪ"����"ʱ����ʾ"��������"��"�ƻ��黹"��"ʵ�ʹ黹����"��"��������"Ҫ��
 	 * �����ⷽʽΪ"����"ʱ�����������ĸ�Ҫ��
 	 */
 	function transactionCodeChange(){
 		var sTransactionCode=getItemValue(0,getRow(),"TRANSACTIONCODE");
 		if(sTransactionCode=="0020"){
 			hideItem(0,'BORROWDATE'); 
 			hideItem(0,'PLANRETURNDATE'); 
 			hideItem(0,'ACTUALRETURNDATE'); 
 			hideItem(0,'TRANSACTIONCONTEXT'); 
 		}else if(sTransactionCode=="0030"){
 			showItem(0,"BORROWDATE");
 			showItem(0,"PLANRETURNDATE");
 			showItem(0,"ACTUALRETURNDATE");
 			showItem(0,"TRANSACTIONCONTEXT");
 		}
 		//modify by lzq 20150331 
 		//setItemValue(0,getRow(0),'OPERATEDESCRIPTION','');
 		operateDescription();//����������ʾ��ͬ����ԭ��ĺ���
 	}
 	
 	//���ⷽʽҪ�ص������¼������ݳ��ⷽʽ�Ĳ�ͬ��ʾ��ͬ�ĳ���ԭ��
 	function operateDescription(){
		var tranSactionType=getItemValue(0,getRow(),"TRANSACTIONCODE");
		if(tranSactionType=="0020" ||tranSactionType=="0030"){
			showItem(0,'OPERATEDESCRIPTION');
			  $("[name=OPERATEDESCRIPTION]").each(function(){
			 	$(this).parent().hide();
			 	if(tranSactionType=="0020"){
					if(this.value=="11" || this.value=="12"|| this.value=="13"|| this.value=="14"
					  || this.value=="15"|| this.value=="16"|| this.value=="17"|| this.value=="18"){
						$(this).parent().show();
					}
			 	}else if(tranSactionType=="0030"){
			 		if(this.value=="1" || this.value=="2"|| this.value=="3"|| this.value=="4"|| this.value=="5"
					  || this.value=="6"|| this.value=="7"|| this.value=="8"|| this.value=="9"|| this.value=="10"){
							$(this).parent().show();
					}
			 	} 
		 	 });  
		}
	}
 	
 	transactionCodeChange();
 	
 	//��ȡ��ǰ�����������ˣ�����ѡ��ǰ�����µ������û�
 	function  selectUser(){
 		 setObjectValue("SelectRoleUser","OrgID,<%=CurOrg.orgID%>","@USEUSERID@0@USEUSERNAME@1@USEORGID@2@USEORGNAME@3",0,0,"");
 	}
 	
 	function initRow(){
 		if(getRow()==0){
 			setItemValue(0,getRow(0),'OPERATEDATE',"<%=StringFunction.getToday()%>");
 			setItemValue(0,getRow(0),'OPERATEUSERID','<%=CurUser.getUserID()%>');
 			setItemValue(0,getRow(0),'OPERATEUSERNAME','<%=CurUser.getUserName()%>');
		}
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
