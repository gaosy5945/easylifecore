<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//<!---------��ǰ�û������пͻ���Ϣ------------------>
	ASObjectModel doTemp = new ASObjectModel("RiskWarningCustomerList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	//�û����
	String UserId = CurUser.getUserID();
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(UserId);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","Ԥ������","Ԥ������","edit()","","","","",""},		
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

	function edit(){
		
		 var sUrl = "BusinessManage/RiskWarningManage/CustomerRiskWarning.jsp";
		 var sCustomerId = getItemValue(0,getRow(0),'CUSTOMERID');
		 if(typeof(sCustomerId)=="undefined" || sCustomerId.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		//AsControl.OpenPage(sUrl,'SerialNo=' +sPara ,'_self','');
		AsControl.PopComp(sUrl,"sCustomerId="+sCustomerId, "resizable=yes;dialogWidth=1200px;dialogHeight=1200px;center:yes;status:no;statusbar:no");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
