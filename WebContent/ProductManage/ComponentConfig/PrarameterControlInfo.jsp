<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>

<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	%>

<table width="100%" height="250px"><tr><td width="5%"></td><tr><td><font color=blue>申请场景</font></td></tr><td width="90%"><iframe type='iframe' name="apply_frame" width="80%" height="200" frameborder="1" src=""></iframe></td></tr></table>
<table width="100%" height="250px"><tr><td width="5%"></td><tr><td><font color=blue>批复场景</font></td></tr><td width="90%"><iframe type='iframe' name="approve_frame" width="80%" height="200" frameborder="1" src=""></iframe></td></tr></table>
<table width="100%" height="250px"><tr><td width="5%"></td><tr><td><font color=blue>合同场景</font></td></tr><td width="90%"><iframe type='iframe' name="contract_frame" width="80%" height="200" frameborder="1" src=""></iframe></td></tr></table>
<table width="100%" height="250px"><tr><td width="5%"></td><tr><td><font color=blue>出账场景</font></td></tr><td width="90%"><iframe type='iframe' name="putout_frame" width="80%" height="200" frameborder="1" src=""></iframe></td></tr></table>
	
<script type="text/javascript">

	AsControl.OpenView("/ProductManage/ComponentConfig/ControlInfo.jsp","SerialNo=<%=serialNo%>"+"&SceneType=apply","apply_frame");
	AsControl.OpenView("/ProductManage/ComponentConfig/ControlInfo.jsp","SerialNo=<%=serialNo%>"+"&SceneType=approve","approve_frame");
	AsControl.OpenView("/ProductManage/ComponentConfig/ControlInfo.jsp","SerialNo=<%=serialNo%>"+"&SceneType=contract","contract_frame");
	AsControl.OpenView("/ProductManage/ComponentConfig/ControlInfo.jsp","SerialNo=<%=serialNo%>"+"&SceneType=putout","putout_frame");

</script>
	
<%@ include file="/IncludeEnd.jsp"%>