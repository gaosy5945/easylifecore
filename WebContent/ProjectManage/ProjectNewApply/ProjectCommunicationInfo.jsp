<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
        Author: undefined 2016-01-12
        Content: ʾ������ҳ��
        History Log: 
    */
	String prjSerialno = CurPage.getParameter("prjSerialno");
	if(prjSerialno == null) prjSerialno = "";

	String sTempletNo = "ProjectCommunicationInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "����");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(prjSerialno);
	
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""}
		//{"true","All","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "north";
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		//������ĿЭ��Ĺ�����ϵ����Ӫ��֮��Ĺ�ϵ
		var customerID = getItemValue(0,0,"CUSTOMERID");
		var values = RunJavaMethodTrans("com.amarsoft.app.als.customer.partner.model.ProjectCommProvider","establishProjectCommRela","customerID="+customerID+",prjSerialNo="+"<%=prjSerialno%>");//����������ǿͻ���ID��Э��ı��
		if(values=="false") {
			alert("��ǰЭ���Ѿ��͸���Ӫ�̹���,������ѡ��");
			return;
		}
		//as_save(0);
	}

	
	function returnList(){
		 AsControl.OpenView("<%=""%>", "","_self","");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>