<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String prjSerialNo = CurComp.getParameter("SerialNo");
	if(prjSerialNo == null) prjSerialNo = "";

    String sTempSaveFlag = "" ;//暂存标志
	String sTempletNo = "ProjectEquipmentInfo1";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(prjSerialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","","btn_icon_save",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function initRow(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		var prjSerialNo = "<%=prjSerialNo%>";
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			setItemValue(0,0,"PROJECTSERIALNO",prjSerialNo);
		}
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
