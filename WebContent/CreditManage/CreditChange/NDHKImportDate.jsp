<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
 <%@ page import="com.amarsoft.app.base.util.DateHelper" %>
 <%
	String edocNo = CurPage.getParameter("EdocNo");
	if(edocNo == null) edocNo = "";
	String fullPathFmt = CurPage.getParameter("FullPathFmt");
	if(fullPathFmt==null) fullPathFmt="";
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo==null) serialNo=""; 
	ASObjectModel doTemp = new ASObjectModel("AfterLoanPrint_Date");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","确认","确认","isSure()","","","","",""},
			{"true","All","Button","取消","取消","cancle()","","","","",""},
		};
	sButtonPosition = "south";
 %>
 
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
<%/* DataWindow选择器选择 */%>
function isSure(){
	var beginDate = getItemValue(0,getRow(0),'RepayBeginDate');
	var finishDate = getItemValue(0,getRow(0),'RepayEndDate');
	if(typeof(beginDate) == "undefined"||beginDate.length == 0 || "undefined" == beginDate){
		alert("起始日期不能为空！");
		return;
	}
	if(typeof(finishDate) == "undefined"||finishDate.length == 0 || "undefined" == finishDate){
		alert("终止日期不能为空！");
		return;
	}
	if(finishDate <= beginDate){
		alert("终止日期必须大于起始日期！");
		return;
	}
 	if(beginDate < '<%=SystemConfig.getBusinessDate()%>'&&'<%=edocNo%>'=='3001'){
		alert("起始日期必须大于等于当前日期！");
		return;
	} 
	AsControl.OpenView('<%=fullPathFmt%>',"SerialNo="+'<%=serialNo%>'+"&BiginDate="+beginDate+"&FinishDate="+finishDate,"_blank");
	self.close();
}

function cancle(){
	self.close();
} 

function initDate(){
	setItemValue(0, getRow(0), "RepayBeginDate", '<%=SystemConfig.getBusinessDate()%>');
	setItemValue(0, getRow(0), "RepayEndDate", '<%=SystemConfig.getBusinessDate()%>');
}

initDate();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
