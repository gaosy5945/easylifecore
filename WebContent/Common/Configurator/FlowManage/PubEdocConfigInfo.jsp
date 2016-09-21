<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String edocNo = CurPage.getParameter("EdocNo");
	if(edocNo == null || edocNo == "undefined") edocNo = "";
	
	String sTempletNo = "PubEdocConfigInfo";//--Ä£°åºÅ--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(edocNo);
	String sButtons[][] = {
		{"true","All","Button","±£´æ","±£´æ","saveRecord()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	initIsUse();
	function saveRecord(){
		initRow();
		as_save("myiframe0","self.close()");
	}
	function initRow(){
		setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputTime","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
	}
	function initIsUse(){
		setItemValue(0,0,"IsInuse","1");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
