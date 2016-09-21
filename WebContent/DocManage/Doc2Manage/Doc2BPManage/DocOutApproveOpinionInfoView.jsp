<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sPTISerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PTISerialNo"));
	if(null==sPTISerialNo) sPTISerialNo="";
	String sDOSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DOSerialNo"));
	if(null==sDOSerialNo) sDOSerialNo="";
	String sDocType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocType"));
	if(null==sDocType) sDocType="";
	String sTransactionCode = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransactionCode"));
	if(null==sTransactionCode) sTransactionCode="";
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if(null==sObjectType) sObjectType="";
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(null==sObjectNo) sObjectNo=""; 
	 String sButtons[][] = {
			//{"true","All","Button","返回","返回列表","returnList()","","","",""},
		};
	//sButtonPosition = "north";
%><tr height="1"><td><%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%></td></tr>
<%-- 页面说明: 示例上下框架页面 --%>
<%@include file="/Resources/CodeParts/Frame03.jsp"%>
<script type="text/javascript">	
	showChangeBtn();
	var sInfoUrl = "";
	var sListUrl = "";
	var sParm1 = "PTISerialNo=<%=sPTISerialNo%>&DOSerialNo=<%=sDOSerialNo%>&DocType=<%=sDocType%>&TransactionCode=<%=sTransactionCode%>";
	var sParm2 = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&DocType=<%=sDocType%>&SerialNo=<%=sDOSerialNo%>&OperationStatus=03&RightType=ReadOnly";
	AsControl.OpenView("/DocManage/Doc1Manage/DocOutApproveOpinionInfo.jsp",sParm1,"frameleft","width:180px");
	AsControl.OpenView("/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseInfoView.jsp",sParm2,"frameright","");
  
	function returnList(){
		OpenPage(sListUrl, "_self");
	}
</script>
<%@ include file="/IncludeEnd.jsp"%> 
 