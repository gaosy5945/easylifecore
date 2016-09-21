<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBegin.jsp"%>
<%
	/* 
	页面说明： 通过数组定义生成Tab框架页面示例
	*/
	//定义tab数组：
	//参数：0.是否显示, 1.标题，2.URL，3，参数串, 4. Strip高度(默认600px)，5. 是否有关闭按钮(默认无) 6. 是否缓存(默认是)
	String sTabStrip[][] = {
		{"true", "欢迎", "/AppMain/WelcomeToUser.jsp", "","","",""},
		{"true", "待处理", "/DeskTop/WorkTips.jsp", "CompClientID="+sCompClientID, "", "",""},
	};
%>

<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/strip.css">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/tabs.css">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%><%=sSkinPath%>/css/tabs.css">
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/tabstrip-1.0.js"></script>
<%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<script type="text/javascript">

</script>
<%@ include file="/IncludeEnd.jsp"%>