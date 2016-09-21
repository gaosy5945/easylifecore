<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	
	String relaSerialNos = DataConvert.toString(CurPage.getParameter("relaSerialNos"));
	String actualBusinessRate = DataConvert.toString(CurPage.getParameter("ActualBusinessRates"));
	if(actualBusinessRate == null){actualBusinessRate = "";}
	String projectNo = DataConvert.toString(CurPage.getParameter("ProjectNo"));
	String projectType = DataConvert.toString(CurPage.getParameter("ProjectType"));
	String managerFeeRate = DataConvert.toString(CurPage.getParameter("ManagerFeeRate"));
	if(managerFeeRate == null){managerFeeRate = "";}
	String otherFeeRate = DataConvert.toString(CurPage.getParameter("OtherFeeRate"));
	if(otherFeeRate == null){otherFeeRate = "";}
	if(actualBusinessRate.endsWith("@")){
		actualBusinessRate = actualBusinessRate.substring(0, actualBusinessRate.length() - 1);
	}
	String[] eachActualBusinessRate = actualBusinessRate.split("@");
	Double minActualBusinessRate = Double.parseDouble(eachActualBusinessRate[0]);
	for(int i = 0; i<eachActualBusinessRate.length; i++){
		Double eachActualBusinessRated = Double.parseDouble(eachActualBusinessRate[i]);
		if(minActualBusinessRate < eachActualBusinessRated){
		}else{
			minActualBusinessRate = eachActualBusinessRated;
		}
	}
	if(relaSerialNos.endsWith("@")){
		relaSerialNos = relaSerialNos.substring(0, relaSerialNos.length() - 1);
	}
	String[] strs = relaSerialNos.split("@");
	String sTempletNo = "";
	sTempletNo = "SetRateInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	if(strs.length != 1){
		dwTemp.genHTMLObjectWindow("");
	}else{
		dwTemp.genHTMLObjectWindow(relaSerialNos);
	}
	String sButtons[][] = {
		{"true","All","Button","确定","确定","ok();","","","",""},
		{"true","All","Button","取消","取消","cancel();","","","",""}
	};
	sButtonPosition = "south";
%>
<HEAD>
<title>转出利率</title>
</HEAD>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
function ok(){
	var relaSerialNos = '<%=relaSerialNos%>';
	var projectNo = '<%=projectNo%>';
	var sRate = getItemValue(0,0,"TRANSFERRATE");
	var sRateAdjustType = getItemValue(0,0,"LOANRATEREPRICETYPE");
	var sResult = '';	
	var sJavaClass = "com.amarsoft.app.als.assetTransfer.action.AssetFilterAction";
	var sJavaMethod = "setRate";
	var sParams = "serialNos="+relaSerialNos+",projectNo="+projectNo+",outRate="+sRate+",outRateAdjustType="+sRateAdjustType+",managerFeeRate="+'<%=managerFeeRate%>'+",otherFeeRate="+'<%=otherFeeRate%>';
	//alert(sParams);
	sResult = RunJavaMethodTrans(sJavaClass,sJavaMethod,sParams);
	if(sResult == 'true'){
		
	}else{
		alert(sResult);
	}
	
	self.returnValue = sResult;
	self.close(); 
}
	
	function cancel(){
		self.close();
	}
	
	function initRow(){
		var loanRateRepriceType = getItemValue(0,0,"LOANRATEREPRICETYPE");
		var transferRate = getItemValue(0,0,"TRANSFERRATE");
		var minActualBusinessRate = '<%=minActualBusinessRate%>';
		var managerFeeRate = '<%=managerFeeRate%>';
		if(managerFeeRate == ""){
			managerFeeRate = 0.0;
		}
		var otherFeeRate = '<%=otherFeeRate%>';
		if(otherFeeRate == ""){
			otherFeeRate = 0.0;
		}
		var projectType = '<%=projectType%>';
		var minActualBusinessRate_0201 = parseFloat(minActualBusinessRate) - parseFloat(managerFeeRate) - parseFloat(otherFeeRate) ;
		if(transferRate == ""){
			if(projectType == '0201'){
				setItemValue(0,getRow(),"TRANSFERRATE",minActualBusinessRate_0201);
			}else if(projectType == '0203'){  
				setItemValue(0,getRow(),"TRANSFERRATE",minActualBusinessRate);
			}  
		}
		if(loanRateRepriceType == ""){
			setItemValue(0,getRow(),"LOANRATEREPRICETYPE","07");
		}
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
