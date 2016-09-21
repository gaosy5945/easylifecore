<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%><%	
	/*
        Author: undefined 2016-01-07
        Content: 
        History Log: 
    */
    String templetNo = CurPage.getParameter("TempletNo");
	String direction = CurPage.getParameter("Direction");
	String invoiceobject = CurPage.getParameter("InvoiceObject");
	if(templetNo == null) templetNo = "";
	if(direction == null) direction = "";
	if(invoiceobject == null) invoiceobject = "";
	ASObjectModel doTemp = new ASObjectModel(templetNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	//dwTemp.MultiSelect = true;	 //多选
	//dwTemp.ShowSummary="1";	 	 //汇总
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	//String drection = CurPage.getAttribute("drection");
	dwTemp.setParameter("direction", direction);
	dwTemp.setParameter("invoiceobject", invoiceobject);
	dwTemp.genHTMLObjectWindow("");

	//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
	String sButtons[][] = {
		{"true","All","Button","新增","新增","newRecord()","","","","btn_icon_add",""},
		{"true","","Button","详情","详情","viewAndEdit()","","","","btn_icon_detail",""},
		{"true","","Button","删除","删除","deleteRecord()","","","","btn_icon_delete",""},
		{"false","","Button","邮寄","邮寄","post()","","","","",""},
		{"false","","Button","签收","签收","sign()","","","","",""},
		{"false","","Button","票据撤销","票据撤销","revoke()","","","","",""},
	};
	if(direction.equals("P")){
		sButtons[3][0] = "true";
		sButtons[4][0] = "true";
		sButtons[5][0] = "true";
	}
	if("03".equals(invoiceobject)) sButtons[0][0] = "false";
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
		 var sUrl = "/InvoiceManage/InvoiceRegisterAddInfo.jsp";
		 var templetNo = "R_InvoiceRegisterAddInfo";
		 if("<%=direction%>"=="P")
			 templetNo = "P_InvoiceRegisterAddInfo";
		 AsControl.OpenView(sUrl,'TempletNo='+templetNo+'&ListTempletNo='+"<%=templetNo%>"+'&Direction='+"<%=direction%>"+'&InvoiceObject='+"<%=invoiceobject%>",'_self','');
	}
	function viewAndEdit(){
		 var sUrl = "/InvoiceManage/InvoiceRegisterInfo.jsp";
		 var sPara = getItemValue(0,getRow(0),'serialno');
		 var purpose = getItemValue(0,getRow(0),'purpose');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("请选择一条记录！");
			return ;
		 }
		 var templetNo = "R_InvoiceRegisterInfo";
		 if("<%=direction%>"=="P"){
			 if("<%=invoiceobject%>" == "03"){
				 templetNo = "P_InvoiceRegisterIndInfo";
			 }else{
				 templetNo = "P_InvoiceRegisterInfo";
			 }
		 }
			
		 AsControl.OpenView(sUrl,'SerialNo='+sPara+'&TempletNo='+templetNo+'&ListTempletNo='+"<%=templetNo%>"+'&Direction='+"<%=direction%>"+'&InvoiceObject='+"<%=invoiceobject%>"+"&Purpose="+purpose,'_self','');
	}
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"serialno");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
		    return;
		}
		if(confirm('确实要删除吗?')){
			AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.invoice.InvoiceDelete","InvoiceDelete","SerialNo="+serialNo);
			as_delete(0);
		}
	}
	function post(){
		var serialno = getItemValue(0,getRow(0),'serialno');
		if(typeof(serialno)=="undefined" || serialno.length==0 ){
			alert("请选择一条记录！");
			return ;
		}
		var status = getItemValue(0,getRow(0),'status');
		if(status == "00" || status == "04"){
			alert("请先确认票据！");
			return
		}
		if(status == "02"){
			alert("该票据已邮寄！");
			return
		}
		if(status == "03"){
			setItemValue(0,getRow(),"status","01");
			var result = AsControl.PopPage("/InvoiceManage/InvoicePostInfo.jsp","SerialNo="+serialno,"resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
			reloadSelf();
		} 
		if(status == "01"){
			var result = AsControl.PopPage("/InvoiceManage/InvoicePostInfo.jsp","SerialNo="+serialno,"resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
			reloadSelf();
		}
	}
	function sign(){
		var serialno = getItemValue(0,getRow(0),'serialno');
		if(typeof(serialno)=="undefined" || serialno.length==0 ){
			alert("请选择一条记录！");
			return ;
		}
		var status = getItemValue(0,getRow(0),'status');
		if(status == "00" || status == "01" || status == "04"){
			alert("该票据不在邮寄状态！");
			return;
		}
		if(status == "03"){
			alert("该票据已签收，签收信息详见借据备注！");
			return;
		}
		if(status == "02"){
			/* var result = AsControl.PopPage("/InvoiceManage/InvoiceSignInfo.jsp","serialNo="+serialno,"resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
			reloadSelf(); */
			if(confirm("是否确认已签收？")){
				var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.afterloan.invoice.InvoiceChange","InvoiceStatusChange","serialNo="+serialno+",status=03");
				if(sReturn == "success"){
					alert("已成功签收！");
					reloadSelf();
				}
			}
		}
	}
	function revoke(){
		var serialno = getItemValue(0,getRow(0),'serialno');
		if(typeof(serialno)=="undefined" || serialno.length==0 ){
			alert("请选择一条记录！");
			return ;
		}
		var status = getItemValue(0,getRow(0),'status');
		if(status != "04"){
			var result = AsControl.PopPage("/InvoiceManage/InvoiceRevokeInfo.jsp","serialNo="+serialno,"resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
			reloadSelf();
		}
		else
			alert("票据已撤销！");
		return
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>