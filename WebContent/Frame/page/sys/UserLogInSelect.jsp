<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="java.util.List"%>
<%@page import="com.amarsoft.are.util.StringFunction"%>
<%@page import="com.amarsoft.app.check.OnLineUserCheck"%>
<%@page import="com.amarsoft.are.util.SpecialTools"%>
<%@page import="com.amarsoft.context.ASUser"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.amarsoft.app.awe.config.role.action.UserLogin"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<html>
<head>
<title>ѡ���¼�����</title>
<%
	String userid="",userName = "";
	BizObject curUserLR =null;
	String sessionID =session.getId();
	List<BizObject> boList =null;
	String sLogInID = session.getAttribute("LogInID").toString();

	if(sLogInID==null){
		throw new Exception("�û�δ��½��");
	}
	String[] users =UserLogin.getUsers(sLogInID);
	String loginOne = CodeManager.getItem("LoginOne", "10").getItemDescribe();
	
	String nextPage="/Main.jsp";
	String   parmete=StringFunction.replace(nextPage,"&","@");
	int localIpUserCount = 0;
	
	//��ȡ��ǰLOGINID�û����ϴε�¼��¼
	boolean bNormalExit=true;
	String curUserIDLR="",curUserNameLR="",curUserOrgNameLR="", timeLR ="",endTimeLR="",ipLR = "",curLoginId="";
	//boList = UserLogin.getCurUserLastRecord(sLogInID, sessionID);
	curUserLR=UserLogin.getCurUserLastEndTime(sLogInID, sessionID);
	BizObject bolast=UserLogin.getCurUserLastLogin(sLogInID, sessionID);
	Map<String,Object> 	map=UserLogin.getSessionUser(application,request,session,sLogInID);
	if(curUserLR!=null){
		endTimeLR= curUserLR.getAttribute("EndTime").getString();
		timeLR= curUserLR.getAttribute("BeginTime").getString();
		ipLR = curUserLR.getAttribute("RemoteAddr").getString();
		sessionID = curUserLR.getAttribute("SessionID").getString();
		curUserIDLR =  curUserLR.getAttribute("UserID").getString();
		curUserNameLR =  curUserLR.getAttribute("UserName").getString();
		curUserOrgNameLR =  curUserLR.getAttribute("OrgName").getString();
		bNormalExit =false;
		if(endTimeLR==null) endTimeLR="";
	}else{
		if(map!=null){
			curLoginId=map.get("LoginID").toString();
			if(curLoginId.equals(sLogInID)){
				sessionID=map.get("sessionid").toString();
				curUserIDLR=map.get("UserID").toString();
				curUserNameLR=map.get("UserName").toString();
				bNormalExit=false;
			}
		}
	}
	if(timeLR==null) timeLR="";
	if(ipLR==null) ipLR="";
	if(sessionID==null) sessionID="";
	
	//��ȡ��ǰIP��ַ��δ�ɹ��˳��û���¼
	String curIP = UserLogin.getIpAddr(request);
	StringBuffer temp=new StringBuffer();
	boolean bexistIp=false;
	 List<BizObject> userLst ;
	 userLst=UserLogin.getCurIPUserList(curIP,sessionID);
	 String curIPUserName = "",curIPUserID="";
	 if(userLst.size()>0){
	 	BizObject bo =userLst.get(0);
		curIPUserName=bo.getAttribute("UserName").getString();
		curIPUserID=bo.getAttribute("UserID").getString();
	    temp.append(bo.getAttribute("SessionID").getString()+"@");
	    localIpUserCount++;
	    bexistIp=true;
	 }else{
		  if(map!=null){
			  	curIPUserID=map.get("IP").toString();
				curLoginId=map.get("LoginID").toString();
				if(curIPUserID.equals(curIP) && !curLoginId.equals(sLogInID)){
					sessionID=map.get("sessionid").toString();
					curIPUserID=map.get("UserID").toString();
					curIPUserName=map.get("UserName").toString();
					bexistIp=true;
				}
			} 
	 }
	 
   Map<String,Object> sessionMap=UserLogin.getSessionInfo(application,request,session);
%>

<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/Frame/page/resources/css/syspage.css"/>
<style type="text/css">

.nor_doc2{
	position:absolute; 
	top:10%;
	left:10%;
	border:1px solid #b9b9b9; 
	width:80%;
	height:50%;
	margin-top:50px;
	text-align:right;
	background-color:#fff;
}

</style>
</head>

