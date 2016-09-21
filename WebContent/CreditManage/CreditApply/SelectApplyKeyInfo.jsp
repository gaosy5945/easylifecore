<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	ASObjectModel doTemp = new ASObjectModel("SelectApplyKeyInfo","");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","确定","确定","saveRecord()","","","",""},
		{"true","","Button","清空","清空","cancel()","","","",""},
	};
	
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(){
		//as_save("myiframe0");
		if(!iV_all("myiframe0"))return;
		var ContractArtificialNo = getItemValue(0, getRow(0), "ContractArtificialNo");
		AsControl.PopView("/ImageManage/ImagePage.jsp", "QueryType=02&FlowFlag=0&ImageCodeNo="+ContractArtificialNo);
	}
	function cancel(){
		setItemValue(0, getRow(0), "ContractArtificialNo", "");
		setItemValue(0, getRow(0), "CustomerName", "");
		setItemValue(0, getRow(0), "CertType", "");
		setItemValue(0, getRow(0), "CertID", "");
	}
	function selectApply(){
		setGridValuePretreat('SelectBusinessApply','<%=CurUser.getOrgID()%>','ContractArtificialNo=ContractArtificialNo@CustomerName=CUSTOMERNAME@CertType=CERTTYPE@CertID=CERTID','','1');
	}
	function selectContract(){
		setGridValuePretreat('SelectBusinessContract','<%=CurUser.getOrgID()%>','ContractArtificialNo=SERIALNO@CustomerName=CUSTOMERNAME@CertType=CERTTYPE@CertID=CERTID','','1');
	}
	function changeContractArtificialNo(){
		var ContractArtificialNo = getItemValue(0, getRow(0), "ContractArtificialNo");
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CheckContractNo", "checkContractNo", "ContractArtificialNo="+ContractArtificialNo);
		if(returnValue.split("@")[0] == "false"){
			cancel();
			alert("您输入的合同号不存在，请查实！");
			return;
		}else{
			setItemValue(0, getRow(0), "CustomerName", returnValue.split("@")[1]);
			setItemValue(0, getRow(0), "CertType", returnValue.split("@")[2]);
			setItemValue(0, getRow(0), "CertID", returnValue.split("@")[3]);
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>