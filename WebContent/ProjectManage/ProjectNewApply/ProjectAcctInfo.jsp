<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String SerialNo = CurPage.getParameter("SerialNo");
	if(SerialNo == null) SerialNo = "";
	String ObjectNo = CurPage.getParameter("ObjectNo");
	if(ObjectNo == null) ObjectNo = "";
	String ObjectType = CurPage.getParameter("ObjectType");
	if(ObjectType == null) ObjectType = "";
	
	String sTempletNo = "ProjectAcctInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	
	dwTemp.setParameter("SerialNo", SerialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{"true","All","Button","返回","返回列表","returnList()","","","",""}
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		OpenPage("/ProjectManage/ProjectNewApply/ProjectAcctList.jsp?ObjectNo="+"<%=ObjectNo%>", "_self", "");
	}
	function initRow(){
		var SerialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
			setItemValue(0,0,"ObjectNo","<%=ObjectNo%>");
			setItemValue(0,0,"ObjectType","<%=ObjectType%>");
		}
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
