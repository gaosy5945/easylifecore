<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

	String sTempletNo = "RelativeContractChooseList";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "1";//2-freeform,
	dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","����","�����б�","returnList()","","","",""}
	};
	//sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function returnList(){
		OpenPage("<%=sPrevUrl%>", "_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
