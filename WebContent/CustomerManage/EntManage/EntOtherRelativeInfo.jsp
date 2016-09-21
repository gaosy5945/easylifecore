<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "其他关联方信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数，客户代码
	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	
	//获得页面参数，关联客户代码、关联关系、编辑权限
	String sRelativeID    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeID"));
	String sRelationShip  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelationShip"));
	String sEditRight  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if(sRelativeID == null) sRelativeID = "";
	if(sRelationShip == null) sRelationShip = "";
	if(sEditRight == null) sEditRight = "";

	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "EntOtherRelativeInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if(sRelativeID == null || sRelativeID.equals("")){
		doTemp.setUnit("CustomerName"," <input type=button class=inputdate value=.. onclick=parent.selectCustomer()><font color=red>(可输可选)</font>");
		doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
	} else {
		doTemp.setReadOnly("CustomerName,CertType,CertID,RelationShip",true);
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";		// 设置DW风格 1:Grid 2:Freeform
	if(sEditRight.equals("01")){
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	
	//设置插入和更新事件，反方向插入和更新
	dwTemp.setEvent("AfterInsert","!CustomerManage.AddRelation(#CustomerID,#RelativeID,#RelationShip)+!CustomerManage.AddCustomerInfo(#RelativeID,#CustomerName,#CertType,#CertID,#LoanCardNo,#InputUserID,#CustomerType)");
	dwTemp.setEvent("AfterUpdate","!CustomerManage.UpdateRelation(#CustomerID,#RelativeID,#RelationShip)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sRelativeID+","+sRelationShip);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{(sEditRight.equals("02")?"true":"false"),"All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{(sEditRight.equals("02")?"true":"false"),"All","Button","保存并新增","保存所有修改并新增","saveAndNewRecord()","","","",""},
		{"true","","Button","返回","返回列表页面","goBack()","","","",""}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	var isSuccess=false;//标记保存成功
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		//录入数据有效性检查
		if (!ValidityCheck()) return;	
		if(bIsInsert){
			//保存前进行检查,检查通过后继续保存,否则给出提示
			if (!RelativeCheck()) return;
			beforeInsert();
			//特殊增加,如果为新增保存,保存后页面刷新一下,防止主键被修改
			beforeUpdate();
			as_save("myiframe0","pageReload()");
			return;
		}

		beforeUpdate();
		as_save("myiframe0","saveSuccess()");
	}

	function saveSuccess(){
		isSuccess=true;
	}
	
	function saveAndNewRecord(){
		saveRecord();
		if(isSuccess){
			OpenPage("/CustomerManage/EntManage/EntOtherRelativeInfo.jsp?EditRight=02","_self","");
		}
		
	}
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
		OpenPage("/CustomerManage/EntManage/EntOtherRelativeList.jsp","_self","");
	}

	/*~[Describe=保存后进行页面刷新动作;InputParam=无;OutPutParam=无;]~*/
	function pageReload(){
		var sRelativeID   = getItemValue(0,getRow(),"RelativeID");//--关联客户代码
		var sRelationShip   = getItemValue(0,getRow(),"RelationShip");//--关联关系
		OpenPage("/CustomerManage/EntManage/EntOtherRelativeInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip+"&EditRight=<%=sEditRight%>", "_self","");
	}

	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer(){
		//返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码、贷款卡编号		
		sReturn = setObjectValue("SelectInvest","","@RelativeID@0@CustomerName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");
		if(sReturn == "_CLEAR_"){
			setItemDisabled(0,0,"CertType",false);
			setItemDisabled(0,0,"CertID",false);
			setItemDisabled(0,0,"CustomerName",false);
		}else{
			//防止用户点开后，什么也不选择，直接取消，而锁住这几个区域
			sCertID = getItemValue(0,0,"CertID");
			if(typeof(sCertID) != "undefined" && sCertID != ""){
				setItemDisabled(0,0,"CertType",true);
				setItemDisabled(0,0,"CertID",true);
				setItemDisabled(0,0,"CustomerName",true);
				setItemDisabled(0,0,"CustomerType",true);  //added by yzheng
			}else{
				setItemDisabled(0,0,"CertType",false);
				setItemDisabled(0,0,"CertID",false);
				setItemDisabled(0,0,"CustomerName",false);
			}
		}
	}

	/*~[Describe=根据证件类型和证件编号获得客户编号和客户名称;InputParam=无;OutPutParam=无;]~*/
	function getCustomerName(){
		var sCertType   = getItemValue(0,getRow(),"CertType");//--证件类型
		var sCertID   = getItemValue(0,getRow(),"CertID");//--证件号码
        if(typeof(sCertType) != "undefined" && sCertType != "" && 
			typeof(sCertID) != "undefined" && sCertID != ""){
	        //获得客户名称
	        var sColName = "CustomerID@CustomerName@LoanCardNo";
			var sTableName = "CUSTOMER_INFO";
			var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
			
			sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.GetColValue","getColValue","colName="+sColName + ",tableName" + sTableName + ",whereClause" + sWhereClause);
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
							setItemValue(0,getRow(),"RelativeID",sReturnInfo[n+1]);
						//设置客户名称
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"CustomerName",sReturnInfo[n+1]);
						//设置贷款卡编号
						if(my_array2[n] == "loancardno") 
						{
							if(sReturnInfo[n+1] != 'null')
								setItemValue(0,getRow(),"LoanCardNo",sReturnInfo[n+1]);
							else
								setItemValue(0,getRow(),"LoanCardNo","");
						}
					}
				}			
			}else{
				setItemValue(0,getRow(),"RelativeID","");
				setItemValue(0,getRow(),"CustomerName","");	
				setItemValue(0,getRow(),"LoanCardNo","");			
			}  
		}
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"Remark","从供货质量(销售)价格、价格稳定性、付款条件等方面对供应商进行描述：");
			setItemValue(0,0,"CurrencyType","01");
		}
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck(){
		//检验关联方贷款卡编号唯一性
		sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//关联方贷款卡编号	
		if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" ){
			sCustomerName = getItemValue(0,getRow(),"CustomerName");//关联方名称	
			sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CheckLoanCardNo","checkLoanCardNo","customerName="sCustomerName+",loanCardNo="+sLoanCardNo);
			if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") {
				alert(getBusinessMessage('234'));//该关联方贷款卡编号已被其他客户占用！							
				return false;
			}						
		}
		
		//检查录入的客户是否为其本身
		sCustomerID   = getItemValue(0,0,"CustomerID");	//客户编号
		sRelativeID   = getItemValue(0,0,"RelativeID");//--关联客户代码
		if (typeof(sRelativeID) != "undefined" && sRelativeID != ''){
			if(sCustomerID == sRelativeID){
				alert(getBusinessMessage('141'));//录入的客户不能为其本身！
				return false;
			}
		}		
		
		return true;	
	}

	/*~[Describe=关联关系插入前检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function RelativeCheck(){
		sCustomerID   = getItemValue(0,0,"CustomerID");//--客户代码				
		sCertType = getItemValue(0,0,"CertType");//--证件类型		
		sCertID = getItemValue(0,0,"CertID");//--证件号码		
		sRelationShip = getItemValue(0,0,"RelationShip");//--关联关系
		if (typeof(sRelationShip)!="undefined" && sRelationShip!=0){
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
				setItemValue(0,0,"RelativeID",info);
			}
		}
		return true;
	}

	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@	include file="/IncludeEnd.jsp"%>