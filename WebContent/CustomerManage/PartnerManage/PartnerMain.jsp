<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//ȡϵͳ����
	String sImplementationName = CurConfig.getConfigure("ImplementationName");
	if (sImplementationName == null) sImplementationName = "";

	/*
	ҳ��˵��:ʾ��ģ����ҳ��
	*/
	String PG_TITLE = sImplementationName; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = null; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "1";//Ĭ�ϵ�treeview���
%>
<%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript">
	AsControl.OpenComp("/CustomerManage/PartnerManage/ProjectQueryList.jsp","","right");
</script>
<%@ include file="/IncludeEnd.jsp"%>