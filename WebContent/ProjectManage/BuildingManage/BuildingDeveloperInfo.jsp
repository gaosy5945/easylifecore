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
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","���������޸�","as_save(0)","","","","",""},
			{"true","","Button","����","����","goBack()","","","","",""},
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
