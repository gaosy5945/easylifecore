<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = CurPage.getAttribute("CustomerID");
	String DoFlag = CurPage.getAttribute("DoFlag");
	if(DoFlag==null) DoFlag="";
	ASObjectModel doTemp = new ASObjectModel("ALCustomerTelList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("CustomerID", customerID);
	dwTemp.genHTMLObjectWindow(customerID);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"check".equals(DoFlag)?"false":"true","","Button","����","����","add()","","","","",""},
			{"check".equals(DoFlag)?"false":"true","","Button","�޸�","�޸�","edit()","","","","",""},
			{"check".equals(DoFlag)?"false":"true","","Button","ɾ��","ɾ��","del()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		AsControl.PopView("/CreditManage/Collection/ALCustomerTelInfo.jsp","","dialogWidth:600px;dialogHeight:400px;");
		reloadSelf();
	}
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		 AsControl.PopView("/CreditManage/Collection/ALCustomerTelInfo.jsp","SerialNo="+serialNo,"dialogWidth:600px;dialogHeight:400px;");
		 reloadSelf();
	}
	function del(){
		 var serialNo = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		 if(!confirm("ȷ��ɾ����ϵ����Ϣ��?")) return;
		 as_delete(0);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
