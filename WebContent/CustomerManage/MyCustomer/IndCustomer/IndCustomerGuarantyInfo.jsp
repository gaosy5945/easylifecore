<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%-- ҳ��˵��: �ͻ���Ϣ����->�ͻ�����һ��->���е�����Ϣҳ��--%>
<%
	String sSerialNo = CurPage.getParameter("serialNo");
	if(sSerialNo == null) sSerialNo = "";

	String sTempletNo = "IndCustomerGuarantyInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(sSerialNo);
    dwTemp.replaceColumn("INDCUSTOMERFORGUARANTYLIST", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"360\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/IndCustomer/IndCustomerForGaurantyList.jsp?serialNo="+sSerialNo+"&CompClientID=" + sCompClientID + "\"></iframe>", CurPage.getObjectWindowOutput());

	String sButtons[][] = {
		/* {"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sSerialNo)),"All","Button","����","�����б�","returnList()","","","",""}
 */	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		OpenPage("<%=sSerialNo%>", "_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
