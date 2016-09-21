<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("PSerialNo");
	if(serialNo == null) serialNo = "";//楼号信息流水号
	
	String estateNo = CurPage.getParameter("EstateNo");
	if(estateNo == null) estateNo = "";//楼盘号

	String sTempletNo = "BuildingDetailInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0,'thisReload();')","","","",""},
	};
	//sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function thisReload(){
		parent.OpenPage("/CustomerManage/PartnerManage/BuildingDetailList.jsp","rightup","");
	}
	setItemValue(0,0,"EstateNo","<%=estateNo%>");
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
