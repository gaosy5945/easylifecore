<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String prjSerialNo = CurComp.getParameter("SerialNo");
	if(prjSerialNo == null) prjSerialNo = "";
%>
<%-- ҳ��˵��: ���������Ϣ --%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	mytoptd.height=300;
	AsControl.OpenView("/ProjectManage/ProjectNewApply/ProjectGuarantyCLUp.jsp","SerialNo="+"<%=prjSerialNo%>","rightup","");
	function OpenInfo(){
		AsControl.OpenView("/ProjectManage/ProjectNewApply/ProjectGuarantyCLUp.jsp","SerialNo="+"<%=prjSerialNo%>","rightup","");
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>