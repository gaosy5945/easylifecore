<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));//账户信息流水号
	String sObjectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));//项目编号
	String sObjectType = DataConvert.toString(CurPage.getParameter("ObjectType"));//项目类型

	String sTempletNo = "AcctAccountsInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","asSave()","","","",""},
		{"true","All","Button","返回","返回列表","returnList()","","","",""}
	};
	//sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function asSave(){
		setItemValue(0,0,"ObjectNo",'<%=sObjectNo%>');
		setItemValue(0,0,"ObjectType",'<%=sObjectType%>');
		as_save(0);
	}
	
	function returnList(){
		OpenPage("/AssetTransfer/AcctAccountsList.jsp", "_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
