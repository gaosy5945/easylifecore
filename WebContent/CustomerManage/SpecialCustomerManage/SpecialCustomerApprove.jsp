<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sTempletNo = CurComp.getParameter("sTempletNo");
	if(sTempletNo == null) sTempletNo = "";

	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	if("CustomerListApproving".equals(sTempletNo)){
		dwTemp.MultiSelect = true; //允许多选
	}
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"CustomerListApproved".equals(sTempletNo)?"false":"true","All","Button","复核","复核","approveCustomer()","","","","",""},
			};
%>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function approveCustomer(){
		var relaSerialNos = '';
		var relaTodoTypes = '';
		var recordArray = getCheckedRows(0);//获取勾选的行
		if (typeof(recordArray)=="undefined" || recordArray.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		for(var i = 1;i <= recordArray.length;i++){
			var serialNo = getItemValue(0,recordArray[i-1],"SERIALNO");
			relaSerialNos += serialNo+"@";
			var todoType = getItemValue(0,recordArray[i-1],"TODOTYPE");
			relaTodoTypes += todoType+"@";
		}
		AsControl.PopView("/CustomerManage/SpecialCustomerManage/SpecialCustomerApproveOpinion.jsp","relaSerialNos="+relaSerialNos+"&relaTodoTypes="+relaTodoTypes,"resizable=yes;dialogWidth=400px;dialogHeight=150px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
