<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: 主页面
		Input Param:
			          
		Output param:
			      
		History Log: 2005/10/15 zywei 增加用户密码安全审计功能
	 */
	%>
<%/*~END~*/%>
<%
	String [] sysdate = com.amarsoft.app.base.util.DateHelper.getBusinessDate().split("/");
	String sysdateFormat = sysdate[0]+"年"+sysdate[1]+"月"+sysdate[2]+"日";
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
	<title>Welcome 欢迎界面</title>
	<link rel="stylesheet" href="<%=sWebRootPath%>/AppMain/resources/css/welcome.css">
	<link rel="stylesheet" href="<%=sWebRootPath%><%=sSkinPath%>/css/welcome.css">
	<link rel="stylesheet" href="<%=sWebRootPath%>/AppMain/resources/css/worktips.css">
	<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%><%=sSkinPath%>/css/worktips.css">
</head>
<body  class="pagebackground" leftmargin="0" topmargin="0" id="mybody" style="background:transparent;">
	<div id="WindowDiv">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" >
			<tr>
				<td align="left" colspan="2">
					<br/><br/><br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<span><b>您好！&nbsp<%=CurUser.getUserName()%></b></span>
				</td>
			</tr>
			<tr>
				<td align="left" colspan="2">
					<br/><br/><br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<span><b>欢迎您进入消费信贷服务系统！</b></span>
				</td>
			</tr>
			<tr>
				<td align="left" colspan="2">
					<br/><br/><br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<span><b>祝您身体健康，工作愉快！</b></span>
				</td>
			</tr>
			<tr>
				<td align="left" colspan="2">
					<br/><br/><br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<span><b>当前系统时间为：<%=sysdateFormat%>&nbsp;<label id="timeShow"></lable></b></span>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>
<script type="text/javascript">
var t = null;
t = setTimeout(time,1000);//开始执行
function time()
{
   clearTimeout(t);//清除定时器
   dt = new Date();
   var h=dt.getHours();
   if (h <= 9) h="0"+h;
   var m=dt.getMinutes();
   if (m <= 9) m="0"+m;
   var s=dt.getSeconds();
   if (s <= 9) s="0"+s;
   document.getElementById("timeShow").innerHTML =  h+":"+m+":"+s;
   t = setTimeout(time,1000); //设定定时器，循环执行
 } 
</script>
<!-------------------------------->
<%@ include file="/IncludeEnd.jsp"%>
