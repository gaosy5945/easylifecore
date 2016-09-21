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
//������֤��
public boolean vaildCheckCode(HttpServletRequest request) {
	String sCheckCode = request.getParameter("CheckCode");
	String sSaveCheckCode = (String)request.getSession().getAttribute("CheckCode");
	if (sSaveCheckCode==null || sCheckCode==null) return true;
	else if (sCheckCode.equalsIgnoreCase(sSaveCheckCode)) return true;
	else return false;
}

//�û���¼�����������֤�Լ��
public boolean vaildUserPassword(HttpServletRequest request, Transaction Sqlca,String sUserID,String sPassword) throws Exception {
    String userName = Sqlca.getString(new SqlObject("select userName from user_info where loginid=:loginId").setParameter("loginId", sUserID));
    LogonUser user = new LogonUser(userName, sUserID, sPassword);
	SecurityAudit securityAudit = new SecurityAudit(user);
	String requestMessage = request.getRemoteAddr() + "," + request.getRemoteHost() + "," + request.getServerName() + "," + request.getServerPort();//��request������Ϣƴ��һ�£�����ȥ
	if(securityAudit.isLogonSuccessful(Sqlca, null, requestMessage)){//Ŀǰ�ⲽ����Ҫ��ĵ�¼��֤
		//��¼�ɹ��������һ������������֤
		PasswordRuleManager pwm = new PasswordRuleManager();
		IsPasswordOverdueRule isPWDOverdueRule = new IsPasswordOverdueRule(sUserID, SecurityOptionManager.getPWDLimitDays(Sqlca), Sqlca);//�ù���ֻ����֤�Թ��򣬲��ǵ�¼�ɹ�ʧ�ܵı�Ҫ����
		ALSPWDRules alsRules = new ALSPWDRules(SecurityOptionManager.getRules(Sqlca));
		pwm.addRule(isPWDOverdueRule);//�ù����ALSPWDRules����Ҫ������ӽ�ȥ
		pwm.addRule(alsRules);
		securityAudit.isValidateSuccessful(Sqlca, pwm);
		return true;
	}
	else return false;
}
%><%
	if (!vaildCheckCode(request)) {
	%><script type="text/javascript">
		alert("��¼ʧ��,��֤��������");
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
	//�û���飬һ��session��������һ���û���¼
	RuntimeContext CurARC_LOGIN=(RuntimeContext)session.getAttribute("CurARC");
	

	java.util.Enumeration<String> attrs = session.getAttributeNames();
	while (attrs.hasMoreElements()) {session.removeAttribute(attrs.nextElement());}

	Transaction Sqlca = null;
	try {
		//��ô���Ĳ������û���¼�˺š����������
		String sPassword = request.getParameter("Password");
		String sScreenWidth = request.getParameter("ScreenWidth");

		Configure CurConfig = Configure.getInstance(application);
		String sWebRootPath = request.getContextPath();
		CurConfig.setContextPath(request.getContextPath());
		Sqlca = new Transaction(CurConfig.getConfigure("DataSource"));
		if (!vaildUserPassword(request, Sqlca, sLoginID, sPassword)) throw new Exception("�û�["+sLoginID+"]��¼ʧ��:�û��������ʧ��");
		
		//ȡ��ǰ�û��ͻ�������������� Session
		ASUser CurUser = ASUser.getUser(SpecialTools.real2Amarsoft(sLoginID),Sqlca);
		String userID=CurUser.getUserID();
		
		//�������������Ĳ��� CurARC����IncludeBegin.jsp��ʹ��
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
		//�û���½�ɹ�����¼��½��Ϣ
	    SessionListener sessionListener=new SessionListener(request,session,CurUser,CurConfig.getConfigure("DataSource"));
	    session.setAttribute("listener",sessionListener);
%><script type="text/javascript">
<%
		String sPasswordState =  new UserMarkInfo(Sqlca,CurUser.getUserID()).getPasswordState();
		/* ��ʽʹ��ʱ�뽫������������״̬У�� */
		//if(sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_USER_FIRST_LOGON)) || sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_PWD_OVERDUE))){
		if(false){
%>
			window.open("<%=sWebRootPath%>/Redirector?ComponentURL=/AppMain/ModifyPassword.jsp","_top");
<%
		}else{
			String MultiCheck = UserLogin.MultiCheck(Sqlca,sLoginID);
			String curIP = UserLogin.getIpAddr(request);
			String  sessionID = session.getId();
	 
				 //��ֻ��һ��������ϴ������˳��ҵ�ǰ����û�������û���ʹ����ֱ�ӽ���ϵͳ��ҳ�� 
				if(MultiCheck.equals("Single")){
					String nextPage="/Main.jsp";
					//nextPage = CurARC.getAttribute("ThemePath")+nextPage;
%>
					window.open("<%=sWebRootPath%>/Redirector?ComponentURL=<%=nextPage%>","_self");
<%	  
				}else {%>//���û���¼
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
			alert("��¼ʧ��,�����û����������Ƿ�������ȷ��\n��������������룬����ϵͳ����Ա��ϵ���ָ���ʼ���롣");
			window.open("index.html","_top");
		</script>			
<%
		return;
	} finally {
		if(Sqlca!=null) {
			//�ϵ���ǰ��������
			Sqlca.commit();
			Sqlca.disConnect();
			Sqlca = null;
		}
	}
%>