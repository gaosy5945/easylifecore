<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	if(serialNo == null) serialNo = "";

	String sTempletNo = "FlowCheckInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "south";
%>
<title>问题描述</title>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		var checkItemName =getItemValue(0, 0, "CheckItemName");
		if(checkItemName != null && checkItemName != ""){
			if (checkItemName.indexOf("\\")>-1){
				alert("录入信息包含'\\'，请检查！");
				return;
			}
		}
		as_save(0);
	}
	function returnList(){
		self.returnValue = getItemValue(0,getRow(),"CheckItemName");
		self.close();
	}
	var InputUserID = getItemValue(0, getRow(0), "InputUserID");
	if(InputUserID != "<%=CurUser.getUserID()%>" && typeof(InputUserID) != "undefined" && InputUserID.length > 0){
		setItemDisabled(0, getRow(0), "CheckItemName", true);
	}
	setItemValue(0,getRow(0),"TaskSerialNo","<%=objectNo%>");
	setItemValue(0,getRow(),"ObjectType","<%=objectType%>");
	setItemValue(0,getRow(),"ObjectNo","<%=objectNo%>");
	var orgid = getItemValue(0,getRow(0),"InputOrgID")
	if(typeof(orgid) == "undefined" || orgid.length == 0)
	{
		setItemValue(0,getRow(0),"InputOrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(0),"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(0),"InputTime","<%=com.amarsoft.app.base.util.DateHelper.getBusinessTime()%>");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
