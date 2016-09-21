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
	String sOperationStatus = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OperationStatus"));
	if(null==sOperationStatus) sOperationStatus="";
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RightType"));
	if(null==sRightType) sRightType="";
	String sDocType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocType"));
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
	var sDOSerialNo = "<%=sDOSerialNo%>";// doc_operation对应的流水号
	var sOperationType = "<%=sOperationType%>";
	var sDOObjectNo = "<%=sDOObjectNo%>";// doc_operation对应的对象编号：额度/贷款时为合同流水号   合作项目时为 项目编号
	var sDOObjectType = "<%=sDOObjectType%>";// doc_operation对应的对象类型
	var OperationStatus = "<%=sOperationStatus%>";
	var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc2ManageAction","selectDocFileObjectNo","SerialNo="+sDOSerialNo);
	if(OperationStatus == "01" || OperationStatus == "05"){//申请 退回
		sInfoUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseApplyInfo.jsp";
		sListUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseApplyList.jsp";
	}
	if(OperationStatus == "02" || OperationStatus == "03"){//审批
		sInfoUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseApplyInfo.jsp";
		sListUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseApproveList.jsp";
	}
	if(OperationStatus == "04"){//处理:业务资料出库领用
		sInfoUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2CollarWithUser.jsp";
		sListUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseForUseList.jsp";
	}
	var returnValue = AsControl.OpenView(sInfoUrl,"DOSerialNo="+sDOSerialNo+"&RightType=<%=sRightType%>&DocType=<%=sDocType%>&DOObjectNo="+sDOObjectNo,"rightup","");
	if(<%=sDocType%> == "02"){
		//AsControl.OpenView("/CreditManage/CreditApply/CreditDocFileList.jsp","ContractArtificialNo="+returnValue+"&flag=approve","rightdown","");
		AsControl.OpenView("/Blank.jsp","","rightdown","");
	}
	
	function returnList(){
		OpenPage(sListUrl, "_self");
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>