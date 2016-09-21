<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
<%
/*
	Author:  --jqcao 2013.11
	Tester:
	Content: --客户详情树图部分
	Input Param:
		  ObjectNo  ：--客户号
	Output param:
		               
	History Log: 
	
 */
%>
<%/*~END~*/%>
<%
	 //获得页面参数
	 String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
%>


<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	mytoptd.height=500;
	var param = "ObjectNo=<%=sObjectNo%>";
	AsControl.OpenView("/CustomerManage/CustomerInfoTreeFrame.jsp", param, "rightup","");
	AsControl.OpenView("/CustomerManage/CustomerImageTreeFrame.jsp", param, "rightdown","");
</script>	
<%@ include file="/IncludeEnd.jsp"%>
