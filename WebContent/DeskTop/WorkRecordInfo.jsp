<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		Describe:--工作笔记详情;
		Input Param:
			ObjectNo：对象编号
			NoteType：笔记类型
			SerialNo：笔记流水号
	 */
	//获得页面参数
	String sNoteType = CurPage.getParameter("NoteType");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sSerialNo = CurPage.getParameter("SerialNo");
	if(sNoteType == null) sNoteType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sSerialNo == null) sSerialNo = "";
	
	//通过显示模版产生ASDataObject对象doTemp
	ASObjectModel doTemp = new ASObjectModel("WorkRecordInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.genHTMLObjectWindow(sSerialNo);

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"false","","Button","返回","返回列表页面","goBack()","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	setDialogTitle("工作笔记");
	function saveRecord(sPostEvents){
		as_save("myiframe0",sPostEvents);	
	}
	
	function goBack(){
		OpenPage("/DeskTop/WorkRecordList.jsp","_self","");
	}
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>