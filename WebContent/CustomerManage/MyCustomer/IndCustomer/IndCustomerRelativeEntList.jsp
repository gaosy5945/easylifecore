<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	String customerType = CurPage.getParameter("CustomerType");
	if(customerType == null) customerType = "";
	String CustomerFlag = CurPage.getParameter("CustomerFlag");
	if(CustomerFlag == null) CustomerFlag = "";

	ASObjectModel doTemp = new ASObjectModel("IndCustomerRelativeEntList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(customerID);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","��ϵ��ҵ����","��ϵ��ҵ����","viewAndEdit()","","","","btn_icon_detail",""},
			//{"true","","Button","��ϵ����","��ϵ����","edit()","","","","",""},
			{"true","All","Button","ɾ��","ɾ��","del()","","","","btn_icon_delete",""},
			};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
	function add(){
		customerID = "<%=customerID%>";
		customerType = "<%=customerType%>";
		CustomerFlag = "<%=CustomerFlag%>";
		AsControl.PopPage("/CustomerManage/MyCustomer/IndCustomer/EntCustomerRelativeInfo.jsp","CustomerID="+customerID+"&CustomerType="+customerType+"&CustomerFlag="+CustomerFlag,"resizable=yes;dialogWidth=500px;dialogHeight=480px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	function viewAndEdit(){
		var customerID = getItemValue(0,getRow(0),"RELATIVECUSTOMERID");
		var customerType = "01";
		if(typeof(customerID)=="undefined" || customerID.length==0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		 CustomerManage.editCustomer(customerID,customerType);
	}
	function edit(){
		serialNo = getItemValue(0,getRow(),"SerialNo");
		customerID = "<%=customerID%>";
		customerType = "<%=customerType%>";
		if (typeof(serialNo)=="undefined" || serialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			AsControl.PopPage("/CustomerManage/MyCustomer/IndCustomer/EntCustomerRelativeInfo.jsp","SerialNo="+serialNo+"&CustomerID="+customerID+"&CustomerType="+customerType,"resizable=yes;dialogWidth=500px;dialogHeight=480px;center:yes;status:no;statusbar:no");
			reloadSelf();
		}
	}
	function del(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		if(confirm('ȷʵҪɾ����?')){
			as_delete(0);
		}
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
