<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%

	String sTempletNo = "TransferinAppliInfo";//模板号
	String customerId = CurPage.getParameter("CustomerID"); 
	if(customerId==null) customerId="";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	dwTemp.replaceColumn("CustomerList","<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"500\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/TransferManage/TransferCustomerList.jsp?CustomerID="+customerId+"&CompClientID="+sCompClientID+"&TransferType=20\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
		{"true","All","Button","确认","确认","doSure()","","","",""},
		{"true","All","Button","取消","返回","top.close()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

	/*~[Describe=确认转入申请;InputParam=无;OutPutParam=无;]~*/
	function doSure(){
		//获取所选客户
		var customers = window.frames["frame_list"].returnCustomers();
		if(typeof(customers)=="undefined" || customers.length==0){
			alert("请至少选择一条客户记录！");
			return;
		}
		if(customers == "error") return;
		var vRightType = getItemValue(0,getRow(),"RightType");
		var param = "customerID="+customers+",userID=<%=CurUser.getUserID()%>,orgID=<%=CurUser.getOrgID()%>,rightType="+vRightType;
		var result = RunJavaMethodTrans("com.amarsoft.app.als.customer.transfer.action.TransferAction","saveTransferIn",param);
		if(result == "true"){
			alert("转入申请成功！");
			self.close();
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>

