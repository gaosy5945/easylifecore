<%@ page contentType="text/html; charset=GBK"%>
 <%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
    //String duebillNo = CurPage.getParameter("DuebillNo");
	String sSerialNo = CurPage.getParameter("SerialNo");
	String sFlowSerialNo = CurPage.getParameter("FlowSerialNo");
	String sTaskSerialNo = CurPage.getParameter("TaskSerialNo");
	String sPhaseNo = CurPage.getParameter("PhaseNo");
	String sAdjustType = CurPage.getParameter("AdjustType");
	
	if(sSerialNo == null) sSerialNo = "";
	if(sFlowSerialNo == null) sFlowSerialNo = "";
	if(sTaskSerialNo == null) sTaskSerialNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	if(sAdjustType == null) sAdjustType = "";
    
	String sTempletNo = "ClassifyApplyInfo";//--模板号--
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("ClassifyApplyInfo",BusinessObject.createBusinessObject(),CurPage);

    doTemp.setHtmlEvent("CLASSIFYMETHOD", "onChange", "changeClassifyMethod");    
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(doTemp,CurPage, request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	
	dwTemp.setParameter("SerialNo", sSerialNo);
	dwTemp.genHTMLObjectWindow("");
	
	dwTemp.replaceColumn("ADDITIONINFO", "<iframe type='iframe' id=\"AdditionInfo\" name=\"frame_list\" width=\"100%\" height=\"500\" frameborder=\"0\" src=\""+sWebRootPath+"/Common/BusinessObject/BusinessObjectDocumentList.jsp?ObjectType=jbo.flow.FLOW_OBJECT&ObjectNo="+sFlowSerialNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存","save()","","","","",""},
		{"true","All","Button","提交","提交","submit()","","","","",""},
		};
%> 
<%@include file="/Frame/resources/include/ui/include_info.jspf" %>
 <script>
	 function changeClassifyMethod(){
		var classifyMethod = getItemValue(0,getRow(),"ClassifyMethod"); 
		if (classifyMethod == "02" && "<%=CurPage.getParameter("RightType")%>"!="ReadOnly"){
		 	setItemDisabled(0, 0, "ADJUSTEDGRADE", true);
		}
		
		var bdCLASSIFYMETHOD = getItemValue(0,getRow(),"BDCLASSIFYMETHOD");
		if(bdCLASSIFYMETHOD=="01" && classifyMethod=="02"){
			setItemRequired("myiframe0", "ADJUSTEDGRADE", false);
			hideItem("myiframe0","ADJUSTEDGRADE");
		}else{
			showItem("myiframe0","ADJUSTEDGRADE");
			setItemRequired("myiframe0", "ADJUSTEDGRADE", true);
		}
	 }
 
	function save(){

		as_save(0);
	}
	
	function submit(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		var flowSerialNo = "<%=sFlowSerialNo%>";
		var taskSerialNo = "<%=sTaskSerialNo%>";
		var phaseNo = "<%=sPhaseNo%>";	
		var userID = "<%=CurUser.getUserID()%>";
		var orgID = "<%=CurOrg.getOrgID()%>";
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		}
		var returnValue1 =RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.CheckClassifyInfo","check","SerialNo="+serialNo);
			if(returnValue1 != "true"){
				alert(returnValue1);
				return;
		}
		if(!confirm('确实要提交吗?'))return;
		var returnValue = PopPage("/Common/WorkFlow/SubmitDialog.jsp?PhaseNo="+phaseNo+"&TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo,"","dialogWidth:450px;dialogHeight:340px;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_") {
			return;
		}
		else
		{
			if(returnValue.split("@")[0] == "true")
			{
				top.close();
			}
		}
	}
	
	$(document).ready(function(){
		changeClassifyMethod();
	});
	</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
