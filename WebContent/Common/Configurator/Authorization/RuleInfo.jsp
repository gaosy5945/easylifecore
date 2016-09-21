<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null || serialNo == "undefined") serialNo = "";
	String authorizeType = CurPage.getParameter("AuthorizeType");
	if(authorizeType == null || authorizeType == "undefined") authorizeType = "";
	String sTempletNo = "";//--模板号--
	if("01".equals(authorizeType)){
		sTempletNo = "RuleSceneGroupInfo";
	}else{
		sTempletNo = "RuleSceneGroupInfo2";
	}
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
			{"true","","Button","保存","保存所有修改","as_save(0)","","","",""},
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function SelectCustomerType(){
		var codeNo = "CustomerType";
		var returnValue = AsCredit.setMultipleTreeValue("SelectCode", "CodeNo,"+codeNo, "", "","myiframe0",getRow(),"CustomerType","CustomerTypeName");
	}
	function SelectEnterpriseScale(){
		var codeNo = "EnterpriseScale";
		var returnValue = AsCredit.setMultipleTreeValue("SelectCode", "CodeNo,"+codeNo, "", "","myiframe0",getRow(),"CustomerScale","CustomerScaleName");
	}
	function SelectVouchType(){
		var codeNo = "VouchType";
		var returnValue = AsCredit.setMultipleTreeValue("SelectCode", "CodeNo,"+codeNo, "", "","myiframe0",getRow(),"VouchType","VouchTypeName");
	}
	function SelectExceptCreditReason(){
		var codeNo = "ExceptCreditReason";
		var returnValue = AsCredit.setMultipleTreeValue("SelectCode", "CodeNo,"+codeNo, "", "","myiframe0",getRow(),"ExceptReason","ExceptReasonName");
	}
	function SelectCreditOccurType(){
		var codeNo = "CreditOccurType";
		var returnValue = AsCredit.setMultipleTreeValue("SelectCode", "CodeNo,"+codeNo, "", "","myiframe0",getRow(),"OccurType","OccurTypeName");
	}
	function SelectCurrency(){
		var codeNo = "Currency";
		var returnValue = AsCredit.setMultipleTreeValue("SelectCode", "CodeNo,"+codeNo, "", "","myiframe0",getRow(),"BusinessCurrency","BusinessCurrencyName");
	}
	function SelectBusinessType(){
		var returnValue = AsCredit.setMultipleTreeValue("SelectBusinessType", "", "", "","myiframe0",getRow(),"BusinessType","BusinessTypeName");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
