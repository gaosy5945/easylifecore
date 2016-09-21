<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	/*
		Author:   qzhang  2014/12/04
		Tester:
		Content: 合同面签信息列表
		Input Param:	 
		Output param:
		History Log: 
	*/

	//获取前端传入的参数
    String sStatus = DataConvert.toString(CurPage.getParameter("Status"));//面签状态
    
    if(sStatus == null) sStatus = "";
    String tempNo = "";
    if("020".equals(sStatus)){
    	tempNo = "ContractInterviewList1";
    }else{
    	tempNo = "ContractInterviewList";
    }
	ASObjectModel doTemp = new ASObjectModel(tempNo);
	if(CurUser.hasRole("PLBS0001") || CurUser.hasRole("PLBS0002"))
	{
	    doTemp.appendJboWhere(" and O.OperateUserID=:UserID ");
	}
	 
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow(CurUser.getOrgID()+","+CurUser.getUserID());

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"false","","Button","面签处理","面签处理","deal()","","","","",""},
			{("020".equals(sStatus)?"true":"false"),"","Button","面签结果","面签结果查看","viewSignResult()","","","","",""},
		};
	 if("010".equals(sStatus)){
		sButtons[0][0] = "true";
	}

%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function deal(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sCustomerId = getItemValue(0,getRow(),"CustomerId");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		AsCredit.openFunction("ContractInterviewTab", "CustomerId="+sCustomerId+"&SerialNo="+sSerialNo);	
		reloadSelf();
	}
	
	function viewSignResult()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sCustomerId = getItemValue(0,getRow(),"CustomerId");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		//AsControl.OpenComp("/CreditManage/CreditContract/ContractInterviewInfo.jsp", "RightType=ReadOnly&CustomerId="+sCustomerId+"&SerialNo="+sSerialNo, "", "_blank");
		AsCredit.openFunction("ContractInterviewTab", "CustomerId="+sCustomerId+"&SerialNo="+sSerialNo+"&RightType=ReadOnly");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
