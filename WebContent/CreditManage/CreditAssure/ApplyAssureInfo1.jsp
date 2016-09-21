<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	/*
		Describe: 业务申请新增的担保信息详情（一个保证合同对应一个保证人）;
		Input Param:
			ObjectNo：对象编号（申请流水号）
			SerialNo：担保信息编号			
			GuarantyType：担保方式
		HistoryLog:lqjiang 2013-12-20 担保信息数据修改漏洞的修改，贷款卡编号校验的修改。
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
	
	//jqcao:2013-07-05 为解决其他页面已OpenPage方式引用该页面时，退回按钮直接关闭页面，不能返回。
	String sBackToClose = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BackToClose"));
	if(sBackToClose == null) sBackToClose = "";
	String sRightType =  CurComp.getParameter("RightType");

	//获取业务申请人
	String sSql = " select CustomerID from BUSINESS_APPLY where SerialNo=:SerialNo ";
	String sCustomerID = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
    //根据担保类型取得显示模版号
	sSql = " select ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyType' and ItemNo=:ItemNo";
	String sTempletNo = Sqlca.getString(new SqlObject(sSql).setParameter("ItemNo",sGuarantyType));
	//设置过滤条件
	String sTempletFilter = " (ColAttribute like '%BA%' ) ";
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//将"担保形式"设置默认值为"一般担保"
	doTemp.setDefaultValue("ContractType","010");
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
		{"ReadOnly".equals(sRightType)?"false":"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button",( sBackToClose.equals("true") )? "关闭":"返回","返回列表页面","goBack()","","","",""}
		};
	
	if( sBackToClose.equals( "true" ) ){
		sButtons[0][0] = "false";
	}
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
    var isSelect=false;//判断客户是从信贷系统中选的还是自己输入的
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		var sCertType = getItemValue(0,0,"CertType");
		var sCertID = getItemValue(0,0,"CertID");
		var GuarantorName = getItemValue(0,0,"GuarantorName");
		//录入数据有效性检查
		if (!ValidityCheck()) return;
		if(bIsInsert){		
			beforeInsert();
		}

		beforeUpdate();
		
// 		changeLoanCardNoProperty(certType);
		
		/*
		Author: lqjiang 2013-12-20
		Describe: 判断是否需要只读,控制只读性
	    */
		if(typeof(sCertType) != "undefined" && sCertType != "" && 
		typeof(sCertID) != "undefined" && sCertID != ""&& 
		typeof(GuarantorName) != "undefined" && GuarantorName != ""){
	        if(isSelect){
				setItemDisabled(0,0,"CertType",true);
		        setItemDisabled(0,0,"CertID",true);
		        setItemDisabled(0,0,"GuarantorName",true);
	        	setItemDisabled(0,0,"LoanCardNo",true);
	        }
	        
			var temp =getItemValue(0,0,"CertType").substring(0,3);
            if(temp=='Ent'){
            	setItemRequired(0,0,"LoanCardNo",true);
            	var sloancardno=getItemValue(0,0,"LoanCardNo");
            	if(sloancardno==null||sloancardno=='undefined'||sloancardno==''&&isSelect){
            		alert("请到客户信息中完善贷款卡编号！");
            		return;
            	} 
            }else{
            	setItemValue(0,getRow(),"LoanCardNo","");  
            	setItemRequired(0,0,"LoanCardNo",false);
            }
		}
		
		as_save("myiframe0",sPostEvents);
 		changeLoanCardNoProperty(sCertType);  //保存后页面显示正确
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
		var BackFlag = "<%=sBackToClose%>";
		if( BackFlag == "true" ){
			self.close();
			return;
		}
		OpenPage("/CreditManage/CreditAssure/ApplyAssureList1.jsp","_self","");
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
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ContractStatus","010");//未签担保合同
			setItemValue(0,0,"GuarantyCurrency","01");
			bIsInsert = true;
		}else{
            setItemDisabled(0,0,"CertType",true);
            setItemDisabled(0,0,"CertID",true);
            setItemDisabled(0,0,"GuarantorName",true);
            sLoanCardNo = getItemValue(0,0,"LoanCardNo");
            //判断贷款卡号是否有值
            if(sLoanCardNo!= 'null' || sLoanCardNo!= ''){
            	setItemDisabled(0,0,"LoanCardNo",true);
            }
           // setItemDisabled(0,0,"LoanCardNo",true);
            var temp =getItemValue(0,0,"CertType").substring(0,3);
            if(temp=='Ent'){
            	setItemRequired(0,0,"LoanCardNo",true);
            }
            else{
            	setItemValue(0,getRow(),"LoanCardNo","");  
            	setItemRequired(0,0,"LoanCardNo",false);
            }
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
		sGuarantyType = getItemValue(0,0,"GuarantyType");//--担保类型
		var sReturn = "";
		if(sCertType!=''&&typeof(sCertType)!='undefined'){
			sParaString = "CertType,"+sCertType;
			sReturn = setObjectValue("SelectOwner",sParaString,"@GuarantorID@0@GuarantorName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");			
		}
		else{
			sParaString = "CertType, ";
			sReturn = setObjectValue("SelectOwner",sParaString,"@GuarantorID@0@GuarantorName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");
		}
		if(typeof(sReturn)=="undefined" || sReturn.length==0) return;
		//增加对CertType、CertID、GuarantorName和LoanCardNo的显示控制  add by zhuang 2010-04-01
		var sCertID = getItemValue(0,0,"CertID");
		if( String(sReturn)==String("_CLEAR_")||String(sReturn)=="undefined"  ){
            /* setItemDisabled(0,0,"CertType",false);
            setItemDisabled(0,0,"CertID",false);
            setItemDisabled(0,0,"GuarantorName",false);
            setItemDisabled(0,0,"LoanCardNo",false); */
            
            setItemDisabled(0,0,"CertType",false);
            setItemDisabled(0,0,"CertID",false);
            setItemDisabled(0,0,"GuarantorName",false);
            setItemDisabled(0,0,"LoanCardNo",false);
            isSelect=false;
		}else if( String(sReturn)!=String("_CLEAR_") && typeof(sCertID) != "undefined" && sCertID != "" ){
			isSelect=true;
            setItemDisabled(0,0,"CertType",true);
            setItemDisabled(0,0,"CertID",true);
            setItemDisabled(0,0,"GuarantorName",true);
            setItemDisabled(0,0,"LoanCardNo",true);
    		var certType = getItemValue(0,0,"CertType");
            var temp = certType.substring(0,3);
            if(temp=='Ent'){
            	setItemDisabled(0,0,"LoanCardNo",true);
            	setItemRequired(0,0,"LoanCardNo",true);
            }
           else{
            	setItemValue(0,getRow(),"LoanCardNo","");  
            	setItemRequired(0,0,"LoanCardNo",false);
             	setItemDisabled(0,0,"LoanCardNo",false);
            }
            sCertType ="";
        }
	}
	
	/*~[Describe=贷款卡号属性设置;InputParam=证件类型;OutPutParam=;]~*/
	function changeLoanCardNoProperty(certType){  //added by yzheng
// 		alert(certType);
		if(certType.indexOf("Ind") != -1){  //个人
        	setItemValue(0,getRow(),"LoanCardNo","");  //如果有误填数据,清除
        	setItemRequired(0,0,"LoanCardNo",false);
        	setItemReadOnly(0,0,"LoanCardNo",true);
		}
        else{  //公司
        	setItemRequired(0,0,"LoanCardNo",true);
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
			if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" ){
				//addded by lqjjiang 校验贷款卡编号的正确性
				s=CheckLoanCardID(sLoanCardNo);
				if(s==false){
					alert("贷款卡编号有误！");//该担保人的贷款卡编号已被其他客户占用！							
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
			&& typeof(sCertID) != "undefined" && sCertID != "")
			{
				var sGuarantorID = PopPageAjax("/PublicInfo/CheckCustomerActionAjax.jsp?CertType="+sCertType+"&CertID="+sCertID,"","");
				if (typeof(sGuarantorID)=="undefined" || sGuarantorID.length==0) {
					return false;
				}
				setItemValue(0,0,"GuarantorID",sGuarantorID);
			}			
		}
		
		//如果担保类型为保证、履约保险保证、保函保证时，需对担保人进行合法性进行验证（保证人非业务申请人）
		if(sGuarantyType == '010010' || sGuarantyType == '010020' || sGuarantyType.substring(0,3) == '010030'){
			sSerialNo = getItemValue(0,getRow(),"SerialNo");//担保信息流水号
			sCustomerID = "<%=sCustomerID%>";	
			sReturn=RunJavaMethodTrans("com.amarsoft.app.bizmethod.BusinessManage","checkGuaranrtyContract","paras=SerialNo@@"+sSerialNo+"@~@CustomerID=@@"+sCustomerID);
 			if(typeof(sReturn) != "undefined" && sReturn != "" && parseInt(sReturn) > 0){
				alert(getBusinessMessage('502'));//该保证人不能为自己申请的业务进行保证！
				return false;
			}		
		}
		var guarantorID=getItemValue(0,0,"GuarantorID");
		var guarantyType=getItemValue(0,0,"GuarantyType");
		//不允许为自己保证担保
		if( guarantyType== "010010"){
			if("<%= sCustomerID %>" == guarantorID){
				alert("不能为自己做保证担保，请检查输入！");
				return false;
			}
		}
		return true;
	}

	/*~[Describe=根据证件类型和证件编号获得客户编号、客户名称和贷款卡编号;InputParam=无;OutPutParam=无;]~*/
	var sCertType="";
	function getCustomerName(){
		sCertType   = getItemValue(0,getRow(),"CertType");
		var sCertID   = getItemValue(0,getRow(),"CertID");
		changeLoanCardNoProperty(sCertType);

		if(typeof(sCertType) != "undefined" && sCertType != "" && 
			typeof(sCertID) != "undefined" && sCertID != ""){
			//获得客户编号、客户名称和贷款卡编号
	        var sColName = "CustomerID@CustomerName@LoanCardNo";
			var sTableName = "CUSTOMER_INFO";
			var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
			
			sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.GetColValue","getColValue","colName="+sColName+",tableName="+sTableName+",whereClause="+sWhereClause);
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
						if(my_array2[n] == "customername"){	
						 setItemValue(0,getRow(),"GuarantorName",sReturnInfo[n+1]);
						 setItemReadOnly(0,0,"GuarantorName",true);//added by lqjiang
						 setItemReadOnly(0,0,"LoanCardNo",false);//added by lqjiang
						}	
						
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
				setItemReadOnly(0,0,"LoanCardNo",false);//added by lqjiang
				setItemReadOnly(0,0,"GuarantorName",false);//added by lqjiang
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