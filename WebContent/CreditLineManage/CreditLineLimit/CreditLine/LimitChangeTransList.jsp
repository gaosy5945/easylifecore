<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String sContractSerialNo = CurPage.getParameter("CONTRACTSERIALNO");
	String sDocumentObjectNo = CurPage.getParameter("DOCUMENTOBJECTNO");
	//将空值转化成空字符串
	if(sContractSerialNo == null) sContractSerialNo = "";
	if(sDocumentObjectNo == null) sDocumentObjectNo = "";

	ASObjectModel doTemp = new ASObjectModel("LimitChangeTransList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.setParameter("SerialNo", sDocumentObjectNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
		{"true","All","Button","引入","引入待移交的借据","importApply()","","","","",""},
		{"true","All","Button","移出","移出选中的待移交的借据","removeApply()","","","","",""},
		{"true","All","Button","业务详情","查看借据详情","view()","","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditLineManage/CreditLineLimit/js/CreditLineManage.js"></script>
<script type="text/javascript">
	function importApply()
	{
		var result = AsDialog.SelectGridValue("SelectLimitChangeTransList", "<%=sContractSerialNo%>,<%=sDocumentObjectNo%>", "SerialNo","","","","");
		
		if(typeof(result) == "undefined" || result.length == 0 ){
			return;
		}
		
		var returnValue1 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.LimitInsertTransaction", "changeDuebillToDo", "SerialNo="+result+",ApplySerialNo=<%=sDocumentObjectNo%>,DoFlag=imported");
		if(returnValue1=="true")
		{
			alert("保存成功！");
			
		}else{
			alert("保存失败！失败原因："+returnValue1);
		}
		reloadSelf();
	}
	
	function removeApply()
	{
		
		var serialno = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialno) == "undefined" || serialno.length == 0 ){
			return;
		}
		
		var returnValue1 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.LimitInsertTransaction", "changeDuebillToDo", "SerialNo="+serialno+",DoFlag=remove");
		if(returnValue1=="true")
		{
			alert("保存成功！");
			
		}else{
			alert("保存失败！失败原因："+returnValue1);
		}
		reloadSelf();
	}
	
	function view()
	{
		
		var serialno = getItemValue(0,getRow(0),"ObjectNo");
		if(typeof(serialno) == "undefined" || serialno.length == 0 ){
			return;
		}
		
		AsControl.PopView("/CreditManage/AfterBusiness/DuebillInfo.jsp", "DuebillSerialNo="+serialno,"");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
