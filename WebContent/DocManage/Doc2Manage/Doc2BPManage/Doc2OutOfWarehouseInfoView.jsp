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
			//{"true","All","Button","����","�����б�","returnList()","","","",""},
		};
	//sButtonPosition = "north";
%><tr height="1"><td><%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%></td></tr>
<%-- ҳ��˵��: ʾ�����¿��ҳ�� --%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	showChangeBtn();
	var sInfoUrl = "";
	var sListUrl = "";
	var sDOSerialNo = "<%=sDOSerialNo%>";// doc_operation��Ӧ����ˮ��
	var sOperationType = "<%=sOperationType%>";
	var sDOObjectNo = "<%=sDOObjectNo%>";// doc_operation��Ӧ�Ķ����ţ����/����ʱΪ��ͬ��ˮ��   ������ĿʱΪ ��Ŀ���
	var sDOObjectType = "<%=sDOObjectType%>";// doc_operation��Ӧ�Ķ�������
	var OperationStatus = "<%=sOperationStatus%>";
	var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc2ManageAction","selectDocFileObjectNo","SerialNo="+sDOSerialNo);
	if(OperationStatus == "01" || OperationStatus == "05"){//���� �˻�
		sInfoUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseApplyInfo.jsp";
		sListUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseApplyList.jsp";
	}
	if(OperationStatus == "02" || OperationStatus == "03"){//����
		sInfoUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseApplyInfo.jsp";
		sListUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2OutOfWarehouseApproveList.jsp";
	}
	if(OperationStatus == "04"){//����:ҵ�����ϳ�������
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