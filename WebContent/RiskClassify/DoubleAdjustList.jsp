<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//String sCustomerID =  CurComp.getParameter("CustomerID");
	//String sCustomerType = CurPage.getParameter("CustomerType");
	//String sListType = CurPage.getParameter("ListType");
     String SerialNo = CurPage.getParameter("SerialNo");
     if(SerialNo == null || "" == SerialNo || "".equals(SerialNo)){
    	 SerialNo = "''";
     }
     
	ASObjectModel doTemp = new ASObjectModel("DUEBILL_DOUBLE_APPLY");
	doTemp.setJboWhere(doTemp.getJboWhere() + " and O.SerialNo in  ("+SerialNo+") ");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
    dwTemp.genHTMLObjectWindow(SerialNo);
    
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			//{"false","All","Button","�����ϴ�","�����ϴ�","","","","","btn_icon_add",""},
		};
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
