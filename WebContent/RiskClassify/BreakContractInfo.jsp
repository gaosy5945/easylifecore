<%@ page contentType="text/html; charset=GBK"%>
 <%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	
	String duebillNo = CurPage.getParameter("DuebillNo");
	String serialNo = CurPage.getParameter("SerialNo");

	
	if(duebillNo == null) duebillNo = "";
	if(serialNo == null) serialNo = "";

	String sTempletNo = "BreakContractInfo";//--模板号--
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel(sTempletNo,BusinessObject.createBusinessObject(),CurPage);

	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(doTemp,CurPage, request);
	
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式	
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		//{"true","All","Button","返回","返回","returnList()","","","",""}
		{"true","All","Button","提交","提交","submit()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function submit(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		}
		var returnValue1 =RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.BreakContractConfirm","check","SerialNo="+serialNo);
		if(returnValue1 != "true"){
			alert(returnValue1);
			return;
		}
		if(!confirm('确实要提交吗?'))return;
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.BreakContractConfirm","submitToApprove","SerialNo="+serialNo);
		if(returnValue.length != 0){
			alert(returnValue);
			top.close();
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
