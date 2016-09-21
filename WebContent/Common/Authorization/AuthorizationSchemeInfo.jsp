<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null || serialNo == "undefined") serialNo = "";

	String sTempletNo = "RuleSceneGroupInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","save()","","","",""},
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function save(){
		as_save("myiframe0");
	}
	function insert(){
		setItemValue(0,getRow(),"STATUS","1");
		setItemValue(0,getRow(),"INPUTDATE","<%=com.amarsoft.app.base.util.DateHelper.getToday()%>");
		setItemValue(0,getRow(),"INPUTUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"INPUTORGID","<%=CurOrg.getOrgID()%>");
	}
	insert();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
