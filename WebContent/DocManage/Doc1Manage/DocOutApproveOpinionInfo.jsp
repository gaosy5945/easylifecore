<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sDocType = CurPage.getParameter("DocType");
	if(sDocType == null) sDocType = "";
	//ҵ�����ϳ���������ˮ��
	String sSerialNo = CurPage.getParameter("DOSerialNo");
	if(sSerialNo == null) sSerialNo = "";
	String sTransactionCode = CurPage.getParameter("TransactionCode");
	if(sTransactionCode == null) sTransactionCode = "";
	String sTempletNo = "DocOutApproveOpinionInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2"; 
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("PTISerialNo"));
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		{"true","All","Button","����ͨ��","����ͨ��","doApprove()","","","",""},
		{"true","All","Button","�˻�","�˻�","doBack()","","","",""},
		{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		OpenPage("<%=sPrevUrl%>", "_self");
	}
	function doApprove(){
		if(!iV_all(0)){
			alert("���ȱ������ݣ�");
			return;
		}
		//��ȡ���������ˮ��
		var sPTISerialNo =  getItemValue(0,getRow(0),'SERIALNO');
		 //���DFP������DFI
		var sOperationType = getItemValue(0,getRow(0),'TRANSACTIONCODE');//���ⷽʽ
		//ҵ���������� 01 һ������   02 �������� 
		var sDocType = "<%=sDocType %>"; 
		//�����ؽ��
		var sReturn = "";
		if(as_isPageChanged()){
			alert("���ȱ������ݣ�");
			return;
		}
			//һ��ҵ������
		if(sDocType == "01"){
		  var sPara = "DOSerialNo=<%=sSerialNo%>,ApplyType=02,UserID=<%=CurUser.getUserID()%>,TransactionCode=<%=sTransactionCode%>";
		  sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc1EntryWarehouseAdd", "commit", sPara);
		}//����ҵ������
		else if(sDocType =="02"){ 
			var sPara = "DOSerialNo=<%=sSerialNo%>,ApplyType=02,UserID=<%=CurUser.getUserID()%>,TransactionCode=<%=sTransactionCode%>,OrgID = <%=CurUser.getOrgID()%>,PTISerialNo="+sPTISerialNo;
			sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.DocOutApproveAction", "doApprove", sPara);
		}  
		if(typeof(sReturn)!="undefined" && sReturn=="true"){
			alert("����ͨ���ɹ���");
			self.close(); 
		}else {
			alert("����ʧ��!");
			return;
		}
	}
	function doBack(){
		//���� PTISerialNo ����DO��Ϣ
		var sPTISerialNo =  getItemValue(0,getRow(0),'SERIALNO');
		 //���DFP������DFI
		var sDocType = "<%=sDocType %>";
		 //�����ؽ��
		var sReturn = "";
		if(as_isPageChanged()){
			alert("���ȱ������ݣ�");
			return;
		}
		//һ��ҵ������
		if(sDocType == "01"){
			 var sPara = "DOSerialNo=<%=sSerialNo%>,ApplyType=03,UserID=<%=CurUser.getUserID()%>";
	 		 sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc1EntryWarehouseAdd", "commit", sPara);
		}//����ҵ������
		else if(sDocType =="02"){
			 sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.DocOutApproveAction", "doBack", "PTISerialNo="+sPTISerialNo+",userID=<%=CurUser.getUserID()%>"+",orgID=<%=CurUser.getOrgID()%>");
		}
		 if(sReturn == "true"){
			alert("�ܾ�������");
			self.close(); 
		}else {
			alert("�˻�ʧ��!");
			return;
		}
		
	}

	setItemValue(0,getRow(),"SerialNo","<%=CurPage.getParameter("PTISerialNo")%>");
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
