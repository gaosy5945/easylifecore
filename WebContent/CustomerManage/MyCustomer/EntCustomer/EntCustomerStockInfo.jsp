<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sCustomerID = CurPage.getParameter("CustomerID");
	if(sCustomerID == null) sCustomerID = "";
	String SerialNo = CurPage.getParameter("SerialNo");
	if(SerialNo == null) SerialNo = "";

	String sTempletNo = "EntCustomerStockInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDefaultValue("CUSTOMERID", sCustomerID);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	doTemp.setDefaultValue("INPUTORGName", CurOrg.getOrgName());
	doTemp.setDefaultValue("INPUTUSERName", CurUser.getUserName());
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("SerialNo", SerialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","","Button","����","����","top.close()","","","",""},
		};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<HEAD>
<title>�ɶ���Ϣ</title>
</HEAD>
<script type="text/javascript"
	src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
	
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	var isSuccess=false;//��Ǳ���ɹ�
	var selectCustMode = false;//�ͻ�ѡ��ʽ��false��ʾ����ͻ���true��ʾ����ͻ������ڴ��Ψһ��У�������ơ�
	
	function saveRecord()
	{	
		var CertID = getItemValue(0,0,"CertID");
		var CertType = getItemValue(0,0,"CertType");
		if(!iV_all("0")) return ;
		if(!checkCertInfo()) return ;
		var RelativePercent = getItemValue(0,getRow(0),"RelativePercent");
		var IsFull = CustomerManage.selectRelativePercent("<%=sCustomerID%>",RelativePercent);
		if(IsFull == "SUCCEED"){
			var sResult = CustomerManage.judgeIsExists(CertID, CertType);
			sResult=sResult.split("@");
			if(sResult[0] == "No"){//��������ͻ��ڱ���Ϊһ���¿ͻ�ʱ�������ÿͻ����������ڱ��ͻ�����
				AddCustomerInfo();
				//importRelativeCustomer(); //������
			}else{//�����ͻ��Ǳ��еĴ����ͻ�
				var RelativeCustomerID = sResult[1];
				var RelativeCustomerName = sResult[2];
				var customerid = "<%=sCustomerID%>";
				var sReturn = CustomerManage.judgeIsRelative(customerid,RelativeCustomerID);//�ù����ͻ��Ƿ��ڱ��ͻ��Ĺ�������Ϣ�У������ظ�������
				sReturn=sReturn.split("@");
				if(sReturn[0] == "2"){
					alert("��Ҫ�����Ŀͻ��Ѵ��ڸÿͻ��������б��У���ȷ�ϣ�");
					return;
				}else{
					setItemValue(0,getRow(0),"RELATIVECUSTOMERID",RelativeCustomerID);
					setItemValue(0,getRow(0),"RELATIVECUSTOMERNAME",RelativeCustomerName);
					saveIframe();
					//importRelativeCustomer();
				}
			}
		}else if(IsFull == "Full"){
			alert("�ɶ�Ͷ�ʱ�����Ϊ100%����ȷ�ϣ�");
			return;
		}else{
			alert("�ɶ�Ͷ�ʱ�������100%����ȷ�ϣ�");
			return;
		}
	}
	
	function checkCertInfo(){
		var certType=getItemValue(0,getRow(),"CertType");
		var certId=getItemValue(0,getRow(),"CertID");
		var countryCode=getItemValue(0,getRow(),"issueCountry");
		var result = CustomerManage.checkCertID(certType,certId,countryCode);
		if(!result){
			alert("֤�����벻���ϱ�׼�����������룡");
			return false;
		}
		return true;
	}
	
	function AddCustomerInfo(){
			//if (!RelativeCheck()) return;
			var customerName = getItemValue(0,getRow(0),"RelativeCustomerName");
			var certType = getItemValue(0,getRow(0),"CertType");
			var certID = getItemValue(0,getRow(0),"CertID");
			var issueCountry = getItemValue(0,getRow(0),"IssueCountry");
			var customerType = getItemValue(0,getRow(0),"CustomerType");
			var inputOrgID = "<%=CurOrg.getOrgID()%>";
			var inputUserID = "<%=CurUser.getUserID()%>";
			var inputDate = "<%=StringFunction.getToday()%>";
			var sReturn = CustomerManage.checkCustomer(certID, customerName, customerType, certType, issueCountry, inputOrgID, inputUserID, inputDate);
		 	temp = sReturn.split("@");	
				if(temp[0] == "true"){
					var result = CustomerManage.createCustomerInfo(customerName, customerType, certID, certType, issueCountry, inputOrgID, inputUserID, inputDate);
					tempResult = result.split("@");
					var sCustomerID = tempResult[1];
					CustomerManage.updateCertID(sCustomerID,certType,certID);
					if(tempResult[0] == "true"){
			 			alert("�ͻ�\""+tempResult[2]+"\"�����ɹ���");
					}else{
						alert("�ͻ�\""+tempResult[2]+"\"����ʧ�ܣ�");
						return;
					}
					setItemValue(0,0,"RELATIVECUSTOMERID",sCustomerID);
					saveIframe();
					return;
		 		}else if(temp[0] != "CBEmpty"){
		 			var relativeCustomerID = temp[1];
					setItemValue(0,0,"RELATIVECUSTOMERID",relativeCustomerID);
					saveIframe();
					return;
		 		}else{
		 			var relativeCustomerID = temp[2];
					setItemValue(0,0,"RELATIVECUSTOMERID",relativeCustomerID);
					saveIframe();
					return;
		 		}
	}
	function saveIframe(){
		as_save("myiframe0");
	}
	function importRelativeCustomer(){
		var relativeCustomerid = getItemValue(0,0,"RELATIVECUSTOMERID");
		var RelationShip = getItemValue(0,0,"RelationShip");
		CustomerManage.importRelationShip("<%=sCustomerID%>",relativeCustomerid,RelationShip,"<%=CurOrg.getOrgID()%>","<%=CurUser.getUserID()%>","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
	}
	
	function selectCustomer1(){
		AsDialog.SetGridValue("SelectEntAndIndCustomer", "<%=CurUser.getUserID()%>", "RELATIVECUSTOMERNAME=CUSTOMERNAME@CertType=CERTTYPE@CertID=CERTID@@IssueCountry=ISSUECOUNTRY", "");
		var certID = getItemValue(0,0,"CertID");
		var certType = getItemValue(0,0,"CertType");
		if(certID != ""){
			if(certType.substr(0,1) == "2" && certType != "2"){
				setItemValue(0,getRow(),"CUSTOMERTYPE","01");
			}else{
				setItemValue(0,0,"CUSTOMERTYPE","03");
			}
			tempFlag = "2";
		}
	}
	
	/*~[Describe=֤������Ϊ����֤��ʱ���ͻ���������Ϊ���˿ͻ�;InputParam=��;OutPutParam=��;]~*/
	function setCustomerType(){
		sCertType = getItemValue(0,getRow(),"CertType");
			if(sCertType.substr(0,1) == "2" && sCertType != "2"){
				setItemValue(0,getRow(),"CustomerType","01");
			}else{
				setItemValue(0,getRow(),"CustomerType","03");
		}
	}
	
	/*~[Describe=����֤�����ͺ�֤����Ż�ÿͻ���źͿͻ�����;InputParam=��;OutPutParam=��;]~*/
	var sCertType="";
	function getCustomerName(){
		sCertType   = getItemValue(0,getRow(),"CertType");//--֤������
		var sCertID   = getItemValue(0,getRow(),"CertID");//--֤������
	    if(typeof(sCertType) != "undefined" && sCertType != "" && 
			typeof(sCertID) != "undefined" && sCertID != ""){
	        //��ÿͻ�����
	        var sColName = "CustomerID@CustomerName@LoanCardNo";
			var sTableName = "CUSTOMER_INFO";
			var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
			
			sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != "") {
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
						//���ÿͻ����
						if(my_array2[n] == "customerid")
							setItemValue(0,getRow(),"RelativeCustomerID",sReturnInfo[n+1]);
						//���ÿͻ�����
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"CustomerName",sReturnInfo[n+1]);
						//���ô�����
						if(my_array2[n] == "loancardno") {
							if(sReturnInfo[n+1] != 'null')
								setItemValue(0,getRow(),"LoanCardNo",sReturnInfo[n+1]);
							else
								setItemValue(0,getRow(),"LoanCardNo","");
						}
					}
				}			
			}else{
				setItemValue(0,getRow(),"RelativeCustomerID","");
				setItemValue(0,getRow(),"CustomerName","");	
				setItemValue(0,getRow(),"LoanCardNo","");			
			}  
		}
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		var sSerialNo = "<%=SerialNo%>";
		if(typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			//as_add("myiframe0");//������¼
			bIsInsert = true;
		}else{
			setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
		}
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck(){
	    sCertID = getItemValue(0,0,"CertID");//֤������
		//У��ɶ�������
		sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//�ɶ�������	
		if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" ){
			if(sLoanCard != sLoanCardNo || selectCustMode == false){
				//����ɶ�������Ψһ��
				sCustomerID = getItemValue(0,getRow(),"CustomerID");//�ͻ�����	
				sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sCustomerID+","+sLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many"){
					alert(getBusinessMessage('231'));//�ùɶ��������ѱ������ͻ�ռ�ã�							
					return false;
				}	
			}					
		}
	
		//У��ɶ��Ƿ��޸�
		sCustomerName = getItemValue(0,getRow(),"CustomerName");//�ͻ�����
		sReturn=RunMethod("CustomerManage","CheckCustomerName",sCustomerName+","+sCertID);
		if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") {
			alert(getBusinessMessage('257'));//�ùɶ��Ѿ����ڣ��벻Ҫ�޸��û�����							
			return false;
		}						
		//У��ɶ��ĳ��ʱ���(%)֮���Ƿ񳬹�100%
		sRelativeID = getItemValue(0,getRow(),"RelativeCustomerID");//--�����ͻ�����
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//--����ͻ�����
		sInvestmentProp = getItemValue(0,getRow(),"InvestmentProp");//--���ʱ���(%)
		if(typeof(sInvestmentProp) != "undefined" && sInvestmentProp != "" ){
			sStockSum = RunMethod("CustomerManage","CalculateStock",sCustomerID+","+sRelativeID);
			sTotalStockSum = parseFloat(sStockSum) + parseFloat(sInvestmentProp);
			if(sTotalStockSum > 100){
				alert(getBusinessMessage('138'));//���йɶ��ĳ��ʱ���(%)֮�Ͳ��ܳ���100%��
				return false;
			}
		}
		return true;
	}
	
	/*~[Describe=������ϵ����ǰ���;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function RelativeCheck(){
		sCustomerID   = getItemValue(0,0,"CustomerID");//--�ͻ�����		
		sCertType = getItemValue(0,0,"CertType");//--֤������		
		sCertID = getItemValue(0,0,"CertID");//֤������		
		sRelationShip = getItemValue(0,0,"RelationShip");//--������ϵ
		if (typeof(sRelationShip) != "undefined" && sRelationShip != ''){
			var sMessage = PopPageAjax("/CustomerManage/EntManage/RelativeCheckActionAjax.jsp?CustomerID="+sCustomerID+"&RelationShip="+sRelationShip+"&CertType="+sCertType+"&CertID="+sCertID,"","");
			var messageArray = sMessage.split("@");
			var isRelationExist = messageArray[0];
			var info = messageArray[1];
			if (typeof(sMessage)=="undefined" || sMessage.length==0) {
				return false;	
			}	
			else if(isRelationExist == "false"){
				alert(info);
				return false;
			}
			else if(isRelationExist == "true"){
				setItemValue(0,0,"RelativeCustomerID",info);
			}
		}
		return true;
	}
	
	function getInvestmentProp(){
			var sOughtSum   = getItemValue(0,getRow(),"OughtSum");//--Ӧ���ʽ��
		var sInvestmentSum   = getItemValue(0,getRow(),"InvestmentSum");//--ʵ��Ͷ�ʽ��
		if((sOughtSum!=null)&&(sOughtSum!="")&&(sInvestmentSum!=null)&&(sInvestmentSum!="")){
			var sInvestmentProp=parseFloat(sInvestmentSum)/parseFloat(sOughtSum)*100;
			setItemValue(0,0,"InvestmentProp",sInvestmentProp);
		}
	 
	 }
	
	initRow();
 	//AsOne.AsInit();
	//init();
	//my_load(2,0,'myiframe0'); 

</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
