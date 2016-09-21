<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%
	String PG_TITLE = "批量押品评估"; 

	String applyStatus = CurPage.getParameter("ApplyStatus");if(applyStatus == null)applyStatus = "";
	String approveStatus = CurPage.getParameter("ApproveStatus");if(approveStatus == null) approveStatus = "";
	String approveFlag = CurPage.getParameter("ApproveFlag");if(approveFlag == null) approveFlag = "";
	
	ASObjectModel doTemp = new ASObjectModel("GuarantyEvaluateMutilList");
	String sWhereSql =  " and exists (select OB.belongorgid from jbo.sys.ORG_BELONG OB where OB.orgid = '"+CurOrg.getOrgID()+"' and OB.belongorgid = O.EVALUATEORGID)";
	doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);	
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	
	dwTemp.setParameter("ApplyStatus", applyStatus);
	dwTemp.setParameter("ApproveStatus", approveStatus);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","All","Button","发起估值","发起估值","newBtch()","","","",""},
			{"true","All","Button","估值处理","估值详情","dealBtch()","","","",""},
			{"true","All","Button","查看估值","查看估值","viewBtch()","","","",""},
			{"true","All","Button","取消","取消","cancel()","","","",""},
			{"true","All","Button","退回","退回","cancel()","","","",""},
			{"true","All","Button","签署意见","签署意见","signOpinion()","","","",""},
			{"true","All","Button","查看意见","查看意见","viewSignOpinion()","","","",""},
			{"true","All","Button","提交","提交","smt()","","","",""},
	};
	
	if("1".equals(applyStatus) && "1".equals(approveStatus)){
		sButtons[0][0] = "true";
		sButtons[1][0] = "true";
		sButtons[2][0] = "false";
		sButtons[3][0] = "true";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		sButtons[6][0] = "false";
		sButtons[7][0] = "true";
	} else if("2".equals(applyStatus) && "1".equals(approveStatus) && "1".equals(approveFlag)){
		sButtons[0][0] = "false";
		sButtons[1][0] = "true";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "true";
		sButtons[5][0] = "true";
		sButtons[6][0] = "true";
		sButtons[7][0] = "true";
	} else {
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "true";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		sButtons[6][0] = "true";
		sButtons[7][0] = "false";
	} 
	
%>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%>

<script type="text/javascript">
	function newBtch(){
		var cmisbtchApplyno = AsControl.PopComp("/BusinessManage/GuarantyManage/GuarantyEvaluateMutilInfo.jsp", "SerialNo=", "", "");
		
		reloadSelf();
	} 
	
	function dealBtch(){
		var cmisbtchApplyno = getItemValue(0,getRow(),"CMISBTCHAPPLYNO");
		
		var pstnType = "1";
		if("<%=applyStatus%>"=="2"){
			pstnType = "2";
		}
		if(typeof(cmisbtchApplyno) == "undefined" || cmisbtchApplyno.length == 0){
			 alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		window.showModalDialog("<%=com.amarsoft.app.oci.OCIConfig.getProperty("GuarantyURL","")%>/RatingManage/PublicService/EvalRedirector.jsp?cmisApplyId="+cmisbtchApplyno+"&pstnType="+pstnType+"&viewMode=0&userId=<%=CurUser.getUserID()%>&orgId=<%=CurUser.getOrgID()%>","","dialogWidth="+screen.availWidth+"px;dialogHeight="+screen.availHeight+"px;resizable=yes;maximize:yes;help:no;status:no;");
		reloadSelf();
	}
	
	/*~[Describe=查看押品估值申请;InputParam=无;OutPutParam=无;]~*/
	function viewBtch(){
		var cmisbtchApplyno = getItemValue(0,getRow(),"CMISBTCHAPPLYNO");
		var pstnType = "1";
		if("<%=applyStatus%>"=="2" || "<%=approveStatus%>"=="2"){
			pstnType = "2";
		}
		if(typeof(cmisbtchApplyno) == "undefined" || cmisbtchApplyno.length == 0){
			 alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		window.showModalDialog("<%=com.amarsoft.app.oci.OCIConfig.getProperty("GuarantyURL","")%>/RatingManage/PublicService/EvalRedirector.jsp?cmisApplyId="+cmisbtchApplyno+"&pstnType="+pstnType+"&viewMode=1&userId=<%=CurUser.getUserID()%>&orgId=<%=CurUser.getOrgID()%>","","dialogWidth="+screen.availWidth+"px;dialogHeight="+screen.availHeight+"px;resizable=yes;maximize:yes;help:no;status:no;");
		reloadSelf();
	}
	
	function cancel(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");//申请号
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			 alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.MutilEvaCheck",
				"backMutilEva","SerialNo="+serialNo+",ApplyStatus=<%=applyStatus%>,ApproveStatus=<%=approveStatus%>");
		
		alert(sReturn);
		reloadSelf();
	}

	function signOpinion(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		AsControl.PopComp("/BusinessManage/GuarantyManage/MutilOpinionInfo.jsp", "SerialNo="+serialNo, "", "");
	}
	
	function viewSignOpinion(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		// 查看签署意见
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.MutilEvaCheck",
				"getOpinion","SerialNo="+serialNo);
		if (sReturn == "true") {
			alert("审核岗还未签署意见！");
			return; 
		} 
		AsControl.PopComp("/BusinessManage/GuarantyManage/MutilOpinionInfo.jsp", "SerialNo="+serialNo+"&RightType=ReadOnly", "", "");
	}
	
	function smt(){
		var cmisApplyNo = getItemValue(0,getRow(),"CMISBTCHAPPLYNO");//申请号
		var EstDestType = "3";//评估目的类型  贷前评估、贷后详细、贷后快速、处置前评估
		var EstMthType = getItemValue(0,getRow(),"EvaluateModel");//评估方法类型
		var PrdNo = "1";//阶段类型
		if("<%=applyStatus%>"=="2" || "<%=approveStatus%>"=="2"){
			PrdNo = "2";
		}
		var InrExtEstType = "1";//内外评
		if(typeof(cmisApplyNo) == "undefined" || cmisApplyNo.length == 0){
			 alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.MutilEvaCheck",
				"checkEvaInfo","CMISApplyNo="+cmisApplyNo+",EstDestType="+EstDestType+",EstMthType="+EstMthType
				+",PrdNo="+PrdNo+",InrExtEstType="+InrExtEstType);
		sReturnValue = sReturn.split("@");
		if (sReturnValue[1] == "000000000000") {
			if(sReturnValue[0] != "1") {
				alert("请完整录入价值评估信息后再提交！");
				return; 
			} 
		} else if(sReturnValue[1] == "021200000002") {
			alert("请进行价值评估后再提交！");
			return; 
		} 
		
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		// 获取签署意见
		var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.MutilEvaCheck",
					"getOpinion","SerialNo="+serialNo);
		// 检查签署意见
		if("<%=applyStatus%>"=="2"){
			if (sReturn == "true") {
				alert("请先签署意见再提交！");
				return; 
			} 
		}
		
		if(sReturn == "01") {
			// 获取估值信息，更新估值表
			if("<%=applyStatus%>"=="2"){
				var getEvaValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.MutilEvaCheck",
						"getEvaValue","CMISApplyNo="+cmisApplyNo+",FlowStatus=1");
			}
		}
		// 提交
		var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.MutilEvaCheck",
				"updateMutilEva","SerialNo="+serialNo+",ApplyStatus=<%=applyStatus%>,ApproveStatus=<%=approveStatus%>,OpinionFlag="+sReturn);
		alert(sReturn);
		
		reloadSelf();
	}
	
</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
