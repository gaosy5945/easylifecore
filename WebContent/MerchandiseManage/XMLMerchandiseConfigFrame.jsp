<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
+
	ҳ��˵��: ���������б�ҳ��
 */
%>
<%@include file="/Resources/CodeParts/Frame03.jsp"%>
	<%
	//��ȡFUNCTION�������Ĳ���
	String xmlFile = CurPage.getParameter("XMLFile");
	String xmlTags = CurPage.getParameter("XMLTags");
	String keys = CurPage.getParameter("Keys");
	%>
<script type="text/javascript">
	//myright.width=250; //�������������
	AsControl.OpenView("/MerchandiseManage/XMLMerchandiseList.jsp","xmlFile="+"<%=xmlFile%>&xmlTags="+"<%=xmlTags%>&keys="+"<%=keys%>","frameleft","");
</script>
<%@ include file="/IncludeEnd.jsp"%>
