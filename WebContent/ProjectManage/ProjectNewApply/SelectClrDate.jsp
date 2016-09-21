<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String AccountNo = CurPage.getParameter("AccountNo");
	if(AccountNo == null) AccountNo = "";
	String sTempletNo = "SelectClrDate";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "0";//只读模式
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","确定","确定","ensure()","","","",""},
		{"true","","Button","取消","取消","self.close()","","","",""},
	};
%>
<title>保证金账户明细查询</title>	
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function ensure(){
		if(!iV_all("0")) return ;
		var startDate = getItemValue(0,getRow(),"StartDate");
		var endDate = getItemValue(0,getRow(),"EndDate");
		if(startDate > endDate){
			alert("起始时间不能大于结束时间，请重新输入！");
			return;
		}
		var AccountNo = "<%=AccountNo%>";
		AsControl.PopPage("/ProjectManage/ProjectNewApply/MarginDetailSelect.jsp","AccountNo="+AccountNo+"&StartDate="+startDate+"&EndDate="+endDate,"resizable=yes;dialogWidth=1000px;dialogHeight=240px;center:yes;status:no;statusbar:no","");
	}
	function initRow(){
		setItemValue(0,getRow(),"StartDate","<%=DateHelper.getBusinessDate()%>");
		setItemValue(0,getRow(),"EndDate","<%=DateHelper.getBusinessDate()%>");
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
