<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String PG_TITLE = "电话核查任务列表"; // 浏览器窗口标题 <title> PG_TITLE </title>

	ASObjectModel doTemp = new ASObjectModel("ApplyTodoList");
	String status = CurPage.getParameter("Status");
	if(status == null) status="";
	String todoType = CurPage.getParameter("TodoType");
	if(todoType == null) todoType="";
	doTemp.appendJboWhere(" and BA.OperateOrgID like '" + CurOrg.getOrgID() + "%'");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setParameter("Status",status);
	dwTemp.setParameter("TodoType",todoType);
	dwTemp.genHTMLObjectWindow(todoType+","+status);
	
	String sButtons[][] = {
		{"true","All","Button","获取任务","获取任务","add()","","","",""},	
		{"true","All","Button","电核处理","电核处理","deal()","","","",""},	
		{"true","All","Button","删除任务","删除任务","deleteTask()","","","",""}
	};
	
	if(status.equals("02")){
		sButtons[0][0] = "false";
		sButtons[1][3] = "电核详情";
		sButtons[1][4] = "电核详情";
		sButtons[2][0] = "false";
	}
%><%@include file="/Frame/resources/include/ui/include_list.jspf" %>
<script type="text/javascript">
	/*~[Describe=新增;InputParam=后续事件;OutPutParam=无;]~*/
	function add(){
		var sResult = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.AcquireTodoTask", "getTask", "OrgID=<%=CurOrg.getOrgID()%>,UserID=<%=CurUser.getUserID()%>,TodoType=<%=todoType%>");
		reloadSelf();
	}
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function deal(){
		var objectNo = getItemValue(0,getRow(),"TraceObjectNo");
		AsCredit.openFunction("DataEntryDeal05", "ObjectType=jbo.app.BUSINESS_APPLY&ObjectNo="+objectNo+"&Status=<%=status%>");
	}
	
	/*~[Describe=删除;InputParam=后续事件;OutPutParam=无;]~*/
	function deleteTask(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
		    return;
		}
		if(confirm('确实要删除吗?')){
			as_delete(0);
		}
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>