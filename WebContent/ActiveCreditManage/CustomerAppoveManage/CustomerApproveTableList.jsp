<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String TempleteNo = CurComp.getParameter("TempleteNo");
	if(TempleteNo == null) TempleteNo = "";
	String BatchNo = CurComp.getParameter("BatchNo");
	if(BatchNo == null) BatchNo = "";

	ASObjectModel doTemp = new ASObjectModel("CustomerApprovalTableList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.setParameter("BatchNo", BatchNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","����","����","viewAndEdit()","","","","btn_icon_detail",""},
			{"true","All","Button","����","����","exportPage('"+sWebRootPath+"',0,'excel','')","","","","",""},
	};
%>
<HEAD>
<title>Ԥ�����б�</title>
</HEAD>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function viewAndEdit(){
	var TempleteNo = "<%=TempleteNo%>";
	var SerialNo = getItemValue(0,getRow(),"SerialNo");
	if(typeof(SerialNo) == "undefined"||SerialNo.length == 0){
		alert("��ѡ��һ����¼��");
		return;
	}
	AsControl.PopView("/ActiveCreditManage/CustomerAppoveManage/CustomerApproveTableInfo.jsp", "SerialNo="+SerialNo+"&TempleteNo="+TempleteNo, "resizable=yes;dialogWidth=800px;dialogHeight=450px;center:yes;status:no;statusbar:no");
	reloadSelf();
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
