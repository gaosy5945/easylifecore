<!-- 	String activitySerialNo = CurPage.getParameter("ActivitySerialNo"); -->
<!-- 	if(activitySerialNo == null || activitySerialNo == "undefined") activitySerialNo = ""; -->
	
<!-- 	ASObjectModel doTemp = new ASObjectModel("MarketActivityInfo"); -->
<!-- 	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request); -->
<!-- 	dwTemp.Style = "2";//freeform -->
<!-- 	String sButtons[][] = { -->
<!-- 			{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""} -->
<!-- 		}; -->
<!-- 	sButtonPosition = "south"; -->
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
        Author: undefined 2015-12-16
        Content: 示例详情页面
        History Log: 
    */
	String sTempletNo = "MarketActivityInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	String serialNo = CurPage.getParameter("SerialNo");
	serialNo = serialNo==null ? "" : serialNo;
	dwTemp.genHTMLObjectWindow(serialNo);
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""}
	};
	sButtonPosition = "south";
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		as_save(0);
		parent.reloadSelf();
	}
	function init(){
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATETIME","<%=StringFunction.getToday()%>");
	}
	init();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>