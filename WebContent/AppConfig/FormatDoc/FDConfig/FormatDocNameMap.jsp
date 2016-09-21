<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	String sDocID = CurPage.getParameter("DocID");
 	String sDirID = CurPage.getParameter("DirID");
	if(sDocID == null) sDocID = "";
	if(sDirID == null) sDirID = "";
	ASObjectModel doTemp = new ASObjectModel("FDNameMapList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "0";//编辑模式
	dwTemp.genHTMLObjectWindow(sDocID+","+sDirID);
	
	String sButtons[][] = {
		{"true","","Button","新增","新增","addRecord()","","","",""},
		{"true","","Button","保存","保存","saveRecord()","","","",""},
		{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	setDialogTitle("字段中文映射");
	function addRecord(){
	 	as_add("myiframe0");
	 	//设置默认值
	 	setItemValue(0,getRow(),'DOCID','<%=sDocID%>');
	 	setItemValue(0,getRow(),'DIRID','<%=sDirID%>');
	}
	function saveRecord(){
		as_save("myiframe0");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>