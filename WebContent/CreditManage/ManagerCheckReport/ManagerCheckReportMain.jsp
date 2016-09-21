<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "管理检查报告"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;管理检查报告&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"管理检查报告","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
	int iTreeNode=1;

	//定义树图结构
	tviTemp.insertPage("root","未完成的管理检查报告","Unfinished","",iTreeNode++);
	tviTemp.insertPage("root","已完成的管理检查报告","Finished","",iTreeNode++);
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick(){
		sAction = getCurTVItem().value;
		if(sAction=="Unfinished"){
			OpenComp("ManagerCheckReportList","/CreditManage/ManagerCheckReport/ManagerCheckReportList.jsp","Status=Unfinished&ComponentName=管理检查报告&Status="+getCurTVItem().id+"&OpenerFunctionName="+getCurTVItem().name,"right");
		}else if(sAction=="Finished"){
			OpenComp("ManagerCheckReportList","/CreditManage/ManagerCheckReport/ManagerCheckReportList.jsp","Status=Finished&ComponentName=管理检查报告&Status="+getCurTVItem().id+"&OpenerFunctionName="+getCurTVItem().name,"right");
		}else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
	
	startMenu();
	expandNode('root');		
</script>
<%@ include file="/IncludeEnd.jsp"%>