<%@ page contentType="text/html; charset=GBK"%><%@
include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String sGroupID = CurPage.getParameter("GroupID");
	String sItemNo = CurPage.getParameter("ItemNo");
	String sDisplayType = CurPage.getParameter("DisplayType");
	if(sGroupID == null) sGroupID = "";
	if(sItemNo == null) sItemNo = "";
	if(sDisplayType == null) sDisplayType = "";

	ASObjectModel doTemp = new ASObjectModel("GroupPageItemInfo");
	if(!"2".equals(sDisplayType)) doTemp.setVisible("Attribute2",false);//如果是Strip则展示《层叠条高度》
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.genHTMLObjectWindow(sGroupID+","+sItemNo);

	String sButtons[][] = {
		{"true","All","Button","保存","","saveRecord()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"
%><script type="text/javascript">
	function saveRecord(){
		as_save(0,'self.close();');
	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>