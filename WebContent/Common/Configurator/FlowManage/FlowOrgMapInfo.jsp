<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String flowOrgMapType = CurPage.getParameter("FlowOrgMapType");
	if(flowOrgMapType == null || flowOrgMapType == "undefined") flowOrgMapType = "";
	String sTempletNo = "FlowOrgMapInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","save()","","","",""},
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	insert();
	function save(){
		as_save(0);
	}
	function SelectOrg(){
		var returnValue = AsCredit.setMultipleTreeValue("SelectAllOrg", "", "", "","myiframe0",getRow(),"OrgList","OrgListName");
	}
	function insert(){
		setItemValue(0,0,"FlowOrgMapType","<%=flowOrgMapType%>");
		setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputDate","<%=com.amarsoft.app.base.util.DateHelper.getToday()%>");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
