<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String transStatus = CurPage.getParameter("TransStatus");
	String applyType = CurPage.getParameter("ApplyType");
	String flowFlag = CurPage.getParameter("FlowFlag");
	String taskType = CurPage.getParameter("TaskType");
	String transCode = CurPage.getParameter("TransCode");
	String gcSerialNo = CurPage.getParameter("GCSerialNo");
	
	ASObjectModel doTemp = new ASObjectModel("GuarantyContractChangeListView");	
	
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	
	dwTemp.setParameter("GCSerialNo",gcSerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
		{"true","","Button","����","����","viewAndEdit()","","","","btn_icon_detail",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function viewAndEdit(){
		var serialNo=getItemValue(0,getRow(),"DocumentObjectNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		var guarantorID=getItemValue(0,getRow(),"GuarantorID");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			guarantorID = "";
		}
		var guarantyType = getItemValue(0,getRow(),"GuarantyType");
		var gcSerialNo=getItemValue(0,getRow(),"RelativeObjectNo");
		var rightType = "ReadOnly";
		AsCredit.openFunction("CeilingGCChangeTab", "ObjectNo="+serialNo+"&GuarantyType="+guarantyType+"&GuarantorID="+guarantorID+"&GCSerialNo="+gcSerialNo+"&RightType="+rightType);
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
