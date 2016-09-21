<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null || serialNo == "undefined") serialNo = "";
	String authorizeType = CurPage.getParameter("AuthorizeType");
	
	String sTempletNo = "RuleSceneGroupInfo1";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","save()","","","",""},
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function save(){
		as_save("myiframe0");
	}
	function insert(){
		setItemValue(0,getRow(),"AuthorizeType", "<%=authorizeType%>");
		setItemValue(0,getRow(),"STATUS","1");
		setItemValue(0,getRow(),"INPUTDATE","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
		setItemValue(0,getRow(),"INPUTUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"INPUTORGID","<%=CurOrg.getOrgID()%>");
		var effeDate = getItemValue(0,getRow(),"EFFECTIVEDATE");
		if(typeof(effeDate) == "undefined" || effeDate.length == 0)
		{
			setItemValue(0,getRow(),"EFFECTIVEDATE","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
		}
		
		var exDate = getItemValue(0,getRow(),"EXPIRYDATE");
		if(typeof(exDate) == "undefined" || exDate.length == 0)
		{
			setItemValue(0,getRow(),"EXPIRYDATE","2099/12/31");
		}
	}
	insert();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
