<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String AccountNo = CurPage.getParameter("AccountNo");
	if(AccountNo == null) AccountNo = "";
	String sTempletNo = "SelectClrDate";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "0";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","ȷ��","ȷ��","ensure()","","","",""},
		{"true","","Button","ȡ��","ȡ��","self.close()","","","",""},
	};
%>
<title>��֤���˻���ϸ��ѯ</title>	
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function ensure(){
		if(!iV_all("0")) return ;
		var startDate = getItemValue(0,getRow(),"StartDate");
		var endDate = getItemValue(0,getRow(),"EndDate");
		if(startDate > endDate){
			alert("��ʼʱ�䲻�ܴ��ڽ���ʱ�䣬���������룡");
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
