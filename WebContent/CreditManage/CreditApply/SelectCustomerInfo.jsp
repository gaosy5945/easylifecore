<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	ASObjectModel doTemp = new ASObjectModel("SelectAllApplyCustomer");
	doTemp.setJboWhereWhenNoFilter("1=2");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","ȷ��","���������޸�","save()","","","",""},
			{"true","All","Button","ȡ��","����","returnList()","","","",""},
	};

%>
<title>�������ѯ����ѡ��ͻ�</title>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function save(){
		var customerID = getItemValue(0, getRow(0), "CustomerID");
		var customerName = getItemValue(0, getRow(0), "CustomerName");
		var certType = getItemValue(0, getRow(0), "CertType");
		var certID = getItemValue(0, getRow(0), "CertID");
		var customerType = getItemValue(0, getRow(0), "CustomerType");
		top.returnValue = "true@"+customerID+"@"+customerName+"@"+certType+"@"+certID+"@"+customerType;
		top.close();
	}
	function returnList(){
		top.returnValue = "false";
		top.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>

