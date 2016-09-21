<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.als.ui.function.FunctionWebTools"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	String rightType = CurPage.getParameter("RightType");//权限
	String flag = CurPage.getParameter("Flag");//"0"风险报告上传--未完成 ,"1"--已完成,"2"风险报告查看
	String buttonFlag = CurPage.getParameter("ButtoFlag");//"0"风险报告复核--待处理，"1"--已处理
	
	String templeteNo =  CurPage.getParameter("ListTempleteNo");//模板
	if(StringX.isEmpty(templeteNo)) templeteNo = "DocBusinessObjectDocumentList01";
	BusinessObject inputParameter = SystemHelper.getPageComponentParameters(CurPage);//BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("orgid", CurUser.getOrgID()); 
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(templeteNo, inputParameter, CurPage, request);
	ASDataObject doTemp = dwTemp.getDataObject();
	if("0".equals(flag)){
		doTemp.appendJboWhere(" and O.SortNo is null");
	}else if("2".equals(flag)){
		doTemp.appendJboWhere(" and O.SortNo = '1'");
	}else if("0".equals(buttonFlag)){
		doTemp.appendJboWhere(" and O.SortNo = '0'");
	}else if("1".equals(buttonFlag)){
		doTemp.appendJboWhere(" and (O.SortNo = '1' or O.SortNo = '2')");
	}else{
		doTemp.appendJboWhere(" and (O.SortNo = '0' or O.SortNo = '1' or O.SortNo = '2')");
	}
	
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"false","","Button","新增","新增","newRecord()","","","","",""},
			{"true","","Button","详情","详情","viewFiles()","","","","",""},
			{"false","","Button","删除","删除","deleteRecord()","","","","",""},
			{"false","","Button","报告下载","报告下载","DocumentDownLoad()","","","","",""},
			{"false","","Button","处理","处理","deal()","","","","",""},
	};
	
	if("0".equals(flag)){
		sButtons[0][0] = "true";
		sButtons[2][0] = "true";
		sButtons[3][0] = "false";
	}
	if("2".equals(flag)){
		sButtons[3][0] = "false";
	}
	if("0".equals(buttonFlag)){
		sButtons[1][0] = "false";
		sButtons[4][0] = "true";
	}
	
%> 

<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/BusinessManage/RiskWarningManage/RiskWarningReportManagementInfo.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>","_blank","");
		reloadSelf();
	}

	function deleteRecord(){
		var docNo = getItemValue(0,getRow(),"DocNo");
		var userID = "<%=CurUser.getUserID()%>";
		if (typeof(docNo)=="undefined" || docNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}

		if(confirm(getHtmlMessage(2))){ //您真的想删除该信息吗？
			var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.risk.RiskReportUpload", "getReportStatus", "UserID="+userID+",DocNo="+docNo);
			if(result == "true"){
				as_delete('myiframe0');
			}else{
				alert("不允许删除非本人上传的报告或状态为已完成的报告！");
			}
		}
	}
	
	<%/*~[Describe=查看及修改附件详情;]~*/%>
	function viewFiles(){
		var rightType = "";
		var docNo = getItemValue(0,getRow(),"DocNo");
		var sortNo = getItemValue(0,getRow(),"SortNo");
		if(typeof(sortNo) == "undefined" || sortNo.length == 0 || sortNo == "Null") sortNo="";
		if (typeof(docNo)=="undefined" || docNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		if(sortNo == "1"||sortNo == "2"){
			rightType = "ReadOnly";
		}else{
			rightType = "<%=rightType%>";
		}
		AsControl.OpenView("/BusinessManage/RiskWarningManage/RiskWarningReportManagementInfo.jsp", "ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&DocNo="+docNo+"&RightType="+rightType, "_blank");
	}
	
	function deal(){
		var docNo = getItemValue(0,getRow(),"DocNo");
		AsCredit.openFunction("RiskWarningReport01","DocNo="+docNo+"&RightType=<%=rightType%>&Flag=<%=flag%>&ButtonFlag=<%=buttonFlag%>","");
		reloadSelf();
	}
	
	<%/*~[Describe=报告下载;]~*/%>
	function DocumentDownLoad(){
		
		var docNo = getItemValue(0,getRow(),"DOCNO");
		if (typeof(docNo)=="undefined" || docNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		AsControl.OpenPage("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+docNo+"&RightType=ReadOnly", "frame_list_attechment");
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>