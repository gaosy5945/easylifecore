<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%
	String sObjectNo = CurPage.getParameter("ObjectNo");
%>
<div>
<%=new Button("上一步", "", "parent.wizard.toPrevStep()").getHtmlText()%>
<%=new Button("下一步", "", "parent.wizard.toNextStep()").getHtmlText()%>
</div>
<div>
	<span>对象编号：</span><span><%=sObjectNo%></span>
</div>
<%@ include file="/Frame/resources/include/include_end.jspf"%>