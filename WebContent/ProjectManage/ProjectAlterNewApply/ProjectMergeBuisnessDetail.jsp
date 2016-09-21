<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String ProjectSerialNo = CurPage.getParameter("SerialNo");
	if(ProjectSerialNo == null) ProjectSerialNo = "";
	String ProjectSerialNoNew = CurPage.getParameter("ProjectSerialNo");
	if(ProjectSerialNoNew == null) ProjectSerialNoNew = "";

	ASObjectModel doTemp = new ASObjectModel("ProjectBusinessDetail");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.MultiSelect = true; //允许多选
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ProjectSerialNo", ProjectSerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","确定","确定","enSure()","","","","",""},
		};
	sASWizardHtml = "<p><font color='red' size='2'> 【贷款业务明细】 </font></p>" ; 
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
	function enSure(){
		var ProjectSerialNoNew = "<%=ProjectSerialNoNew%>";
		var ProjectSerialNoOld = "<%=ProjectSerialNo%>";
		var relaPRSerialNos = '';
		var recordArray = getCheckedRows(0);//获取勾选的行
		if (typeof(recordArray)=="undefined" || recordArray.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		for(var i = 1;i <= recordArray.length;i++){//通过循环获取
			var PRSerialNo = getItemValue(0,recordArray[i-1],"SerialNo");
			relaPRSerialNos += PRSerialNo+"@";
		}
		//var result = CustomerManage.importCustomer(recordArray, relaCustomerIDs, userID, inputDate, inputOrgID);
		var result = ProjectManage.projectMerge(ProjectSerialNoNew, ProjectSerialNoOld, relaPRSerialNos);
		if(result == "SUCCEED"){
			alert("项目合并成功！");
		}else{
			alert("项目合并失败！");
		}
		reloadSelf();
	}
	
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
