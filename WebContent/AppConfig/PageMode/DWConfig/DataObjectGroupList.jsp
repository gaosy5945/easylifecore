<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	String sDONo = CurPage.getParameter("DONo");
	if(sDONo == null) sDONo = "";
	
	ASObjectModel doTemp = new ASObjectModel("DataObjectGroupList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sDONo);

	String sButtons[][] = {
		{"true", "All","Button","快速新增","当前页面新增","afterAdd()","","",""},
		{"true", "All","Button","快速保存","快速保存当前页面","afterSave()","","",""},
		{"true", "All", "Button", "删除", "", "deleteRecord()", "", "", ""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	setDialogTitle("DataWindow显示模板分组信息");
	var sDONo = "<%=sDONo%>";
	function afterSave(){
		as_save("myiframe0");
	}
	
	//快速新增
	function afterAdd(){
		as_add("myiframe0");
		//快速新增时候给定默认值
		setItemValue(0,getRow(),"DONO",sDONo);
	}
	
	//快速删除
	function deleteRecord(){
		var sDockId = getItemValue(0,getRow(),"DOCKID");
		if (typeof(sDockId)=="undefined" || sDockId.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage("2"))){ //您真的想删除该信息吗？
			as_delete("myiframe0");
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>