<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//获取请求参数
	String sDOSerialNo = CurPage.getParameter("DOSerialNo");
	if(null==sDOSerialNo) sDOSerialNo="";
	String sAISerialNo = CurPage.getParameter("AISerialNo");
	if(null==sAISerialNo) sAISerialNo="";
	String sApplyType = CurPage.getParameter("ApplyType");
	if(null==sApplyType) sApplyType="";
	String sApproveType = CurPage.getParameter("ApproveType");
	if(null==sApproveType) sApproveType="";
	String sRightType = CurPage.getParameter("RightType");
	if(null==sRightType) sRightType="";
	String sDFPSerialNo = CurPage.getParameter("DFPSerialNo");
	if(null==sDFPSerialNo) sDFPSerialNo="";
	String sButtons[][] = {
			//{"true","All","Button","返回","返回列表","returnList()","","","",""},
		};
	//sButtonPosition = "north";
%><tr height="1"><td><%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%></td></tr>
<%-- 页面说明: 示例上下框架页面 --%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	showChangeBtn();
	var sInfoUrl = "/DocManage/Doc1Manage/Doc1OutOfWarehouseApplyInfo.jsp";
	var sListUrl = "";
	var sDOSerialNo = "<%=sDOSerialNo%>";
	var sAISerialNo = "<%=sAISerialNo%>";
	var sApplyType = "<%=sApplyType%>";
	var sApproveType = "<%=sApproveType%>";
	//在新增申请或查看详情时，跳转到该页面
	var sPara = "RightType=<%=sRightType%>";
	sPara = "&DOSerialNo="+sDOSerialNo+"&AISerialNo="+sAISerialNo+"&ApplyType="+sApplyType+"&ApproveType =<%=sApproveType%>&DFPSerialNo=<%=sDFPSerialNo%>";
	 	
	AsControl.OpenView(sInfoUrl,sPara,"rightup","");	
	
	if(sAISerialNo == "null" || sAISerialNo == "" || sAISerialNo == null || sAISerialNo == "undefine" ){
		 	
	}else{
		AsControl.OpenView("/DocManage/Doc1Manage/Doc1RightCertificateList.jsp","AISerialNo="+sAISerialNo+"&ApplyType="+sApplyType+"","rightdown","");	
	}
	//在出库申请或出库审批阶段，在新增或详情界面点击返回按钮时，跳转到不同的展示页面
	if(sApplyType == "0010"||sApplyType == "0010"||sApplyType == "0020" ){//申请 
		sListUrl = "/DocManage/Doc1Manage/Doc1OutOfWarehouseApplyList.jsp";
	}
	if(sApproveType == "0010"||sApproveType == "0020"){//审批
		sListUrl = "/DocManage/Doc1Manage/Doc1OutOfWarehouseApproveList.jsp";
	}
	
	//单击"返回"按钮时触发该事件
	function returnList(){
		self.close();
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>