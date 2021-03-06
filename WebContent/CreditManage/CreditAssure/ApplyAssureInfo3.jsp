<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	/*
		Describe: 业务申请新增的担保信息详情（一个保证合同对应多个保证人）;
		Input Param:
			ObjectNo：对象编号（申请流水号）
			SerialNo：担保信息编号			
			GuarantyType：担保方式
	 */
	String PG_TITLE = "担保详情信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数：对象编号
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	//获得页面参数：担保方式、担保信息编号
    String sGuarantyType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyType"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	//将空值转化为空字符串
	if(sGuarantyType == null) sGuarantyType = "";
	if(sSerialNo == null) sSerialNo = "";

	String sSql = " select CustomerID from BUSINESS_APPLY where SerialNo=:SerialNo ";
	String sCustomerID = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
    //根据担保类型取得显示模版号
	sSql = " select ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyType' and ItemNo=:ItemNo";
	String sTempletNo = Sqlca.getString(new SqlObject(sSql).setParameter("ItemNo",sGuarantyType));
	//设置过滤条件
	String sTempletFilter = " (ColAttribute like '%BA%' ) ";
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	if(sGuarantyType.substring(0,3).equals("010")){
		//设置字段不可见
		doTemp.setVisible("CertType,CertID,GuarantorName,LoanCardNo",false);
		if(sGuarantyType.equals("010020")) //履约保险保证
			doTemp.setVisible("CreditOrgName,GuarantyInfo",false);
		if(sGuarantyType.equals("010030")) //保函保证
			doTemp.setVisible("CreditOrgName,OtherName",false);

		//设置字段非必输
		doTemp.setRequired("CertType,CertID,GuarantorName,LoanCardNo",false);
		if(sGuarantyType.equals("010020")) //履约保险保证
			doTemp.setRequired("CreditOrgName,GuarantyInfo",false);
		if(sGuarantyType.equals("010030")) //保函保证
			doTemp.setRequired("CreditOrgName,OtherName",false);
	}
	
	if(sGuarantyType.equals("050") || sGuarantyType.equals("060")){
		//设置权利人选择框
		doTemp.setUnit("CertID"," <input type=button value=.. onclick=parent.selectCustomer()><font color=red>(存在的客户请选择,否则请输入)</font>");
		doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
		doTemp.setHTMLStyle("GuarantorName"," style={width:400px} ");
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//设置setEvent	
	dwTemp.setEvent("AfterInsert","!BusinessManage.InsertRelative("+sObjectNo+",GuarantyContract,#SerialNo,APPLY_RELATIVE)+!CustomerManage.AddCustomerInfo(#GuarantorID,#GuarantorName,#CertType,#CertID,#LoanCardNo,#InputUserID)");
	dwTemp.setEvent("AfterUpdate","!CustomerManage.AddCustomerInfo(#GuarantorID,#GuarantorName,#CertType,#CertID,#LoanCardNo,#InputUserID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button","返回","返回列表页面","goBack()","","","",""}
	};
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
		OpenPage("/CreditManage/CreditAssure/ApplyAssureList3.jsp","_self","");
	}
	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		initSerialNo();//初始化流水号字段
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0) == 0){
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"GuarantyType","<%=sGuarantyType%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ContractStatus","010");//未签担保合同
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
	
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer(){
		//返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码、贷款卡编号	
		var sReturn = "";
		if(sCertType!=''&&typeof(sCertType)!='undefined'){
			sParaString = "CertType,"+sCertType;
			sReturn = setObjectValue("SelectOwner",sParaString,"@GuarantorID@0@GuarantorName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");			
		}else{
			sParaString = "CertType, ";
			sReturn = setObjectValue("SelectOwner",sParaString,"@GuarantorID@0@GuarantorName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");
		}	
		var sCertID = getItemValue(0,0,"CertID");
		if( String(sReturn)==String("_CLEAR_") ){
            setItemDisabled(0,0,"CertType",false);
            setItemDisabled(0,0,"CertID",false);
            setItemDisabled(0,0,"GuarantorName",false);
            setItemDisabled(0,0,"LoanCardNo",false);
		}else if( String(sReturn)!=String("_CLEAR_") && typeof(sCertID) != "undefined" && sCertID != "" ){
            setItemDisabled(0,0,"CertType",true);
            setItemDisabled(0,0,"CertID",true);
            setItemDisabled(0,0,"GuarantorName",true);
            var certType = getItemValue(0,0,"CertType");
            var temp = certType.substring(0,3);
            if(temp=='Ent'){
            	setItemRequired(0,0,"LoanCardNo",true);
            	 setItemDisabled(0,0,"LoanCardNo",true);
            }
            else{
            	setItemRequired(0,0,"LoanCardNo",false);
            	 setItemDisabled(0,0,"LoanCardNo",false);
            }
            sCertType="";
        }
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck(){
		sGuarantyType = getItemValue(0,0,"GuarantyType");//--担保类型		
		//如果担保类型为抵押、质押时，需对录入的证件编号合法性进行验证
		if(sGuarantyType == '050' || sGuarantyType == '060'){
			//检查证件编号是否符合编码规则
			sCertType = getItemValue(0,0,"CertType");//--证件类型		
			sCertID = getItemValue(0,0,"CertID");//证件代码
			if(typeof(sCertType) != "undefined" && sCertType != "" ){
				//判断组织机构代码合法性
				if(sCertType =='Ent01'){
					if(typeof(sCertID) != "undefined" && sCertID != "" ){
						if(!CheckORG(sCertID)){
							alert(getBusinessMessage('102'));//组织机构代码有误！						
							return false;
						}
					}
				}
					
				//判断身份证合法性,个人身份证号码应该是15或18位！
				if(sCertType =='Ind01' || sCertType =='Ind08'){
					if(typeof(sCertID) != "undefined" && sCertID != "" ){
						if (!CheckLisince(sCertID)){
							alert(getBusinessMessage('156'));//身份证号码有误！				
							return false;
						}
					}
				}
			}
			
			//校验担保人贷款卡编号
			sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//担保人贷款卡编号	
			if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" ){
				if(!CheckLoanCardID(sLoanCardNo)){
					alert(getBusinessMessage('414'));//担保人的贷款卡编号有误！							
					return false;
				}	
				
				//检验担保人贷款卡编号唯一性
				sGuarantorName = getItemValue(0,getRow(),"GuarantorName");//客户名称	
				sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CheckLoanCardNo","run","CustomerID="+sGuarantorName+",LoanCardNo="+sLoanCardNo);

				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many"){
					alert(getBusinessMessage('419'));//该担保人的贷款卡编号已被其他客户占用！							
					return false;
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
		return true;
	}

	/*~[Describe=根据证件类型和证件编号获得客户编号、客户名称和贷款卡编号;InputParam=无;OutPutParam=无;]~*/
	var sCertType="";
	function getCustomerName(){
		sCertType   = getItemValue(0,getRow(),"CertType");
		var sCertID   = getItemValue(0,getRow(),"CertID");
		if(typeof(sCertType) != "undefined" && sCertType != "" && 
			typeof(sCertID) != "undefined" && sCertID != ""){
			//获得客户编号、客户名称和贷款卡编号
	        var sColName = "CustomerID@CustomerName@LoanCardNo";
			var sTableName = "CUSTOMER_INFO";
			var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
			
			sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.GetColValue","getColValue","colName="+sColName",tableName="+sTableName+",whereClause="+sWhereClause);

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
							setItemValue(0,getRow(),"GuarantyID",sReturnInfo[n+1]);
						//设置客户名称
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"GuarantyName",sReturnInfo[n+1]);
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
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@ include file="/IncludeEnd.jsp"%>