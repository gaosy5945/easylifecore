
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<%@ page contentType="text/html; charset=GBK"%>
<style>
	table{
		background-color: #FFCC00;
	}
	.tr_class{
		background-color: #FFFF00;
	}.tr_class2{
		background-color: #FFFFFF;
	}
</style>
<table >
  <tr>
    <th>用户编号</th>
    <th>用户名称</th>
    <th>所属机构</th>
    <th>IP地址</th>
    <th>登录时间</th>
    <th>sessionID</th>
  </tr>
   

<%

	HashMap userPool = (HashMap)application.getAttribute("ACTIVE_USER_POOL");
	if(userPool!=null){
		int i=0;
		  for(Iterator<String> it=userPool.keySet().iterator();it.hasNext();){
			  String key=it.next();
			  Map<String,Object> map=(Map<String,Object>)userPool.get(key);
			 if(i%2==0) out.print("<tr class='tr_class'>");
			 else out.print("<tr class='tr_class2'>");
			  out.print("<td>"+map.get("UserID")+"</td>");
			  out.print("<td>"+map.get("UserName")+"</td>");
			  out.print("<td>"+map.get("OrgName")+"</td>");
			  out.print("<td>"+map.get("IP")+"</td>");
			  out.print("<td>"+map.get("EntryTime")+"</td>");
			  out.print("<td>"+map.get("sessionid")+"</td>");
			  out.print("</tr>");
			  i++;
		  }
		
	}

%>
</table>