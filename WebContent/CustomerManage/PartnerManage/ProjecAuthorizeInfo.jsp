<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	String projectNo = CurPage.getParameter("ProjectNo");
	if(serialNo == null) serialNo = "";

	String sTempletNo = "ProjecAuthorizeInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "测试");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","All","Button","返回","返回列表","goBack()","","","",""},
		{"false","All","Button","暂存","暂存","saveTemp()","","","",""}
	};
//	sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

	/**保存数据	 */
	function saveRecord(){
		setItemValue(0,0,"ConsignerIssueCountry",getItemValue(0,0,"ConsignerIssueCountryName"));
//		setItemValue(0,0,"TempSaveFlag","0");
		as_save(0);
	}
	/*暂存*/
	function saveTemp(){
		setItemValue(0,0,"TempSaveFlag","1");
		as_saveTmp("myiframe0");
	}
	
	function goBack(){
		var sUrl = "/CustomerManage/PartnerManage/ProjectAuthorizeList.jsp?SerialNo=<%=projectNo%>";
		 OpenPage(sUrl,'_self','');
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>