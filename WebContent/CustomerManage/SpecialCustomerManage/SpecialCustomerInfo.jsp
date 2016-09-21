<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	String listType = CurPage.getParameter("ListType");
	if(listType == null) listType = "";

	String sTempletNo = "SpecialCustInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	doTemp.setDefaultValue("LISTTYPE", listType);
	doTemp.setDefaultValue("INPUTUSERID", CurUser.getUserID());
	doTemp.setDefaultValue("USERName", CurUser.getUserName());
	doTemp.setDefaultValue("STATUS", "1");
	dwTemp.setParameter("SerialNo", serialNo);

	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"false","All","Button","提交","提交","submit()","","","",""},
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{"true","All","Button","返回","返回列表页面","goBack()","","","",""}
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script><script type="text/javascript">
	function submit(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(sSerialNo == ""){
			alert("请先保存，再进行提交！");
		}else{
			var todoType = "03"; //特殊客户新增
			var status = "01"; //待处理
			var serialNo = getItemValue(0,getRow(),"SerialNo");
			if(confirm('确实要提交到【待处理阶段】吗?')){			
				 var sReturn = CustomerManage.updatePhaseAction(todoType, status, serialNo);
				 if(sReturn == "SUCCEED"){
					 	alert("提交成功！");
					}else if(sReturn == "FAILED"){
						alert("该客户已在【待处理】阶段，无需再次提交！");
					}else{
						alert("提交失败！");
					}
				}
			}
	}
	
	
	function pageReload(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		OpenPage("/CustomerManage/SpecialCustomerManage/SpecialCustomerInfo.jsp?SerialNo="+sSerialNo,"_self","");
	}
	
	function goBack(){
		OpenPage("/CustomerManage/SpecialCustomerManage/SpecialCustomerListNew.jsp","_self","");
	}
	function selectCustomer1(){
		AsDialog.SetGridValue("SelectCustomerList1", "", "CUSTOMERID=CUSTOMERID@CUSTOMERNAME=CUSTOMERNAME@CERTTYPE=CERTTYPE@CERTID=CERTID", "", "","1");
	}
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{	
		//返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码
		sParaString = "UserID"+","+"<%=CurUser.getUserID()%>";		
		
		//实现清空功能:如是用户自己输入的信息时,只清空客户姓名,如是从系统里关联查询出来,则清空 证件类型、证件号码和客户姓名字段;实现字段关联显示功能。
		sStyle = "dialogWidth:700px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
		sObjectNoString = selectObjectValue("SelectCustomerList",sParaString,sStyle);
		sValueString = "@CustomerID@0@CustomerName@1@CertType@2@CertID@3";
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
	             setItemDisabled(0,0,"CustomerName",false);
	             setItemValue(0,getRow(),"CustomerName","");
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
		function initRow(){
			<% if(CurComp.getParameter("SerialNo") == null){%>
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"BEGINDATE","<%=StringFunction.getToday()%>");
		<% }else{%>
			setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
		<%}%>
			
		}
		initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
