<%@page import="com.amarsoft.awe.res.AppManager"%>
<%@ page import="com.amarsoft.web.ui.mainmenu.AmarMenu"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String sMenuId = CurPage.getParameter("MenuId");
	if(sMenuId == null) sMenuId = "";

	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"UI组件导航","right");
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数
	
	ArrayList<String> ExcludeIDs = new ArrayList<String>();
	AmarMenu menu = new AmarMenu(CurUser, AppManager.getMainAppID(), ExcludeIDs);
	menu.fillMenu(tviTemp);
	
	String sButtons[][] = {
	};
%><%@include file="/Resources/CodeParts/View07.jsp"%>
<script type="text/javascript">
function startMenu(){
	<%=tviTemp.generateHTMLTreeView()%>
	expandNode('root');
	selectItem('<%=sMenuId%>');
}
function TreeViewOnClick(){}
function TreeViewOnDBLClick(){
	doSure();
}
function doSure(){
	var node = getCurTVItem();
	if(node.type == "folder"){
		alert("请选择末端功能菜单！");
		return;
	}
	top.returnValue = node.id+"@"+node.name;
	top.close();
}
startMenu();
</script>
<%@ include file="/IncludeEnd.jsp"%>