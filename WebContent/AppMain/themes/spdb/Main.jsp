<%@page import="com.amarsoft.web.ui.mainmenu.AmarMenu"%>
<%@page import="com.amarsoft.awe.res.AppManager"%>
<%@page import="com.amarsoft.awe.res.MenuManager"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf" %>
<link rel="stylesheet" type="text/css" href="./css/main.css">
<%
	String sTitle = CurPage.getParameter("Title");
	if(sTitle == null){
		String sProductName = CurConfig.getConfigure("ProductName");
		if (sProductName == null) sProductName = "";
		String sImplementationVersion = CurConfig.getConfigure("ImplementationVersion");
		if (sImplementationVersion == null) sImplementationVersion = "";
		sTitle = sProductName+"V"+sImplementationVersion;
	}
	int index0 = 1, index1 = 0;
	try{ index0 = Integer.parseInt(CurPage.getParameter("Index0")); }catch(Exception e){}
	if(index0 < 1) index0 = 1;
	try{ index1 = Integer.parseInt(CurPage.getParameter("Index1")); }catch(Exception e){}
	if(index1 < 0) index1 = 0;
	
	String mainPage = CurARC.getAttribute("ThemePath")+"/Main.jsp";
%>
<title><%=sTitle%></title>
<body>
<div class="page_top">
	<div class="logo" ></div>
	<div class="first_menu" >
		<a href="javascript:void(0);" class="InLine" onclick="AsControl.OpenComp('<%=mainPage%>', '', '_self');" >��ҳ</a>
		<span class="InLine" >&nbsp;<span></span></span>
		<span class="InLine" >&nbsp;<span></span></span>
	</div>
	<div class="user_info" >
		<span class="username" >��ӭ��<%=CurUser.getUserName()%></span>
		<a hidefocus class="showaction" href="javascript:void(0);" onclick="return false;" ></a>
		<div class="action" >
			<a hidefocus href="javascript:void(0);" onclick="return false;" >�ҵ���Ϣ</a>
			<a hidefocus href="javascript:void(0);" onclick="ModifyPass();return false;" >�޸�����</a>
			<a hidefocus href="javascript:void(0);" onclick="sessionOut();return false;" >��ȫ�˳�</a>
		</div>
	</div>
</div>
<div class="function_page">
	<div class="sitmap" >&nbsp;</div>
	<iframe name="FunctionPage" frameborder="0" width="100%" ></iframe>
</div>
<div class="board"></div>
<div class="drag">
	<div class="arrow"></div>
</div>
</body>
<%
String sAppID =  CurPage.getParameter("AppID");
String sMenuId = CurPage.getParameter("MenuId");
if(sMenuId == null) sMenuId = "";

if(StringX.isSpace(sAppID)) sAppID = AppManager.getMainAppID();
String sMenuJson = (String)session.getAttribute("ASMenuJSON");

if (sMenuJson == null) {
	ArrayList<String> ExcludeIDs = new ArrayList<String>();
	AmarMenu menu = new AmarMenu(CurUser, sAppID, ExcludeIDs);
	sMenuJson = menu.getMenuJson();
	session.setAttribute("ASMenuJSON", sMenuJson); // ����session
}
%>
<script type="text/javascript">
	var menus = <%=sMenuJson%>;
	var sMenuId = "<%=sMenuId%>";
	var index0 = <%=index0%>;
	var index1 = <%=index1%>;

	function sessionOut(){
 		if(confirm("ȷ���˳���ϵͳ��"))
 			AsControl.OpenComp("/AppMain/SignOut.jsp","","_top");
	}
	
	function ModifyPass(){
		// �����޸����룬ת���޸�����ҳ���֪��������
		AsControl.PopPage("/AppMain/ModifyPassword.jsp","PasswordState=0","dialogHeight=480px;dialogWidth=800px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    }
</script>
<script type="text/javascript" src="<%=CurARC.getAttribute("ThemePath")%>/js/maintop.js"></script>
<%@ include file="/Frame/resources/include/include_end.jspf" %>