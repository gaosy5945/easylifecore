<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
 <%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>

<% 
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	if(taskSerialNo == null) taskSerialNo = "";
	String sTempletNo = "SignAdviceInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(taskSerialNo);
	String sButtons[][] = {
		{"true","All","Button","ȷ��","ȷ��","saveRecord()","","","",""}, 
		{"true","All","Button","����","����","back()","","","",""}, 
	};
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>

<script type="text/javascript">
	function saveRecord(){ 
		if(!iV_all("myiframe0"))return; 
		as_save("myiframe0");
		//self.close();
	}
	
	function back(){
		self.close();
	}
	setItemValue(0,0,"USERID","<%=CurUser.getUserID()%>");
	setItemValue(0,0,"ORGID","<%=CurUser.getOrgName()%>");
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 