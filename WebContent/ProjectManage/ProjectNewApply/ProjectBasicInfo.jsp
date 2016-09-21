<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String FlowSerialNo = CurPage.getParameter("FlowSerialNo");
	if(FlowSerialNo == null) FlowSerialNo = "";
	String RightType = CurPage.getParameter("RightType");
	if(RightType == null) RightType = "";

	String sTempletNo = CurPage.getParameter("TempletNo");
	if(sTempletNo == null || sTempletNo.length()==0) sTempletNo = "ProjectBasicInfo";
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("serialNo", serialNo);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();	
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(serialNo);
	dwTemp.replaceColumn("PartnerCustomer", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/ProjectManage/ProjectNewApply/ProjectPartnerCustomerList.jsp?prjSerialNo="+serialNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","save()","","","",""},
		{"true","All","Button","暂存","暂存","tempSave()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">

	function selectCustomer(){
		//setObjectValue("SelectPartnerCustomer",sParaString,"@CustomerID@0@CustomerName@1@CertType@2@CertID@3",0,0,"");
		AsDialog.SetGridValue("SelectPartnerCustomer","<%=CurUser.getUserID()%>", "CustomerID=CustomerID@CustomerName=CustomerName@CertType=CertType@CertID=CertID", "","","1");
	}
	
	function selectProduct(){
		var returnValue= AsCredit.selectTree("SelectBusinessType","","","");//单选树
		setItemValue(0,getRow(),'ProductList',returnValue["ID"]);
		setItemValue(0,getRow(),'ProductListName',returnValue["Name"]);
		
		//AsCredit.setMultipleTreeValue("SelectBusinessType", "", "", "","0",getRow(),"ProductList","ProductListName");
	}
	
	function selectOrg(){
		AsCredit.setMultipleTreeValue("SelectAllOrg", "", "", "","0",getRow(),"PARTICIPATEORG","ParticipateOrgName");
	}

	function tempSave(){
		setItemValue(0,getRow(),'TempSaveFlag',"1");//暂存标志（0：保存  1：暂存）
		as_saveTmp("myiframe0");
	}

	function save(){
		var EffectDate = getItemValue(0,getRow(0),"EffectDate");
		var EffectYear = EffectDate.substring(0, 4);
		var EffectMonth = EffectDate.substring(5, 7);
		var EffectDay = EffectDate.substring(8, 10);
		var EffectDateSub = EffectYear+EffectMonth+EffectDay;
		var ExpiryDate = getItemValue(0,getRow(0),"ExpiryDate");
		var ExpiryYear = ExpiryDate.substring(0, 4);
		var ExpiryMonth = ExpiryDate.substring(5, 7);
		var ExpiryDay = ExpiryDate.substring(8, 10);
		var ExpiryDateSub = ExpiryYear+ExpiryMonth+ExpiryDay;
		if((EffectDateSub != "" || EffectDateSub.length != 0) && (ExpiryDateSub != "" || ExpiryDateSub.length != 0)){
			if(ExpiryDateSub < EffectDateSub || ExpiryDateSub == EffectDateSub){
				alert("项目到期日不能小于或等于项目起始日，请重新输入！");
				return;
			}
		}
		setItemValue(0,0,"UPDATEUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateHelper.getBusinessDate()%>");
		var prjSerialNo = "<%=serialNo%>";
		var productList = getItemValue(0,getRow(0),"ProductList");
		var participateOrg = getItemValue(0,getRow(0),"PARTICIPATEORG");
		var ProjectType = getItemValue(0,getRow(0),"ProjectType");
		productList = productList.replace(/,/g,"@");
		participateOrg = participateOrg.replace(/,/g,"@");
		if(ProjectType != "0110"){
			var sReturn = ProjectManage.selectProductAndParticipate(prjSerialNo,productList,participateOrg);
			setItemValue(0,getRow(),"TEMPSAVEFLAG","0"); //暂存标志（0：保存  1：暂存）
			if(sReturn == "Same" || sReturn == "Empty"){
		    	as_save(0);
			}else{
				as_save("deleteCutCL()");
			}
		}else{
			setItemValue(0,getRow(),"TEMPSAVEFLAG","0"); //暂存标志（0：保存  1：暂存）
			setItemValue(0,getRow(),"Status","13");
			as_save(0);
		}
		
	}
	
	function deleteCutCL(){
		var prjSerialNo = "<%=serialNo%>";
		ProjectManage.deleteCutCL(prjSerialNo);
	}
	
	function compareSize(){
		var EffectDate = getItemValue(0,getRow(0),"EffectDate");
		var EffectYear = EffectDate.substring(0, 4);
		var EffectMonth = EffectDate.substring(5, 7);
		var EffectDay = EffectDate.substring(8, 10);
		var EffectDateSub = EffectYear+EffectMonth+EffectDay;
		var ExpiryDate = getItemValue(0,getRow(0),"ExpiryDate");
		var ExpiryYear = ExpiryDate.substring(0, 4);
		var ExpiryMonth = ExpiryDate.substring(5, 7);
		var ExpiryDay = ExpiryDate.substring(8, 10);
		var ExpiryDateSub = ExpiryYear+ExpiryMonth+ExpiryDay;
		if((EffectDateSub != "" || EffectDateSub.length != 0) && (ExpiryDateSub != "" || ExpiryDateSub.length != 0)){
			if(ExpiryDateSub < EffectDateSub || ExpiryDateSub == EffectDateSub){
				alert("项目到期日不能小于或等于项目起始日，请重新输入！");
				return;
			}
		}
	}
	function initRow(){
		var ProjectType = getItemValue(0,getRow(0),"ProjectType");
		if(ProjectType != "0110"){
			ALSObjectWindowFunctions.setItemsRequired(0,"CUSTOMERNAME",true);
		}
		var OrgID = getItemValue(0,getRow(0),"PARTICIPATEORG");
		if(typeof(OrgID) == "undefined" || OrgID.length == 0){
			setItemValue(0,0,"PARTICIPATEORG","<%= CurOrg.getOrgID()%>");
			setItemValue(0,0,"PARTICIPATEORGName","<%= CurOrg.getOrgName()%>");
		}
	}
	//校验账户信息
	function checkAccount(ai,at,an,ana,ac,an1,acid,amfcid,subdw)
	{
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,subdw);
		var accountIndicator = getItemValue(subdwname, getRow(subdwname), ai);
		var accountType = getItemValue(subdwname, getRow(subdwname), at);
		var accountNo = getItemValue(subdwname, getRow(subdwname), an);
		var accountName = getItemValue(subdwname, getRow(subdwname), ana);
		var accountCurrency = getItemValue(subdwname, getRow(subdwname), ac);
		
		if(typeof(accountNo) == "undefined" || accountNo.length == 0) return;
		
		var returnValue = AsControl.RunASMethod("WorkFlowEngine","CheckClientCHNName",accountIndicator+","+accountNo+","+accountType+","+accountName+","+accountCurrency);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		if(returnValue.split("@")[0] == "false"){
			alert(returnValue.split("@")[1]);
			setItemValue(subdwname, getRow(subdwname), ana, "");
			setItemValue(subdwname, getRow(subdwname), an1, "");
			return false;
		}else{
			setItemValue(subdwname, getRow(subdwname), an1, returnValue.split("@")[1]);
			setItemValue(subdwname, getRow(subdwname), ana, returnValue.split("@")[2]);
			setItemValue(subdwname, getRow(subdwname), acid, returnValue.split("@")[3]);
			setItemValue(subdwname, getRow(subdwname), amfcid, returnValue.split("@")[4]);
		}
		return true;
	}
	$(document).ready(function(){
		initRow();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
