<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String prjSerialNo = CurPage.getParameter("PrjSerialNo");
	if(prjSerialNo == null) prjSerialNo = "";

	String sTempletNo = "ProjectAccumulationGuarantyInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			{"true","All","Button","����","���������޸�","as_save(0)","","","","btn_icon_save"},
			{"true","All","Button","����","���������޸�","reloadSelf()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function reloadSelf(){
		AsControl.OpenView("/ProjectManage/ProjectNewApply/ProjectAccumulationGuarantyList.jsp", "", "_self", "");
	}
	function initRow(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"PROJECTSERIALNO","<%=prjSerialNo%>");
		}else{
			setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
		}
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
