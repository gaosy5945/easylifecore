<%@ page contentType="text/html; charset=GBK"%>
 <%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	
	String duebillNo = CurPage.getParameter("DuebillNo");
	String serialNo = CurPage.getParameter("SerialNo");

	
	if(duebillNo == null) duebillNo = "";
	if(serialNo == null) serialNo = "";

	String sTempletNo = "BreakContractInfo";//--ģ���--
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel(sTempletNo,BusinessObject.createBusinessObject(),CurPage);

	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(doTemp,CurPage, request);
	
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ	
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		//{"true","All","Button","����","����","returnList()","","","",""}
		{"true","All","Button","�ύ","�ύ","submit()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function submit(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		}
		var returnValue1 =RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.BreakContractConfirm","check","SerialNo="+serialNo);
		if(returnValue1 != "true"){
			alert(returnValue1);
			return;
		}
		if(!confirm('ȷʵҪ�ύ��?'))return;
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.BreakContractConfirm","submitToApprove","SerialNo="+serialNo);
		if(returnValue.length != 0){
			alert(returnValue);
			top.close();
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
