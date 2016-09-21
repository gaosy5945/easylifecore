<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 在线用户

<%@page import="com.amarsoft.app.als.sys.user.CheckUserAction"%><table>
  <tr>
    <th>客户编号</th>
    <th>IP地址</th>
    <th>访问地址</th> 
    <th>操作</th> 
  </tr>

 <%
 
 		String action=CurPage.getParameter("action");
 		if(action==null) action="";
 		String userId=CurPage.getParameter("UserID");
 		session.getAttribute("a") ;
 		HashMap userPool = (HashMap)application.getAttribute("ACTIVE_USER_POOL");
 		if(userPool!=null){
 			if(action.equals("checkout")){
 					CheckUserAction.removeSession(application,request,session,userId);
	 		 }
 			for(Iterator<String> it=userPool.keySet().iterator();it.hasNext();){
 				String key=it.next();
 				Map<String,Object> map=(Map<String,Object>)userPool.get(key);
 				out.print("<tr>");
 				out.print("<td>"+key+"</td>");
 				out.print("<td>"+map.get("IP")+"</td>");
 				out.print("<td>"+map.get("host")+"</td>"); 
 				out.print("<td ><a href='#' onClick='javascript:checkOut(\""+key+"\")'>签退</a></td>"); 
 				out.print("</tr>");
 			}
 		}
 	
 %>
</table>
 <script type="text/javascript">
	function checkOut(userId){
		OpenPage("/UserCheckList.jsp?action=checkout&UserID="+userId,"_self")
	}
	action="<%=action%>";
	if(action=="checkout"){
		alert("签退成功!");
	}
</script>
 
<%@ include file="/IncludeEnd.jsp"%>