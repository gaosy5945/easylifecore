<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@page import="com.amarsoft.app.als.credit.common.model.CreditConst"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String packageNo = CurPage.getParameter("ObjectNo");//主申请编号
	if(StringX.isSpace(packageNo)) packageNo = "";
	String objectType = CurPage.getParameter("ObjectType");
	if(StringX.isSpace(objectType)) objectType = "";
	String unionID = CurPage.getParameter("CustomerID");
	if(unionID == null) unionID = "";
	String sourceType = CurPage.getParameter("SourceType");
	if(sourceType == null) sourceType = "";
	BizObject bo = null;
	String applyType = "";
	if(CreditConst.CREDITOBJECT_APPLY_REAL.equals(objectType)){
		CreditObjectAction coa=new CreditObjectAction(packageNo,objectType);
		bo = coa.getCreditObjectBO();//.amarsoft.app.als.process.action.GetApplyParams.getApplyParams(packageNo);
		applyType = bo.getAttribute("ApplyType").getString();
	}
	if(StringX.isSpace(applyType)) applyType = "";
	
	ASObjectModel doTemp = new ASObjectModel("UnionMemberList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(50);
	dwTemp.genHTMLObjectWindow(unionID);
	
	String sButtons[][] = {
		{"true","","Button","成员详情","成员详情","viewInfo()","","","","",""},
		{"true","All","Button","引入成员","引入成员","imports()","","","","",""},
		{"true","All","Button","移出成员","移出成员","remove()","","","","",""},
		{"false","All","Button","发起申请","发起申请","newApply()","","","","",""},
	};
	if(CreditConst.CREDITOBJECT_APPLY_REAL.equals(objectType) && "APPLY".equalsIgnoreCase(sourceType)){
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "true";
	}else if(CreditConst.CREDITOBJECT_APPROVE_REAL.equals(objectType)){
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
	}
%> 
<script type="text/javascript">	
	/*~[Describe=成员详情;InputParam=无;OutPutParam=无;]~*/
	function viewInfo(){
		var customerID = getItemValue(0,getRow(),"MemberCustomerID");
		if (typeof(customerID)=="undefined" || customerID.length==0){
			alert("请选择一条记录！");
			return;
		}
		if("<%=sourceType%>" == "APPLY"){
			var customerName = getItemValue(0,getRow(),"CustomerName");
			var paramString = "ObjectType=Customer&ObjectNo="+customerID+"&ViewID=001";
			if(typeof(parent.parent.parent.addViewTabItem)=="function"){
				parent.parent.parent.addViewTabItem("mCustomerDetail"+customerID,customerName+"的客户详情","/Frame/ObjectViewer.jsp",paramString);
				parent.parent.parent.selectTab("mCustomerDetail"+customerID);	
			}else if(typeof(parent.parent.addTabItem)=="function"){
				parent.parent.addTabItem(customerName+"的客户详情@"+customerID,"/Frame/ObjectViewer.jsp",paramString);
			}
		}else{
	    	AsCredit.openFunction("CustomerDetail","CustomerID="+customerID,"");
			//openObject("Customer",customerID,"001");
			reloadSelf();	
		}
	}	
	/*~[Describe=引入成员;InputParam=无;OutPutParam=无;]~*/
	function imports(){
		//如果是“对公联保体”则引入客户列表中只显示对公客户
		//如果是“个人联保体”则引入客户列表中只显示个人客户
		//var sCustomerType = RunJavaMethod("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","getUnionType","unionID=<%=unionID%>");
		//var sReturn = AsControl.PopComp("/CustomerManage/UnionManage/UnionMemberSelList.jsp", "CustomerType="+sCustomerType+"&MultiSelect=false","resizable=yes;dialogWidth=600px;dialogHeight=500px;center:yes;status:no;statusbar:no");
		var customerType = window.parent.getItemValue(0,getRow(),"GroupType1");
		var ct1 = "",ct2 = "";
		if(customerType=="0110"){//对公联保体
			ct1 = "01";
			ct2 = "01";
		}else if(customerType=="0120"){//个人联保体
			ct1 = "03";
			ct2 = "03";
		}else{//其它客户群
			ct1 = "01";
			ct2 = "03";
		}
		var param = "CustomerType1,"+ct1+",CustomerType2,"+ct2+",UserID,<%=CurUser.getUserID()%>";
		var sReturn = setObjectValue("SelectUnionMember",param,"",0,0,"");
		if(typeof(sReturn) == "undefined" || sReturn == "_CLEAR_") return;
		var customerID = sReturn.split("@");
		//检查是否已存在于本客户群内
		var sResult = RunJavaMethod("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","checkInner","unionID=<%=unionID%>,customerID="+customerID);
		if(sResult == "true"){
			alert("该客户已存在于本客户群内，无需重复引入！");
			return;
		}
		//检查是否已存在于其他有效客户群内
		sResult = RunJavaMethod("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","checkMemberExist","customerID="+customerID);
		if(sResult == "true" && !confirm("该客户已存在于有效的客户群中，是否继续引入？")){
			return;
		}
		sResult = RunJavaMethodTrans("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","importMember","unionID=<%=unionID%>,customerID="+customerID+",userID=<%=CurUser.getUserID()%>,orgID=<%=CurUser.getOrgID()%>");
		if(sResult == "true"){
			alert("引入成功！");
			reloadSelf();
			setRowCount();
		}else{
			alert("引入失败");
		}
	}
	/*~[Describe=移除成员;InputParam=无;OutPutParam=无;]~*/
	function remove(){
		var customerID = getItemValue(0,getRow(),"MemberCustomerID");
		if (typeof(customerID)=="undefined" || customerID.length==0){
			alert("请选择一条记录！");
			return;
		}
		//在途授信申请检查
		var sResult = RunJavaMethod("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","checkMemberApply","unionID=<%=unionID%>,customerID="+customerID);
		if(sResult == "true"){
			alert("该成员下存在在途联保贷款申请，无法移除！");
			return;
		}
		if(!confirm("确认要移除该成员吗？")) return;
		sResult = RunJavaMethodTrans("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","removeMember","unionID=<%=unionID%>,customerID="+customerID);
		if(sResult == "true"){
			alert("移除成员成功！");
			reloadSelf();
			setRowCount();
		}else{
			alert("移除成员失败！");
		}
	}
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newApply(){
		var applyType = "<%=applyType%>";	
		var packageNo = "<%=packageNo%>";
		var customerID = getItemValue(0,getRow(),"MemberCustomerID");
		var style = "dialogWidth=550px;dialogHeight=480px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;";
		var compID = "NewApply";
		var compURL = "/CreditManage/CreditApply/NewApplyInfo.jsp";
		var returnMessage = popComp(compID,compURL,"ApplyType="+applyType+"&PackageNo="+packageNo+"&MCustomerID="+customerID,style);
		if(!returnMessage|| returnMessage=="_CANCEL_") return;
		returnMessage = returnMessage.split("@");
		var objectNo=returnMessage[0];
		var objectType=returnMessage[1];
        //根据新增申请的流水号，打开申请详情界面
		var paramString = "ObjectType="+objectType+"&ObjectNo="+objectNo+"&ViewID=001";
		var customerName = getItemValue(0,getRow(),"CustomerName");
		if(typeof(parent.parent.parent.addViewTabItem)=="function"){
			parent.parent.parent.addViewTabItem("memberDetail"+objectNo,customerName+"的业务详情","/Frame/ObjectViewer.jsp",paramString);
			parent.parent.parent.selectTab("memberDetail"+objectNo);	
		}else if(typeof(parent.parent.addTabItem)=="function"){
			parent.parent.addTabItem(customerName+"的业务详情@"+objectNo,"/Frame/ObjectViewer.jsp",paramString);
		}
		AsControl.OpenView("/CreditManage/CreditApply/UGMemberApplyList.jsp","PackageNo=<%=packageNo%>&ObjectType=<%=objectType%>","rightdown","");
	}
	function setRowCount(){
		var vCount = getRowCount(0);
		window.parent.setItemValue(0,getRow(),"att01",vCount);
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
