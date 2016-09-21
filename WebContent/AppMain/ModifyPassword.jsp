<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.awe.security.*"%>
<%
	String sPasswordState = CurPage.getParameter("PasswordState");
	if(StringX.isSpace(sPasswordState)) sPasswordState = new UserMarkInfo(Sqlca,CurUser.getUserID()).getPasswordState();
	if(sPasswordState == null) sPasswordState = "";
%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript">
	function checkpassword(){
		sOldPassword  = document.getElementById("oldPassword").value;	
		sNewPassword  = document.getElementById("newPassword").value;	
		sNewPassword2  = document.getElementById("newPassword2").value;	

		var pattern = /^.*[^a-zA-Z0-9!@$*.]{1,}.*$/;
		
		if(sOldPassword==""){
			showMessage("������ԭ��������!");
			return;
		}
		if(sNewPassword=="" && sNewPassword2==""){
			showMessage("�����벻��Ϊ��!");
			return;
		}
		if(sNewPassword != sNewPassword2){
			showMessage("������������벻һ��!");
			return;
		}
		if(pattern.exec(sNewPassword)){
			showMessage("���벻�ܰ�����Сд��ĸ�����ֻ���!@$*.֮����ַ�!");
			return;
		}

		sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.orguser.action.CheckPassword","checkPassword","OldPassword="+sOldPassword+",NewPassword="+sNewPassword+",UserID=<%=CurUser.getUserID()%>");
		if(sReturn != "SUCCEEDED"){
			showMessage(sReturn);
		}else{
			<%if(sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_USER_FIRST_LOGON)) || sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_PWD_OVERDUE))){%>
				showMessage("�����޸ĳɹ��������µ�¼ϵͳ!");
				window.open("<%=sWebRootPath%>/logon.html","_top");
			<%}else{%>
				showMessage("�����޸ĳɹ�!");
			<%}%>
			alert("�����޸ĳɹ�!");
			self.close();
		}
	}

	function showMessage(src){
		var o = document.getElementById("message");
		if(o.flag) window.clearTimeout(o.flag);
		
		o.innerHTML = src;
		o.style.display = "block";
		var flag = setTimeout(function(){
			o.style.display = "none";
			o.flag = "";
		}, 10000);
		o.flag = flag;
	}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>�޸�����</title>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/AppMain/resources/css/page.css"/>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%><%=sSkinPath%>/css/page.css">
</head>
<body scroll="no" bgcolor="#f2f2f2">
	<div class="pwd_main" >
		<p id="message"></p>
		<form id="pass_word">
	        <input type="password" id="oldPassword" />
	        <input type="password" id="newPassword" />
	        <input type="password" id="newPassword2" />
	    </form>
	    <div class="nor_btnzone" >
	    	<table width="100%"><tr>
			<td align="right"><%=new Button("ȷ��","ȷ��","checkpassword()").getHtmlText()%></td><td  align="left">
	<%if(sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_USER_FIRST_LOGON)) || sPasswordState.equals(String.valueOf(SecurityAuditConstants.CODE_PWD_OVERDUE))){
      	out.write(new Button("���µ�¼","ȷ��","window.open('" + sWebRootPath + "/logon.html','_top')").getHtmlText());
	}else{
		out.write(new Button("�ر�","�ر�","self.close()").getHtmlText());
	}%>
      		</td></tr></table>
	    </div>
    </div>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>