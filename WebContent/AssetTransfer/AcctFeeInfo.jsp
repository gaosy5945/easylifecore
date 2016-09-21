<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	
	String sSerialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));//费用方案流水号
	String sObjectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));//项目编号
	String sObjectType = DataConvert.toString(CurPage.getParameter("ObjectType"));//项目类型
	String sTempletNo = "ProjectAssetAcctFeeInfo";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setReadOnly("ObjectNo,ObjectType", true);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.setPageSize(30);
	dwTemp.genHTMLObjectWindow(sSerialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","asSave()","","","",""},
		{"true","","Button","返回","返回列表","returnList()","","","",""}
	};
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function asSave(){
		setItemValue(0,0,"ObjectNo",'<%=sObjectNo%>');
		setItemValue(0,0,"ObjectType",'<%=sObjectType%>'); 
		as_save("myiframe0","");
	}

	function returnList(){
		AsControl.OpenPage("/ProjectManage/ProjectAssetTransfer/ProjectAssetAcctFeeList.jsp","ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","_self");
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
