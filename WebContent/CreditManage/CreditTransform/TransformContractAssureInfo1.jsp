<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	/*
		Describe: ҵ���ͬ�����ĵ�����ͬ���飨һ����֤��ͬ��Ӧһ����֤�ˣ�;
		Input Param:
			ObjectNo�������ţ���ͬ��ˮ�ţ�
			SerialNo��������ͬ���			
			GuarantyType��������ʽ
	 */
	String PG_TITLE = "������ͬ������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//������������
	//������ʽ
    String sGuarantyType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyType"));
	//GUARANTY_CONTRACT����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	//TRANSFORM_RELATIVE����
	String sTRSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TRSerialNo"));
	String sContractType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContractType"));
	String sRelationStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RelationStatus"));
	if(sRelationStatus == null) sRelationStatus = "";
	if(sGuarantyType == null) sGuarantyType = "";
	if(sContractType == null) sContractType = "";
	if(sSerialNo == null) sSerialNo = "";
	//��ͬ���
	String sObjectNo = Sqlca.getString(new SqlObject("select RelativeSerialNo from GUARANTY_TRANSFORM where SerialNo =:SerialNo ").setParameter("SerialNo",sTRSerialNo));
	if(sObjectNo == null) sObjectNo = "";

	String sSql = " select CustomerID from BUSINESS_CONTRACT where SerialNo=:SerialNo ";
	String sCustomerID = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
    //���ݵ�������ȡ����ʾģ���
	sSql = " select ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyType' and ItemNo=:ItemNo";
	String sTempletNo = Sqlca.getString(new SqlObject(sSql).setParameter("ItemNo",sGuarantyType));
	//���ù�������
	String sTempletFilter = " (ColAttribute like '%BC%' ) ";
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//����Ȩ����ѡ���
	
	if(sGuarantyType.equals("010040")){
		doTemp.appendHTMLStyle("GuarantyInfo"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤������ķ�ΧΪ[0,100]\" ");
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
//	if(sContractType.equals("020")){
//		dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
//		CurComp.setAttribute("RightType","ReadOnly");
//	}else
		dwTemp.ReadOnly = "0";
	//����setEvent	
	dwTemp.setEvent("AfterInsert","!BusinessManage.InsertRelative("+sTRSerialNo+",GuarantyContract,#SerialNo,TRANSFORM_RELATIVE)+!CustomerManage.AddCustomerInfo(#GuarantorID,#GuarantorName,#CertType,#CertID,#LoanCardNo,#InputUserID)+!BusinessManage.UpdateTransformStatus("+sTRSerialNo+",020,#SerialNo)");
	dwTemp.setEvent("AfterUpdate","!CustomerManage.AddCustomerInfo(#GuarantorID,#GuarantorName,#CertType,#CertID,#LoanCardNo,#InputUserID)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","","Button","����","�����б�ҳ��","goBack()","","","",""}
		};
	if(sRelationStatus.equals("020")){
		sButtons[0][0] = "true";
	}
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
		if(bIsInsert){		
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		sSerialNo = "<%=sTRSerialNo%>";
		sStatus = "<%=sRelationStatus%>";
		OpenPage("/CreditManage/CreditTransform/TransformContractList1.jsp?TRSerialNo="+sSerialNo+"&ObjectType=TransformApply&RelationStatus="+sStatus,"_self","");
	}
	
	var selectCustMode = false;//�ͻ�ѡ��ʽ��false��ʾ����ͻ���true��ʾ����ͻ������ڴ��Ψһ��У�������ơ�
	var sLoanCard ="";//��¼�����

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();//��ʼ����ˮ���ֶ�
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"ContractStatus","010");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0) == 0){
			as_add("myiframe0");//������¼
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"GuarantyType","<%=sGuarantyType%>");
			setItemValue(0,0,"ContractType","010");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ContractStatus","010");//��ǩ������ͬ
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "GUARANTY_CONTRACT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=������������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectAssureType(){
		sParaString = "CodeNo"+",AssureType";		
		setObjectValue("SelectCode",sParaString,"@CheckGuarantyMan2@0@CheckGuarantyMan2Name@1",0,0,"");
	}

	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer(){
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤�����롢������
		var sReturn = "";
		if(sCertType!=''&&typeof(sCertType)!='undefined'){
			sParaString = "CertType,"+sCertType;
			sReturn = setObjectValue("SelectOwner",sParaString,"@GuarantorID@0@GuarantorName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");			
		}
		else{
			sParaString = "CertType, ";
			sReturn = setObjectValue("SelectOwner",sParaString,"@GuarantorID@0@GuarantorName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");
		}
		if(sReturn == "_CLEAR_"){
			setItemDisabled(0,0,"CertType",false);
			setItemDisabled(0,0,"CertID",false);
			setItemDisabled(0,0,"GuarantorName",false);
			selectCustMode = false;
			sLoanCard ="";
		}else{
			//��ֹ�û��㿪��ʲôҲ��ѡ��ֱ��ȡ��������ס�⼸������
			sCertID = getItemValue(0,0,"CertID");
			if(typeof(sCertID) != "undefined" && sCertID != ""){
				setItemDisabled(0,0,"CertType",true);
				setItemDisabled(0,0,"CertID",true);
				setItemDisabled(0,0,"GuarantorName",true);
				selectCustMode = true;
				var certType = getItemValue(0,0,"CertType");
				 var temp = certType.substring(0,3);
		            if(temp=='Ent'){
		            	sLoanCard = getItemValue(0,0,"LoanCardNo");//�����
		            	setItemRequired(0,0,"LoanCardNo",true);
		            	setItemDisabled(0,0,"LoanCardNo",true);
		            }
		            else{
		            	sLoanCard ="";//�����
		            	setItemRequired(0,0,"LoanCardNo",false);
		            	setItemDisabled(0,0,"LoanCardNo",false);
		            }
		            sCertType="";
			}else{
				selectCustMode = false;
				setItemDisabled(0,0,"CertType",false);
				setItemDisabled(0,0,"CertID",false);
				setItemDisabled(0,0,"GuarantorName",false);
				sLoanCard ="";
			}
		}
	}

	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck(){
		sGuarantyType = getItemValue(0,0,"GuarantyType");//--��������		
		//�����������Ϊ��Ѻ����Ѻ����֤����Լ���ձ�֤��������֤����֤��ʱ�����¼���֤����źϷ��Խ�����֤
		if(sGuarantyType == '050' || sGuarantyType == '060' || sGuarantyType.substring(0,3) == '010'){
			//���֤������Ƿ���ϱ������
			sCertType = getItemValue(0,0,"CertType");//--֤������		
			sCertID = getItemValue(0,0,"CertID");//֤������
			//У�鵣���˴�����
			sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//�����˴�����
			sCertID = getItemValue(0,getRow(),"CertID");//������֤����	
			if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" ){
				if(sLoanCard != sLoanCardNo || selectCustMode == false){
					//���鵣���˴�����Ψһ��
					sGuarantorName = getItemValue(0,getRow(),"GuarantorName");//�ͻ�����	
					sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sGuarantorName+","+sLoanCardNo);
					if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many"){
						alert(getBusinessMessage('419'));//�õ����˵Ĵ������ѱ������ͻ�ռ�ã�							
						return false;
					}
				}
				//�����������ŵĶ�Ӧ��У�顣
				sReturn=RunMethod("PublicMethod","GetColValue","LoanCardNo,ENT_INFO,String@CorpID@"+sCertID);
				if(typeof(sReturn) != "undefined" && sReturn != "" ){
					sItems =sReturn.split('@');
					sReturn = sItems[1];
					if(sReturn != "" && sReturn !=sLoanCardNo){
						alert("���������Ǹÿͻ��Ĵ��!");//���������Ǹÿͻ��Ĵ��!		
						return false;
					}
				}
				
			}
			
			//�������ĵ������Ƿ����Ŵ���ϵ�����δ��������Ҫ�»�ȡ�����˵Ŀͻ����
			if(typeof(sCertType) != "undefined" && sCertType != "" 
				&& typeof(sCertID) != "undefined" && sCertID != ""){
				var sGuarantorID = PopPageAjax("/PublicInfo/CheckCustomerActionAjax.jsp?CertType="+sCertType+"&CertID="+sCertID,"","");
				if (typeof(sGuarantorID)=="undefined" || sGuarantorID.length==0) {
					return false;
				}
				setItemValue(0,0,"GuarantorID",sGuarantorID);
			}			
		}
		
		//�����������Ϊ��֤����Լ���ձ�֤��������֤ʱ����Ե����˽��кϷ��Խ�����֤����֤�˷�ҵ�������ˣ�jlwu@
		if(sGuarantyType == '010010' || sGuarantyType == '010020' || sGuarantyType == '010030'){
			sCustomerID = "<%=sCustomerID%>";//ȡ��ҵ�������˵Ŀͻ�id
			sGuarantorID = getItemValue(0,getRow(),"GuarantorID");//��֤�˵Ŀͻ�id
			if(sCustomerID==sGuarantorID){
				alert(getBusinessMessage('502'));//�ñ�֤�˲���Ϊ�Լ������ҵ����б�֤��
				return false;
			}	
		}
		
		return true;
	}
	var sCertType="";
	/*~[Describe=����֤�����ͺ�֤����Ż�ÿͻ���š��ͻ����ƺʹ�����;InputParam=��;OutPutParam=��;]~*/
	function getCustomerName(){
		sCertType   = getItemValue(0,getRow(),"CertType");
		var sCertID   = getItemValue(0,getRow(),"CertID");
		if(typeof(sCertType) != "undefined" && sCertType != "" && 
			typeof(sCertID) != "undefined" && sCertID != ""){
			//��ÿͻ���š��ͻ����ƺʹ�����
	        var sColName = "CustomerID@CustomerName@LoanCardNo";
			var sTableName = "CUSTOMER_INFO";
			var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
			
			sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != ""){
				sReturn = sReturn.split('~');
				var my_array1 = new Array();
				for(i = 0;i < sReturn.length;i++){
					my_array1[i] = sReturn[i];
				}
				
				for(j = 0;j < my_array1.length;j++){
					sReturnInfo = my_array1[j].split('@');	
					var my_array2 = new Array();
					for(m = 0;m < sReturnInfo.length;m++){
						my_array2[m] = sReturnInfo[m];
					}
					
					for(n = 0;n < my_array2.length;n++){
						//���ÿͻ�ID
						if(my_array2[n] == "customerid")
							setItemValue(0,getRow(),"GuarantorID",sReturnInfo[n+1]);
						//���ÿͻ�����
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"GuarantorName",sReturnInfo[n+1]);
						//���ô�����
						if(my_array2[n] == "loancardno"){
							if(sReturnInfo[n+1] != 'null')
								setItemValue(0,getRow(),"LoanCardNo",sReturnInfo[n+1]);
							else
								setItemValue(0,getRow(),"LoanCardNo","");
						}
					}
				}
			}else{
				setItemValue(0,getRow(),"GuarantorID","");
				setItemValue(0,getRow(),"GuarantorName","");	
				setItemValue(0,getRow(),"LoanCardNo","");			
			} 
		}		
	}

	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@ include file="/IncludeEnd.jsp"%>