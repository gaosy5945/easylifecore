<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";

	ASObjectModel doTemp = new ASObjectModel("EntCustomerClList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","�������","�������","CLView()","","","","",""},
			{"true","","Button","������´�������","������´�������","BDView()","","","","",""},
			};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function CLView(){
		 var serialNo = getItemValue(0,getRow(0),"SerialNo");
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("��ѡ��һ����Ϣ��");
			return ;
		 }
		 var sUrl = "/CustomerManage/MyCustomer/EntCustomer/EntCustomerClInfo.jsp";
		 AsControl.OpenPage(sUrl,'_self','');
	}
	function BDView(){
		 var sUrl = "/CustomerManage/MyCustomer/EntCustomer/EntCustomerAlList.jsp";
		 var serialNo = getItemValue(0,getRow(0),"SerialNo");
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("��ѡ��һ����Ϣ��");
			return ;
		 }
		AsControl.PopView(sUrl,'SerialNo=' +sPara ,'resizable=yes;dialogWidth=60;dialogHeight=40;center:yes;status:no;statusbar:no');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
