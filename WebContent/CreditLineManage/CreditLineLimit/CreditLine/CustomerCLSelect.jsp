<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("CLAcountList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","�������","�������","view()","","","","",""},
			};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function view(){
		 var serialNo = getItemValue(0,getRow(0),"SERIALNO");
		 if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			 alert("��ѡ��һ�����룡");
			 return;
		 }
		 AsControl.PopComp("/CreditLineManage/CreditLineLimit/CreditLine/CLInfo.jsp","SerialNo="+serialNo,"resizable=yes;dialogWidth=900px;dialogHeight=420px;center:yes;status:no;statusbar:no");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
