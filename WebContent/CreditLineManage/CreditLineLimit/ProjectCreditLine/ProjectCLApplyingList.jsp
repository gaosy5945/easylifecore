<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String status = CurPage.getParameter("Status");
	if(status == null) status = "";

	ASObjectModel doTemp = new ASObjectModel("ProjectCLApplyingList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("Status", status);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","ǩ�����","ǩ�����","writeOpinion()","","","","",""},
			{"true","All","Button","�ύ","�ύ","approveOpinion()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditLineManage/CreditLineLimit/js/CreditLineManage.js"></script>
<script type="text/javascript">
	function writeOpinion(){
		 var serialNo = getItemValue(0,getRow(0),"SERIALNO");
		 var COSerialNo = getItemValue(0,getRow(0),"TRACEOBJECTNO");
		 var CLSerialNo = getItemValue(0,getRow(0),"CLSERIALNO");
		 if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			 alert("��ѡ��һ�����룡");
			 return;
		 }
		AsControl.PopView("/CreditLineManage/CreditLineLimit/ProjectCreditLine/ProjectCLApproveInfo.jsp","SerialNo="+serialNo+"&COSerialNo="+COSerialNo+"&CLSerialNo="+CLSerialNo,"");
		reloadSelf();
	}
	function approveOpinion(){
		 var serialNo = getItemValue(0,getRow(0),"SERIALNO");
		 var COSerialNo = getItemValue(0,getRow(0),"TRACEOBJECTNO");
		 if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			 alert("��ѡ��һ�����룡");
			 return;
		 }
		AsControl.PopComp("/CreditLineManage/CreditLineLimit/CreditLine/CLApproveOpinion.jsp","SerialNo="+serialNo+"&COSerialNo="+COSerialNo,"resizable=yes;dialogWidth=400px;dialogHeight=150px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
