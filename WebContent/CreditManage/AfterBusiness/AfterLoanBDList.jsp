<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = DataConvert.toString(CurPage.getParameter("CustomerID"));
    String ObjectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));//��Ŀ���
    if(ObjectNo==null) ObjectNo="";
	ASObjectModel doTemp = new ASObjectModel("AfterLoanBDList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ProjectSerialNo", ObjectNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			//{"true","","Button","����","����","edit()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		 var duebillSerialNo = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(duebillSerialNo)=="undefined" || duebillSerialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.PopView("/CreditManage/AfterBusiness/DuebillInfo.jsp",'DuebillSerialNo=' +duebillSerialNo ,'','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
