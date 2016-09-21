<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 特殊客户管理页面
		Input Param:
		       --SerialNO:流水号
		Output param:
		History Log: 
		-- fbkang 重新整改页面

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "特殊客户管理页面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>

<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	
	//定义变量
	
		//获得页面参数	：黑名单流水号
    	String sSerialNo = CurPage.getParameter("SerialNo");
		String specialCustomerType = CurPage.getParameter("SpecialCustomerType");
		String infoTempletNo = CurPage.getParameter("DoInfoTemplet");
    	if(sSerialNo==null) sSerialNo="";
    	if(specialCustomerType==null) specialCustomerType="";
    	if(infoTempletNo==null) infoTempletNo="";
		// 通过DW模型产生ASDataObject对象doTemp
		ASObjectModel doTemp = new ASObjectModel(infoTempletNo,"");
		
		if(specialCustomerType==""){
			doTemp.setReadOnly("SpecialCustomerType", false);
		}
		
		ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
		dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写

		//使用配置模板前的“显示后缀”
		//doTemp.setUnit("CustomerName"," <input type=button value=.. onclick=parent.selectCustomer()>");
		//doTemp.setHTMLStyle("CertID"," onchange=parent.getCustomerName() ");
		
		//生成HTMLDataWindow
		dwTemp.genHTMLObjectWindow(sSerialNo);
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button","返回","返回列表页面","goBack()","","","",""}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
<%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
	
		if(bIsInsert){
			beforeInsert();
			//特殊增加,如果为新增保存,保存后页面刷新一下,防止主键被修改
			beforeUpdate();
			as_save("myiframe0","pageReload()");
			return;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
			OpenPage("/CustomerManage/SpecialCustomerManage/SpecialCustomerList.jsp?SpecialCustomerType="+"<%=specialCustomerType%>","_self","");
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=保存后进行页面刷新动作;InputParam=无;OutPutParam=无;]~*/
	function pageReload(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--重新获得流水号
		OpenPage("/CustomerManage/SpecialCustomerManage/SpecialCustInfo.jsp?SerialNo="+sSerialNo+"", "_self","");
	}
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
       initSerialNo();//初始化流水号字段
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer(){
		//返回、客户代码、客户名称、证件类型、证件号码
		if(sCertType!=""&&typeof(sCertType)!="undefined"){
			sParaString = "CertType,"+sCertType;
			setObjectValue("SelectOwner",sParaString,"@CustomerID@0@CustomerName@1@CertType@2@CertID@3",0,0);
		}else{
			sParaString = "CertType, ";
			setObjectValue("SelectOwner",sParaString,"@CustomerID@0@CustomerName@1@CertType@2@CertID@3",0,0);
		}
	}
	
	/*~[Describe=得到客户名字;InputParam=无;OutPutParam=无;]~*/
	var sCertType ="";
	function getCustomerName(){
		sCertType   = getItemValue(0,getRow(),"CertType");//--证件类型
		var sCertID   = getItemValue(0,getRow(),"CertID");//--证件号码
        //获得客户名称
        var sColName = "CustomerID@CustomerName";
		var sTableName = "CUSTOMER_INFO";
		var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
		if(typeof(sCertType) != "undefined" && sCertType != ""&&typeof(sCertID) != "undefined" && sCertID != ""){
			sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		}else return;
		if(typeof(sReturn) != "undefined" && sReturn != ""){
			sReturn = sReturn.split('~');
			var my_array1 = new Array();
			for(var i = 0;i < sReturn.length;i++){
				my_array1[i] = sReturn[i];
			}
			
			for(var j = 0;j < my_array1.length;j++){
				sReturnInfo = my_array1[j].split('@');	
				var my_array2 = new Array();
				for(var m = 0;m < sReturnInfo.length;m++){
					my_array2[m] = sReturnInfo[m];
				}
				
				for(var n = 0;n < my_array2.length;n++){
					//设置客户编号
					if(my_array2[n] == "customerid")
						setItemValue(0,getRow(),"CustomerID",sReturnInfo[n+1]);
					//设置客户名称
					if(my_array2[n] == "customername")
						setItemValue(0,getRow(),"CustomerName",sReturnInfo[n+1]);
				}
			}			
		} 
	}
	
	/*~[Describe=选择行业投向（国标行业类型）;InputParam=无;OutPutParam=无;]~*/
	function getIndustryType()
	{
		var sIndustryType = getItemValue(0,getRow(),"ATTRIBUTE1");
		//由于行业分类代码有几百项，分两步显示行业代码
		sIndustryTypeInfo = PopComp("IndustryVFrame","/Common/ToolsA/IndustryVFrame.jsp","IndustryType="+sIndustryType,"dialogWidth=650px;dialogHeight=500px;center:yes;status:no;statusbar:no","");
		//sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		//alert(sIndustryTypeInfo);
		if(sIndustryTypeInfo == "NO")
		{
			//alert(sIndustryTypeInfo);
			setItemValue(0,getRow(),"Direction","");
			setItemValue(0,getRow(),"DirectionName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			//alert(sIndustryTypeInfo);
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- 行业类型代码
			sIndustryTypeName = sIndustryTypeInfo[1];//--行业类型名称
		/* 	setItemValue(0,getRow(),"ATTRIBUTE1",sIndustryTypeValue.substr(0,1));
			setItemValue(0,getRow(),"ATTRIBUTE2",sIndustryTypeValue.substr(0,3));
			setItemValue(0,getRow(),"ATTRIBUTE3",sIndustryTypeValue.substr(0,4)); */
			setItemValue(0,getRow(),"ATTRIBUTE1",sIndustryTypeValue.substr(0,5));
			getIndustryTypeParentName(sIndustryTypeValue,sIndustryTypeName);//获取贷款投向的二级节点名称，并设置贷款投向
		}
	}
	//获取贷款投向的二级节点名称 
	function getIndustryTypeParentName(sIndustryTypeValue,sIndustryTypeName){
		//获取贷款投向的二级节点名称，并设置贷款投向
		var sTableName = "CODE_LIBRARY" ;
		var sColName = "ItemName";
		var sWhereClause = "ItemNo="+"'"+substring(sIndustryTypeValue,0,3)+"'";	
		var sIndustryTypeParentName = RunMethod("公用方法","GetColValue",sTableName + "," + sColName + "," + sWhereClause); 
		
		setItemValue(0,getRow(),"NAME1",sIndustryTypeParentName+" >> "+sIndustryTypeName);	
		
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			bIsInsert = true;
			setItemValue(0,0,"SpecialCustomerType","<%=specialCustomerType%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"OrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
	}
	
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "CUSTOMER_SPECIAL";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
       
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
