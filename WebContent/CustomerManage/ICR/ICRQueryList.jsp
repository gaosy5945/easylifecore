<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");

	if(customerID == null) customerID = "";
	if(objectNo == null) objectNo = "";
	if(objectType == null) objectType = "";
	
	ASObjectModel doTemp = new ASObjectModel("ICRQueryList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("CustomerID", customerID);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","All","Button","���Ų�ѯ","���Ų�ѯ","query()","","","","btn_icon_detail",""},
			{"true","","Button","�鿴������Ϣ","�鿴������Ϣ","view()","","","","btn_icon_detail",""}
		};
	sASWizardHtml = "<p><font color='red' size='2'>1�����ò�ѯδ��Ȩ�ͻ������ű��棬���������ѯ�ͻ����ñ��档</font></p>" + 
			"<p><font color='red' size='2'>2������ѯ��Ϣ���������а��������Ŵ�ҵ�񣬲���й¶��������Ϣ��</font></p>" +
			"<p><font color='red' size='2'>3������Ա������Ϊ֪Ϥ�Ŀͻ���Ϣ���ܡ�</font></p>";
%> 
<script type="text/javascript">
	function query(){
		var customerID = "<%=customerID%>";
		
		var returnValue = AsControl.RunASMethod("WorkFlowEngine","SingleQuery",customerID+",<%=CurUser.getUserID()%>");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		if(returnValue.split("@")[0] == "true")
		{
			AsControl.PopPage("/CustomerManage/ICR/viewReport.jsp","ReportSN="+returnValue.split("@")[1],"");
			reloadSelf();
		}
		else
		{
			alert(returnValue.split("@")[1]);
		}
		
	}
	<%/*��¼��ѡ��ʱ�����¼�*/%>
	function mySelectRow(){
		var sReportSN = getItemValue(0,getRow(),"ReportSN");
		if(typeof(sReportSN)=="undefined" || sReportSN.length==0) {
			return;
		}else{
			//AsControl.OpenView("/CustomerManage/ICR/ICRPKeyField.jsp","ReportSN="+sReportSN,"rightdown","");
		}
	}

	function view(){
		var reportNo = getItemValue(0,getRow(0),"REPORTSN");
		if (typeof(reportNo)=="undefined" || reportNo.length==0){
            alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
            return;
        }
		AsControl.OpenPage("/CustomerManage/ICR/viewReport.jsp","ReportSN="+reportNo,"");
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@
 include file="/Frame/resources/include/include_end.jspf"%>
