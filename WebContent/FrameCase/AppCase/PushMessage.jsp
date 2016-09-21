
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <script type="text/javascript" src="<%=sWebRootPath%>/FrameCase/AppCase/new_message.js"></script>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/AppMain/resources/css/app_als.css">

<div>

</div>
<br>
<div>
发送人:<input type='text' name='FromUserID' value='test11'/><br>
接收人:<input type='text' name='ToUserID' value='test22'/><br>
发送消息：
<textarea rows="5" cols="40"  id='message'></textarea>
<br>
	<input type='button' value='发送' onClick='javascript:sendMessage()'/> 
</div>
 

<script type="text/javascript">
	
	function sendMessage(){
		var message=document.getElementById("message").value;
		var FromUserID=document.getElementById("FromUserID").value;
		var ToUserID=document.getElementById("ToUserID").value;
		param="FromUserID="+FromUserID+"&ToUserID="+ToUserID+"&Message="+message+"&action=put";
		var sReturn=AsControl.RunJsp("/AppConfig/BoardManage/MessageActionAJAX.jsp",param);
		alert(sReturn);
	}

	 function startMessage(){
		msg=new newMessage("test11");
		msg.start();
		if(msg.messageArray==0){
				setTimeout(startMessage, 1000);
		}
	}

		setTimeout(startMessage, 1000);
</script>

 <%@ include file="/IncludeEnd.jsp"%>