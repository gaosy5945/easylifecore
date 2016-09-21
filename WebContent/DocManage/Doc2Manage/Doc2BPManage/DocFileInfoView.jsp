<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sDOSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(null==sDOSerialNo) sDOSerialNo="";
	String sDOObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if(null==sDOObjectType) sDOObjectType="";
	String sDOObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(null==sDOObjectNo) sDOObjectNo="";
	String sOperationType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OperationType"));
	if(null==sOperationType) sOperationType="";
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RightType"));
	if(null==sRightType) sRightType="";
	String sButtons[][] = {
			//{"true","All","Button","返回","返回列表","returnList()","","","",""},
		};
	//sButtonPosition = "north";
%><tr height="1"><td><%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%></td></tr>
<%-- 页面说明: 示例上下框架页面 --%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	showChangeBtn();
	var sInfoUrl = "";
	var sListUrl = "";
	var sDOSerialNo = "<%=sDOSerialNo%>";
	var sOperationType = "<%=sOperationType%>";
	var sDOObjectNo = "<%=sDOObjectNo%>";
	var sDOObjectType = "<%=sDOObjectType%>";
	//AsControl.OpenView("/FrameCase/widget/dw/ExampleList06.jsp","","rightup","");
	if(sOperationType == ""){
		sInfoUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2BeforPigeonholeManageInfo.jsp";
		sListUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2BeforPigeonholeManageList.jsp";
	}
	if(sOperationType == "0010"){
		sInfoUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2EntryWarehouseInfo.jsp";
		sListUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2EntryWarehouseList.jsp";
	}
	
	AsControl.OpenView(sInfoUrl,"DOSerialNo="+sDOSerialNo+"&RightType="+"<%=sRightType%>","rightup","");
	//var sPara = "FolderId="+sFolderId+"&ViewId="+sViewId;
	AsControl.OpenView("/DocManage/Doc2Manage/Doc2BPManage/DocFileList.jsp","DOSerialNo="+sDOSerialNo+"&DOObjectType="+sDOObjectType+"&DOObjectNo="+sDOObjectNo+""+"&RightType="+"<%=sRightType%>","rightdown","");
	
	function returnList(){
		OpenPage(sListUrl, "_self");
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>