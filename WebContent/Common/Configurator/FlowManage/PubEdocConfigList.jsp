<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("PubEdocConfigList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����ģ��","����","add()","","","","",""},
			{"true","","Button","ģ������","����","edit()","","","","",""},
			{"true","","Button","ɾ��ģ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","",""},
			{"true","","Button","��ʽ�ļ��ϴ�","��ʽ�ļ��ϴ�","upLoadform()","","","","",""},
			{"true","","Button","�鿴��ʽ�ļ�","�鿴��ʽ�ļ�","formedit(1)","","","","",""},
			{"true","","Button","�����ļ��ϴ�","�����ļ��ϴ�","upLoaddata()","","","","",""},
			{"true","","Button","�鿴�����ļ�","�鿴�����ļ�","formedit(0)","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 AsControl.PopView("/Common/Configurator/FlowManage/PubEdocConfigInfo.jsp",'','_self','');
		 reloadSelf();
	}
	function edit(){
		 var edocNo = getItemValue(0,getRow(0),'EdocNo');
		 if(typeof(edocNo)=="undefined" || edocNo.length==0 ){
			alert("��ѡ��һ����¼��");
			return ;
		 }
		AsControl.PopView("/Common/Configurator/FlowManage/PubEdocConfigEditInfo.jsp",'EdocNo=' +edocNo ,'dialogWidth=800px;dialogHeight=400px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;','');
	}
	function upLoadform(){
		var edocNo = getItemValue(0,getRow(0),'EdocNo');
		if(typeof(edocNo)=="undefined" || edocNo.length==0){
				alert("��ѡ��һ����¼��");
				return ;
			 }
		AsControl.PopView("/Common/Configurator/FlowManage/PubEdocUploadForm.jsp","EdocNo="+edocNo,"_self","");
		reloadSelf();
	}
	
	function formedit(flag){
		var sAttachmentNo = getItemValue(0,getRow(),"EdocName");
		var sDocNo= getItemValue(0,getRow(),"EdocNo");
		if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else{
			AsControl.PopView("/Common/Configurator/FlowManage/PubEDocView.jsp","EDocNo="+sDocNo+"&Flag="+flag);
		}
	}
	
	function upLoaddata(){
		var edocNo = getItemValue(0,getRow(0),'EdocNo');
		if(typeof(edocNo)=="undefined" || edocNo.length==0){
				alert("��ѡ��һ����¼��");
				return ;
			 }
		AsControl.PopView("/Common/Configurator/FlowManage/PubEdocUploadData.jsp","EdocNo="+edocNo,"_self","");
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
