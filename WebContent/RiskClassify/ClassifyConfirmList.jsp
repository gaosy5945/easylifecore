<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
    String isused=CurPage.getParameter("isused");
	String sSerialNo = CurPage.getParameter("SerialNo");
	
	if(sSerialNo == null) sSerialNo = "";
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("ClassifyConfirmList",BusinessObject.createBusinessObject(),CurPage);
	ASObjectWindow  dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request);
	
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{String.valueOf(isused.equals("0")),"All","Button","ȷ����Ч","ȷ����Ч","confirm()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function confirm(){	
		var serialNo = getItemValue(0,getRow(0),"CRSERIALNO");//������		
		var classifyResult = getItemValue(0,getRow(0),"REFERENCEGRADE"); //ϵͳ������

		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}	
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.ClassifyConfirm","confirm","SerialNo="+serialNo+",ClassifyResult="+classifyResult);
		alert(returnValue);
		reloadSelf();
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
