<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	
	String sObjectNo = CurPage.getParameter("DAOSerialNo");
	if(sObjectNo == null) sObjectNo = "";
	String sObjectType = CurPage.getParameter("ObjectType");
	if(sObjectType == null) sObjectType = "";
	String sTransactionType = CurPage.getParameter("TransactionType");
	if(sTransactionType == null) sTransactionType = "";//���÷�ʽ
	String sDASerialNo = CurPage.getParameter("DASerialNo");
	if(sDASerialNo == null) sDASerialNo = "1";
String sPara = "ObjectNo="+sObjectNo + "&ObjectType="+sObjectType+"&TransactionType="+sTransactionType+"&DASerialNo="+sDASerialNo;
	ASObjectModel doTemp = new ASObjectModel("DAOtherFeeList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sObjectNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 var sUrl = "/RecoveryManage/PDAManage/PDADailyManage/DAOtherFeeInfo.jsp";
		 AsControl.OpenPage(sUrl,"<%=sPara%>",'_self','');
	}
	function edit(){
		 var sUrl = "/RecoveryManage/PDAManage/PDADailyManage/DAOtherFeeInfo.jsp";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.OpenPage(sUrl,'SerialNo=' +sPara+"&<%=sPara%>" ,'_self','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
