<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sDocType = CurPage.getParameter("DocType");
	if(sDocType == null) sDocType = "";
	//业务资料出库申请流水号
	String sSerialNo = CurPage.getParameter("DOSerialNo");
	if(sSerialNo == null) sSerialNo = "";
	String sTransactionCode = CurPage.getParameter("TransactionCode");
	if(sTransactionCode == null) sTransactionCode = "";
	String sTempletNo = "DocOutApproveOpinionInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2"; 
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("PTISerialNo"));
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{"true","All","Button","审批通过","审批通过","doApprove()","","","",""},
		{"true","All","Button","退回","退回","doBack()","","","",""},
		{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		OpenPage("<%=sPrevUrl%>", "_self");
	}
	function doApprove(){
		if(!iV_all(0)){
			alert("请先保存数据！");
			return;
		}
		//获取审批意见流水号
		var sPTISerialNo =  getItemValue(0,getRow(0),'SERIALNO');
		 //添加DFP，更新DFI
		var sOperationType = getItemValue(0,getRow(0),'TRANSACTIONCODE');//出库方式
		//业务资料类型 01 一类资料   02 二类资料 
		var sDocType = "<%=sDocType %>"; 
		//处理返回结果
		var sReturn = "";
		if(as_isPageChanged()){
			alert("请先保存数据！");
			return;
		}
			//一类业务资料
		if(sDocType == "01"){
		  var sPara = "DOSerialNo=<%=sSerialNo%>,ApplyType=02,UserID=<%=CurUser.getUserID()%>,TransactionCode=<%=sTransactionCode%>";
		  sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc1EntryWarehouseAdd", "commit", sPara);
		}//二类业务资料
		else if(sDocType =="02"){ 
			var sPara = "DOSerialNo=<%=sSerialNo%>,ApplyType=02,UserID=<%=CurUser.getUserID()%>,TransactionCode=<%=sTransactionCode%>,OrgID = <%=CurUser.getOrgID()%>,PTISerialNo="+sPTISerialNo;
			sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.DocOutApproveAction", "doApprove", sPara);
		}  
		if(typeof(sReturn)!="undefined" && sReturn=="true"){
			alert("审批通过成功！");
			self.close(); 
		}else {
			alert("审批失败!");
			return;
		}
	}
	function doBack(){
		//依据 PTISerialNo 更新DO信息
		var sPTISerialNo =  getItemValue(0,getRow(0),'SERIALNO');
		 //添加DFP，更新DFI
		var sDocType = "<%=sDocType %>";
		 //处理返回结果
		var sReturn = "";
		if(as_isPageChanged()){
			alert("请先保存数据！");
			return;
		}
		//一类业务资料
		if(sDocType == "01"){
			 var sPara = "DOSerialNo=<%=sSerialNo%>,ApplyType=03,UserID=<%=CurUser.getUserID()%>";
	 		 sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc1EntryWarehouseAdd", "commit", sPara);
		}//二类业务资料
		else if(sDocType =="02"){
			 sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.DocOutApproveAction", "doBack", "PTISerialNo="+sPTISerialNo+",userID=<%=CurUser.getUserID()%>"+",orgID=<%=CurUser.getOrgID()%>");
		}
		 if(sReturn == "true"){
			alert("拒绝审批！");
			self.close(); 
		}else {
			alert("退回失败!");
			return;
		}
		
	}

	setItemValue(0,getRow(),"SerialNo","<%=CurPage.getParameter("PTISerialNo")%>");
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
