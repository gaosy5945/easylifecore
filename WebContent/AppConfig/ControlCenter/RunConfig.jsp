<%@page import="com.amarsoft.awe.control.SessionListener"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%Runtime runtime = Runtime.getRuntime();%>
<style>
li{
  margin-left: 20px;
}
</style>
<body class="ListPage" leftmargin="0" topmargin="0" >
<div id="Layer1" style="position:absolute;width:100%; height:100%; z-index:1; overflow: auto">
<div class="strip_tit" >
	<table style='cursor: pointer;border: 1;width: 100%;'>
		<tr bgcolor="#00659C" valign="middle" height="20"> 
			<td><font color="#FFFFFF">&nbsp;&nbsp;运行参数</font></td>
		</tr>
	</table>
</div>
<div class="strip_doc" style="height: 120px;display: block">
	<table style="width: 100%;border: 0;">
        <tr><td>
              <ul><li><strong>CPU:</strong> <%="availableProcessors="+runtime.availableProcessors()%></li></ul>
        </td></tr>
        <tr><td>
              <ul><li><strong>MEM: </strong><%="maxMemory=["+runtime.maxMemory()/1024/1024+"M] freeMemory=[" + runtime.freeMemory()/1024/1024 +"M] totalMemory=[" + runtime.totalMemory()/1024/1024+"M]"%></li></ul>
        </td></tr>
        <tr><td>
              <ul><li><strong>AppServer: </strong><%="ServerInfo=[" + application.getServerInfo() + "] WebAppVersion=[" + application.getMajorVersion() + "." + application.getMinorVersion()+"]"%></li></ul>
        </td></tr>
        <tr><td>
              <ul><li><strong>Context: </strong><%="ContextPath= [" + request.getContextPath() + "] WebRealPath= [" + application.getRealPath("") + "] ContextName = ["+application.getServletContextName()+"]"%></li></ul>
        </td></tr>
        <tr><td>
              <ul><li><strong>Context: </strong><%="ServerName= [" + request.getServerName() + "] ServerPort= [" + request.getServerPort()+ "] RemoteAddr= [" + request.getRemoteAddr()+ "] LocalAddr= [" + request.getLocalAddr()+"] LocalPort= [" + request.getLocalPort()+"]"%></li></ul>
        </td></tr>
        <tr><td>
              <ul><li><strong>Online User: </strong><%="Count = [" + SessionListener.getCount() + "]"%>
<!--           		<a href="#" onclick="javascript:AsDebug.showOnlineUserList();">查看</a> -->
              </li></ul>
        </td></tr>
        <%HashSet sessions = (HashSet) application.getAttribute("sessions");
        if (sessions != null) { %> 
        <tr><td>
              <ul><li><strong>SessionTotal: </strong><%="Count = [" + sessions.size() + "]"%></li></ul>
        </td></tr>
        <%} %>
	</table>
</div>
<div class="strip_tit" >
	<table style='cursor: pointer;border: 1;width: 100%'>
		<tr bgcolor="#00659C" valign="middle" height="20"> 
			<td><font color="#FFFFFF">&nbsp;&nbsp;应用参数</font></td>
		</tr>
	</table>
</div>
<div class="strip_doc" style="height: 120px;display: block">
	<table style="width: 100%;border: 0;">
		<tr> 
			<td width="50%" >
		        <ul><li>RunMode:<strong><%=CurConfig.getConfigure("RunMode")%></strong></li></ul>
		    </td>
		    <td width="50%" >
		        <ul><li>FileSaveMode:<strong><%=CurConfig.getConfigure("FileSaveMode")%></strong> FileNameType:<strong><%=CurConfig.getConfigure("FileNameType")%></strong></li></ul>
		    </td>
		</tr>
		<tr>
		    <td width="50%" >
		        <ul><li>FileSavePath:<strong><%=CurConfig.getConfigure("FileSavePath")%></strong></li></ul>
		    </td>
		    <td width="50%" >
		        <ul><li>WorkDocSavePath:<strong><%=CurConfig.getConfigure("WorkDocSavePath")%></strong></li></ul>
		    </td>
	  	</tr>
	  	<tr> 
		    <td width="50%" colspan="2">
		        <ul><li>基础产品版本:<strong><%=CurConfig.getConfigure("ProductName")%> <%=CurConfig.getConfigure("ProductID")%> <%=CurConfig.getConfigure("ProductVersion")%></strong></li></ul>
		    </td>
	  	</tr>
	  	<tr> 
		    <td width="50%" colspan="2">
		        <ul><li>客户增值版本:<strong><%=CurConfig.getConfigure("ImplementationName")%> <%=CurConfig.getConfigure("ImplementationID")%> <%=CurConfig.getConfigure("ImplementationVersion")%></strong></li></ul>
		    </td>
	  	</tr>
	  	<tr> 
		    <td width="50%" colspan="2">
		        <ul><li>客户:<strong><%=CurConfig.getConfigure("BankName")%></strong></li></ul>
		    </td>
	  	</tr>
	</table>
</div>
</div>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>