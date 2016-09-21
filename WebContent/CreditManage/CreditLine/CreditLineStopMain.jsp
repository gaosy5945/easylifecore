<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "授信额度终止"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;授信额度终止&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"授信额度终止","right");
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	//定义树图结构
	tviTemp.insertPage("root","有效的授信额度列表","",1);
	tviTemp.insertPage("root","已终止的授信额度列表","",2);
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript">
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick(){
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=='有效的授信额度列表'){
			OpenComp("CreditLineStopList","/CreditManage/CreditLine/CreditLineStopList.jsp","StopFlag=1","right");
		}
		if(sCurItemname=='已终止的授信额度列表'){
			OpenComp("CreditLineStopList","/CreditManage/CreditLine/CreditLineStopList.jsp","StopFlag=2","right");
		}
		setTitle(getCurTVItem().name);
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	startMenu();
	expandNode('root');	
	selectItemByName('有效的授信额度列表');
</script>
<%@ include file="/IncludeEnd.jsp"%>