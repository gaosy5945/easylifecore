<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	//资产赎回测算
	String sTempletNo = "AssetRansomCalInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(CurPage.getParameter(""));
	String sButtons[][] = {
		{"false","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{"false","All","Button","返回","返回列表","returnList()","","","",""}
	};
	//sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		
	}
	
	function cal(){
		var ransomDate = getItemValue(0,0,"RansomDate");
		if(ransomDate.length == 0){
			alert("请先选择日期");
			return;
		}
		
		
		
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
