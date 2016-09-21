<%@page import="com.amarsoft.app.awe.config.role.action.RoleManager"%>
<%@page import="com.amarsoft.web.ui.mainmenu.AmarMenu"%>
<%@page import="com.amarsoft.awe.res.AppManager"%>
<%@page import="com.amarsoft.awe.res.MenuManager"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf" %>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath+CurARC.getAttribute("ThemePath")%>/css/main.css">
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
	
	String mainPage = "/Main.jsp";
	
	String lastVisitTime = CurARC.getAttribute("LastSignInTime");
	if(lastVisitTime==null) lastVisitTime="";
	String lastSignOutTime = CurARC.getAttribute("LastSignOutTime");
	if(lastSignOutTime==null) lastSignOutTime="";
	String visitTimes=CurARC.getAttribute("VisitTimes");
	if(visitTimes==null) visitTimes="";
	
	String uiasURL="";
	
	String smflag=CurARC.getAttribute("CurUserSMFlag");
	if("1".equals(smflag)){
		smflag="checked";
	}
	String mailflag=CurARC.getAttribute("CurUserMailFlag");
	if("1".equals(mailflag)){
		mailflag="checked";
	}
	String mobelMessage=CurARC.getAttribute("CurUserMobileTel");
	if(StringX.isEmpty(mobelMessage)) mobelMessage="未设置手机！请登录<a href=\""+uiasURL+"\" target=\"_blank\">"+uiasURL+"</a>，完善信息！";
	else mobelMessage=""+mobelMessage+"<input type=\"checkbox\" id=\"ATTRIBUTE8\" "+smflag+"  onclick=\"changeMessageRight(this)\"><b>短信提醒</b>";
	 
	String emailMessage=CurARC.getAttribute("CurUserEMail");
	if(StringX.isEmpty(emailMessage)) emailMessage="未设置邮箱！请登录<a href=\""+uiasURL+"\"  target=\"_blank\">"+uiasURL+"</a>，完善信息！";
	else emailMessage=""+emailMessage+"<input type=\"checkbox\" id=\"ATTRIBUTE7\" "+mailflag+" onclick=\"changeMessageRight(this)\"><b>邮件提醒</b>";
	
	String userRole="",moreRoleFlag="";
	for(String roleID:CurUser.getRoleTable()){
		if(userRole.length()>20){
			moreRoleFlag="...<a href=\"javascript:void(0);\" onclick=moreRole()><b>更多</b></a>";
			break;
		}
		String roleName = com.amarsoft.dict.als.manage.RoleManager.getRoleName(roleID);
		userRole+=roleName+",";
		
	}
%>
<title><%=sTitle%></title>
<body>
<div class="page_top">
	<div class="logo" ></div>
	<div class="first_menu" >
		
		<span class="InLine" >&nbsp;<span></span></span>
		<span class="InLine" >&nbsp;<span></span></span>
	</div>
	<div class="main_right_menu" >
		<span id="main_right_btn" class="main_right_btn">
			<a href="javascript:void(0);" onclick="AsControl.OpenComp('<%=mainPage%>', '', '_self');" hidefocus="">主页</a>
			<a forid="userinfo" hidefocus="" href="javascript:void(0);" onclick="return false;" 
			onmouseover="userinfo.style.display='block'" onmouseout="userinfo.style.display='none'">我的信息</a>
			<a hidefocus="" href="javascript:void(0);" onclick="sessionOut();return false;">安全退出</a>
		</span>
	</div>
</div>

<div class="function_page">
	<iframe name="FunctionPage" frameborder="0" height="100%" width="100%"></iframe>
</div>
<div class="board"></div>
<div id="userinfo" class="userinfo" onmouseover="userinfo.style.display='block'" onmouseout="userinfo.style.display='none'">
	<table width="100%" align="center" >
		<tr>
			<td height=5px width=30%></td><td ></td>
		</tr>
		<tr height=20px>
			<td align=right valign=top>当前用户：</td>
			<td valign=top valign=top><b><%=CurUser.getUserName()%></b><a hidefocus="" href="javascript:void(0);" onclick="changePsw();return false;">&nbsp&nbsp&nbsp&nbsp&nbsp<font color="blue">修改密码</font></a></td>
		</tr>
		<tr  height=20px>
			<td align=right valign=top>Email：</td>
			<td valign=top><%=emailMessage%></td>
		</tr>
		<tr  height=20px>
			<td align=right valign=top>手机： </td>
			<td valign=top><%=mobelMessage%></td>
		</tr>
		<tr  height=20px>
			<td align=right valign=top>上次登陆：</td>
			<td valign=top><%=lastVisitTime%></td>
		</tr>
		<tr  height=20px>
			<td align=right valign=top>上次退出： </td>
			<td valign=top><%=lastSignOutTime%></td>
		</tr>
		<tr  height=20px>
			<td align=right valign=top>登陆次数： </td>
			<td valign=top ><%=visitTimes%></td>
		</tr>
		<tr  height=20px >
			<td align=right valign=top>我的角色： </td>
			<td valign=top><%=userRole+"   "+moreRoleFlag%></td>
		</tr>
		<tr  height=20px>
			<td align=right valign=top> </td>
			<td></td>
		</tr>
	</table>
</div>
</body>
<%
String sAppID =  CurPage.getParameter("AppID");
String sMenuId = CurPage.getParameter("MenuId");
if(sMenuId == null) sMenuId = "";

if(StringX.isSpace(sAppID)) sAppID = AppManager.getMainAppID();
String sMenuJson = (String)session.getAttribute("ASMenuJSON");
 
if (sMenuJson == null) {
	RoleManager roleManager =new RoleManager();
	AmarMenu menu = roleManager.getMenu(CurUser);
	sMenuJson = menu.getMenuJson();
	session.setAttribute("ASMenuJSON", sMenuJson); // 存入session
}
%>
<script type="text/javascript">
	var menus = <%=sMenuJson%>;
	var sMenuId = "<%=sMenuId%>";
	var index0 = <%=index0%>;
	var index1 = <%=index1%>;
	function test(){
		alert(1);
		alert($(".userinfo").display);
		$(".userinfo").display="block";
	}
	function sessionOut(){
 		if(confirm("确认退出本系统吗？"))
 			AsControl.OpenComp("/AppMain/SignOut.jsp","","_self");
	}
	function changePsw(){
		// 主动修改密码，转到修改密码页面告知密码正常
		AsControl.PopPage("/AppMain/ModifyPassword.jsp","PasswordState=0","dialogHeight=480px;dialogWidth=800px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	function moreRole(){
		var style = "dialogWidth:800px;dialogHeight:680px;resizable:yes;scrollbars:no;status:no;help:no";
		popComp("UserRoleList","/AppConfig/OrgUserManage/UserRoleList.jsp","UserID=<%=CurUser.getUserID()%>",style);
	}
	
	function changeMessageRight(obj){
		var value="";
		if(obj.checked)value="1";
		else value="0";
		var parameterMap={"ObjectType":"jbo.sys.USER_INFO","ObjectNo":"<%=CurUser.getUserID()%>"};
		parameterMap["Attributes"]={};
		parameterMap["Attributes"][obj.id]=value;
		var args=JSON.stringify(parameterMap);
		var result =  AsControl.RunJspOne("/UserAction.jsp?InputParameters="+args);
		return result;
	}
</script>
<script type="text/javascript" src="<%=sWebRootPath+CurARC.getAttribute("ThemePath")%>/js/maintop.js"></script>
<%@ include file="/Frame/resources/include/include_end.jspf" %>