<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String PG_TITLE = "�����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//����������	��������ˮ�š��������͡������š�ҵ�����͡��ͻ����͡��ͻ�ID
	
	String clSerialNo = CurPage.getParameter("CLSerialNo");
	
	//����ֵת���ɿ��ַ���
	if(clSerialNo == null) clSerialNo = "";	
	

	ASObjectModel doTemp = new ASObjectModel("CreditApplyRelaCLInfo","");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setParameter("SerialNo", clSerialNo);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"false","","Button","����","����","saveRecord()","","","",""},	
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){
		
	}

	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>