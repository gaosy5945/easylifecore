<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String status = CurPage.getParameter("Status");
	if(status == null) status = "";

	ASObjectModel doTemp = new ASObjectModel("ProjectCLApplyingList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("Status", status);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","签署意见","签署意见","writeOpinion()","","","","",""},
			{"true","All","Button","提交","提交","approveOpinion()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditLineManage/CreditLineLimit/js/CreditLineManage.js"></script>
<script type="text/javascript">
	function writeOpinion(){
		 var serialNo = getItemValue(0,getRow(0),"SERIALNO");
		 var COSerialNo = getItemValue(0,getRow(0),"TRACEOBJECTNO");
		 var CLSerialNo = getItemValue(0,getRow(0),"CLSERIALNO");
		 if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			 alert("请选择一条申请！");
			 return;
		 }
		AsControl.PopView("/CreditLineManage/CreditLineLimit/ProjectCreditLine/ProjectCLApproveInfo.jsp","SerialNo="+serialNo+"&COSerialNo="+COSerialNo+"&CLSerialNo="+CLSerialNo,"");
		reloadSelf();
	}
	function approveOpinion(){
		 var serialNo = getItemValue(0,getRow(0),"SERIALNO");
		 var COSerialNo = getItemValue(0,getRow(0),"TRACEOBJECTNO");
		 if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			 alert("请选择一条申请！");
			 return;
		 }
		AsControl.PopComp("/CreditLineManage/CreditLineLimit/CreditLine/CLApproveOpinion.jsp","SerialNo="+serialNo+"&COSerialNo="+COSerialNo,"resizable=yes;dialogWidth=400px;dialogHeight=150px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
