<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sCustomerID = CurPage.getParameter("CustomerID");
	if(sCustomerID == null) sCustomerID = "";
	String SerialNo = CurPage.getParameter("SerialNo");
	if(SerialNo == null) SerialNo = "";

	String sTempletNo = "EntCustomerStockInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDefaultValue("CUSTOMERID", sCustomerID);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	doTemp.setDefaultValue("INPUTORGName", CurOrg.getOrgName());
	doTemp.setDefaultValue("INPUTUSERName", CurUser.getUserName());
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("SerialNo", SerialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button","返回","返回","top.close()","","","",""},
		};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<HEAD>
<title>股东信息</title>
</HEAD>
<script type="text/javascript"
	src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
	
	var bIsInsert = false; //标记DW是否处于“新增状态”
	var isSuccess=false;//标记保存成功
	var selectCustMode = false;//客户选择方式：false表示填入客户，true表示引入客户。用于贷款卡唯一性校验做控制。
	
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
			if(sResult[0] == "No"){//如果关联客户在本行为一个新客户时，新增该客户，并将其于本客户关联
				AddCustomerInfo();
				//importRelativeCustomer(); //互关联
			}else{//关联客户是本行的存量客户
				var RelativeCustomerID = sResult[1];
				var RelativeCustomerName = sResult[2];
				var customerid = "<%=sCustomerID%>";
				var sReturn = CustomerManage.judgeIsRelative(customerid,RelativeCustomerID);//该关联客户是否在本客户的关联人信息中（不可重复关联）
				sReturn=sReturn.split("@");
				if(sReturn[0] == "2"){
					alert("所要关联的客户已存在该客户关联人列表中，请确认！");
					return;
				}else{
					setItemValue(0,getRow(0),"RELATIVECUSTOMERID",RelativeCustomerID);
					setItemValue(0,getRow(0),"RELATIVECUSTOMERNAME",RelativeCustomerName);
					saveIframe();
					//importRelativeCustomer();
				}
			}
		}else if(IsFull == "Full"){
			alert("股东投资比例已为100%，请确认！");
			return;
		}else{
			alert("股东投资比例超过100%，请确认！");
			return;
		}
	}
	
	function checkCertInfo(){
		var certType=getItemValue(0,getRow(),"CertType");
		var certId=getItemValue(0,getRow(),"CertID");
		var countryCode=getItemValue(0,getRow(),"issueCountry");
		var result = CustomerManage.checkCertID(certType,certId,countryCode);
		if(!result){
			alert("证件号码不符合标准，请重新输入！");
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
			 			alert("客户\""+tempResult[2]+"\"新增成功！");
					}else{
						alert("客户\""+tempResult[2]+"\"新增失败！");
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
	
	/*~[Describe=证件类型为个人证件时，客户类型设置为个人客户;InputParam=无;OutPutParam=无;]~*/
	function setCustomerType(){
		sCertType = getItemValue(0,getRow(),"CertType");
			if(sCertType.substr(0,1) == "2" && sCertType != "2"){
				setItemValue(0,getRow(),"CustomerType","01");
			}else{
				setItemValue(0,getRow(),"CustomerType","03");
		}
	}
	
	/*~[Describe=根据证件类型和证件编号获得客户编号和客户名称;InputParam=无;OutPutParam=无;]~*/
	var sCertType="";
	function getCustomerName(){
		sCertType   = getItemValue(0,getRow(),"CertType");//--证件类型
		var sCertID   = getItemValue(0,getRow(),"CertID");//--证件号码
	    if(typeof(sCertType) != "undefined" && sCertType != "" && 
			typeof(sCertID) != "undefined" && sCertID != ""){
	        //获得客户名称
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
						//设置客户编号
						if(my_array2[n] == "customerid")
							setItemValue(0,getRow(),"RelativeCustomerID",sReturnInfo[n+1]);
						//设置客户名称
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"CustomerName",sReturnInfo[n+1]);
						//设置贷款卡编号
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
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		var sSerialNo = "<%=SerialNo%>";
		if(typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			//as_add("myiframe0");//新增记录
			bIsInsert = true;
		}else{
			setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
		}
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck(){
	    sCertID = getItemValue(0,0,"CertID");//证件代码
		//校验股东贷款卡编号
		sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//股东贷款卡编号	
		if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" ){
			if(sLoanCard != sLoanCardNo || selectCustMode == false){
				//检验股东贷款卡编号唯一性
				sCustomerID = getItemValue(0,getRow(),"CustomerID");//客户名称	
				sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sCustomerID+","+sLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many"){
					alert(getBusinessMessage('231'));//该股东贷款卡编号已被其他客户占用！							
					return false;
				}	
			}					
		}
	
		//校验股东是否被修改
		sCustomerName = getItemValue(0,getRow(),"CustomerName");//客户名称
		sReturn=RunMethod("CustomerManage","CheckCustomerName",sCustomerName+","+sCertID);
		if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") {
			alert(getBusinessMessage('257'));//该股东已经存在，请不要修改用户名！							
			return false;
		}						
		//校验股东的出资比例(%)之和是否超过100%
		sRelativeID = getItemValue(0,getRow(),"RelativeCustomerID");//--关联客户代码
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//--主体客户代码
		sInvestmentProp = getItemValue(0,getRow(),"InvestmentProp");//--出资比例(%)
		if(typeof(sInvestmentProp) != "undefined" && sInvestmentProp != "" ){
			sStockSum = RunMethod("CustomerManage","CalculateStock",sCustomerID+","+sRelativeID);
			sTotalStockSum = parseFloat(sStockSum) + parseFloat(sInvestmentProp);
			if(sTotalStockSum > 100){
				alert(getBusinessMessage('138'));//所有股东的出资比例(%)之和不能超过100%！
				return false;
			}
		}
		return true;
	}
	
	/*~[Describe=关联关系插入前检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function RelativeCheck(){
		sCustomerID   = getItemValue(0,0,"CustomerID");//--客户代码		
		sCertType = getItemValue(0,0,"CertType");//--证件类型		
		sCertID = getItemValue(0,0,"CertID");//证件代码		
		sRelationShip = getItemValue(0,0,"RelationShip");//--关联关系
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
			var sOughtSum   = getItemValue(0,getRow(),"OughtSum");//--应出资金额
		var sInvestmentSum   = getItemValue(0,getRow(),"InvestmentSum");//--实际投资金额
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
