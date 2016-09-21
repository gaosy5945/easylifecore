<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sDOSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(null==sDOSerialNo) sDOSerialNo="";
	String sBeforeDOSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DoSerialNo"));
	if(null==sBeforeDOSerialNo) sBeforeDOSerialNo="";
	String sDfpSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DFPSerialNo"));
	if(null==sDfpSerialNo) sDfpSerialNo="";
	String sOperationType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OperationType"));
	if(null==sOperationType) sOperationType="";
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
	var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc2ManageAction","selectDocFileObjectNo","SerialNo="+sDOSerialNo);
	sInfoUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseApplyInfo.jsp";
	sListUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseApplyList.jsp";
	var returnValue = AsControl.OpenView(sInfoUrl,"DOSerialNo="+sDOSerialNo+"&BeforeDOSerialNo=<%=sBeforeDOSerialNo%>&DFPSerialNo=<%=sDfpSerialNo%>&RightType=<%=sRightType%>&DocType=<%=sDocType%>","rightup","");
	if(<%=sDocType%> == "02"){
		//AsControl.OpenView("/CreditManage/CreditApply/CreditDocFileList.jsp","ContractArtificialNo="+returnValue+"&flag=approve","rightdown","");
		AsControl.OpenView("/Blank.jsp","","rightdown","");
	}
	
	function returnList(){
		OpenPage(sListUrl, "_self");
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>