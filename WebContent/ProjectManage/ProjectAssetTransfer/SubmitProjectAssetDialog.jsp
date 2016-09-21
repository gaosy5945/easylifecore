<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
 <%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>

<% 
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String sTempletNo = "ProjectAssetSubmitDialog";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	/* doTemp.setJboWhere("O.SerialNo = :serialNo"); */
	doTemp.setDefaultValue("SERIALNO", "111111");
	doTemp.setUnit("SerialNo","&nbsp;&nbsp;<input  value=\"...\" type=button id=\"takeSerialNo\" onclick=parent.takeSerialNo() >");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			/* saveRecord(0) */
		{"true","All","Button","确认","确认","saveRecord(0)","","","",""}, 
		{"true","All","Button","取消","取消","goBack(0)","","","",""}, 
	};
	sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>

<%@page import="com.amarsoft.app.als.customer.model.CustomerConst"%><script type="text/javascript">
	function goBack(){ 
		self.close();
	}

	function saveRecord(){ 
/* 		beforeSubmit(); */
		//submit();
		self.close();
	}
	
<%--  	function submit(){
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		var sProjectType = getItemValue(0,getRow(),"PROJECTTYPE");
		var status = '<%=AssetProjectCodeConstant.AssetProjectStatus_020%>';
		var approveOrgId = getItemValue(0,getRow(),"APPROVEORGID");
		var approveUserId = getItemValue(0,getRow(),"APPROVEUSERID");
		if(typeof(approveOrgId) == 'undefined' || approveOrgId.length == 0){
			alert("请输入提交岗位！");
			return;
		}
		else if(typeof(approveUserId) == 'undefined' || approveUserId.length == 0){
			alert("请输入提交人！");
			return;
		}
		else if(confirm('确定要进行此操作吗?')){
			RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.AssetTransferAction","changeProjectStatus","projectNo="+sProjectNo+",status="+status+",assetProjectType="+sProjectType);
			reloadSelf();
		}
	}  --%>
	
	 function submit(){
		var sAssetProjectNo = getItemValue(0,getRow(),"SerialNo");
		/* var sProjectType = getItemValue(0,getRow(),"PROJECTTYPE"); */
		var projectAssetStatus = '<%=AssetProjectCodeConstant.ProjectAssetStatus_02%>';
/* 		var approveOrgId = getItemValue(0,getRow(),"APPROVEORGID");
		var approveUserId = getItemValue(0,getRow(),"APPROVEUSERID"); */
		alert(sAssetProjectNo);
		alert(projectAssetStatus);
/* 		if(typeof(approveOrgId) == 'undefined' || approveOrgId.length == 0){
			alert("请输入提交岗位！");
			return;
		}
		else if(typeof(approveUserId) == 'undefined' || approveUserId.length == 0){
			alert("请输入提交人！");
			return;
		}
		else  */if(confirm('确定要进行此操作吗?')){
			RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.AssetTransferAction","changeProjectAssetStatus","assetProjectNo="+sAssetProjectNo+",projectAssetStatus="+projectAssetStatus);
			reloadSelf();
		}
	}  
	
/* 	 beforeSubmit(){
		 var serialNo = 
		 alert(serialNo);
	 } */
	 
	function takeSerialNo()
	{
		alert("333");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 