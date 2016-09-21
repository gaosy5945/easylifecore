<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String buildingSerialNo = CurPage.getParameter("BuildingSerialNo");
	if(buildingSerialNo == null) buildingSerialNo = "";

	String sTempletNo = "BuildingClrMarginInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("ObjectNo", buildingSerialNo);
	dwTemp.setParameter("ObjectType", "jbo.app.BUILDING_INFO");
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function calculatePrepaySum(){
		var prepayAmount = getItemValue(0,getRow(),"PREPAYAMOUNT").replace(/,/g,"");
		var prepayPercent = getItemValue(0,getRow(),"PREPAYPERCENT").replace(/,/g,"");
		if(prepayAmount < 0 || prepayPercent < 0) {
			alert("参数不可为负数！请重新输入！");
			return;
		}else if(prepayAmount == 0 || prepayPercent == 0){
			setItemValue(0,getRow(),"PREPAYSUM","0");
		}else{
			var prepaySum = FormatKNumber(parseFloat(prepayAmount)*parseFloat(prepayPercent)/100.00,2);
			setItemValue(0,getRow(),"PREPAYSUM",prepaySum); 
		}
	}
	function initRow(){
		var SerialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
			setItemValue(0,getRow(),"OBJECTNO","<%=buildingSerialNo%>");
			setItemValue(0,getRow(),"OBJECTTYPE","jbo.app.BUILDING_INFO");
		}
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
