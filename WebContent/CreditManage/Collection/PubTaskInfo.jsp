<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";

	String sTempletNo = "PubTaskInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.setParameter("SerialNo",serialNo);
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		{"true","All","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		self.close();
	}
	setItemValue(0,getRow(),"OPERATEUSERID", "<%=CurUser.getUserID()%>");
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