<body  id="welcome" style="padding-top:50px;">
<div class="nor_doc2">
	 
	 <%
	 out.print("  <div id='freamBody' style='margin:0 auto;	width:100%;height:90%;text-align:left;'>");
	 out.print(" <div id='top'><div id='logo' style='font-weight:bold;margin-left:80px;font-size:14px;font-color:blue;margin-top:40px;'><img src='"+sWebRootPath+sSkinPath+"/images/logo.gif' />��˶��Ϣ</div></div>");
	 out.print(" <div style='font-weight:;margin-left:260px;font-size:14px'> 		") ;
	 out.print("<span style=\"font-weight:bold;font-size:16px;\">"+sLogInID+"</span>�����ã�<br>");
		    		if(bolast!=null) {
		    			out.print("<br /><br /><br />����һ����"+bolast.getAttribute("UserName").getString()+"("+bolast.getAttribute("UserID").getString()+")��ݵ�¼��ϵͳ");
		    			out.print("	 ��¼ʱ��Ϊ"+bolast.getAttribute("BeginTime").getString()+"����¼IP��ַΪ"+bolast.getAttribute("RemoteAddr").getString()+"��");
		    		}
		    		
		    		if(false){
		    			out.print("����ʹ�û�û�������˳�����<a style=\"font-weight:bold;font-size:16px;font-color:red;\" color=\"#afcce7;\" onclick=\"javascript:checkOut($(this));\"");
		    			out.print("sessionID='"+sessionID+"' userid='"+curUserIDLR+"'  href='#'><font color=red>ǩ��</font></a>");
		    			out.print("<br /><br /><br /> Ϊ�˱�֤�������ݰ�ȫ��ϵͳ�������ܣ�ǿ�ҽ�������������˳�ϵͳ��");
		    		} 
	    		
		    		if(false){
		    			out.print("�õ������Ѿ���¼���û�("+sessionMap.get("UserName").toString()+")����<a style=\"font-weight:bold;font-size:16px;font-color:red;\" color=\"#afcce7;\" onclick=\"javascript:checkOut($(this));\"");
		    			out.print("sessionID='"+sessionMap.get("sessionid").toString()+"' userid='"+curUserIDLR+"'  href='#'><font color=red>ǩ��</font></a>");
		    		}
		    		if(users.length>2)
		    		{
		    			
		    			out.print("</br></br>���Ŀ�ѡ������£���ѡ�����ϵͳ</br>");
		    			 for(int i = 0; i < users.length - 1; i += 2){
							//ȡ��ǰ�û��ͻ�������������� Session 
							out.print("<div><input type='radio' name ='roleRadio' value='"+users[i]+"'  />"+users[i + 1]+"</div>");
		    			 }
		    		}
		    		if(false){
		    			out.print("<br /><br />"); 
		    			out.print("��ǰ������,�û�<span style=\"font-weight:bold;font-size:16px;\">"+curIPUserName+"("+curIPUserID+")</span>�ѵ�¼��������ʹ�ý���ʹ���˳���");
		    		} 
	    			out.print("<br /><br />");
	    			out.print("ϵͳ������ѷֱ��ʣ�1280*1024");
	    			out.print("<br /><br />");
				   out.print("</div></div>");
				String sButtons[][] = {
					   {"true","","Button","����ϵͳ","����ϵͳ","login()",""},
					   {"true","","Button","�޸�����","����","changePWD()",""},
					   {"true","","Button","�˳�ϵͳ","ɾ��","exitSystem()",""}
			};
			
			%>
			<div>
				<%@ include file="/Frame/page/jspf/ui/widget/buttonset_dw.jspf"%>
			</div>
	 	
</div>
</body>
</html>
<script type="text/javascript">
	function checkOut(obj){
		var userid = obj.attr("userid");
		var sessionId = obj.attr("sessionID");
		//sessionID = sessionID.substring(0,sessionID.length-1);
		sessionId = sessionId.split(";")[0];
		var sReturn=RunJspAjax("/AppConfig/OrgUserManage/UserRemove.jsp?sessionId="+sessionId+"&userId="+userid);
		if(typeof(sReturn) != "undefined" &&sReturn != ""){
			alert("ǩ�˳ɹ���");
		}else{
			alert("ǩ��ʧ�ܣ�");
		}
		self.location.reload();
}


	function windowOpen(surl){
		 newwin = window.open("", "_top","scrollbars");
		 if(document.all){
			 newwin.moveTo(0,0);
			 newwin.resizeTo(screen.width,screen.height);
		 }
		 newwin.location = surl;
	}

	function login(){
		var userid ="";
		/* //��ǰLOGINID���ж����ݣ����ȡѡ�е���� */
		if("<%=users.length%>">2) {
			var temp = document.getElementsByName("roleRadio");
			for(var i=0;i<temp.length;i++){
				if(temp[i].checked)
					userid=temp[i].value;
			}
			if(userid == ""){
				alert("��ѡ���¼��ݣ�");
				return;
			}
		}
		//����ǵ����¼���ұ������������û���ʹ�ã��������û�ǿ���˳�
		if(<%=loginOne%>=="2"&&"<%=localIpUserCount%>"!="0"){
				var s=$.ajax({
					  type: "POST",
					  url: "<%=sWebRootPath%>/SystemManage/SynthesisManage/OutOtherUser.jsp",
					   data: encodeURI("SessionOut=<%=temp.toString()%>&CompClientID=<%=sCompClientID%>"),
					   processData: false,
					   async: true,
					   success: function(msg){  
						   msg=trim(msg);
						   if(msg=="SUCCESS"){
							   window.open("<%=sWebRootPath%>/Redirector?ComponentURL=/Frame/page/sys/UserLogIn.jsp&UserID="+userid,"_self");
						   }
					  }
					 }); 
			return;
			}
			window.open("<%=sWebRootPath%>/Redirector?ComponentURL=/Frame/page/sys/UserLogIn.jsp&UserID="+userid,"_self");
	}

	function changePWD(){
		// �����޸����룬ת���޸�����ҳ���֪��������
		//IsLogon��ʾ�Ƿ�һ��ʼ�޸����룬Ϊ1��ʾ��
		AsControl.PopPage("/AppMain/ModifyPassword.jsp","PasswordState=0&IsLogon=1&LoginID=<%=sLogInID%>","dialogHeight=480px;dialogWidth=800px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}

	function exitSystem(){
		
		window.open('<%=sWebRootPath%>/logon.html', '_top');
	}
	//ҳ�����ʱĬ��ѡ�е�һ�����
	$(document).ready(function(){
		$("input[name='roleRadio']").first().attr("checked","checked");
		});
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>