<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String CustomerID = CurPage.getParameter("CustomerID");
	if(CustomerID == null) CustomerID = "";
	String ProjectSerialNo = CurPage.getParameter("ProjectSerialNo");
	if(ProjectSerialNo == null) ProjectSerialNo = "";
%>
<%-- 页面说明: 示例上下框架页面 --%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	mytoptd.height=350;
	OpenList();
 	function OpenList(){
		AsControl.OpenView("/ProjectManage/ProjectAlterNewApply/ProjectMerge.jsp","CustomerID="+"<%=CustomerID%>","rightup","");
 	}
 	
	function OpenInfo(prjSerialNo){
		AsControl.OpenView("/ProjectManage/ProjectAlterNewApply/ProjectMergeBuisnessDetail.jsp", "SerialNo="+prjSerialNo+"&ProjectSerialNo="+"<%=ProjectSerialNo%>", "rightdown");
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>