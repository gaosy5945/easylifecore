<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%

	String teamID = CurPage.getParameter("TeamID");
	String orgID = CurPage.getParameter("OrgID");
	if(teamID == null || teamID == "undefined") teamID = "";
	if(orgID == null || orgID == "undefined") orgID = "";

	ASObjectModel doTemp = new ASObjectModel("FlowTeamInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.setParameter("OrgID", orgID);
	dwTemp.setParameter("TeamID", teamID);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(teamID+","+orgID);
	
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	initRow();
	function saveRecord(){
		as_save("myiframe0","self.close()");
	}
	
	function initRow(){
			var itemNo = getSerialNo("TEAM_INFO","TeamID");// �Զ���ȡ�Ŷӱ��
			setItemValue(0,0,"TeamID",itemNo);
			setItemValue(0,0,"Status","1");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputDate","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
