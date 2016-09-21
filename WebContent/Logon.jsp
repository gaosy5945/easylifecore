<%@page import="com.amarsoft.app.base.businessobject.BusinessObject"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObjectManager"%>
<%@page import="com.amarsoft.app.awe.config.role.action.UserLogin"%>
<%@page contentType="text/html; charset=GBK"%><%@
page import="com.amarsoft.are.util.*"%><%@
page import="com.amarsoft.awe.util.*"%><%@
page import="com.amarsoft.context.*"%><%@
page import="com.amarsoft.web.*"%><%@
page import="com.amarsoft.web.dw.*"%><%@
page import="com.amarsoft.awe.*"%><%@
page import="com.amarsoft.awe.control.SessionListener"%><%@
page import="com.amarsoft.awe.control.model.*"%><%@
page import="com.amarsoft.awe.util.*"%><%@
page import="com.amarsoft.awe.Configure"%><%@
page import="com.amarsoft.awe.security.*"%><%@
page import="com.amarsoft.awe.security.pwdrule.*"%><%!
//检验验证码
public boolean vaildCheckCode(HttpServletRequest request) {
	String sCheckCode = request.getParameter("CheckCode");
	String sSaveCheckCode = (String)request.getSession().getAttribute("CheckCode");
	if (sSaveCheckCode==null || sCheckCode==null) return true;
	else if (sCheckCode.equalsIgnoreCase(sSaveCheckCode)) return true;
	else return false;
}

