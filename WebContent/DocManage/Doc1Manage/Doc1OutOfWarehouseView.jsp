<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//��ȡ�������
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
			//{"true","All","Button","����","�����б�","returnList()","","","",""},
		};
	//sButtonPosition = "north";
%><tr height="1"><td><%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%></td></tr>
<%-- ҳ��˵��: ʾ�����¿��ҳ�� --%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	showChangeBtn();
	var sInfoUrl = "/DocManage/Doc1Manage/Doc1OutOfWarehouseApplyInfo.jsp";
	var sListUrl = "";
	var sDOSerialNo = "<%=sDOSerialNo%>";
	var sAISerialNo = "<%=sAISerialNo%>";
	var sApplyType = "<%=sApplyType%>";
	var sApproveType = "<%=sApproveType%>";
	//�����������鿴����ʱ����ת����ҳ��
	var sPara = "RightType=<%=sRightType%>";
	sPara = "&DOSerialNo="+sDOSerialNo+"&AISerialNo="+sAISerialNo+"&ApplyType="+sApplyType+"&ApproveType =<%=sApproveType%>&DFPSerialNo=<%=sDFPSerialNo%>";
	 	
	AsControl.OpenView(sInfoUrl,sPara,"rightup","");	
	
	if(sAISerialNo == "null" || sAISerialNo == "" || sAISerialNo == null || sAISerialNo == "undefine" ){
		 	
	}else{
		AsControl.OpenView("/DocManage/Doc1Manage/Doc1RightCertificateList.jsp","AISerialNo="+sAISerialNo+"&ApplyType="+sApplyType+"","rightdown","");	
	}
	//�ڳ����������������׶Σ���������������������ذ�ťʱ����ת����ͬ��չʾҳ��
	if(sApplyType == "0010"||sApplyType == "0010"||sApplyType == "0020" ){//���� 
		sListUrl = "/DocManage/Doc1Manage/Doc1OutOfWarehouseApplyList.jsp";
	}
	if(sApproveType == "0010"||sApproveType == "0020"){//����
		sListUrl = "/DocManage/Doc1Manage/Doc1OutOfWarehouseApproveList.jsp";
	}
	
	//����"����"��ťʱ�������¼�
	function returnList(){
		self.close();
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>