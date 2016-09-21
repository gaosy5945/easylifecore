<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	String industryType = "";
	ASObjectModel doTemp = new ASObjectModel("EntCustomerBuildingList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
 	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select IndustryType from ENT_INFO where CustomerID=:CustomerID ").setParameter("CustomerID",customerID));
 	if(rs.next()){
			industryType=rs.getString("industryType");
			if(industryType == null) {
				industryType = "";
			}
		}
	rs.getStatement().close();

	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(customerID);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{ "E0000".equals(industryType)? "true":"false","All","Button","����","����","add()","","","","btn_icon_add",""},
			{ "E0000".equals(industryType)? "true":"false","All","Button","����","����","edit()","","","","btn_icon_detail",""},
			{ "E0000".equals(industryType)? "true":"false","All","Button","ɾ��","ɾ��","del()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var customerID = "<%=customerID%>";
		AsControl.PopView("/CustomerManage/MyCustomer/EntCustomer/EntCustomerBuildingInfo.jsp","CustomerID="+customerID,"resizable=yes;dialogWidth=520px;dialogHeight=550px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	function edit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		AsControl.PopComp("/CustomerManage/MyCustomer/EntCustomer/EntCustomerBuildingInfo.jsp","SerialNo="+serialNo,"resizable=yes;dialogWidth=520px;dialogHeight=550px;center:yes;status:no;statusbar:no");
		reloadSelf();
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