//用户登录检查与密码验证性检查
public boolean vaildUserPassword(HttpServletRequest request, Transaction Sqlca,String sUserID,String sPassword) throws Exception {
    String userName = Sqlca.getString(new SqlObject("select userName from user_info where loginid=:loginId").setParameter("loginId", sUserID));
    LogonUser user = new LogonUser(userName, sUserID, sPassword);
	SecurityAudit securityAudit = new SecurityAudit(user);
	String requestMessage = request.getRemoteAddr() + "," + request.getRemoteHost() + "," + request.getServerName() + "," + request.getServerPort();//将request请求信息拼接一下，传进去
	if(securityAudit.isLogonSuccessful(Sqlca, null, requestMessage)){//目前这步不需要别的登录验证
		//登录成功，还需进一步进行密码验证
		PasswordRuleManager pwm = new PasswordRuleManager();
		IsPasswordOverdueRule isPWDOverdueRule = new IsPasswordOverdueRule(sUserID, SecurityOptionManager.getPWDLimitDays(Sqlca), Sqlca);//该规则只是验证性规则，不是登录成功失败的必要条件
		ALSPWDRules alsRules = new ALSPWDRules(SecurityOptionManager.getRules(Sqlca));
		pwm.addRule(isPWDOverdueRule);//该规则比ALSPWDRules更重要，先添加进去
		pwm.addRule(alsRules);
		securityAudit.isValidateSuccessful(Sqlca, pwm);
		return true;
	}
	else return false;
}
%><%
	if (!vaildCheckCode(request)) {
	%><script type="text/javascript">
		alert("登录失败,验证码检验错误。");
		window.open("index.html","_top");
	</script><%
	return;
	}
	String sLoginID = request.getParameter("LoginID");
	String sLoginIDSelected = "";
	if (sLoginID == null || sLoginID.equals("")) {
		sLoginIDSelected = request.getParameter("LoginIDSelected");
		sLoginID = sLoginIDSelected;
	}
	//用户检查，一个session中运行有一个用户登录
	RuntimeContext CurARC_LOGIN=(RuntimeContext)session.getAttribute("CurARC");
	

	java.util.Enumeration<String> attrs = session.getAttributeNames();
	while (attrs.hasMoreElements()) {session.removeAttribute(attrs.nextElement());}

	Transaction Sqlca = null;
	try {
		//获得传入的参数：用户登录账号、口令、界面风格
		String sPassword = request.getParameter("Password");
		String sScreenWidth = request.getParameter("ScreenWidth");

		Configure CurConfig = Configure.getInstance(application);
		String sWebRootPath = request.getContextPath();
		CurConfig.setContextPath(request.getContextPath());
		Sqlca = new Transaction(CurConfig.getConfigure("DataSource"));
		if (!vaildUserPassword(request, Sqlca, sLoginID, sPassword)) throw new Exception("用户["+sLoginID+"]登录失败:用户密码检验失败");
		
		//取当前用户和机构，并将其放入 Session
		ASUser CurUser = ASUser.getUser(SpecialTools.real2Amarsoft(sLoginID),Sqlca);
		String userID=CurUser.getUserID();
		
		//设置运行上下文参数 CurARC　在IncludeBegin.jsp中使用
		RuntimeContext CurARC = new RuntimeContext();
		CurARC.setAttribute("WebRootPath",sWebRootPath);
		CurARC.setAttribute("ThemePath","/AppMain/themes/spdb");
		CurARC.setAttribute("ScreenWidth",sScreenWidth);
		CurARC.setUser(CurUser);
		CurARC.setAttribute("LoginID", sLoginID);

		UserMarkInfo userMarkInfo = new UserMarkInfo(Sqlca,CurUser.getUserID());
        CurARC.setAttribute("LastSignInTime",userMarkInfo.getLastSignInTime());
        CurARC.setAttribute("LastSignOutTime",userMarkInfo.getLastSignOutTime());
        CurARC.setAttribute("VisitTimes",""+userMarkInfo.getVisitTimes());
        BusinessObject user=BusinessObjectManager.createBusinessObjectManager().loadBusinessObject("jbo.sys.USER_INFO", userID);
        CurARC.setAttribute("CurUserEMail",user.getString("EMail"));
        CurARC.setAttribute("CurUserMobileTel",user.getString("MobileTel"));
        
    	CurARC.setAttribute("CurUserSMFlag",user.getString("Attribute7"));
    	CurARC.setAttribute("CurUserMailFlag",user.getString("Attribute8"));

		CurARC.setCompSession(new ComponentSession());

		session.setAttribute("CurARC",CurARC);
		session.setAttribute("LogInID",sLoginID);
		//用户登陆成功，记录登陆信息
	    SessionListener sessionListener=new SessionListener(request,session,CurUser,CurConfig.getConfigure("DataSource"));
	    session.setAttribute("listener",sessionListener);
%><script type="text/javascript">
<%
		String sPasswordState =  new UserMarkInfo(Sqlca,CurUser.getUserID()).getPasswordState();
		/* 正式使用时请将代码启用密码状态校验 */
		//if(sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_USER_FIRST_LOGON)) || sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_PWD_OVERDUE))){
		if(false){
%>
			window.open("<%=sWebRootPath%>/Redirector?ComponentURL=/AppMain/ModifyPassword.jsp","_top");
<%
		}else{
			String MultiCheck = UserLogin.MultiCheck(Sqlca,sLoginID);
			String curIP = UserLogin.getIpAddr(request);
			String  sessionID = session.getId();
	 
				 //若只有一个身份且上次正常退出且当前机器没有其他用户在使用则直接进入系统主页面 
				if(MultiCheck.equals("Single")){
					String nextPage="/Main.jsp";
					//nextPage = CurARC.getAttribute("ThemePath")+nextPage;
%>
					window.open("<%=sWebRootPath%>/Redirector?ComponentURL=<%=nextPage%>","_self");
<%	  
				}else {%>//多用户登录
					var sStyle = "Height=480px,Width=800px,resizable=yes,scrollbars=no";
					window.open("<%=sWebRootPath%>/Redirector?ComponentURL=/Frame/page/sys/UserLogInSelect.jsp","_self");
					<%			
				}

			} 
%></script>
<%
	} catch (Exception e) {
		e.printStackTrace();
		e.fillInStackTrace();
		e.printStackTrace(new java.io.PrintWriter(System.out));
%>
		<script type="text/javascript">
			alert("登录失败,请检查用户名和密码是否输入正确！\n如果您忘记了密码，请与系统管理员联系，恢复初始密码。");
			window.open("index.html","_top");
		</script>			
<%
		return;
	} finally {
		if(Sqlca!=null) {
			//断掉当前数据连接
			Sqlca.commit();
			Sqlca.disConnect();
			Sqlca = null;
		}
	}
%>