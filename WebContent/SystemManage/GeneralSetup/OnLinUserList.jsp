<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 �����û�

<%@page import="com.amarsoft.app.als.sys.user.CheckUserAction"%><table>
  <tr>
    <th>�ͻ����</th>
    <th>IP��ַ</th>
    <th>���ʵ�ַ</th> 
    <th>����</th> 
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
 				out.print("<td ><a href='#' onClick='javascript:checkOut(\""+key+"\")'>ǩ��</a></td>"); 
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
		alert("ǩ�˳ɹ�!");
	}
</script>
 
<%@ include file="/IncludeEnd.jsp"%>