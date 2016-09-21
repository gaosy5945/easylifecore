<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明:示例对象信息查看页面
	 */
	String PG_TITLE = "客户详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;客户详情&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "1";//默认的treeview宽度

	//获得页面参数
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if( sObjectNo == null ) sObjectNo = "";

%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	var param = "ObjectNo=<%=sObjectNo%>";
	AsControl.OpenView("/CustomerManage/CustomerInfoTree.jsp", param, "right","");
</script>
<%@ include file="/IncludeEnd.jsp"%>
