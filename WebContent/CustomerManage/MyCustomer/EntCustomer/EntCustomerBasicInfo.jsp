<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	String customerType = CurPage.getParameter("CustomerType");
	if(customerType == null) customerType = "";
	String sTempletNo =null;
	
	String listType =  CurPage.getParameter("ListType");
	boolean isRetailCustomer = false;//是否是商户门店。商户门店单独使用一套模板
	if(!StringX.isEmpty(listType) && (listType.equals("0020") || listType.equals("0021"))){
		isRetailCustomer = true;
	}
	if(isRetailCustomer){
		sTempletNo = "RetailCustomerBasicInfo";//--门店商户管理模板号--"
	}
	else{
		sTempletNo = "EntCustomerBasicInfo";//--模板号--
	}
	//通过显示模版产生ASDataObject对象doTemp
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("CustomerID", customerID);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();	
	
/* 	if(!"01".equals(customerType)){
		doTemp.setVisible("MFCUSTOMERID", true);
	}
	if("".equals(customerType)){
		doTemp.setVisible("MFCUSTOMERID", false);
		doTemp.setVisible("CUSTOMERID",true);
	} */
	dwTemp.Style = "2";//freeform
	if("".equals(customerType)){
		customerType = "01";
	}
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	doTemp.setDefaultValue("INPUTORGName", CurOrg.getOrgName());
	doTemp.setDefaultValue("INPUTUSERName", CurUser.getUserName());
	if(isRetailCustomer){//商户门店需要新增电话联系方式
		dwTemp.replaceColumn("TelInfo", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/CustomerTelList.jsp?CustomerID="+customerID+"&CustomerType="+customerType+"&isRetail="+"Retail"+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	}
	dwTemp.replaceColumn("ADDRESSINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/CustomerAddressList.jsp?CustomerID="+customerID+"&CustomerType="+customerType+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("ECONTRACT", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/CustomerEContractList.jsp?CustomerID="+customerID+"&CustomerType="+customerType+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	//dwTemp.replaceColumn("ACCOUNTNO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/Accounting/LoanDetail/LoanTerm/BusinessAccountList.jsp?ObjectNo="+customerID+"&ObjectType="+"jbo.customer.CUSTOMER_INFO"+"&CompClientID="+sCompClientID+"&Status=0@1@2@3"+"\"></iframe>", CurPage.getObjectWindowOutput());
	//dwTemp.replaceColumn("LEGALREPRESENT", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/CustomerLegalRepresentList.jsp?CustomerID="+customerID+"&CustomerType="+customerType+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	//dwTemp.replaceColumn("REGISTERINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/EntCustomer/EntCustomerRegisterList.jsp?CustomerID="+customerID+"&CustomerType="+customerType+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	//dwTemp.replaceColumn("CUSTOMERCERTINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/CustomerCertList.jsp?CustomerID="+customerID+"&CustomerType="+customerType+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	//dwTemp.replaceColumn("TELINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/CustomerTelList.jsp?CustomerID="+customerID+"&CustomerType="+customerType+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());

	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveInfo()","","","","btn_icon_save",""},
		{"true","All","Button","暂存","暂时保存所有修改内容","saveRecordTemp()","","","",""},
		};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
    function saveInfo(){
		setItemValue(0,0,"UPDATEORGID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,0,"UPDATEUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateHelper.getBusinessDate()%>");
		setItemValue(0,getRow(),"TEMPSAVEFLAG","0"); //暂存标志（0：保存  1：暂存）
    	as_save("myiframe0");
	}	 
	function saveRecordTemp()
	{
		setItemValue(0,getRow(),'TempSaveFlag',"1");//暂存标志（0：保存  1：暂存）
		setItemValue(0,0,"UPDATEDATE","<%=DateHelper.getBusinessDate()%>");
		as_saveTmp("myiframe0");
	}		
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode()
	{
		var sCity = getItemValue(0,getRow(),"CITY");
		sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sCity,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"CNIDREGCITY","");
			setItemValue(0,getRow(),"CNIDREGCITYName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					setItemValue(0,getRow(),"CNIDREGCITY",sAreaCodeValue);
					setItemValue(0,getRow(),"CNIDREGCITYName",sAreaCodeName);				
			}
		}
	}
	function selectLegalCustomer(){
		ALSObjectWindowFunctions.setObjectValuePretreat('SelectAllIndCustomer', "<%=CurUser.getUserID()%>", 'RELATIVECUSTOMERNAME=CustomerName','','','LC',0,'1');
	}
	
	function IsUnKnown(){
		var IndustryType = getItemValue(0, getRow(0), "INDUSTRYTYPE");
		if(IndustryType == "N98"){
			alert("行业类型不允许选择【未知】！");
			setItemValue(0, getRow(0),"INDUSTRYTYPE","");
			return;
		}
	}
	function hideCustomerName(){
		var MFCustomerID = getItemValue(0,getRow(),"MFCUSTOMERID");
		if(typeof(MFCustomerID) == "undefined" || MFCustomerID.length == 0){
			setItemDisabled(0, getRow(), "CUSTOMERNAME", false);
		}else{
			setItemDisabled(0, getRow(), "CUSTOMERNAME", true);
		}
	}
	hideCustomerName();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
