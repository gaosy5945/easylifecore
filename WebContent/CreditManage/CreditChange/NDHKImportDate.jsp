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
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","ȷ��","ȷ��","isSure()","","","","",""},
			{"true","All","Button","ȡ��","ȡ��","cancle()","","","","",""},
		};
	sButtonPosition = "south";
 %>
 
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
<%/* DataWindowѡ����ѡ�� */%>
function isSure(){
	var beginDate = getItemValue(0,getRow(0),'RepayBeginDate');
	var finishDate = getItemValue(0,getRow(0),'RepayEndDate');
	if(typeof(beginDate) == "undefined"||beginDate.length == 0 || "undefined" == beginDate){
		alert("��ʼ���ڲ���Ϊ�գ�");
		return;
	}
	if(typeof(finishDate) == "undefined"||finishDate.length == 0 || "undefined" == finishDate){
		alert("��ֹ���ڲ���Ϊ�գ�");
		return;
	}
	if(finishDate <= beginDate){
		alert("��ֹ���ڱ��������ʼ���ڣ�");
		return;
	}
 	if(beginDate < '<%=SystemConfig.getBusinessDate()%>'&&'<%=edocNo%>'=='3001'){
		alert("��ʼ���ڱ�����ڵ��ڵ�ǰ���ڣ�");
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
