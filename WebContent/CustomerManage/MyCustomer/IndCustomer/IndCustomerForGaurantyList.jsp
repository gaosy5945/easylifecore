<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%-- ҳ��˵��: �ͻ���Ϣ����->�ͻ�����һ��->�ÿͻ�Ϊ���ж�Ȼ�����ṩ��֤���ҳ��--%>
<%	
 	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
/*	ASObjectModel doTemp = new ASObjectModel("IndCustomerForGuarantyList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); */
	
	BusinessObject inputParameter =BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("CustomerID", customerID);
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("IndCustomerForGuarantyList",inputParameter,CurPage);
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	dwTemp.Style="1";      	     //--����ΪGrid���--
	//dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("CustomerID", customerID);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
		{"true","","Button","������������","������������","editApply()","","","","btn_icon_detail",""},
		{"true","","Button","������ͬ����","������ͬ����","editContract()","","","","btn_icon_detail",""},
	};
	sASWizardHtml = "<p><font color='red' size='2'>�ÿͻ�Ϊ���ж�Ȼ�����ṩ��֤�����</font></p>" ; 
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function editApply(){
		var SerialNo = getItemValue(0,getRow(0),"SerialNo");
		 if(typeof(SerialNo)=="undefined" || SerialNo.length==0 ){
			alert("��ѡ��һ����Ϣ��");
			return ;
		 }
		 AsControl.PopComp("/CustomerManage/MyCustomer/IndCustomer/GuarantyApplyList.jsp","SerialNo="+SerialNo,"resizable=yes;dialogWidth=850px;dialogHeight=500px;center:yes;status:no;statusbar:no");
	}
	function editContract(){
		 var SerialNo = getItemValue(0,getRow(0),"SerialNo");
		 if(typeof(SerialNo)=="undefined" || SerialNo.length==0 ){
			alert("��ѡ��һ����Ϣ��");
			return ;
		 }
		 AsControl.PopComp("/CustomerManage/MyCustomer/IndCustomer/ContractRelativeList.jsp","SerialNo="+SerialNo,"resizable=yes;dialogWidth=800px;dialogHeight=500px;center:yes;status:no;statusbar:no");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
