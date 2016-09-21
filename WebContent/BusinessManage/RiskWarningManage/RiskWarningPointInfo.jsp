<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";	
	String rightType2 = CurPage.getParameter("RightType2");
	if(rightType2 == null) rightType2 = "";	
    String objectType = "RectifyDemand";
	String sTempletNo = "RiskWarningPointInfo";//--模板号--
	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	if("ReadOnly".equals(rightType2)){
		doTemp.setReadOnly("*", true);
	}
	dwTemp.genHTMLObjectWindow(serialNo);
	dwTemp.replaceColumn("ATTACHMENT", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"\\Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
		{"ReadOnly".equals(rightType2)?"false":"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
	};
	//sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	//生成流水号
	function GetSerialNo(){
		var sTableName = "RISK_WARNING_SIGNAL";//表名
		var sColumnName = "SERIALNO";//字段名
		var sPrefix = "";//前缀
		//获取流水号
		var serialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//赋值
		setItemValue(0, getRow(), 'SerialNo', serialNo);
	}
	
	function selectOrgMuti(){
		var orgID = "<%=CurUser.getOrgID()%>";
		if(orgID == "9900"){
			AsCredit.setMultipleTreeValue('SelectBelongBossOrg', "OrgID,<%=CurUser.getOrgID()%>", "", "", "myiframe0", getRow(), "GiveOutOrg", "OrgName");
		}else{
			AsCredit.setMultipleTreeValue('SelectBelongSubOrg', "OrgID,<%=CurUser.getOrgID()%>", "", "", "myiframe0", getRow(), "GiveOutOrg", "OrgName");
		}
	}
	
	/*~[Describe=打开附件页面;InputParam=无;OutPutParam=无;]~*/
	function openDoc(){
		var objectNo=getItemValue(0,0,"SerialNo");
		OpenComp("DocumentList","/Common/BusinessObject/BusinessObjectDocumentList.jsp","RightType=<%=rightType2%>&ObjectType=<%=objectType%>&ObjectNo="+objectNo,"frame_list","");
	}
	
	if("<%=serialNo%>" == ""){
		GetSerialNo();
	}
	openDoc();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
