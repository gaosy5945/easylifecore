<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sContractArtificialNo = CurPage.getParameter("ContractArtificialNo");
	if(sContractArtificialNo==null) sContractArtificialNo = "";
	String sBDSerialNo = CurPage.getParameter("BDSerialNo");
	if(sBDSerialNo==null) sBDSerialNo = "";
	String sTempletNo = "PDARecoverRecordInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "����");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","All","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var rightType = "<%=CurPage.getParameter("RightType")%>"
	initRow();
	
	function saveRecord(){
		var sReviewStyle = getItemValue(0,getRow(),"REVIEWSTYLE");
		var sReviewStyleReason = getItemValue(0,getRow(),"DISTRIBUTEPROJECT");
		if (sReviewStyle == "03") {
			if (sReviewStyleReason == "") {
				alert("��¼���϶���׷��Ȩ�϶�˵��");
				return;
			} else {
				AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.recoverymanage.handler.PDARecoverRecordInfo", "updateBusinessStatus", "serialNo=<%=sBDSerialNo%>");
			}
		}
		as_save(0);
	}
	
	function returnList(){
		<%-- OpenPage("<%=sPrevUrl%>", "_self"); --%>
		self.close();
	}
	
	function initRow(){
		if(getRow(0)==0){

			setItemValue(0,getRow(),"SERIALNO",getSerialNo("LAWCASE_BOOK","SerialNo",""));
			setItemValue(0,getRow(),"BOOKTYPE","210");
			setItemValue(0,getRow(),"AGENTNO","<%=sContractArtificialNo%>");
			setItemValue(0,getRow(),"LAWCASESERIALNO","<%=sBDSerialNo%>");
			setItemValue(0,getRow(),"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"INPUTORGID","<%=CurUser.getOrgID()%>");
			setItemValue(0,getRow(),"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"INPUTORGNAME","<%=CurUser.getOrgName()%>");
			setItemValue(0,getRow(),"INPUTDATE","<%=StringFunction.getToday()%>");
		}
		setItemValue(0,getRow(),"UPDATEDATE","<%=StringFunction.getToday()%>");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
