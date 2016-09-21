<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("LimitContractList");
	doTemp.setJboWhereWhenNoFilter(" and O.ContractStatus = '02' ");

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","查看详情","查看详情","edit()","","","","",""},
			{"true","","Button","发送额度到核心","发送额度到核心","send()","","","","",""},
			{"true","","Button","受益账户绑定申请","受益账户绑定申请","sendAccount()","","","","",""},
			{"true","","Button","打印放款通知书","打印放款通知书","print()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

	function edit(){
		 var serialNo = getItemValue(0,getRow(0),"SerialNo");
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("请选择一条记录！");
			return ;
		 }
		
		AsCredit.openFunction("ContractInfo","ObjectType=jbo.app.BUSINESS_CONTRACT&ObjectNo="+serialNo+"&RightType=ReadOnly","");
	}
	
	function send(){
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("请选择一条记录！");
			return ;
		}
		
		if(!confirm("确定发送放款申请？")) return;
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.SendCLInfo","send","ContractNo="+serialNo); 
		alert(returnValue);
		reloadSelf();
	}
	
	function sendAccount(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");//出账流水号
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		} 
		if(!confirm("确定发送受益账户？")) return;
		//try{
			var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.SendAccountInfo","send","ObjectNo="+serialNo+",ObjectType=jbo.app.BUSINESS_CONTRACT"); 
			alert(returnValue);
		//}catch(e){}
		reloadSelf();
	}
	
	function print(){
		var businessType = getItemValue(0,getRow(),"BUSINESSTYPE");
		var contractSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(contractSerialNo) == "undefined" || contractSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(businessType == '666'){//判断为消贷易额度
			AsControl.OpenView("/BillPrint/XdyApplyPass.jsp","SerialNo="+contractSerialNo,"_blank");//消贷易额度及生成贷款规则信息表
		}else if(businessType == '500' || businessType == '502'){ //判断为融资易额度
			AsControl.OpenView("/BillPrint/RzyApplyPass.jsp","SerialNo="+contractSerialNo,"_blank");//融资易额度及生成贷款规则信息表
		} else {
			alert("请选择消贷易或者融资易额度记录");
		}
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
