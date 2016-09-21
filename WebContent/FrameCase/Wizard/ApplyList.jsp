<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("DemoWizardList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";
	dwTemp.ReadOnly = "1";
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","","Button","新增","","openWizard()","","","",""},
			{"true","","Button","向导","","viewWizard()","","","",""},
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function viewWizard(){
		var sSerialNo = getItemValue(0, getRow(), "SerialNo");
		if(!sSerialNo){
			alert("请选择一条记录！");
			return;
		}
		openWizard(sSerialNo);
	}
	
	function openWizard(sObjectNo){
		var sParam = "WizardId=TestWizard";
		if(sObjectNo) sParam += "&ObjectNo="+sObjectNo;
		AsControl.PopView("/Frame/page/control/WizardPage.jsp", sParam);
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>