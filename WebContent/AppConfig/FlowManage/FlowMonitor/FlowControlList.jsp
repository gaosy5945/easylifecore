<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Describe: 流程监控列表
	 */
	String PG_TITLE = "<font color=red>本页面数据量较大，请通过查询条件查询</font>@PageTitle";
	String sApproveNeed = CurConfig.getConfigure("ApproveNeed");//获取业务是否要走最终审批意见的流程的标志
	
	//获得页面参数: FlowStatus：01在办业务 02办结业务
  	String sFlowStatus =  CurPage.getParameter("FlowStatus");  
	if(sFlowStatus == null) sFlowStatus = "";

	ASDataObject doTemp = new ASDataObject("FlowControlList",Sqlca);
	doTemp.WhereClause += " and OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%') ";
	if(sFlowStatus.equals("01"))
		doTemp.WhereClause += " and PhaseNo not in ('1000','8000') " ;
	else
		doTemp.WhereClause += " and PhaseNo in ('1000','8000') " ;
	//设置Filter		
	doTemp.setFilter(Sqlca,"1","FlowName","Operators=EqualsString;HtmlTemplate=PopSelect");
	doTemp.setFilter(Sqlca,"2","PhaseName","Operators=EqualsString;HtmlTemplate=PopSelect");
	doTemp.setFilter(Sqlca,"3","ObjectNo","Operators=EqualsString,Contains,BeginsWith,EndWith;");
	doTemp.setFilter(Sqlca,"4","UserName","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"5","OrgName","Operators=EqualsString;HtmlTemplate=PopSelect");
	doTemp.setFilter(Sqlca,"6","InputDate","HtmlTemplate=Date;Operators=BeginsWith,EndWith,BetweenString;");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","详情","详情","ViewDetail()","","","",""},
		{"true","","Button","查看意见","查看意见","ViewOpinion()","","","",""},
		{"true","","Button","流转记录","流转记录","ChangeFlow()","","","",""},
		{"false","","Button","业务移交","业务移交","BizTransfer()","","","",""}
	};
	
	if(sFlowStatus.equals("01")){
		sButtons[3][0] = "true";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function ViewDetail(){
		var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType   = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			paraString = RunMethod("WorkFlowEngine","GetFlowParaString",sObjectType+","+sObjectNo+",FlowDetailPara");
			paraList = paraString.split("@");
			popComp(paraList[1],paraList[0],paraList[2],"");
		}
	}

	function ViewOpinion(){
		var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType   = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			paraString = RunMethod("WorkFlowEngine","GetFlowParaString",sObjectType+","+sObjectNo+",FlowOpinionPara");
			paraList = paraString.split("@");
			popComp(paraList[1],paraList[0],paraList[2],"");
		}
	}
	
	<%/*~[Describe=流转记录;]~*/%>
	function ChangeFlow(){
		var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType   = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			popComp("FlowChangeList","/AppConfig/FlowManage/FlowMonitor/FlowChangeList.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&FlowStatus="+"<%=sFlowStatus%>","");
			reloadSelf();
		}
	}

	<%/*~[Describe=业务移交;]~*/%>
	function BizTransfer(){
		var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType   = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			sParaStr = "SortNo,"+"<%=CurOrg.getSortNo()%>";
			sReturn= setObjectValue("SelectUserInOrg",sParaStr,"",0,0);	
			if(typeof(sReturn) != "undefined" && sReturn.length != 0 ){
				sReturn = sReturn.split('@');
				sUserID = sReturn[0];
				RunMethod("WorkFlowEngine","ChangeFlowOperator",sObjectNo+","+sObjectType+","+sUserID);
				alert("当前业务已移交给用户 "+sUserID);
				reloadSelf();
			}
		}  
	}

	<%/*~[Describe=查询条件弹出对话框;]~*/%>
	function filterAction(sObjectID,sFilterID,sObjectID2){
		var oMyObj2 = document.getElementById(sObjectID);
		var oMyObj = document.getElementById(sObjectID2);
		if(sFilterID=="1"){
			var sApproveNeed = "<%=sApproveNeed%>";
			if("true" == sApproveNeed){//判断该笔业务是否要走最终审批意见的流程
				sParaString = "CodeNo"+","+"FlowObject";
				sReturn =setObjectValue("SelectCode",sParaString,"",0,0,"");
			}else{
				sParaString = "CodeNo"+","+"FlowObject"+","+"Attribute1"+","+"SWITapprove";
				sReturn =setObjectValue("SelectCodeFlowObject",sParaString,"",0,0,"");
			}
			if(typeof(sReturn) == "undefined" || sReturn == "_CANCEL_"){
				return;
			}else if(sReturn == "_CLEAR_"){
				oMyObj.value = "";
				oMyObj2.value = "";
			}else{				
				sReturns = sReturn.split("@");
				oMyObj2.value=sReturns[1];
				oMyObj.value=sReturns[1];
			}
		}else if(sFilterID=="2"){		
			obj = document.getElementById("1_1_INPUT");
			if(obj.value == ""){
				alert('请先选择流程名称！');
				return;
			}
			sParaString = "FlowName"+","+obj.value;
			sReturn =setObjectValue("SelectPhaseByFlowName",sParaString,"",0,0,"");
			if(typeof(sReturn) == "undefined" || sReturn == "_CANCEL_"){
				return;
			}else if(sReturn == "_CLEAR_"){
				oMyObj.value = "";
				oMyObj2.value = "";
			}else{				
				sReturns = sReturn.split("@");
				oMyObj2.value=sReturns[1];
				oMyObj.value=sReturns[1];
			}
		}else if(sFilterID=="5"){		
			sParaString = "OrgID,<%=CurOrg.getOrgID()%>";
			sReturn =setObjectValue("SelectBelongOrg",sParaString,"",0,0,"");
			alert(sReturn);
			if(typeof(sReturn) == "undefined" || sReturn == "_CANCEL_"){
				return;
			}else if(sReturn == "_CLEAR_"){
				oMyObj.value = "";
				oMyObj2.value = "";
			}else{				
				sReturns = sReturn.split("@");
				oMyObj2.value=sReturns[1];
				oMyObj.value=sReturns[1];
			}
		}
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		//showFilterArea();
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>