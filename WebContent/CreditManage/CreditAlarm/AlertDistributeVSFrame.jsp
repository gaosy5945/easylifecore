<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = ""; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;已选择分发目标&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "正在打开页面，请稍候...";//默认的内容区文字
	String PG_LEFT_WIDTH = "50%";//默认的treeview宽度

	CurPage.setAttribute("PG_CONTENT_TITLE_LEFT","&nbsp;&nbsp;查询&nbsp;&nbsp;");
	CurPage.setAttribute("PG_CONTNET_TEXT_LEFT","正在打开页面，请稍候...");
	//获得页面参数	
	String sAlertIDString = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlertIDString"));
%><%@include file="/Resources/CodeParts/VerticalSplit04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick(){
		OpenComp("ExampleList","/Frame/CodeExamples/ExampleList.jsp","ComponentName=我的例子&SortNo="+getCurTVItem().id+"&OpenerFunctionName="+getCurTVItem().name,"right");
		setTitle(getCurTVItem().name);
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu(){
	}
	
	function reloadLeftAndRight(){
		left.reloadSelf();
		right.reloadSelf();
	}

	startMenu();
	expandNode('root');
	OpenComp("AlertDistributeUserQuery","/CreditManage/CreditAlarm/UserQueryList.jsp","","left");
	OpenComp("AlertDistributeSelectedUsers","/CreditManage/CreditAlarm/SelectedUserList.jsp","","right");
</script>
<%@ include file="/IncludeEnd.jsp"%>