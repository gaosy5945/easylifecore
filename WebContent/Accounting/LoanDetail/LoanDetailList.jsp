<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
  
<%
	String PG_TITLE = "�˻���Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String businessType = "";
	String projectVersion = "";
	
	//����������	
	
	//���ҳ�����
	String sObjectNo = CurPage.getParameter("TransSerialNo");
	if(sObjectNo == null) sObjectNo = "";
	
	
	//��ʾģ����
	String sTempletNo = "LoanDetailList";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style = "1"; //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sObjectNo);
	

	String sButtons[][] = {
	};
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script language=javascript>
	//��ʼ��
// 	AsOne.AsInit();
// 	init();
// 	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>