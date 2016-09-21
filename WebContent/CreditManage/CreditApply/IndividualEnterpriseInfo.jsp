<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String objectType = CurPage.getParameter("ObjectType");
	if(objectType == null) objectType = "";
	String objectNo = CurPage.getParameter("ObjectNo");
	if(objectNo == null) objectNo = "";
	double businessSum = 0.0;
	String ProductID = CurPage.getParameter("ProductID");
	if(ProductID == null) ProductID = "";

	BusinessObject param = BusinessObject.createBusinessObject();
	param.setAttributeValue("ObjectNo", objectNo);
	param.setAttributeValue("ObjectType", objectType);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info("IndividualEnterpriseInfo", param, CurPage, request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();

	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "0";//只读模式

	dwTemp.genHTMLObjectWindow(objectType+","+objectNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","All","Button","暂存","暂存所有修改","saveTemp()","","","",""},
		{"false","All","Button","删除","删除","deleteRecord()","","","",""}
	};
	
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();	
	BusinessObject ba = bom.loadBusinessObject(objectType, objectNo);
	if(ba != null){
		businessSum = ba.getDouble("BusinessSum");
	}
	
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		setItemValue(0,getRow(),'TempSaveFlag',"0");//暂存标志（1：是；0：否）
		as_save(0);
	}
	
	function saveTemp(){
		setItemValue(0,getRow(),'TempSaveFlag',"1");//暂存标志（1：是；0：否）
		as_saveTmp("myiframe0");   //暂存
	}
	
	function deleteRecord(){
		if(!confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
			return ;
		as_delete(0,'refresh()');	
	}
	
	function refresh(){
		AsControl.OpenView("/CreditManage/CreditApply/IndividualEnterpriseInfo.jsp", "ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>", "_self", "");
	}
	
	function calcAssetLiabilityRatio(){
		var asset = getItemValue(0,getRow(),"TOTALASSETS");
		var liability = getItemValue(0,getRow(),"GROSSLIABILITY");
		var businessSum ="<%=businessSum%>" ;
		if(asset != null && asset.length != 0 && liability != null && liability.length != 0){
			if(asset == 0){
				setItemValue(0,getRow(),"ASSETLIABILITYRATIO1",0);
				setItemValue(0,getRow(),"ASSETLIABILITYRATIO2",0);
				return;
			}
			var ratio = 100*liability/asset;
			var ratio1 = 100*(1.0 *liability + 1.0 * businessSum)/asset;
			setItemValue(0,getRow(),"ASSETLIABILITYRATIO1",ratio);
			setItemValue(0,getRow(),"ASSETLIABILITYRATIO2",ratio1);
		}
		else{
			setItemValue(0,getRow(),"ASSETLIABILITYRATIO1",0);
			setItemValue(0,getRow(),"ASSETLIABILITYRATIO2",0);
		}
	}
	
	function changeEnterpriseCredit(){
		var enterpriseCredit = getItemValue(0,getRow(),"ENTERPRISECREDIT");		
		if(enterpriseCredit == '0'){
			setItemRequired(0,"LOANSTATUS",false);
			hideItem(0,"LOANSTATUS");
			hideItem(0,"LOANBALANCE");
			hideItem(0,"LOANODBALANCE");
		}else{
			setItemRequired(0,"LOANSTATUS",true);
			showItem(0,"LOANSTATUS");
			showItem(0,"LOANBALANCE");
			showItem(0,"LOANODBALANCE");
		}
	}
 	function selectEntCustomer(){
		var sReturn = AsDialog.SetGridValue("EntCustomerList1", "<%=CurUser.getUserID()%>", "RELACUSTOMERID=CustomerID@RELACUSTOMERNAME=CustomerName@CERTTYPE=CertType@CERTID=CertID", "");
		if(typeof(sReturn) != "undefined"){
			setItemDisabled(0,0,"RelaCustomerName",true);
			setItemDisabled(0,0,"CertType",true);
			setItemDisabled(0,0,"CertID",true);
		}
 	}
	function productChange(){
 		var ProductID = "<%=ProductID%>";
 		if(ProductID != "057" && ProductID != "065"){
 			ALSObjectWindowFunctions.hideItems(0,"EASYTOLOANBUSINESS,PLEDGETYPE,HOUSELEVEL");
 		}else if(ProductID == "057"){
 			ALSObjectWindowFunctions.setItemsRequired(0,"EASYTOLOANBUSINESS",true);
 			ALSObjectWindowFunctions.hideItems(0,"PLEDGETYPE,HOUSELEVEL");
 		}else if(ProductID == "065"){
 			ALSObjectWindowFunctions.hideItems(0,"EASYTOLOANBUSINESS");
 			ALSObjectWindowFunctions.setItemsRequired(0,"PLEDGETYPE,HOUSELEVEL",true);
 		}
	}
 	function ETLChange(){
 		var easyToLoanBusiness = getItemValue(0,getRow(),"EASYTOLOANBUSINESS");
 		if(easyToLoanBusiness != "02"){
			setItemValue(0,getRow(),"SOLDGROWTHRATE","");
			setItemValue(0,getRow(),"BUSINESSINCOMESCALE","");
			ALSObjectWindowFunctions.hideItems(0,"SOLDGROWTHRATE,BUSINESSINCOMESCALE");
 			ALSObjectWindowFunctions.setItemsRequired(0,"SOLDGROWTHRATE,BUSINESSINCOMESCALE",false);
 		}else{
 			ALSObjectWindowFunctions.showItems(0,"SOLDGROWTHRATE,BUSINESSINCOMESCALE");
			ALSObjectWindowFunctions.setItemsRequired(0,"SOLDGROWTHRATE,BUSINESSINCOMESCALE",true);
 		}
 	}
	function init(){
		if(getRowCount(0) != 0){
			//setItemDisabled(0,0,"RelaCustomerName",true);
			//setItemDisabled(0,0,"CertType",true);
			//setItemDisabled(0,0,"CertID",true);
		}
		setItemValue(0,getRow(),"ObjectType","<%=objectType%>");
		setItemValue(0,getRow(),"ObjectNo","<%=objectNo%>");
		setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"InputOrgID","<%=CurOrg.getOrgID()%>");
		changeEnterpriseCredit();
		productChange();
		ETLChange();
	}
	function industrySelect(){
		var IndustryMain = getItemValue(0,getRow(),"INDUSTRYTYPE");
		if(typeof(IndustryMain) == "undefined" || IndustryMain.length == 0){
			alert("请选择行业投向大类！");
			return;
		}else{
			IndustryMain = IndustryMain.substring(0,1);
			setObjectValuePretreat('SelectIndustry','IndustryMain,'+IndustryMain,'@INVESTINDUSTRY1@0@INVESTINDUSTRY2@1');
			return;
		}
	}
	$(document).ready(function(){
		init();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
