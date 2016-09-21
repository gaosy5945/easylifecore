<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String serialNo = CurPage.getParameter("SerialNo");
	String transSerialNo = CurPage.getParameter("TransSerialNo");
	String childUrl = CurPage.getParameter("ChildUrl");
	String transCode = CurPage.getParameter("TransCode");
	
	if(serialNo == null) serialNo = "";
	if(transSerialNo == null) transSerialNo = "";
	if(childUrl == null) childUrl = "";
	
	ASObjectModel doTemp = new ASObjectModel("SelectChangeDuebill");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(serialNo);

	String sButtons[][] = {
		//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
		{"true","All","Button","新增变更","新增变更","addChange()","","","","",""},
		{"true","All","Button","删除变更","删除变更","deleteChange()","","","","",""},
		{"true","","Button","借据详情","借据详情","viewDuebill()","","","","",""},
		{"0010".equals(transCode)?"true":"false","","Button","打印提前还款通知书","打印提前还款通知书","print()","","","","",""},
		{"0020".equals(transCode)?"true":"false","","Button","打印第三方还款通知书","打印第三方还款通知书","print()","","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function addChange(){
		var objectNo = getItemValue(0,getRow(),"SerialNo");//取借据流水号
		var objectType = "jbo.app.BUSINESS_DUEBILL";
		var parentTransSerialNo = "<%=transSerialNo%>";
		var childUrl = "<%=childUrl%>";
		
		if(typeof(objectNo) == "undefined" || objectNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",TransSerialNo="+parentTransSerialNo+",TransCode=<%=transCode%>,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,Flag=Y";	
		var transSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CreateTransaction","create",para);
		if(typeof(transSerialNo) == "undefined" || transSerialNo.length == 0 )  return;
		AsControl.OpenPage(childUrl, "DBSerialNo="+objectNo+"&TransSerialNo="+transSerialNo, "rightdown", "");
		reloadSelf();
	}
	
	function deleteChange(){
		if(!confirm('确实要删除吗?')) return;
		var objectNo = getItemValue(0,getRow(),"SerialNo");//取借据流水号
		var objectType = "jbo.app.BUSINESS_DUEBILL";
		var parentTransSerialNo = "<%=transSerialNo%>";
		if(typeof(objectNo) == "undefined" || objectNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",TransSerialNo="+parentTransSerialNo+",TransCode=<%=transCode%>,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.DeleteTransaction","delete",para);
		alert(result);
		AsControl.OpenPage("/Blank.jsp", "TextToShow=没有变更信息", "rightdown", "");
		reloadSelf();
	}
	
	
	function viewDuebill(){
		var duebillSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(duebillSerialNo) == "undefined" || duebillSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		AsControl.OpenView("/CreditManage/AfterBusiness/DuebillInfo.jsp","DuebillSerialNo="+duebillSerialNo,"_blank");
	}

	var oldSerialNo = "";
	function mySelectRow(){
		var objectNo = getItemValue(0,getRow(),"SerialNo");//取借据流水号
		var objectType = "jbo.app.BUSINESS_DUEBILL";
		var parentTransSerialNo = "<%=transSerialNo%>";
		var childUrl = "<%=childUrl%>";
		if(typeof(objectNo)=="undefined" || objectNo.length==0) return;
		
		
		var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",TransSerialNo="+parentTransSerialNo+",TransCode=<%=transCode%>,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,Flag=N";
		if(oldSerialNo != objectNo)
		{
			oldSerialNo = objectNo;
			var transSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CreateTransaction","create",para);
			if(typeof(transSerialNo) == "undefined" || transSerialNo.length == 0 )
				AsControl.OpenPage("/Blank.jsp", "TextToShow=没有变更信息", "rightdown", "");
			else
				AsControl.OpenPage(childUrl, "DBSerialNo="+objectNo+"&TransSerialNo="+transSerialNo, "rightdown", "");
		}
	}
	
	function print(){
		var parentTransSerialNo = "<%=transSerialNo%>";
		var serialNo = getItemValue(0,getRow(),"SerialNo");//取借据流水号
		if('<%=transCode%>' == '0010'){
			AsControl.OpenView("/BillPrint/AdvRepay.jsp","SerialNo="+serialNo+"&ParentTransSerialNo="+parentTransSerialNo,"_blank");//个人贷款提前还款通知书
		}else {
			AsControl.OpenView("/BillPrint/ThirdPartyAdvRepay.jsp","SerialNo="+serialNo+"&ParentTransSerialNo="+parentTransSerialNo,"_blank");//个人贷款第三方账户提前还款通知书
		}
	}
	mySelectRow();

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
