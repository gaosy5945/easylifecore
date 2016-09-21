<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%-- 页面说明: 客户信息详情->客户授信一览->本行担保信息页面--%>
<%
	String sSerialNo = CurPage.getParameter("serialNo");
	if(sSerialNo == null) sSerialNo = "";

	String sTempletNo = "IndCustomerGuarantyInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sSerialNo);
    dwTemp.replaceColumn("INDCUSTOMERFORGUARANTYLIST", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"360\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/IndCustomer/IndCustomerForGaurantyList.jsp?serialNo="+sSerialNo+"&CompClientID=" + sCompClientID + "\"></iframe>", CurPage.getObjectWindowOutput());

	String sButtons[][] = {
		/* {"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sSerialNo)),"All","Button","返回","返回列表","returnList()","","","",""}
 */	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		OpenPage("<%=sSerialNo%>", "_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
