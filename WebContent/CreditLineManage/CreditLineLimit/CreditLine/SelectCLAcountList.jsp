<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String ObjectNo = CurPage.getParameter("ObjectNo");
	String CustomerID = CurPage.getParameter("CustomerID");
	String CustomerName = CurPage.getParameter("CustomerName");
	String BusinessType = CurPage.getParameter("BusinessType");
	ASObjectModel doTemp = new ASObjectModel("SelectCLAcountList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.setParameter("CustomerID", CustomerID);
	dwTemp.setParameter("CustomerName", CustomerName);
	dwTemp.setParameter("ObjectNo", ObjectNo);
	dwTemp.setParameter("BusinessType", BusinessType);
	dwTemp.genHTMLObjectWindow(CustomerID+","+CustomerName+","+ObjectNo+","+BusinessType);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","ȷ��","ȷ��","save()","","","","",""},
			{"true","All","Button","ȡ��","ȡ��","returnList()","","","","",""},
		};
	//sButtonPosition = "south";
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function save(){
		var objectNo = getItemValue(0, getRow(0), "ObjectNo");
		top.returnValue = objectNo;
		top.close();
	}
	function returnList(){
		self.close();
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
