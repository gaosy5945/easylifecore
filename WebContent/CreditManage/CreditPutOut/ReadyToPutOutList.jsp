<%@page import="com.amarsoft.app.workflow.interdata.ApplyData"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String putOutStatus = DataConvert.toString(CurPage.getParameter("PutOutStatus"));
	String flag = DataConvert.toString(CurPage.getParameter("Flag"));
	String OperateOrgID = CurUser.getOrgID();
	
	
	String orgList = "";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select OrgList from FLOW_ORGMAP where FlowOrgMapType = '01' and OrgID = :OrgID").setParameter("OrgID", CurUser.getOrgID()));
	if(rs.next())
	{
		orgList = rs.getString(1);
	}
	rs.close();
	
	ASObjectModel doTemp = new ASObjectModel("ReadyToPutOutList");
	if("02".equals(putOutStatus)){
		doTemp.appendJboWhere("and PutOutDate <> '"+DateHelper.getBusinessDate()+"' and PutOutStatus = '03' and OperateOrgID in('"+orgList.replaceAll(",","','")+"','"+CurUser.getOrgID()+"')");
	}else if("03".equals(putOutStatus)){
		doTemp.appendJboWhere("and PutOutDate = '"+DateHelper.getBusinessDate()+"' and PutOutStatus = '03' and OperateOrgID in('"+orgList.replaceAll(",","','")+"','"+CurUser.getOrgID()+"')");
	}else{
		doTemp.appendJboWhere(" and PutOutStatus in ('"+putOutStatus.replaceAll(",","','")+"') and OperateOrgID in('"+orgList.replaceAll(",","','")+"','"+CurUser.getOrgID()+"')");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	dwTemp.setParameter("OperateOrgID", OperateOrgID);
	dwTemp.setParameter("PutOutStatus", putOutStatus);
	dwTemp.genHTMLObjectWindow(OperateOrgID+","+putOutStatus);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","老个贷迁移未入账贷款放款操作","老个贷迁移未入账贷款放款操作","OldLoanOperate()","","","",""},
			{"true","All","Button","查看详情","查看详情","view()","","","",""},
			{("1".equals(flag) ? "true" : "false"),"All","Button","发送放款申请","发送放款申请","send()","","","",""},
			//{("1".equals(flag) ? "true" : "false"),"All","Button","打印放款审核书","打印放款审核书","print()","","","",""},
			{("2".equals(flag) ? "true" : "false"),"All","Button","重新发送放款申请","重新发送放款申请","send()","","","",""},
			//{("2".equals(flag) ? "true" : "false"),"All","Button","受益账户绑定申请","受益账户绑定申请","sendAccount()","","","",""},
			{("2".equals(flag) ? "true" : "false"),"All","Button","打印放款通知单","打印放款通知单","print()","","","",""},
			{("2".equals(flag) ? "true" : "false"),"All","Button","打印个人贷款借款凭证","打印个人贷款借款凭证","printDueBill()","","","",""},
			{("2".equals(flag) ? "true" : "false"),"All","Button","打印终审意见","打印终审意见","printBusinessApprove()","","","",""},
			{"false","All","Button","撤销申请","撤销","backout()","","","",""},
			{"true","All","Button","终止放款","终止放款","cancel()","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function cancel(){
		var applySerialNo = getItemValue(0, getRow(), "ApplySerialNo");
		if(typeof(applySerialNo) == "undefined" || applySerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(!AsCredit.newConfirm("请确认已入账业务不能终止放款","未入账","已入账")) return;
		if(!confirm("请再次确认是否终止放款？")) return;
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.UpdateStatusForCancelPutOut","update","ApplySerialNo="+applySerialNo);
		if(returnValue == "true"){
			alert("终止成功！");
			reloadSelf();
		}
	}
	function OldLoanOperate(){
		var result = AsControl.PopView("/CreditManage/CreditPutOut/OldLoanOperateList.jsp","","resizable=yes;dialogWidth=950px;dialogHeight=600px;center:yes;status:no;statusbar:no");
		if(typeof(result) == "undefined" || result.length == 0){
			return;
		}else{
			result = result.split("@");
			if(result[0] == "true"){
				var BCSerialNo = result[1];
				var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.putout.action.InitGDPutout","initGDPutout","SerialNo="+BCSerialNo); 
				if(returnValue.split("@")[0] == "true"){
					var BPSerialNo = returnValue.split("@")[2];
				       if("<%=flag%>" == "1"){
				               AsControl.OpenView("/BillPrint/LoanFksh.jsp","SerialNo="+BPSerialNo,"_blank");//放款审核书
				        }else if("<%=flag%>" == "2"){
				               AsControl.OpenView("/BillPrint/LoanGrant.jsp","SerialNo="+BPSerialNo,"_blank");//放款通知书
					    }
				}	
			}
		}
	}
	function view(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.
				length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		} 
		AsControl.PopView("/CreditManage/CreditPutOut/CreditPutOutInfo.jsp", "ObjectNo="+serialNo+"&ObjectType=jbo.app.BUSINESS_PUTOUT&RightType=ReadOnly","");
	}
	function send(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");//出账流水号
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		} 
		if(!confirm("确定发送放款申请？")) return;
		//try{
			var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.SendLoanInfo","Determine","PutoutNo="+serialNo); 
			alert(returnValue.split("@")[1]);
		//}catch(e){}
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
			var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.SendAccountInfo","send","ObjectNo="+serialNo+",ObjectType=jbo.app.BUSINESS_PUTOUT"); 
			alert(returnValue);
		//}catch(e){}
		reloadSelf();
	}
	
	function print(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if('<%=flag%>' == '1'){
			AsControl.OpenView("/BillPrint/LoanFksh.jsp","SerialNo="+serialNo,"_blank");//放款审核书
		}else if('<%=flag%>' == '2'){
			AsControl.OpenView("/BillPrint/LoanGrant.jsp","SerialNo="+serialNo,"_blank");//放款通知书
		}
	}
	function printDueBill(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		AsControl.OpenView("/BillPrint/DueBillForm.jsp","SerialNo="+serialNo,"_blank");//个人贷款借款凭证
	}
	
	function printBusinessApprove(){
		var BusinessType = getItemValue(0,getRow(0),'BUSINESSTYPE');
		var contractSerialNo = getItemValue(0,getRow(0),'CONTRACTSERIALNO');
		if(typeof(contractSerialNo) == "undefined" || contractSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		} 
		if(typeof(BusinessType) == "undefined" || BusinessType.length == 0){
			alert("基础产品为空！");//基础产品不能为空！
			return;
		} 
		var applySerialNo = getItemValue(0,getRow(0),"APPLYSERIALNO");
		var PRODUCTTYPE3 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.ProductIDtoProductType","getRalativeProductType"
				,"ProductID="+BusinessType);
		if(PRODUCTTYPE3 == "01" && BusinessType != "555" && BusinessType != "999"){ 
			AsCredit.openFunction("PrintConsumeLoanApprove","SerialNo="+applySerialNo);//消费类贷款审批意见表
		}else if(PRODUCTTYPE3 == "02"){
			AsControl.OpenView("/BillPrint/BusinessApprove.jsp","SerialNo="+applySerialNo,"_blank");//经营类贷款审批意见表
		}else if(BusinessType == "555" || BusinessType == "999"){
			AsControl.OpenView("/BillPrint/ApplyDtl1For555.jsp","SerialNo="+applySerialNo,"_blank");//个人授信额度贷款审批意见表
		}
		
	}
	
	function backout(){
		var tranTellerNo = "92261005";
		var branchId = "2261";
		var bussType = "0";
		var duebillSerialNo = getItemValue(0,getRow(),"DuebillSerialNo");
		var actTranDate = "<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>";
		var hostSeqNo = "";
		if(typeof(duebillSerialNo) == "undefined" || duebillSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		} 
		if(!confirm("确定撤销该笔放款申请？")) return;
		//调用贷款发放撤销接口
		var returnValue = AsControl.RunASMethod("PutOutSend","LoanDstrCncl",tranTellerNo+","+branchId+","+bussType+","+duebillSerialNo+","+actTranDate+","+hostSeqNo);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		if(returnValue.split("@")[0] == "false") alert(returnValue.split("@")[1]);
		else
		{
			alert(returnValue.split("@")[1]);
			reloadSelf();
		} 
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
