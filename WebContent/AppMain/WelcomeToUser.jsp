<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: ��ҳ��
		Input Param:
			          
		Output param:
			      
		History Log: 2005/10/15 zywei �����û����밲ȫ��ƹ���
	 */
	%>
<%/*~END~*/%>
<%
	String [] sysdate = com.amarsoft.app.base.util.DateHelper.getBusinessDate().split("/");
	String sysdateFormat = sysdate[0]+"��"+sysdate[1]+"��"+sysdate[2]+"��";
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
	<title>Welcome ��ӭ����</title>
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
					<span><b>���ã�&nbsp<%=CurUser.getUserName()%></b></span>
				</td>
			</tr>
			<tr>
				<td align="left" colspan="2">
					<br/><br/><br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<span><b>��ӭ�����������Ŵ�����ϵͳ��</b></span>
				</td>
			</tr>
			<tr>
				<td align="left" colspan="2">
					<br/><br/><br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<span><b>ף�����彡����������죡</b></span>
				</td>
			</tr>
			<tr>
				<td align="left" colspan="2">
					<br/><br/><br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<span><b>��ǰϵͳʱ��Ϊ��<%=sysdateFormat%>&nbsp;<label id="timeShow"></lable></b></span>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>
<script type="text/javascript">
var t = null;
t = setTimeout(time,1000);//��ʼִ��
function time()
{
   clearTimeout(t);//�����ʱ��
   dt = new Date();
   var h=dt.getHours();
   if (h <= 9) h="0"+h;
   var m=dt.getMinutes();
   if (m <= 9) m="0"+m;
   var s=dt.getSeconds();
   if (s <= 9) s="0"+s;
   document.getElementById("timeShow").innerHTML =  h+":"+m+":"+s;
   t = setTimeout(time,1000); //�趨��ʱ����ѭ��ִ��
 } 
</script>
<!-------------------------------->
<%@ include file="/IncludeEnd.jsp"%>
