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
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("CustomerID", customerID);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","All","Button","征信查询","征信查询","query()","","","","btn_icon_detail",""},
			{"true","","Button","查看征信信息","查看征信信息","view()","","","","btn_icon_detail",""}
		};
	sASWizardHtml = "<p><font color='red' size='2'>1、不得查询未授权客户的征信报告，不得随意查询客户信用报告。</font></p>" + 
			"<p><font color='red' size='2'>2、所查询信息仅用于我行办理、管理信贷业务，不得泄露、滥用信息。</font></p>" +
			"<p><font color='red' size='2'>3、所有员工必须为知悉的客户信息保密。</font></p>";
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
	<%/*记录被选中时触发事件*/%>
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
            alert(getHtmlMessage('1')); //请选择一条信息！
            return;
        }
		AsControl.OpenPage("/CustomerManage/ICR/viewReport.jsp","ReportSN="+reportNo,"");
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@
 include file="/Frame/resources/include/include_end.jspf"%>
