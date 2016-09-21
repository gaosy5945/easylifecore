<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
 	String sMsgType = CurPage.getParameter("MsgType");
 	if(sMsgType == null) sMsgType = "";
 
 	ASObjectModel doTemp = new ASObjectModel("AWEDictErrMsg");
 	doTemp.setReadOnly("MSGTYPE", true);
 	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "0";//只读模式
	dwTemp.setPageSize(50);
	dwTemp.genHTMLObjectWindow(sMsgType);
	String sButtons[][] = {
		{"true", "All","Button","快速新增","当前页面新增","afterAdd()","","","","btn_icon_add"},
		{"true", "All","Button","快速保存","快速保存当前页面","as_save(0)","","","","btn_icon_save"},
		{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","","btn_icon_delete",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function afterAdd(){
		as_add(0);
		//快速新增时候给定默认值
		setItemValue(0, getRow(), "MSGTYPE", "<%=sMsgType%>");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>