<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//��ȡҳ�����
	String objectType = CurPage.getParameter("ObjectType");
	String userID = CurUser.getUserID();
	if(objectType == null || objectType == "undefined") objectType = "";
	if(userID == null || userID == "undefined") userID = "";
	
	ASObjectModel doTemp = new ASObjectModel("DocLibraryList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("UserID", userID);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			{"true","All","Button","�ϴ�","�ϴ�EXCEL","upLoad()","","","",""},
			{"true","","Button","�ĵ�����","�鿴�ĵ�����","viewAndEdit_attachment()","","","",""},
			{"true","All","Button","ɾ��","ɾ���ĵ���Ϣ","deleteRecord()","","","",""},
			{"true","All","Button","��������","��������","initialize()","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function upLoad(){
		AsControl.PopView("/CreditManage/CreditApply/BatchFrame.jsp","objectType=<%=objectType%>", "dialogWidth=500px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}

	function deleteRecord(){
		var inputUserID=getItemValue(0,getRow(),"InputUserID");//ȡ�ĵ�¼����	
		var sDocNo = getItemValue(0,getRow(),"DocNo");
		if (typeof(sDocNo)=="undefined" || sDocNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else if(inputUserID=='<%=CurUser.getUserID()%>'){
			if(confirm(getHtmlMessage(2))){ //�������ɾ������Ϣ��
				as_delete('myiframe0');
				as_save('myiframe0'); //�������ɾ������Ҫ���ô����             
			}
		}else{
			alert(getHtmlMessage('3'));
			return;
		}
	}
	<%/*~[Describe=�鿴���޸ĸ�������;]~*/%>
	function viewAndEdit_attachment(){
		var sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
		var sDocNo= getItemValue(0,getRow(),"DocNo");
		if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else{
			AsControl.PopView("/AppConfig/Document/AttachmentView.jsp","DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo);
		}
	}
	function initialize(){
		var pageURL = "/AppConfig/FileImport/FileSelector.jsp";
	    var parameter = "clazz=jbo.import.excel.CREDIT_LOAN&userId="+'<%=CurUser.getUserID()%>'+"&orgId="+'<%=CurOrg.getOrgID()%>';
	    var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
	    var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
	    reloadSelf();
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
