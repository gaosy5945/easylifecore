 <%@ page contentType="text/html; charset=GBK"%><%@
  include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*
		Describe:--工作笔记列表;
		Input Param:
			ObjectNo： 对象编号
			NoteType： 笔记类型
	 */
	String PG_TITLE = "工作笔记列表"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//获得组件参数
	String sNoteType = CurPage.getParameter("NoteType");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	if(sNoteType == null) sNoteType = "";
	if(sObjectNo == null) sObjectNo = "";

	ASObjectModel doTemp = new ASObjectModel("WorkRecordList");
	/* if (!sNoteType.equals("All")){
		doTemp.appendJboWhere(" and ObjectType = '"+sNoteType+"' and ObjectNo = '"+sObjectNo+"' ");
	} */
		
	//设置DataWindow
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(CurUser.getUserID());

	String sButtons[][] = {
		{"true","","Button","新增","新增客户经理工作笔记","newRecord()","","","",""},
		{"true","","Button","详情","查看客户经理工作笔记","viewAndEdit()","","","",""},
		{"true","","Button","删除","删除客户经理工作笔记","deleteRecord()","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
		OpenPage("/DeskTop/WorkRecordInfo.jsp","_self","");
	}

	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm(getHtmlMessage('2'))){ //您真的想删除该信息吗？
			as_delete('myiframe0');
		}
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--当前流水号
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			OpenPage("/DeskTop/WorkRecordInfo.jsp?SerialNo="+sSerialNo, "_self","");
		}
	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>