<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("SelectCustomerList");
	doTemp.setJboWhereWhenNoFilter(" and 1<>1 ");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","�鿴����","�鿴����","edit()","","","","btn_icon_detail",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
	function edit(){
		var customerID = getItemValue(0,getRow(0),"CUSTOMERID");
		var serialNo = getItemValue(0,getRow(0),"SERIALNO");

		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		var result = CustomerManage.selectCustomer(customerID);
		if(result == "SUCCEED"){
			var customerType = CustomerManage.selectCustomerType(customerID);
			CustomerManage.editCustomer(customerID,customerType);
		}else{
			alert("�����޸ÿͻ���Ϣ��");
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
