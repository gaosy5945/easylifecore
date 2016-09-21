<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String edocNo = CurPage.getParameter("EdocNo");
	if(edocNo == null || edocNo == "undefined") edocNo = "";
	
	String sTempletNo = "PubEdocConfigEditInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(edocNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","save()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function save(){
		initRow();
		as_save("myiframe0","self.close()");
	}
	function initRow(){
		setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateOrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"UpdateTime","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
