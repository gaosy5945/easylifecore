<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%	
	String CustomerID = CurComp.getParameter("CustomerID");
	if(CustomerID == null) CustomerID = "";

	ASObjectModel doTemp = new ASObjectModel("IndCustomerRiskAndImportant");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");
	dwTemp.replaceColumn("RISKINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/IndCustomerRiskList.jsp?CustomerID="+CustomerID+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("IMPORTANTINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/IndCustomerImportantInfoList.jsp?CustomerID="+CustomerID+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
		};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
