<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//基础产品为“个人信用贷款”（018）的贷款余额之和
	//Double Balance = Sqlca.getDouble(new SqlObject("select sum(bd.balance) from business_contract bc,business_duebill bd where bc.contractartificialno=bd.contractserialno and bd.businesstype='018'"));
	//基础产品为 “消贷易授信额度”（666）且担保方式为信用且未结清的 合同金额之和
	//Double BusinessSum = Sqlca.getDouble(new SqlObject("select sum(bd.businessSum) from business_contract bc,business_duebill bd where bc.vouchtype = 'D' and bc.businesstype = '666' and bc.contractartificialno = bd.contractserialno and bd.businessstatus in ('L0', 'L11', 'L12', 'L13')"));
	//计算N行内非网贷消费类信用贷款余额
	//Double NBusinessBalance = Balance + BusinessSum;

	ASObjectModel doTemp = new ASObjectModel("CustomerApprovalList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","newCustomerApprove()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","viewAndEdit()","","","","btn_icon_detail",""},
			{"true","","Button","预审批名单详情","预审批名单详情","approvalView()","","","","",""},
			{"true","All","Button","批量导入","批量导入","importData()","","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function newCustomerApprove(){
	AsControl.PopComp("/ActiveCreditManage/CustomerAppoveManage/CustomerApproveInfo.jsp","","resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
	reloadSelf();
}
function viewAndEdit(){
	var BatchNo = getItemValue(0,getRow(),"BatchNo");
	if (typeof(BatchNo)=="undefined" || BatchNo.length==0){
		alert("请选择一条信息！");
		return;
	}
	AsControl.PopComp("/ActiveCreditManage/CustomerAppoveManage/CustomerApproveInfo.jsp","BatchNo="+BatchNo,"resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
	reloadSelf();
}
function approvalView(){
	var CustomerBaseID = getItemValue(0,getRow(),"CustomerBaseID");
	var BatchNo = getItemValue(0,getRow(),"BatchNo");
	if (typeof(BatchNo)=="undefined" || BatchNo.length==0){
		alert("请选择一条信息！");
		return;
	}
	var CustomerBaseType = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.activeCredit.customerBase.SelectCustomerBase", "selectCustomerBaseType", "CustomerBaseID="+CustomerBaseID);
	if(CustomerBaseType == "101"){
		templeteNo = "CustomerApprovalInfo_House";
	}else if(CustomerBaseType == "102"){
		templeteNo = "CustomerApprovalInfo_Finance";
	}else if(CustomerBaseType == "103"){
		templeteNo = "CustomerApprovalInfo_Income";
	}
	AsControl.PopPage("/ActiveCreditManage/CustomerAppoveManage/CustomerApproveTableList.jsp","BatchNo="+BatchNo+"&TempleteNo="+templeteNo,"resizable=yes;dialogWidth=1000px;dialogHeight=500px;center:yes;status:no;statusbar:no");
}
function importData(){
	var CustomerBaseID = getItemValue(0,getRow(),"CustomerBaseID");
	var CustomerBaseLevel = getItemValue(0,getRow(),"CustomerBaseLevel");
	var BatchNo = getItemValue(0,getRow(),"BatchNo");
	var ApproveOrgID = getItemValue(0,getRow(),"ApprovalOrgID");
	if (typeof(BatchNo)=="undefined" || BatchNo.length==0){
		alert("请选择一条信息！");
		return;
	}
	var CustomerBaseType = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.activeCredit.customerBase.SelectCustomerBase", "selectCustomerBaseType", "CustomerBaseID="+CustomerBaseID);
	var pageURL = "/AppConfig/FileImport/FileSelector.jsp";
	if(CustomerBaseType == "101"){
		var parameter = "BATCHNO="+BatchNo+"&CUSTOMERBASEID="+CustomerBaseID+"&APPROVEORGID="+ApproveOrgID+"&CUSTOMERBASELEVEL="+CustomerBaseLevel+"&clazz=jbo.import.excel.CUSTOMERAPPROVALINFO_HOUSE"; 
	}else if(CustomerBaseType == "102"){
		var parameter = "BATCHNO="+BatchNo+"&CUSTOMERBASEID="+CustomerBaseID+"&APPROVEORGID="+ApproveOrgID+"&CUSTOMERBASELEVEL="+CustomerBaseLevel+"&clazz=jbo.import.excel.CUSTOMERAPPROVALINFO_FINANCE";
	}else if(CustomerBaseType == "103"){
		var parameter = "BATCHNO="+BatchNo+"&CUSTOMERBASEID="+CustomerBaseID+"&APPROVEORGID="+ApproveOrgID+"&CUSTOMERBASELEVEL="+CustomerBaseLevel+"&clazz=jbo.import.excel.CUSTOMERAPPROVALINFO_INCOME";
	}
	var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
	var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
    reloadSelf();
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
