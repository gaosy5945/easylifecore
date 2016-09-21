<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String authSerialNo = CurPage.getParameter("AuthSerialNo");
	if(authSerialNo == null || authSerialNo == "undefined") authSerialNo = "";
	String authorizeType = CurPage.getParameter("AuthorizeType");
	if(authorizeType == null || authorizeType == "undefined") authorizeType = "";
	String sTempletNo = "";
	
	if("02".equals(authorizeType)){
		sTempletNo = "RuleSceneInfo1";
	}else{
		sTempletNo = "RuleSceneInfo";//--模板号--
	}
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("AuthSerialNo", authSerialNo);
	dwTemp.genHTMLObjectWindow(authSerialNo);
	String sButtons[][] = {
			{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		as_save("myiframe0");	
	}
	setItemValue(0,getRow(),"AUTHSERIALNO","<%=authSerialNo%>");

	function SelectCustomerGrade(){
		var codeNo = "CustomerGrade";
		AsCredit.setMultipleTreeValue("SelectCode", "CodeNo,"+codeNo, "", "","myiframe0",getRow(),"CustomerGrade","CustomerGradeName");
	}
	function SelectCustomerType(){
		var codeNo = "CustomerType";
		AsCredit.setMultipleTreeValue("SelectCode", "CodeNo,"+codeNo, "", "","myiframe0",getRow(),"CustomerType","CustomerTypeName");
	}
	function SelectEnterpriseScale(){
		var codeNo = "EnterpriseScale";
		AsCredit.setMultipleTreeValue("SelectCode", "CodeNo,"+codeNo, "", "","myiframe0",getRow(),"CustomerScale","CustomerScaleName");
	}
	function SelectVouchType(){
		var codeNo = "VouchType";
		AsCredit.setMultipleTreeValue("SelectCode", "CodeNo,"+codeNo, "", "","myiframe0",getRow(),"VouchType","VouchTypeName");
	}
	function SelectExceptCreditReason(){
		var codeNo = "ExceptCreditReason";
		AsCredit.setMultipleTreeValue("SelectCode", "CodeNo,"+codeNo, "", "","myiframe0",getRow(),"ExceptReason","ExceptReasonName");
	}
	function SelectCreditOccurType(){
		var codeNo = "CreditOccurType";
		AsCredit.setMultipleTreeValue("SelectCode", "CodeNo,"+codeNo, "", "","myiframe0",getRow(),"OccurType","OccurTypeName");
	}
	function SelectCurrency(){
		var codeNo = "Currency";
		AsCredit.setMultipleTreeValue("SelectCode", "CodeNo,"+codeNo, "", "","myiframe0",getRow(),"BusinessCurrency","BusinessCurrencyName");
	}
	function SelectBusinessType(){
		AsCredit.setMultipleTreeValue("SelectBusinessTypeAll", "", "", "","myiframe0",getRow(),"BusinessType","BusinessTypeName");
	}
	function SelectOrgID(){
		AsCredit.setMultipleTreeValue("SelectAllOrg", "", "", "","myiframe0",getRow(),"OrgID","OrgName");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
