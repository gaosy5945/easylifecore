<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String status = CurPage.getParameter("Status");
	if(status == null) status = "";

	ASObjectModel doTemp = new ASObjectModel("CLAppliedList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("Status", status);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","�������","�������","view()","","","","",""},
			{"true","All","Button","�鿴���","�鿴���","viewOpinion()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function view(){
		 var serialNo = getItemValue(0,getRow(0),"TraceObjectNo");
		 if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			 alert("��ѡ��һ�����룡");
			 return;
		 }
		 AsControl.PopComp("/CreditLineManage/CreditLineLimit/CreditLine/CLAcountInfo.jsp","SerialNo="+serialNo,"resizable=yes;dialogWidth=900px;dialogHeight=420px;center:yes;status:no;statusbar:no");
	}
	function viewOpinion(){
		 var serialNo = getItemValue(0,getRow(0),"SERIALNO");
		 var COSerialNo = getItemValue(0,getRow(0),"TRACEOBJECTNO");
		 var CLSerialNo = getItemValue(0,getRow(0),"CLSERIALNO");
		 if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			 alert("��ѡ��һ�����룡");
			 return;
		 }
		 var RightType = "01";
		 AsControl.PopView("/CreditLineManage/CreditLineLimit/CreditLine/CLApproveInfo.jsp","SerialNo="+serialNo+"&COSerialNo="+COSerialNo+"&CLSerialNo="+CLSerialNo+"&RightType="+RightType,"");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
