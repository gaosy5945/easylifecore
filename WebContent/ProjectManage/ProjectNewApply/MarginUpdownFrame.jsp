<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String ProjectSerialNo=CurPage.getAttribute("SerialNo");
	if(ProjectSerialNo == null) ProjectSerialNo = "";
	String ObjectNo=CurPage.getAttribute("ObjectNo");
	if(ObjectNo == null) ObjectNo = "";
	String Flag=CurPage.getAttribute("Flag");
	if(Flag == null) Flag = "";
	String ProjectType=CurPage.getAttribute("ProjectType");
	if(ProjectType == null) ProjectType = "";
	String CustomerID=CurPage.getAttribute("CustomerID");
	if(CustomerID == null) CustomerID = "";
	String ReadFlag=CurPage.getAttribute("ReadFlag");
	if(ReadFlag == null) ReadFlag = "";
%>
<%-- 页面说明: 示例上下框架页面 --%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	//mytoptd.height=280;
	AsControl.OpenView("/ProjectManage/ProjectNewApply/CLRMaginInfo.jsp","SerialNo="+"<%=ProjectSerialNo%>"+"&ObjectNo="+"<%=ObjectNo%>"+"&Flag="+"<%=Flag%>"+"&ProjectType="+"<%=ProjectType%>"+"&CustomerID="+"<%=CustomerID%>"+"&ReadFlag="+"<%=ReadFlag%>","","");
	//AsControl.OpenView("/Blank.jsp","","rightdown","");
	//function openInfo(){
	//	AsControl.OpenView("/ProjectManage/ProjectNewApply/CLRMaginInfo.jsp","SerialNo="+"<%=ProjectSerialNo%>"+"&ObjectNo="+"<%=ObjectNo%>"+"&Flag="+"<%=Flag%>"+"&ProjectType="+"<%=ProjectType%>"+"&CustomerID="+"<%=CustomerID%>"+"&ReadFlag="+"<%=ReadFlag%>","rightup","");
	//}
</script>	
<%@ include file="/IncludeEnd.jsp"%>
