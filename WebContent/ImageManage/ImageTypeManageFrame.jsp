<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	页面说明: 示例上下框架页面
 */
 
	//获得页面参数
	String sType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));
 	String sStartWithId = CurComp.getParameter("StartWithId");
 	
%><%@include file="/Resources/CodeParts/Frame03.jsp"%>
<script type="text/javascript">	
	myleft.width=400;
	//var param = "Type=<%=sType%>";
	var param = "StartWithId=<%=sStartWithId%>";
	OpenComp("ImageTypeTreePreview","/ImageManage/ImageTypeTreePreview.jsp", param, "frameleft","");
	OpenComp("ImageTypeList","/ImageManage/ImageTypeList.jsp",param, "frameright","");
</script>
<%@ include file="/IncludeEnd.jsp"%>
