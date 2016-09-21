<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String objectType = CurPage.getParameter("ObjectType");
	if(objectType == null) objectType = "";
	String objectNo = CurPage.getParameter("ObjectNo");
	if(objectNo == null) objectNo = "";

	String sTempletNo = "BusinessEducation";//--助学贷款附属信息模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "0";//只读模式
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.genHTMLObjectWindow(objectType+","+objectNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","All","Button","删除","删除","deleteRecord()","","","",""}
	};
	
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		as_save(0);
	}
	
	function deleteRecord(){
		if(!confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
			return ;
		as_delete(0,'refresh()');	
	}
	
	function refresh(){
		AsControl.OpenComp("/CreditManage/CreditApply/BusinessEducation.jsp", "ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>", "_self", "");
	}
	
	function init(){
		setItemValue(0,getRow(),"ObjectType","<%=objectType%>");
		setItemValue(0,getRow(),"ObjectNo","<%=objectNo%>");
	}
	
	init();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
