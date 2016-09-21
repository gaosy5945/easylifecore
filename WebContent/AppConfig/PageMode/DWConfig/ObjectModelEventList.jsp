<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String sDoNo = CurPage.getParameter("DoNo");
	String sColName = CurPage.getParameter("ColName");

	ASObjectModel doTemp = new ASObjectModel("ObjectModelEventList");
	doTemp.setLockCount(2); //锁定两列
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "0";//编辑模式
	dwTemp.setPageSize(20);
	dwTemp.ConvertCode2Title = "1";
	dwTemp.genHTMLObjectWindow(sDoNo+","+sColName);

	String sButtons[][] = {
		{"true", "All", "Button", "新增", "新增一行", "afterAdd()", "", "", "", "btn_icon_add"},
		{"true", "All", "Button", "保存", "保存修改数据", "afterSave()", "", "", "", "btn_icon_save"},
		{"true", "All", "Button", "删除", "删除选择行", "deleteRecord()", "", "", "", ""},
	};
%>
<script type="text/javascript">
function afterAdd(){
	as_add(0);
	//快速新增时候给定默认值
	setItemValue(0, getRow(), "DONO", "<%=sDoNo%>");
	setItemValue(0, getRow(), "COLNAME", "<%=sColName%>");
}
function afterSave(){
	as_save(0);
}
//快速删除
function deleteRecord(){
	if(!confirm('确实要删除吗?')) return;
	as_delete(0);
}
</script>
<%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>