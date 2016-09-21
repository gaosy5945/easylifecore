<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

	String sTempletNo = "PubRateInfo";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	String sPara = CurPage.getParameter("Currency")+","+CurPage.getParameter("EffectDate")+","+CurPage.getParameter("RateType")+","+CurPage.getParameter("RateUnit")+","+CurPage.getParameter("Term")+","+CurPage.getParameter("TermUnit");
	dwTemp.genHTMLObjectWindow(sPara);
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{"true","All","Button","返回","返回列表","returnList()","","","",""}
	};
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		 AsControl.OpenView("/AppConfig/RateManange/PubRateList.jsp", "","_self","");
	}
	function initRow(){
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTUSERName","<%=com.amarsoft.dict.als.manage.NameManager.getUserName(CurUser.getUserID())%>");
		setItemValue(0,0,"INPUTORG","<%=CurOrg.getOrgID()%>");
		setItemValue(0,0,"INPUTORGName","<%=com.amarsoft.dict.als.manage.NameManager.getOrgName(CurOrg.getOrgID())%>");
		setItemValue(0,0,"INPUTTIME","<%=com.amarsoft.app.base.util.DateHelper.getBusinessTime()%>");
		bIsInsert = true;
	}
	initRow()
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>