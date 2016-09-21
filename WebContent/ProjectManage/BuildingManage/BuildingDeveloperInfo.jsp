<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%	
	String SerialNo = CurComp.getParameter("SerialNo");
	if(SerialNo == null) SerialNo = "";
	String buildingSerialNo = CurPage.getParameter("BuildingSerialNo");
	if(buildingSerialNo == null) buildingSerialNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("BuildingDeveloperInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("SERIALNO", SerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","保存","保存所有修改","as_save(0)","","","","",""},
			{"true","","Button","返回","返回","goBack()","","","","",""},
		};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function goBack(){
		AsControl.OpenView("/ProjectManage/BuildingManage/BuildingDeveloperList.jsp","BuildingSerialNo="+"<%=buildingSerialNo%>","_self");
	}
	function initRow(){
		var SerialNo = "<%=SerialNo%>";
		if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
			setItemValue(0,0,"BUILDINGSERIALNO","<%=buildingSerialNo%>");
		}
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
