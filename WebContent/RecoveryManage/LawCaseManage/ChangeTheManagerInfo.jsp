<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	//sPara = "RelativeSerialNoList="+sSerialNoList+"&ManagerUserIdList="+sManagerUserIdList+"&ManagerOrgIdList="+sManagerOrgIdList;
	String ManagerUserIdList = CurPage.getParameter("ManagerUserIdList");
	if(ManagerUserIdList == null) ManagerUserIdList = "";	

	String sTempletNo = "ChangeTheManagerInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "测试");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		<%-- OpenPage("<%=sPrevUrl%>", "_self"); --%>
		self.close();
	}
	function saveRecord(){
		as_save(0,"aftersaveRecord()");
	}
	function aftersaveRecord(){
		var ManagerUserIdList = "<%=ManagerUserIdList%>";
		var nowUserID = getItemValue(0,getRow(),'OPERATEUSERID');
		var icount = (ManagerUserIdList.split(nowUserID)).length - 1;
		if(icount > 0){
			alert("选择变更的信息中有"+ icount +" 笔信息的管理人与现管理人相同！");
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
