<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBegin.jsp"%>
<%
	/* 
	ҳ��˵���� ͨ�����鶨������Tab���ҳ��ʾ��
	*/
	//����tab���飺
	//������0.�Ƿ���ʾ, 1.���⣬2.URL��3��������, 4. Strip�߶�(Ĭ��600px)��5. �Ƿ��йرհ�ť(Ĭ����) 6. �Ƿ񻺴�(Ĭ����)
	String sTabStrip[][] = {
		{"true", "��ӭ", "/AppMain/WelcomeToUser.jsp", "","","",""},
		{"true", "������", "/DeskTop/WorkTips.jsp", "CompClientID="+sCompClientID, "", "",""},
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