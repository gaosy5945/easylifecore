<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String teamID = CurPage.getParameter("TeamID");
	String userID = CurPage.getParameter("UserID");
	if(teamID == null || teamID == "undefined") teamID = "";
	if(userID == null || userID == "undefined") userID = "";

	String sTempletNo = "TeamUserInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.setParameter("UserID", userID);
	dwTemp.setParameter("TeamID", teamID);
	dwTemp.genHTMLObjectWindow(teamID+","+userID);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","All","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		self.close();
	}
	function saveRecord(){
		initRow();
		as_save("myiframe0","self.close()");
	}
	
	<%-- function initRow(){
		setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateOrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"UPDATETIME","<%=com.amarsoft.app.base.util.DateHelper.getToday()%>");
	} --%>
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
