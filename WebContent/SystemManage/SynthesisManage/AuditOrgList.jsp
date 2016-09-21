<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "本行认可评估机构管理";

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "AuditOrgList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo, Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request, iPostChange);
	CurPage.setAttribute("FilterHTML", doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "1"; //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for (int i = 0; i < vTemp.size(); i++) out.print((String) vTemp.get(i));

	String sButtons[][] = {
		{"true", "", "Button", "新增", "新增一条记录", "newRecord()",	"","","",""},
		{"true", "", "Button", "详情", "查看/修改详情","viewAndEdit()", "","","",""},
		{"true", "", "Button", "删除", "删除所选中的记录","deleteRecord()", "","","",""}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord() {
		OpenPage("/SystemManage/SynthesisManage/AuditOrgInfo.jsp", "_self", "");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord() {
		sSerialNo = getItemValue(0, getRow(), "SerialNo");
		if (typeof (sSerialNo) == "undefined" || sSerialNo.length == 0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if (confirm(getHtmlMessage('2'))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0"); //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit() {
		sSerialNo = getItemValue(0, getRow(), "SerialNo");
		if (typeof (sSerialNo) == "undefined" || sSerialNo.length == 0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		OpenPage("/SystemManage/SynthesisManage/AuditOrgInfo.jsp?SerialNo="+ sSerialNo, "_self", "");
	}

	AsOne.AsInit();
	init();
	my_load(2, 0, 'myiframe0');
</script>
<%@ include file="/IncludeEnd.jsp"%>