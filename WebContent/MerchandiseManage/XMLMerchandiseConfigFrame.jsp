<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
+
	页面说明: 参数管理列表页面
 */
%>
<%@include file="/Resources/CodeParts/Frame03.jsp"%>
	<%
	//获取FUNCTION传过来的参数
	String xmlFile = CurPage.getParameter("XMLFile");
	String xmlTags = CurPage.getParameter("XMLTags");
	String keys = CurPage.getParameter("Keys");
	%>
<script type="text/javascript">
	//myright.width=250; //设置左边区域宽度
	AsControl.OpenView("/MerchandiseManage/XMLMerchandiseList.jsp","xmlFile="+"<%=xmlFile%>&xmlTags="+"<%=xmlTags%>&keys="+"<%=keys%>","frameleft","");
</script>
<%@ include file="/IncludeEnd.jsp"%>
