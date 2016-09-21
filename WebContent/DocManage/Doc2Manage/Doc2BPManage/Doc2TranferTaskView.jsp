<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sPTISerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PTISerialNo"));
	if(null==sPTISerialNo) sPTISerialNo="";

	String sButtons[][] = {
			{"true","All","Button","返回","返回列表","returnList()","","","",""},
		};
	//sButtonPosition = "north";
%><tr height="1"><td><%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%></td></tr>
<%-- 页面说明: 示例上下框架页面 --%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	showChangeBtn();
	var sInfoUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2TranferTaskInfo.jsp";
	var sListUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2TranferTaskList.jsp";
	var sPTISerialNo = "<%=sPTISerialNo%>";
	//AsControl.OpenView("/FrameCase/widget/dw/ExampleList06.jsp","","rightup","");
	AsControl.OpenView(sInfoUrl,"PTISerialNo="+sPTISerialNo,"rightup","");
	AsControl.OpenView("/DocManage/Doc2Manage/Doc2BPManage/Doc2TranferTaskOPList.jsp","PTISerialNo="+sPTISerialNo+"","rightdown","");
	
	function returnList(){
		OpenPage(sListUrl, "_self");
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>