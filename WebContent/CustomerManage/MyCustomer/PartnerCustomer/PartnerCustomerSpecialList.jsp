<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";	
	String CertType = CurComp.getParameter("CertType");
	if(CertType == null) CertType = "";
	String CertID = CurComp.getParameter("CertID");
	if(CertID == null) CertID = "";

	
	ASObjectModel doTemp = new ASObjectModel("IndCustomerSpecialList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("CertType", CertType);
	dwTemp.setParameter("CertID", CertID);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"false","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"false","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"false","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
