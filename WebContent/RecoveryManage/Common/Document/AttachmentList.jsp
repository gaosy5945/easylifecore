<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sDOCNO = CurPage.getParameter("SerialNo");//Ȩ��
	if(sDOCNO == null) sDOCNO = "";
	ASObjectModel doTemp = new ASObjectModel("DOCAttachmentList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sDOCNO);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","��������","��������","newRecord()","","","","btn_icon_add",""},
			{"true","","Button","��������","��������","viewFile()","","","","btn_icon_detail",""},
			{"true","","Button","ɾ������","ɾ������","deleteRecord()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function newRecord(){
	var sDocNo="<%=sDOCNO%>";
	AsControl.PopView("/RecoveryManage/Common/Document/AttachmentChooseDialog.jsp","DocNo="+sDocNo,"dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	reloadSelf();
}

function deleteRecord(){
	var sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
	if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0){
		alert(getHtmlMessage(1));  //��ѡ��һ����¼��
		return;
	}else{
		if(confirm(getHtmlMessage(2))){ //�������ɾ������Ϣ��
    		as_delete('myiframe0');
		}
	}
}

<%/*~[Describe=�鿴���޸�����;]~*/%>
function viewFile(){
	var sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
	var sDocNo= getItemValue(0,getRow(),"DocNo");
	if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0){
		alert(getHtmlMessage(1));  //��ѡ��һ����¼��
		return;
	}else{
		AsControl.OpenPage("/AppConfig/Document/AttachmentView.jsp","DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo);
	}
}

// �������ع���
function exportFile(){
	var sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
	var sDocNo= getItemValue(0,getRow(),"DocNo");
	if (sAttachmentNo =="undefined"||sAttachmentNo.length == 0){
		alert(getHtmlMessage(1));  //��ѡ��һ����¼��
		return;
	}else{
		// http ��ʽ
		//AsControl.PopView("/AppConfig/Document/AttachmentDownload.jsp","DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo,"");
		// servlet ��ʽ
		AsControl.PopView("/AppConfig/Document/AttachmentView.jsp","DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo+"&ViewType=save");
	}
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
