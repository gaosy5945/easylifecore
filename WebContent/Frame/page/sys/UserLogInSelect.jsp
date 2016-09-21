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
<title>选择登录的身份</title>
<%
	String userid="",userName = "";
	BizObject curUserLR =null;
	String sessionID =session.getId();
	List<BizObject> boList =null;
	String sLogInID = session.getAttribute("LogInID").toString();

	if(sLogInID==null){
		throw new Exception("用户未登陆！");
	}
	String[] users =UserLogin.getUsers(sLogInID);
	String loginOne = CodeManager.getItem("LoginOne", "10").getItemDescribe();
	
	String nextPage="/Main.jsp";
	String   parmete=StringFunction.replace(nextPage,"&","@");
	int localIpUserCount = 0;
	
	//获取当前LOGINID用户的上次登录记录
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
	
	//获取当前IP地址的未成功退出用户记录
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
	 out.print(" <div id='top'><div id='logo' style='font-weight:bold;margin-left:80px;font-size:14px;font-color:blue;margin-top:40px;'><img src='"+sWebRootPath+sSkinPath+"/images/logo.gif' />安硕信息</div></div>");
	 out.print(" <div style='font-weight:;margin-left:260px;font-size:14px'> 		") ;
	 out.print("<span style=\"font-weight:bold;font-size:16px;\">"+sLogInID+"</span>，您好！<br>");
		    		if(bolast!=null) {
		    			out.print("<br /><br /><br />您上一次以"+bolast.getAttribute("UserName").getString()+"("+bolast.getAttribute("UserID").getString()+")身份登录本系统");
		    			out.print("	 登录时间为"+bolast.getAttribute("BeginTime").getString()+"，登录IP地址为"+bolast.getAttribute("RemoteAddr").getString()+"，");
		    		}
		    		
		    		if(false){
		    			out.print("正在使用或没有正常退出，请<a style=\"font-weight:bold;font-size:16px;font-color:red;\" color=\"#afcce7;\" onclick=\"javascript:checkOut($(this));\"");
		    			out.print("sessionID='"+sessionID+"' userid='"+curUserIDLR+"'  href='#'><font color=red>签退</font></a>");
		    			out.print("<br /><br /><br /> 为了保证您的数据安全和系统运行性能，强烈建议您今后正常退出系统。");
		    		} 
	    		
		    		if(false){
		    			out.print("该电脑上已经登录了用户("+sessionMap.get("UserName").toString()+")，请<a style=\"font-weight:bold;font-size:16px;font-color:red;\" color=\"#afcce7;\" onclick=\"javascript:checkOut($(this));\"");
		    			out.print("sessionID='"+sessionMap.get("sessionid").toString()+"' userid='"+curUserIDLR+"'  href='#'><font color=red>签退</font></a>");
		    		}
		    		if(users.length>2)
		    		{
		    			
		    			out.print("</br></br>您的可选身份如下，请选择进入系统</br>");
		    			 for(int i = 0; i < users.length - 1; i += 2){
							//取当前用户和机构，并将其放入 Session 
							out.print("<div><input type='radio' name ='roleRadio' value='"+users[i]+"'  />"+users[i + 1]+"</div>");
		    			 }
		    		}
		    		if(false){
		    			out.print("<br /><br />"); 
		    			out.print("当前电脑上,用户<span style=\"font-weight:bold;font-size:16px;\">"+curIPUserName+"("+curIPUserID+")</span>已登录，您继续使用将会使其退出！");
		    		} 
	    			out.print("<br /><br />");
	    			out.print("系统建议最佳分辨率：1280*1024");
	    			out.print("<br /><br />");
				   out.print("</div></div>");
				String sButtons[][] = {
					   {"true","","Button","进入系统","进入系统","login()",""},
					   {"true","","Button","修改密码","详情","changePWD()",""},
					   {"true","","Button","退出系统","删除","exitSystem()",""}
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
			alert("签退成功！");
		}else{
			alert("签退失败！");
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
		/* //当前LOGINID若有多个身份，则获取选中的身份 */
		if("<%=users.length%>">2) {
			var temp = document.getElementsByName("roleRadio");
			for(var i=0;i<temp.length;i++){
				if(temp[i].checked)
					userid=temp[i].value;
			}
			if(userid == ""){
				alert("请选择登录身份！");
				return;
			}
		}
		//如果是单点登录，且本机器有其他用户在使用，则将其他用户强制退出
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
		// 主动修改密码，转到修改密码页面告知密码正常
		//IsLogon表示是否一开始修改密码，为1表示是
		AsControl.PopPage("/AppMain/ModifyPassword.jsp","PasswordState=0&IsLogon=1&LoginID=<%=sLogInID%>","dialogHeight=480px;dialogWidth=800px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}

	function exitSystem(){
		
		window.open('<%=sWebRootPath%>/logon.html', '_top');
	}
	//页面加载时默认选中第一个身份
	$(document).ready(function(){
		$("input[name='roleRadio']").first().attr("checked","checked");
		});
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>