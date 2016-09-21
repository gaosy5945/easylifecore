<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID =  CurComp.getParameter("CustomerID");

	ASObjectModel doTemp = new ASObjectModel("IndCustomerEmploymentList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(customerID);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ��","del()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
	function add(){
		var CustomerID = "<%=customerID%>";
		var sReturn = CustomerManage.selectResumeEndDate(CustomerID);
		if(sReturn == "Empty"){
			alert("�ͻ��Ĵ�ְʱ��û����д�����ܽ�����������������");
			return;
		}
		AsControl.PopComp("/CustomerManage/CustomerEmploymentInfo.jsp","CustomerID=<%=customerID%>","resizable=yes;dialogWidth=450px;dialogHeight=430px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	function edit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		AsControl.PopComp("/CustomerManage/CustomerEmploymentInfo.jsp","SerialNo="+serialNo,"resizable=yes;dialogWidth=450px;dialogHeight=430px;center:yes;status:no;statusbar:no");
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