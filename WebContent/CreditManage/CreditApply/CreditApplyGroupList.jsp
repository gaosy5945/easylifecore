<%@ page contentType="text/html; charset=GBK"%>
<%@include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	//获得参数：显示模板、客户编号
	String templateNo = CurPage.getParameter("TemplateNo");
	String groupSerialNo = CurPage.getParameter("GroupSerialNo");
	String businessPriority = CurPage.getParameter("BusinessPriority");
	String nonstdIndicator = CurPage.getParameter("NonstdIndicator");
	String accountingOrgID = CurPage.getParameter("AccountingOrgID");
	String applyType = CurPage.getParameter("ApplyType");
	String addSingleFunctionID = CurPage.getParameter("AddSingleFunctionID");
	
	//将空值转化成空字符串
	if(templateNo == null) templateNo = "";	
	

	ASObjectModel doTemp = new ASObjectModel(templateNo,"");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	dwTemp.genHTMLObjectWindow(groupSerialNo);
	
	String sButtons[][] = {
		{"true","","Button","新增","新增","newRecord()","","","",""},
		{"true","","Button","详情","详情","view()","","","",""},
		{"false","","Button","删除","删除所选中的记录","deleteRecord()","","","",""}
	};
	
%><%@include file="/Frame/resources/include/ui/include_list.jspf" %>
<script type="text/javascript">
	function newRecord()
	{
		
		AsCredit.openFunction("<%=addSingleFunctionID%>","ApplyType=<%=applyType%>&SYS_FUNCTIONITEMID=&BusinessPriority=<%=businessPriority%>&NonstdIndicator=<%=nonstdIndicator%>&GroupSerialNo=<%=groupSerialNo%>&AccountingOrgID=<%=accountingOrgID%>","dialogWidth:500px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no");
		reloadSelf();
	}
	
	function view()
	{
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0) return;
		
		AsCredit.openFunction("ApplyInfo","ObjectNo="+serialNo+"&ObjectType=jbo.app.BUSINESS_APPLY");
	}
	
	function deleteRecord(){
		if(confirm(getHtmlMessage('2'))){ //您真的想删除该信息吗？
			var applySerialNo = getItemValue(0,getRow(),"SerialNo");
			var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "updateGroupGCInfo", "ApplySerialNo="+applySerialNo+",GroupSerialNo=<%=groupSerialNo%>");
			if(sReturn == "true")
				as_delete(0);
			else
				alert("删除失败！");
		}
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>