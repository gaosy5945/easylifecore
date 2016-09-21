<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String creditInspectType = DataConvert.toString(CurPage.getParameter("CreditInspectType"));
	String flag = DataConvert.toString(CurPage.getParameter("Flag"));
	String orgID = CurUser.getOrgID();
	String operateUserID = CurUser.getUserID();
	ASObjectModel doTemp = new ASObjectModel("AfterLoanCheckQueryList");
	if("0".equals(flag)){
		doTemp.appendJboWhere( "O.status in ('1','2','5','6')" );
	}else{
		doTemp.appendJboWhere( "O.status in ('3','4')" );
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(creditInspectType+","+operateUserID+","+orgID);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","检查详情","详情","edit()","","","","",""}
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'SERIALNO');
		 var duebillSerialNo = getItemValue(0,getRow(0),'OBJECTNO');
		 var contractSerialNo = getItemValue(0,getRow(0),'CONTRACTSERIALNO');
		 var creditInspectType = "<%=creditInspectType%>";
		 var customerID = getItemValue(0, getRow(0), 'CustomerID');
	
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		 if(creditInspectType == "02"){
			 AsCredit.openFunction("FundPurposeInfo","CreditInspectType="+creditInspectType+"&CustomerID="+customerID+"&SerialNo="+serialNo+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo+"&RightType=ReadOnly");
			 reloadSelf();
			 return;
		 }else if(creditInspectType == "03"){
			 AsCredit.openFunction("RunDirectionInfo","CreditInspectType="+creditInspectType+"&CustomerID="+customerID+"&SerialNo="+serialNo+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo+"&RightType=ReadOnly");
			 reloadSelf();
			 return;
		 }
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
