<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String ProjectSerialNo = CurPage.getParameter("SerialNo");
	if(ProjectSerialNo == null) ProjectSerialNo = "";

	String sTempletNo = "ProjectStop";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	doTemp.setDefaultValue("INPUTUSERName", CurUser.getUserName());
	doTemp.setDefaultValue("INPUTORGName", CurOrg.getOrgName());
	dwTemp.setParameter("SerialNo", ProjectSerialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","确定","确定","saveRecord()","","","",""},
		{"true","All","Button","取消","取消","self.close()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
	function saveRecord(){
		var ProjectSerialNo = "<%=ProjectSerialNo%>";
		var sReturn = ProjectManage.selectPrjIsLose(ProjectSerialNo);
		if(sReturn == "16"){
			alert("该项目已失效，无需再次执行此操作！");
			return;
		}else{
			setItemValue(0,0,"Status","16");
			as_save(0);
		}
		reloadSelf();
	}
	function initRow(){
		setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
