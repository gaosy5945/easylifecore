<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sSerialNo = CurPage.getParameter("SerialNo");
	if(sSerialNo == null) sSerialNo = ""; 
 	String sCustomerID = CurPage.getParameter("CustomerID");
	if(sCustomerID == null) sCustomerID = ""; 
	String sCustomerType = CurPage.getParameter("CustomerType");
	if(sCustomerType == null) sCustomerType = ""; 
	String sRelationShipFlag = CurPage.getParameter("RelationShipFlag");
	if(sRelationShipFlag == null) sRelationShipFlag = ""; 
	String sRelativeCustomerID = CurPage.getParameter("RelativeCustomerID");
	if(sRelativeCustomerID == null) sRelativeCustomerID = "";
	String sRelationShip = CurPage.getParameter("RelationShip");
	if(sRelationShip == null) sRelationShip = "";
	String sMarriage = "";
	String sTempletNo = "EntCustomerRelativeInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);	

		//设置下拉框
		if(("1001".equals(sRelationShipFlag))){//企业客户中的法人代表下拉框
		    doTemp.setReadOnly("RELATIONSHIP", true);
		    doTemp.setDefaultValue("RELATIONSHIP", "1001");
		}else if(("03".equals(sCustomerType))&&("".equals(sRelationShipFlag))){//个人客户中关联人下拉框
	 	 	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select Marriage from IND_INFO where CustomerID=:CustomerID ").setParameter("CustomerID",sCustomerID));
			while(rs.next()){
				sMarriage = rs.getString("Marriage");
			} 
			if("10".equals(sMarriage)){
				doTemp.setDDDWJbo("RelationShip","jbo.sys.CODE_LIBRARY,itemNo,ItemName,codeno = 'CustomerRelationShip' and ItemNo like '20%' and IsInUse = '1' and ItemNo not in ('2000','2007','2001','2002') ");
			}else{
				doTemp.setDDDWJbo("RelationShip","jbo.sys.CODE_LIBRARY,itemNo,ItemName,codeno = 'CustomerRelationShip' and ItemNo in ('2007','2001','2003','2005') and IsInUse = '1' ");
			}
			rs.getStatement().close();
			doTemp.setDDDWJbo("CERTTYPE","jbo.sys.CODE_LIBRARY,itemNo,ItemName,codeno = 'CustomerCertType' and ItemNo like '1%' and IsInUse = '1' ");
		}else{//个人客户中关联企业下拉框
			//doTemp.setDDDWJbo("RelationShip","jbo.sys.CODE_LIBRARY,itemNo,ItemName,codeno = 'CustomerRelationShip' and ((ItemNo like '30%' and ItemNo <> '3000') or ItemNo = '9999') and IsInUse = '1' ");
			doTemp.setDefaultValue("RelationShip", "1023");
			doTemp.setReadOnly("RelationShip", true);
			doTemp.setDDDWJbo("CERTTYPE","jbo.sys.CODE_LIBRARY,itemNo,ItemName,codeno = 'CustomerCertType' and ItemNo like '2%' and ItemNo <> '2' and IsInUse = '1' ");
		}
		//若关联客户编号为空，则出现选择客户提示框
		if(sRelativeCustomerID == null || sRelativeCustomerID.equals(""))
		{
			doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
		} else {
			doTemp.setReadOnly("CustomerName,CertType,CertID,RelationShip",true);
		}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	doTemp.setDefaultValue("INPUTORGName", CurOrg.getOrgName());
	doTemp.setDefaultValue("INPUTUSERName", CurUser.getUserName());
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sSerialNo);
	String sButtons[][] = {
			{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
			{"true","","Button","返回","返回列表页面","goBack()","","","",""},
			};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<HEAD>
<title>关联企业信息</title>
</HEAD>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
var bIsInsert = false; //标记DW是否处于“新增状态”
var isSuccess=false;//标记保存成功
//---------------------定义按钮事件------------------------------------

/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(){	
		var CertIDTemp = getItemValue(0,0,"CertID");
		var CertID = CertIDTemp.replace(/\s+/g,"");
		var CertType = getItemValue(0,0,"CertType");
		if(!iV_all("0")) return ;
			var sResult = CustomerManage.judgeIsExists(CertID, CertType);
			sResult=sResult.split("@");
			if(sResult[0] == "No"){//如果关联客户在本行为一个新客户时，新增该客户，并将其于本客户关联
				AddCustomerInfo();
				importRelativeCustomer(); //互关联
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
					importRelativeCustomer();
				}
			}
		}
	function importRelativeCustomer(){
		var relativeCustomerid = getItemValue(0,0,"RELATIVECUSTOMERID");
		var RelationShip = getItemValue(0,0,"RelationShip");
		CustomerManage.importRelationShip("<%=sCustomerID%>",relativeCustomerid,RelationShip,"<%=CurOrg.getOrgID()%>","<%=CurUser.getUserID()%>","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
	}
	function AddCustomerInfo(){
		if (!RelativeCheck()) return;
		var customerName = getItemValue(0,getRow(0),"RelativeCustomerName");
		var certType = getItemValue(0,getRow(0),"CertType");
		var certID = getItemValue(0,getRow(0),"CertID");
		var issueCountry = getItemValue(0,getRow(0),"IssueCountry");
		var customerType = "<%=sCustomerType%>";
		var inputOrgID = "<%=CurOrg.getOrgID()%>";
		var inputUserID = "<%=CurUser.getUserID()%>";
		var inputDate = "<%=StringFunction.getToday()%>";
		var sReturn = CustomerManage.checkCustomer(certID, customerName, customerType, certType);
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
		 	}else if(temp[0] == "CBEmpty"){
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
/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
function goBack()
{
	top.close();
}

</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
<script type="text/javascript">
	var flag = false;//判断客户信息的输入是用户输入(false)还是从系统中选择(true)

	/*~[Describe=保存后进行页面刷新动作;InputParam=无;OutPutParam=无;]~*/
	function pageReload()
	{
		var sRelativeID   = getItemValue(0,getRow(),"RelativeCustomerID");
		var sRelationShip = getItemValue(0,getRow(),"RelationShip");
		OpenPage("/CustomerManage/MyCustomer/IndCustomer/IndCustomerRelativeInfo.jsp?RelativeCustomerID="+sRelativeID+"&RelationShip="+sRelationShip, "_self","");
	}
	function selectCustomer1(){
		AsDialog.SetGridValue("SelectRelativeEntCustomer", "<%=CurUser.getUserID()%>", "RELATIVECUSTOMERNAME=CUSTOMERNAME@CertType=CERTTYPE@CertID=CERTID@@IssueCountry=ISSUECOUNTRY", "");
		var certID = getItemValue(0,0,"CertID");
		if(certID != ""){
			temp = "2";
		}
	}
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{	//取客户类型的前两位，然后通过数据库查询客户类型前两位符合的客户
		var customerType = "<%=sCustomerType%>";
		var sCustomerType = customerType.substring(0, 2);
		//返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码
		sParaString = "CustomerType"+","+sCustomerType+","+"UserID"+","+"<%=CurUser.getUserID()%>";		
		//sReturn = setObjectValue("SelectManager",sParaString,"@RelativeID@0@CustomerName@1@CertType@2@CertID@3",0,0,"");
		
		//实现清空功能:如是用户自己输入的信息时,只清空客户姓名,如是从系统里关联查询出来,则清空 证件类型、证件号码和客户姓名字段;实现字段关联显示功能。add by zhuang 2010-03-30
		sStyle = "dialogWidth:700px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
		sObjectNoString = selectObjectValue("SelectManager",sParaString,sStyle);
		sValueString = "@RelativeCustomerID@0@RelativeCustomerName@1@CertType@2@CertID@3@IssueCountry@4@IssueCountryName@5";
		sValues = sValueString.split("@");
	
		var i=sValues.length;
	    i=i-1;
	    if (i%2!=0){
	    	alert("setObjectValue()返回参数设定有误!\r\n格式为:@ID列名@ID在返回串中的位置...");
	        return;
	    }else{   
	        var j=i/2,m,sColumn,iID;    
	        if(typeof(sObjectNoString)=="undefined"){
	            return; 
	        }else if(String(sObjectNoString)==String("_CANCEL_") ){
	            return;
	        }else if(String(sObjectNoString)==String("_CLEAR_")){
	        	 setItemDisabled(0,0,"CertType",false);
	             setItemDisabled(0,0,"CertId",false);
	             setItemDisabled(0,0,"RelativeCustomerName",false);
	             setItemValue(0,getRow(),"RelativeCustomerName","");
	             if(flag){
	            	 setItemValue(0,getRow(),"CertType","");
	            	 setItemValue(0,getRow(),"CertID","");
	             }
	             flag = false;
	        }else if(String(sObjectNoString)!=String("_NONE_") && String(sObjectNoString)!=String("undefined")){
	            sObjectNos = sObjectNoString.split("@");
	            for(m=1;m<=j;m++){
	                sColumn = sValues[2*m-1];
	                iID = parseInt(sValues[2*m],10);
	                if(sColumn!=""){
	                	setItemValue(0,0,sColumn,sObjectNos[iID]);
	                }
	                    
	            }  
	            temp = "2";
	            flag = true;
	        }
	    }
	}
	
	/*~[Describe=根据证件类型和证件编号获得客户编号和客户名称;InputParam=无;OutPutParam=无;]~*/
	function getCustomerName()
	{
		var sCertType = getItemValue(0,getRow(),"CertType");//--证件类型
		var sCertID = getItemValue(0,getRow(),"CertID");//--证件号码
	    
	    if(typeof(sCertType) != "undefined" && sCertType != "" && 
		typeof(sCertID) != "undefined" && sCertID != "")
		{
	        //获得客户名称
	        var sColName = "CustomerId@CustomerName";
			var sTableName = "CUSTOMER_INFO";
			var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
			
			sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{			
				sReturn = sReturn.split('~');
				var my_array1 = new Array();
				for(i = 0;i < sReturn.length;i++)
				{
					my_array1[i] = sReturn[i];
				}
				
				for(j = 0;j < my_array1.length;j++)
				{
					sReturnInfo = my_array1[j].split('@');	
					var my_array2 = new Array();
					for(m = 0;m < sReturnInfo.length;m++)
					{
						my_array2[m] = sReturnInfo[m];
					}
					
					for(n = 0;n < my_array2.length;n++)
					{									
						//设置客户编号
						if(my_array2[n] == "customerid")
							setItemValue(0,getRow(),"RelativeCustomerID",sReturnInfo[n+1]);
						//设置客户名称
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"RelativeCustomerName",sReturnInfo[n+1]);
					}
				}			
			}else
			{
				setItemValue(0,getRow(),"RelativeCustomerID","");
				setItemValue(0,getRow(),"RelativeCustomerName","");								
			} 
		}				     
	}
	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段
		/* bIsInsert = false; */
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
	}
	
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{	
		var sSerialNo = "<%=sSerialNo%>";//--证件类型
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){//如当前无记录，则新增一条
			setItemValue(0,0,"CUSTOMERID","<%=sCustomerID%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			//as_add("myiframe0");//新增记录 
			bIsInsert = true;
		}else{
			setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
		}
	}
	
	/*~[Describe=关联关系插入前检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function RelativeCheck()
	{
		sCustomerID   = getItemValue(0,0,"CustomerID");	//客户编号
		sCertType = getItemValue(0,0,"CertType");//证件类型	
		sCertID = getItemValue(0,0,"CertID");//证件编号	
		sRelationShip = getItemValue(0,0,"RelationShip");//关联关系
		
		if (typeof(sRelationShip) != "undefined" && sRelationShip != "")
		{
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
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "CUSTOMER_RELATIVE";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
       
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	

</script>
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	initRow();
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>
