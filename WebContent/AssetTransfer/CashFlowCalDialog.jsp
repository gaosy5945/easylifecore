<%@page import="com.amarsoft.are.lang.DateX"%>
<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@ page import="java.util.Date"%>
<%	
	//

	String sTempletNo = "CashFlowCalDialog";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(CurPage.getParameter(""));
	String sButtons[][] = {
		{"true","All","Button","确定","确定","ok()","","","",""},
		{"true","All","Button","取消","取消","cancel()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	$(document).ready(function(){
		var curDate = '<%=DateX.format(new Date())%>';
		setItemValue(0,0,"startDate",curDate);
	});

	function ok(){
		var startDate = getItemValue(0,0,"startDate");
		var endDate = getItemValue(0,0,"endDate");
		var term = getItemValue(0,0,"term");
		
		if(typeof(startDate) == 'undefined' || startDate.length == 0){
			alert("预测开始日不能为空");
			return;
		}
		if(typeof(endDate) == 'undefined' || endDate.length == 0){
			alert("预测结束日不能为空");
			return;
		}
		if(typeof(term) == 'undefined' || term.length == 0){
			alert("期间单位不能为空");
			return;
		}
		
		self.returnValue = startDate+"@"+endDate+"@"+term;
		self.close();
		
	}
	
	function cancel(){
		self.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
