<%@ page contentType="text/html; charset=GBK"%>
<%@include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	//��ò�������ʾģ�塢�ͻ����
	String templateNo = CurPage.getParameter("TemplateNo");
	String customerID = CurPage.getParameter("CustomerID");

	//����ֵת���ɿ��ַ���
	if(templateNo == null) templateNo = "";	
	

	ASObjectModel doTemp = new ASObjectModel(templateNo,"");
	
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	dwTemp.genHTMLObjectWindow(customerID);
	
	String sButtons[][] = {
	};
	
%><%@include file="/Frame/resources/include/ui/include_list.jspf" %>
<script type="text/javascript">
	function getValue(){
		return getItemValue(0,getRow(0),"SerialNo");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>