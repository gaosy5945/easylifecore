<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sTempletNo = CurComp.getParameter("sTempletNo");
	if(sTempletNo == null) sTempletNo = "";

	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	if("CustomerListApproving".equals(sTempletNo)){
		dwTemp.MultiSelect = true; //�����ѡ
	}
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"CustomerListApproved".equals(sTempletNo)?"false":"true","All","Button","����","����","approveCustomer()","","","","",""},
			};
%>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function approveCustomer(){
		var relaSerialNos = '';
		var relaTodoTypes = '';
		var recordArray = getCheckedRows(0);//��ȡ��ѡ����
		if (typeof(recordArray)=="undefined" || recordArray.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		for(var i = 1;i <= recordArray.length;i++){
			var serialNo = getItemValue(0,recordArray[i-1],"SERIALNO");
			relaSerialNos += serialNo+"@";
			var todoType = getItemValue(0,recordArray[i-1],"TODOTYPE");
			relaTodoTypes += todoType+"@";
		}
		AsControl.PopView("/CustomerManage/SpecialCustomerManage/SpecialCustomerApproveOpinion.jsp","relaSerialNos="+relaSerialNos+"&relaTodoTypes="+relaTodoTypes,"resizable=yes;dialogWidth=400px;dialogHeight=150px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
