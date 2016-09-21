<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sFolderId = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FolderId"));
	if(null==sFolderId) sFolderId="";
	String sViewId = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewId"));
	if(null==sViewId) sViewId="";
%>
<%-- 页面说明: 示例上下框架页面 --%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	showChangeBtn();
	//AsControl.OpenView("/FrameCase/ExampleList06.jsp","","rightup","");
	//AsControl.OpenView("/DocManage/DocViewConfig/DocViewList.jsp","","rightup","");
	<%-- if("<%=sFolderId%>"=="" || null == "<%=sFolderId%>"){
		AsControl.OpenView("/DocManage/DocViewConfig/DocViewFileList.jsp","FolderId="+sFolderId+"&ViewId="+sViewId,"rightdown","");
	} else {
		AsControl.OpenView("/DocManage/DocViewConfig/DocViewFileList.jsp","","rightdown","");
	} --%>
	
	//var sPara = "FolderId="+sFolderId+"&ViewId="+sViewId;
	openChildComp("/DocManage/DocViewConfig/DocViewFileList.jsp", "","","");
</script>
<%@ include file="/IncludeEnd.jsp"%>