<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<!-- 

    author: yjhou 2015.03.04 
    description:���ڿͻ� ����ҵ������������ز��� 

 -->
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sSerialNo = CurPage.getParameter("DOSerialNo"); //��ǰҵ�����ϳ���������ˮ��
	if(sSerialNo == null) sSerialNo = ""; 
	String sRightType = CurPage.getParameter("RightType");
	if(sRightType == null) sRightType = "";
	String sTempletNo = "Doc2OutOfWarehouseApplyInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDefaultValue("TRANSACTIONCODE", "0020");
	doTemp.setHtmlEvent("TRANSACTIONCODE", "onClick", "transactionCodeChange");
	//����ҵ����������ʱ����ʾ������ˮ��
	doTemp.setVisible("SERIALNO", false);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	if("ReadOnly".equals(sRightType)){
		dwTemp.ReadOnly = "-2";
		doTemp.setColInnerBtEvent("*", "");
	}
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(sSerialNo);
	String sButtons[][] = {
			{"true","All","Button","ȷ��","ȷ������","submit()","","","",""},
			{"true","All","Button","ȡ������","ȡ������","self.close()","","","",""},
		//{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	
	function returnList(){
		OpenPage("<%=sPrevUrl%>", "");
	}
	//���������
	function submit(){
		var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
		var sDOObjectType = getItemValue(0,getRow(0),'ObjectType');
		var sDOObjectNo = getItemValue(0,getRow(0),'ObjectNo');
		var sOperationType = getItemValue(0,getRow(0),'TRANSACTIONCODE');//���ⷽʽ
		//����һ����������DocOutApproveAction
		var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.DocOutApproveAction", "updateOperation", "DOSerialNo="+sDOSerialNo+",UserID=<%=CurUser.getUserID()%>");
		if((typeof(sReturn)!="undefined" && sReturn=="true")&&sReturn.length>0){
				alert("�����ύ�ɹ���");
				self.close();
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
 		}else if(sTransactionCode=="0030"){
 			showItem(0,"BORROWDATE");
 			showItem(0,"PLANRETURNDATE");
 			showItem(0,"ACTUALRETURNDATE");
 			
 		}
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
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
