<%@page import="com.amarsoft.awe.res.model.MenuItem"%>
<%@page import="com.amarsoft.awe.res.MenuManager"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/tabs.css">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%><%=sSkinPath%>/css/tabs.css">
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/tabstrip-1.0.js"></script>
<%
	String sMenuIds = CurPage.getParameter("MenuIds");
	String[] aMenuIds = sMenuIds.split("@");
	String sMenuId = CurPage.getParameter("MenuId");
	if(sMenuId == null) sMenuId = aMenuIds[0];
	MenuItem item = MenuManager.getMenuItem(sMenuId);
	String PG_TITLE = CurPage.getParameter("DisplayName"); // 浏览器窗口标题 <title> PG_TITLE </title>
	if(item != null) PG_TITLE = item.getDisplayName();
	
	String PG_CONTENT_TITLE = null; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "1";//默认的treeview宽度
%>
<%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript">
	var tabCompent = new TabStrip("T01", "四级菜单", "tab", "#SecondFrame");
	<%for(String menuId : aMenuIds){
		item = MenuManager.getMenuItem(menuId);
		String sScript = "AsControl.OpenComp('/AppMain/FourMenu.jsp', 'ToDestroyAllComponent=Y&IsMenuItem=Y&MenuIds="+sMenuIds+"&MenuId="+menuId+"', '_top')";
		if(menuId.equals(sMenuId)){
			if(StringX.isSpace(item.getUrl())){%>
				tabCompent.addDataItem("<%=menuId%>", "<%=item.getDisplayName()%>", "", false); // alert(\"菜单地址未配置！\")
			<%continue;}else{
				sScript = "AsControl.OpenComp('"+item.getUrl()+"', '_SYSTEM_MENU_FALG=0&"+item.getUrlParamClear()+"', 'TabContentFrame')";
			}
		}
	%>
	tabCompent.addDataItem("<%=menuId%>", "<%=item.getDisplayName()%>", "<%=sScript%>", true);
	<%}%>
	tabCompent.setSelectedItem("<%=sMenuId%>");
	tabCompent.init();
	
	$(function(){
		$(window).resize(function(){
			$(".tabs_content").height($("#SecondFrame").height()-$(".tabs_button").height()-7);
		}).resize();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>