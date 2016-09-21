<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String transStatus = CurPage.getParameter("TransStatus");
	String applyType = CurPage.getParameter("ApplyType");
	String sTempletNo = CurPage.getParameter("TempletNo");
	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);	
	
	doTemp.appendJboWhere(" and AT.TransStatus in('"+transStatus.replaceAll(",", "','")+"')");
	doTemp.setJboOrder(" AT.INPUTTIME");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","","Button","执行交易","执行交易","runTransaction()","","","","btn_icon_detail",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'RELATIVEOBJECTNO');
		 var transSerialNo = getItemValue(0,getRow(0),'SERIALNO');
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			 alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		 }
		 AsCredit.openFunction("PostLoanChangeTab","serialNo="+serialNo+"&transSerialNo="+transSerialNo+"&RightType=ReadOnly");
		 reloadSelf();
	}
	
	function runTransaction(){
		var transactionSerialno = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(transactionSerialno) == "undefined" || transactionSerialno.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		//com.amarsoft.app.als.afterloan.change.AfterChangeRun
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.AfterChangeRun","runTransaction","TransactionSerialno="+transactionSerialno);
		if(result=="success"){
			alert("交易执行成功！");
			reloadSelf();
		}else{
			alert(result);
			return;
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
