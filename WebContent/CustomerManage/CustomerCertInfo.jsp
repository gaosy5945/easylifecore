<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sCustomerID =  CurComp.getParameter("CustomerID");
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sCustomerID == null) sCustomerID = "";
	if(sPrevUrl == null) sPrevUrl = "";

	String sTempletNo = "CustomerCertInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDefaultValue("CustomerID", sCustomerID);
	doTemp.setDefaultValue("InputUser",CurUser.getUserID());
	doTemp.setDefaultValue("InputOrg", CurUser.getOrgID());

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		OpenPage("<%=sPrevUrl%>", "_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
