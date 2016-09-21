<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%

	String sTempletNo = "BuildingInitInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(CurPage.getParameter(""));
	String sButtons[][] = {
		{"true","All","Button","确定","确定","returnList()","","","",""},
		{"true","All","Button","取消","取消","cancel()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	/*确定*/
	function returnList(){
		if(!iV_all(0)){
			return;
		}
		var buildingName = getItemValue(0,0,"buildingName");
		var status = RunJavaMethod("com.amarsoft.app.als.customer.partner.action.BuildingAction","nameCanUse","buildingName=" + buildingName);
		if(status == "1"){
			alert("楼盘名称已经存在，请重新录入");
			return;
		}
		as_save(0,"aftSave();");
	}
	
	function aftSave(){
		top.returnValue = getItemValue(0,0,"SerialNo");
		top.close();
	}
	/*取消*/
	function cancel(){
		top.returnValue = "_CANCEL_";
		top.close();
	}
	/*初始化流水号*/
	function initSerialNo(){
		var serialNo = "<%=DBKeyHelp.getSerialNo("BUILDING_INFO", "SerialNo")%>";
		setItemValue(0,0,"SerialNo",serialNo);
	}
	
	initSerialNo();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
