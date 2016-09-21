<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//疑似匹配的数据
	String batchSerialNo = CurPage.getParameter("BatchSerialNo");
	String putOutStatus = CurPage.getParameter("PutOutStatus");
	
	ASObjectModel doTemp = new ASObjectModel("BatchPrePutOutList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("BatchSerialNo", batchSerialNo);
	dwTemp.setParameter("PutOutStatus", putOutStatus);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"02".equals(putOutStatus) ? "true" : "false","","Button","疑似匹配","疑似匹配","match1()","","","",""},
			{"03".equals(putOutStatus) ? "true" : "false","","Button","匹配","匹配","match2()","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function match1(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var certID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			certID = "%"+certID.replace(" ","%")+"%";
			var returnValue =  AsDialog.SelectGridValue('SelectYSContract','<%=CurUser.getOrgID()%>,'+certID,'SerialNo',null,false);
			if(typeof(returnValue)=="undefined" || returnValue.length==0 || returnValue == "_CLEAR_") return;

			modify(returnValue,serialNo);
		}
	}
	
	function match2(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			var returnValue =  AsDialog.SelectGridValue('SelectUEQContract','<%=CurUser.getOrgID()%>','SerialNo',null,false);
			if(typeof(returnValue)=="undefined" || returnValue.length==0 || returnValue == "_CLEAR_") return;
			
			modify(returnValue,serialNo);
		}
	}
	
	function modify(contractSerialNo,putoutSerialNo){
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.putout.action.ModifyPutOut","modify","ContractSerialNo="+contractSerialNo+",PutOutSerialNo="+putoutSerialNo);
		AsControl.OpenPage("/CreditManage/CreditPutOut/BatchPrePutOutList.jsp","","_self")
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
