<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String prjSerialNo = CurPage.getParameter("SerialNo");
	if(prjSerialNo == null) prjSerialNo = "";

	String sTempletNo = "ProjectRelativeVehicleInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.setParameter("ProjectSerialNo", prjSerialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function initRow(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			setItemValue(0,0,"PROJECTSERIALNO","<%=prjSerialNo%>");
		}
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
