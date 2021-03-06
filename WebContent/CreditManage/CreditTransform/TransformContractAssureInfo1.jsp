<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	/*
		Describe: 业务合同新增的担保合同详情（一个保证合同对应一个保证人）;
		Input Param:
			ObjectNo：对象编号（合同流水号）
			SerialNo：担保合同编号			
			GuarantyType：担保方式
	 */
	String PG_TITLE = "担保合同详情信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数：
	//担保方式
    String sGuarantyType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyType"));
	//GUARANTY_CONTRACT主键
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	//TRANSFORM_RELATIVE主键
	String sTRSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TRSerialNo"));
	String sContractType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContractType"));
	String sRelationStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RelationStatus"));
	if(sRelationStatus == null) sRelationStatus = "";
	if(sGuarantyType == null) sGuarantyType = "";
	if(sContractType == null) sContractType = "";
	if(sSerialNo == null) sSerialNo = "";
	//合同编号
	String sObjectNo = Sqlca.getString(new SqlObject("select RelativeSerialNo from GUARANTY_TRANSFORM where SerialNo =:SerialNo ").setParameter("SerialNo",sTRSerialNo));
	if(sObjectNo == null) sObjectNo = "";

	String sSql = " select CustomerID from BUSINESS_CONTRACT where SerialNo=:SerialNo ";
	String sCustomerID = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
    //根据担保类型取得显示模版号
	sSql = " select ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyType' and ItemNo=:ItemNo";
	String sTempletNo = Sqlca.getString(new SqlObject(sSql).setParameter("ItemNo",sGuarantyType));
	//设置过滤条件
	String sTempletFilter = " (ColAttribute like '%BC%' ) ";
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//设置权利人选择框
	
	if(sGuarantyType.equals("010040")){
		doTemp.appendHTMLStyle("GuarantyInfo"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例的范围为[0,100]\" ");
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
//	if(sContractType.equals("020")){
//		dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
//		CurComp.setAttribute("RightType","ReadOnly");
//	}else
		dwTemp.ReadOnly = "0";
	//设置setEvent	
	dwTemp.setEvent("AfterInsert","!BusinessManage.InsertRelative("+sTRSerialNo+",GuarantyContract,#SerialNo,TRANSFORM_RELATIVE)+!CustomerManage.AddCustomerInfo(#GuarantorID,#GuarantorName,#CertType,#CertID,#LoanCardNo,#InputUserID)+!BusinessManage.UpdateTransformStatus("+sTRSerialNo+",020,#SerialNo)");
	dwTemp.setEvent("AfterUpdate","!CustomerManage.AddCustomerInfo(#GuarantorID,#GuarantorName,#CertType,#CertID,#LoanCardNo,#InputUserID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button","返回","返回列表页面","goBack()","","","",""}
		};
	if(sRelationStatus.equals("020")){
		sButtons[0][0] = "true";
	}
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		//录入数据有效性检查
		if (!ValidityCheck()) return;
		if(bIsInsert){		
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
		sSerialNo = "<%=sTRSerialNo%>";
		sStatus = "<%=sRelationStatus%>";
		OpenPage("/CreditManage/CreditTransform/TransformContractList1.jsp?TRSerialNo="+sSerialNo+"&ObjectType=TransformApply&RelationStatus="+sStatus,"_self","");
	}
	
	var selectCustMode = false;//客户选择方式：false表示填入客户，true表示引入客户。用于贷款卡唯一性校验做控制。
	var sLoanCard ="";//记录贷款卡号

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		initSerialNo();//初始化流水号字段
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"ContractStatus","010");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0) == 0){
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"GuarantyType","<%=sGuarantyType%>");
			setItemValue(0,0,"ContractType","010");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ContractStatus","010");//已签担保合同
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "GUARANTY_CONTRACT";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=弹出保函类型选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectAssureType(){
		sParaString = "CodeNo"+",AssureType";		
		setObjectValue("SelectCode",sParaString,"@CheckGuarantyMan2@0@CheckGuarantyMan2Name@1",0,0,"");
	}

	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer(){
		//返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码、贷款卡编号
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
			//防止用户点开后，什么也不选择，直接取消，而锁住这几个区域
			sCertID = getItemValue(0,0,"CertID");
			if(typeof(sCertID) != "undefined" && sCertID != ""){
				setItemDisabled(0,0,"CertType",true);
				setItemDisabled(0,0,"CertID",true);
				setItemDisabled(0,0,"GuarantorName",true);
				selectCustMode = true;
				var certType = getItemValue(0,0,"CertType");
				 var temp = certType.substring(0,3);
		            if(temp=='Ent'){
		            	sLoanCard = getItemValue(0,0,"LoanCardNo");//贷款卡号
		            	setItemRequired(0,0,"LoanCardNo",true);
		            	setItemDisabled(0,0,"LoanCardNo",true);
		            }
		            else{
		            	sLoanCard ="";//贷款卡号
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

	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck(){
		sGuarantyType = getItemValue(0,0,"GuarantyType");//--担保类型		
		//如果担保类型为抵押、质押、保证、履约保险保证、保函保证、保证金时，需对录入的证件编号合法性进行验证
		if(sGuarantyType == '050' || sGuarantyType == '060' || sGuarantyType.substring(0,3) == '010'){
			//检查证件编号是否符合编码规则
			sCertType = getItemValue(0,0,"CertType");//--证件类型		
			sCertID = getItemValue(0,0,"CertID");//证件代码
			//校验担保人贷款卡编号
			sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//担保人贷款卡编号
			sCertID = getItemValue(0,getRow(),"CertID");//担保人证件号	
			if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" ){
				if(sLoanCard != sLoanCardNo || selectCustMode == false){
					//检验担保人贷款卡编号唯一性
					sGuarantorName = getItemValue(0,getRow(),"GuarantorName");//客户名称	
					sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sGuarantorName+","+sLoanCardNo);
					if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many"){
						alert(getBusinessMessage('419'));//该担保人的贷款卡编号已被其他客户占用！							
						return false;
					}
				}
				//机构号与贷款卡号的对应性校验。
				sReturn=RunMethod("PublicMethod","GetColValue","LoanCardNo,ENT_INFO,String@CorpID@"+sCertID);
				if(typeof(sReturn) != "undefined" && sReturn != "" ){
					sItems =sReturn.split('@');
					sReturn = sItems[1];
					if(sReturn != "" && sReturn !=sLoanCardNo){
						alert("所填贷款卡并非该客户的贷款卡!");//所填贷款卡并非该客户的贷款卡!		
						return false;
					}
				}
				
			}
			
			//检查输入的担保人是否建立信贷关系，如果未建立，需要新获取担保人的客户编号
			if(typeof(sCertType) != "undefined" && sCertType != "" 
				&& typeof(sCertID) != "undefined" && sCertID != ""){
				var sGuarantorID = PopPageAjax("/PublicInfo/CheckCustomerActionAjax.jsp?CertType="+sCertType+"&CertID="+sCertID,"","");
				if (typeof(sGuarantorID)=="undefined" || sGuarantorID.length==0) {
					return false;
				}
				setItemValue(0,0,"GuarantorID",sGuarantorID);
			}			
		}
		
		//如果担保类型为保证、履约保险保证、保函保证时，需对担保人进行合法性进行验证（保证人非业务申请人）jlwu@
		if(sGuarantyType == '010010' || sGuarantyType == '010020' || sGuarantyType == '010030'){
			sCustomerID = "<%=sCustomerID%>";//取得业务申请人的客户id
			sGuarantorID = getItemValue(0,getRow(),"GuarantorID");//保证人的客户id
			if(sCustomerID==sGuarantorID){
				alert(getBusinessMessage('502'));//该保证人不能为自己申请的业务进行保证！
				return false;
			}	
		}
		
		return true;
	}
	var sCertType="";
	/*~[Describe=根据证件类型和证件编号获得客户编号、客户名称和贷款卡编号;InputParam=无;OutPutParam=无;]~*/
	function getCustomerName(){
		sCertType   = getItemValue(0,getRow(),"CertType");
		var sCertID   = getItemValue(0,getRow(),"CertID");
		if(typeof(sCertType) != "undefined" && sCertType != "" && 
			typeof(sCertID) != "undefined" && sCertID != ""){
			//获得客户编号、客户名称和贷款卡编号
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
						//设置客户ID
						if(my_array2[n] == "customerid")
							setItemValue(0,getRow(),"GuarantorID",sReturnInfo[n+1]);
						//设置客户名称
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"GuarantorName",sReturnInfo[n+1]);
						//设置贷款卡编号
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