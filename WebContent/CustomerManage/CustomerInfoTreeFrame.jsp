<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��:ʾ��������Ϣ�鿴ҳ��
	 */
	String PG_TITLE = "�ͻ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�ͻ�����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "1";//Ĭ�ϵ�treeview���

	//���ҳ�����
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if( sObjectNo == null ) sObjectNo = "";

%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	var param = "ObjectNo=<%=sObjectNo%>";
	AsControl.OpenView("/CustomerManage/CustomerInfoTree.jsp", param, "right","");
</script>
<%@ include file="/IncludeEnd.jsp"%>
