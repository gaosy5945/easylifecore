<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//String sCustomerID =  CurComp.getParameter("CustomerID");
	//String sCustomerType = CurPage.getParameter("CustomerType");
	//String sListType = CurPage.getParameter("ListType");

	ASObjectModel doTemp = new ASObjectModel("DOC_LIBRARY");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("111");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","�����ϴ�","�����ϴ�","","","","","",""},
			{"true","","Button","��������","��������","","","","","",""},
			{"true","All","Button","ɾ��","ɾ��","","","","","",""},
			
		};
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
