<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	
	//����ֵת���ɿ��ַ���
	if(objectType == null) objectType = "";
	if(objectNo == null) objectNo = "";	
	if(taskSerialNo == null) taskSerialNo = "";	
	
	ASObjectModel doTemp = new ASObjectModel("ContractFileCheck");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "0";	 //ֻ��ģʽ
	dwTemp.setPageSize(3);
	dwTemp.genHTMLObjectWindow(objectNo+","+objectType+","+taskSerialNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","save()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function save(){
		 as_save("myiframe0");
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
