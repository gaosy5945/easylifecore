<%@ page contentType="text/html; charset=GBK"%>
 <%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String status = CurPage.getParameter("Status");
	if(status == null) status = "";
	
	ASObjectModel doTemp = new ASObjectModel("RiskClassifyRecordList");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.setParameter("Status", status);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

	function edit(){
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("��ѡ��һ����¼��");
			return ;
		}
		var returnValue =RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.ClassifyAdjustInfo","getFlowSerialNo","SerialNo="+serialNo);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		AsCredit.openFunction("ViewClassifyInfo","SerialNo="+serialNo+"&RightType=ReadOnly&FlowSerialNo="+returnValue);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
