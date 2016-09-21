<%@page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	
	String serialNo = CurPage.getParameter("SerialNo");

	
	if(serialNo == null) serialNo = "";

	String sTempletNo = "BreakOpinionInfo";//--模板号--
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel(sTempletNo,BusinessObject.createBusinessObject(),CurPage);

	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(doTemp,CurPage, request);
	
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式	
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","save()","","","",""},
		//{"true","All","Button","退回","退回","returnList()","","","",""},
		{"true","All","Button","提交","提交","saveRecord()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

	function save(){
		setItemValue(0,0,"APPROVEDATE", "<%=DateHelper.getBusinessDate()%>");
		as_save(0);
	}
	
	function saveRecord(){
		//增加必输项校验
		if(!iV_all("0"))return;
		setItemValue(0,0,"APPROVEDATE", "<%=DateHelper.getBusinessDate()%>");
		as_save("submit()");
	}
	
	function submit(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		}
		var returnValue1 =RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.BreakContractConfirm","checkOpinion","SerialNo="+serialNo);
		if(returnValue1 != "true"){
			alert(returnValue1);
			return;
		}
		if(!confirm('确实要提交吗?'))return;
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.BreakContractConfirm","submitOpinion","SerialNo="+serialNo);
		if(returnValue.length != 0){
			alert(returnValue);
			top.close();
		}
	}
	
	function returnList(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		}
		if(!confirm('确实要退回吗?'))return;
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.BreakContractConfirm","goBackApply","SerialNo="+serialNo);
		if(returnValue.length != 0){
			alert(returnValue);
			top.close();
		}
	}
	
	function onChangePhaseAction(){
		var phaseAction = getItemValue(0,getRow(),"APPROVEOPINION");		
		if(phaseAction == '01'){
			setItemRequired(0,"OPINIONDETAIL",false);
		}
		else{
			setItemRequired(0,"OPINIONDETAIL",true);
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>