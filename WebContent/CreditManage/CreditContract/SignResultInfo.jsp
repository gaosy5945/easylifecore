<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	/*
	Author:   qzhang  2004/12/09
	Tester:
	Content: ��ͬ��ǩ�����¼
	Input Param:	 
	Output param:
	History Log: 
	*/
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	if(objectNo == null) objectNo = "";
	if(objectType == null) objectType = "";

	String sTempletNo = "SignResultInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(objectNo+","+objectType);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
	};
	//sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord()
	{
		beforeUpdate();	
		as_save(0);
	}
	function beforeUpdate(){
		setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");	
		setItemValue(0,0,"OBJECTNO","<%=objectNo%>");	
		setItemValue(0,0,"OBJECTTYPE","<%=objectType%>");	
		setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");	
		setItemValue(0,0,"INPUTORGID","<%=CurUser.getOrgID()%>");	
	}


</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
