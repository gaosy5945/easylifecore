<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

	String sDOCNO = CurPage.getParameter("DOCNO");
	if(sDOCNO == null) sDOCNO = "";

	String sTempletNo = "RelativeDocumentInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "����");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(sDOCNO);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		{"true","All","Button","�鿴/�޸ĸ���","�鿴/�޸�ѡ���ĵ���ص����и���","viewAndEdit_attachment()","","","",""},
		{"true","","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		self.close();
	}

	<%/*~[Describe=�鿴��������;]~*/%>
	function viewAndEdit_attachment(){
		
		/* if(!iV_all(0)){
			alert("���ȱ������ݣ�");
			return;
		} 
		if(as_isPageChanged()){
			alert("�ύǰ���ȱ������ݣ�");
			return;
		} */
		var sDOCNO = getItemValue(0,getRow(),'DOCNO');
		var sSql = "select count(DOCNO) from DOC_LIBRARY dl where dl.docno='"+sDOCNO+"'";
		var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
		if(sReturnValue>0){
			var sDocNo = getItemValue(0,getRow(),"DocNo");
			var sUserID = getItemValue(0,getRow(),"UserID");//ȡ¼����ID
			var sRightType="<%=CurPage.getParameter("RightType")%>";
			if (typeof(sDocNo)=="undefined" || sDocNo.length==0){
	        	alert("���ȱ����ĵ����ݣ����ϴ�������");  //��ѡ��һ����¼��
				return;
	    	}else{
	    		//popComp("AttachmentList","/AppConfig/Document/AttachmentList.jsp","DocNo="+sDocNo+"&UserID="+sUserID+"&RightType="+sRightType);
				AsControl.PopView("/RecoveryManage/Common/Document/AttachmentFrame.jsp", "DocNo="+sDocNo+"&UserID="+sUserID+"&RightType="+sRightType, "dialogWidth=650px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    		reloadSelf();
			}
		}else{
			alert("���ȱ������ݣ�");
			return;
		} 
		
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
