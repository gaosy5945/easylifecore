<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "系统警示信息";
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;"+PG_TITLE+"&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"系统警示信息","right");
	tviTemp.TriggerClickEvent=true;
 	tviTemp.insertPage("0010", "root", "未处理的Java常用异常", "", "", 1);
 	tviTemp.insertPage("0020", "root", "ARE系统信息代码", "", "", 2);
 	tviTemp.insertPage("0030", "root", "AWE系统信息代码", "", "", 3);
 	tviTemp.insertPage("0040", "root", "DataWindow信息代码", "", "", 4);
 	tviTemp.insertPage("0050", "root", "业务层面信息代码", "", "", 5);
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		AsControl.OpenView("/AppConfig/WarnMessage/WarnMsgList.jsp","MsgType="+sCurItemID,"right");
		setTitle(getCurTVItem().name);
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItem("0010");
	}
		
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>