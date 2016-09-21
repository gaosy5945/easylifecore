<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	/*
		Describe: 添加重点信息链接中
		Input Param:
			ObjectType：信息类型
			ObjectNo：信息代码
	 */
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo   = CurPage.getParameter("ObjectNo");
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	
   	String sSql = " select ObjectType,UserID,ObjectNo from USER_DEFINEINFO "+
		          " where UserID ='"+CurUser.getUserID()+"' and ObjectType='"+sObjectType+"' and ObjectNo='"+sObjectNo+"'";
   ASResultSet rs = Sqlca.getResultSet(sSql);
   if(rs.next()){
%>
<script type="text/javascript">
	 alert(getMessageText("ALS70242"));	
	 self.close();
</script>
<%
   }else{
	    Sqlca.executeSQL(" insert into USER_DEFINEINFO(UserID,ObjectType,ObjectNo) values('"+CurUser.getUserID()+"','"+sObjectType+"','"+sObjectNo+"') ");		
%>
<script type="text/javascript">
	alert(getMessageText("ALS70243"));	
	self.close();
</script>
<%	
    }
	rs.getStatement().close();
%>
<%@ include file="/IncludeEnd.jsp"%>