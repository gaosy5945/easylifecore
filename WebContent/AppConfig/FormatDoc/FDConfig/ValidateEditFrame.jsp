<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
/*
	Content: ���¿��ҳ��, �ϲ�����֤�����б�
 */
 	String sDono = CurPage.getParameter("Dono");
	if(sDono == null) sDono = "";
%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">
	setDialogTitle("��֤��������");
	AsControl.OpenView("/AppConfig/FormatDoc/FDConfig/ValidateList.jsp","Dono=<%=sDono%>","rightup","");
</script>	
<%@ include file="/IncludeEnd.jsp"%>