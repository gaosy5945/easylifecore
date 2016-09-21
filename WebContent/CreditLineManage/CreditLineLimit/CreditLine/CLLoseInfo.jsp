<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String CLSerialNo = CurPage.getParameter("SerialNo");
	if(CLSerialNo == null) CLSerialNo = "";

	String sTempletNo = "CLLoseInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	doTemp.setDefaultValue("OPERATETYPE", "4");
	doTemp.setReadOnly("OPERATETYPE", true);
	doTemp.setDefaultValue("OPERATEUSERIDName", CurUser.getUserName());
	doTemp.setDefaultValue("OPERATEORGIDName", CurOrg.getOrgName());
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","ȷ��","ȷ��","saveRecord()","","","",""},
		{"true","All","Button","����","����","self.close()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditLineManage/CreditLineLimit/js/CreditLineManage.js"></script>
<script type="text/javascript">
	function saveRecord(){
		as_save(0,"updateCLLose()");
	}
	function updateCLLose(){
		var CLSerialNo = getItemValue(0,getRow(0),"CLSERIALNO");
		CreditLineManage.updateCLLose(CLSerialNo);
	}
	function initRow(){
		setItemValue(0,0,"CLSERIALNO","<%=CLSerialNo%>");
		setItemValue(0,0,"OPERATIONSTATUS","50");
		setItemValue(0,0,"OPERATEUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"OPERATEORGID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,0,"OPERATDATE","<%=DateHelper.getToday()%>");
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
