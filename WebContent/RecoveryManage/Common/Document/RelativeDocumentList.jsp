<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//����������
	String sObjectTable = CurPage.getParameter("ObjectTable");
	if(sObjectTable == null) sObjectTable = "";
	String sLISerialNo = CurPage.getParameter("SerialNo");
	if(sLISerialNo == null) sLISerialNo = "";

	ASObjectModel doTemp = new ASObjectModel("RelativeDocumentList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sObjectTable+","+sLISerialNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","addDocument()","","","","btn_icon_add",""},
			{"true","","Button","�ĵ�����","�ĵ�����","editDocument()","","","","btn_icon_detail",""},
			{"false","All","Button","�ϴ�����","�ϴ�����","uploadAttachment()","","","","btn_icon_add",""},
			{"false","","Button","��������","��������","viewAttachment()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ��","deleteRecord()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function addDocument(){
		 var sUrl = "/RecoveryManage/Common/Document/RelativeDocumentInfo.jsp";
		 AsControl.PopComp(sUrl, '', '');
		 reloadSelf();
	}
	function editDocument(){
		 var sUrl = "/RecoveryManage/Common/Document/RelativeDocumentInfo.jsp";
		 var sPara = getItemValue(0,getRow(0),'DOCNO');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.PopComp(sUrl,'DOCNO=' +sPara ,'');
		reloadSelf();
	}
	function uploadAttachment(){
		viewAttachment();
	}
	function viewAttachment(){
		var sDocNo=getItemValue(0,getRow(),"DocNo");
    	var sUrl = "/RecoveryManage/Common/Document/AttachmentList.jsp";
    	if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
    	{        
        	alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;         
    	}
    	else
    	{
    		//popComp("AttachmentList","/RecoveryManage/Common/Document/AttachmentList.jsp","DocNo="+sDocNo+"&UserID="+sUserID+"&RightType="+sRightType);
    		AsControl.PopComp(sUrl,'SerialNo=' +sDocNo ,'');
    		reloadSelf();
      	}
    	
	}
	function deleteRecord(){
		if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert("ɾ���ɹ���")');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
