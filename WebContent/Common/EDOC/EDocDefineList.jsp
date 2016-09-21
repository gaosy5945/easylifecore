<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("EdocDefinelist");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	 //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","newRecord()","","","","btn_icon_add",""},
			{"true","","Button","����","����","viewAndEdit()","","","","btn_icon_detail",""},
			{"true","","Button","ɾ��","ɾ��","deleteRecord()","","","","btn_icon_delete",""},
			{"true","","Button","��ʽ�ļ��ϴ�","��ʽ�ļ��ϴ�","TemplateUploadFmt()","","","","",""},			
			{"true","","Button","���ݶ����ļ��ϴ�","���ݶ����ļ��ϴ�","TemplateUploadDef()","","","","",""},
			{"true","","Button","�鿴��ʽ�ļ�","�鿴��ʽ�ļ�","TemplateViewFmt()","","","","",""},			
			{"true","","Button","�鿴���ݶ����ļ�","�鿴���ݶ����ļ�","TemplateViewDef()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
function newRecord(){
	AsControl.OpenPage("/Common/EDOC/EDocDefineInfo.jsp","","_self");
    reloadSelf();
}

/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
function viewAndEdit(){
    var edocNo = getItemValue(0,getRow(),"EDocNo");
    if(typeof(edocNo)=="undefined" || edocNo.length==0) {
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        return ;
	}
    AsControl.OpenPage("/Common/EDOC/EDocDefineInfo.jsp","EDocNo="+edocNo,"_self");
    reloadSelf();
}

/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
function deleteRecord(){
	var edocNo = getItemValue(0,getRow(),"EDocNo");
    if(typeof(edocNo)=="undefined" || edocNo.length==0) {
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        return ;
	}
	
	// 	var printNum = RunJavaMethodTrans("com.amarsoft.app.edoc.SelectEDocDefine","selectEDocDefine","docNo="+edocNo);
	var printNum = RunJavaMethodTrans("com.amarsoft.app.bizmethod.BusinessManage","selectEDocDefine","paras=docNo@@"+edocNo);
	printNum = parseInt(printNum);
	if(printNum > 0){
		alert('��ģ�������ɵ��Ӻ�ͬ������ɾ����');
	}else{
		if(confirm("ȷ��Ҫɾ����ģ����")) 
			as_delete(0);
	}
}

/*~[Describe=��ʽ�ļ��ϴ�;InputParam=��;OutPutParam=��;]~*/
function TemplateUploadFmt(){
	var edocNo = getItemValue(0,getRow(),"EDocNo");
    if(typeof(edocNo)=="undefined" || edocNo.length==0) {
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        return;
	}
    
	var fileName = getItemValue(0,getRow(),"FileNameFmt");//ģ���ļ�����
    if(typeof(fileName)!="undefined" &&  fileName.length!=0) {
		if(!confirm("�����ĵ���ʽ�ļ��Ѿ����ڣ�ȷ��Ҫ�����ϴ���"))
		    return;
	}
	popComp("TemplateChooseDialog","/Common/EDOC/TemplateChooseDialog.jsp","EDocNo="+edocNo+"&DocType=Fmt","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	reloadSelf();
}

/*~[Describe=���ݶ����ļ��ϴ�;InputParam=��;OutPutParam=��;]~*/
function TemplateUploadDef(){
	var edocNo = getItemValue(0,getRow(),"EDocNo");
    if(typeof(edocNo)=="undefined" || edocNo.length==0) {
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        return ;
	}
    
	var fileName = getItemValue(0,getRow(),"FileNameDef");//ģ���ļ�����
    if(typeof(fileName)!="undefined" &&  fileName.length!=0) {
		if(!confirm("�����ĵ����ݶ����ļ��Ѿ����ڣ�ȷ��Ҫ�����ϴ���"))
		    return;
	}
	popComp("TemplateChooseDialog","/Common/EDOC/TemplateChooseDialog.jsp","EDocNo="+edocNo+"&DocType=Def","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	reloadSelf();
}

function TemplateViewFmt(){
	var edocNo = getItemValue(0,getRow(),"EDocNo");
    if(typeof(edocNo)=="undefined" || edocNo.length==0) {
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        return ;
	}
	
	var fileName = getItemValue(0,getRow(),"FileNameFmt");//--��ʽ�ļ�
    if(typeof(fileName)=="undefined" || fileName.length==0) {
		alert("�ļ�δ�ϴ���");//��ѡ��һ����Ϣ��
        return ;
	}
	popComp("TemplateView","/Common/EDOC/TemplateView.jsp","EDocNo="+edocNo+"&EDocType=Fmt");
}

/*~[Describe=�����ļ��鿴;InputParam=��;OutPutParam=��;]~*/
function TemplateViewDef(){//alert("developing...");return;
	var edocNo = getItemValue(0,getRow(),"EDocNo");//--�������ͱ��
    if(typeof(edocNo)=="undefined" || edocNo.length==0) {
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        return;
	}
	
	var fileName = getItemValue(0,getRow(),"FileNameDef");//--��ʽ�ļ�
    if(typeof(fileName)=="undefined" || fileName.length==0) {
		alert("�ļ�δ�ϴ���");//��ѡ��һ����Ϣ��
        return ;
	}
	popComp("TemplateView","/Common/EDOC/TemplateView.jsp","EDocNo="+edocNo+"&EDocType=Def");
}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>