<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sSerialNo = CurPage.getParameter("SerialNo");
	
	if(sSerialNo == null) sSerialNo = "";

	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("ClassifyRemindList",BusinessObject.createBusinessObject(),CurPage);
	ASObjectWindow  dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","ҵ������","ҵ������","view()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function view(){
		 var serialNo = getItemValue(0,getRow(0),"SERIALNO");//��ݱ��
		 var crSerialNo = getItemValue(0,getRow(0),"CRSERIALNO");//������
		 AsCredit.openFunction("ClassifyRemindInfo","DuebillNo="+serialNo+"&CRSerialNo="+crSerialNo);
	     reloadSelf();
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
