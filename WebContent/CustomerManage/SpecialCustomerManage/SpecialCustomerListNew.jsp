<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String listType = CurPage.getParameter("ListType");
	if(listType == null) listType = "";
	String importTemplet = CurPage.getParameter("ImportTemplet");
	if(importTemplet == null) importTemplet = "";

	ASObjectModel doTemp = new ASObjectModel("SpecialCustList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.MultiSelect = true; //允许多选
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.genHTMLObjectWindow(listType);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","All","Button","详情","详情","viewAndEdit()","","","","",""},
			{"true","All","Button","取消特殊客户记录","取消特殊客户记录","cancelRecord()","","","","",""},
			{"true","All","Button","批量导入","批量导入","importData()","","","","",""},
			{"true","All","Button","特殊客户详情","特殊客户详情","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'')","","","","btn_icon_delete",""},
			{"true","All","Button","导出","导出","exportPage('"+sWebRootPath+"',0,'excel','')","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script><script type="text/javascript">
	function add(){
		var listType = "<%=listType%>";
    	OpenPage("/CustomerManage/SpecialCustomerManage/SpecialCustomerInfo.jsp?listType="+listType,"_self","");
		reloadSelf();
	}
	function viewAndEdit(){
		var serialNo = getItemValue(0,getRow(0),"SERIALNO");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert("请选择一条信息！");
			return;
		}
		OpenPage("/CustomerManage/SpecialCustomerManage/SpecialCustomerInfo.jsp?SerialNo="+serialNo,"_self","");
		reloadSelf();
	}
	function cancelRecord(){
		var relaSerialNos = '';
		var relaStatus = '';
		var recordArray = getCheckedRows(0);//获取勾选的行
		if (typeof(recordArray)=="undefined" || recordArray.length==0){
			alert("请至少选择一条记录！");
			return;
		}

		for(var i = 1;i <= recordArray.length;i++){
			var serialNo = getItemValue(0,recordArray[i-1],"SERIALNO");
			relaSerialNos += serialNo+"@";
		}
		
		for(var i = 1;i <= recordArray.length;i++){
			var status = getItemValue(0,recordArray[i-1],"STATUS");
			relaStatus += status+"@";
		}
		relaStatus = relaStatus.split("@");
		for(var i=0;i < relaStatus.length-1;i++){
			if(relaStatus[i] == "0"){
				alert("存在未复核或复核结论为【不同意】的客户，请确认！");
				return;
			}else if(relaStatus[i] == "2"){
				alert("存在已取消记录的特殊客户，请确认！");
				return;
			}
		}
		AsControl.PopView("/CustomerManage/SpecialCustomerManage/CancelSpecialCustomer.jsp","relaSerialNos="+relaSerialNos,"resizable=yes;dialogWidth=800px;dialogHeight=320px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	function edit(){
		var customerID = getItemValue(0,getRow(0),"CUSTOMERID");
		var serialNo = getItemValue(0,getRow(0),"SERIALNO");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert("请选择一条信息！");
			return;
		}
		var result = CustomerManage.selectCustomer(customerID);
		if(result == "SUCCEED"){
			var customerType = CustomerManage.selectCustomerType(customerID);
			CustomerManage.editCustomer(customerID,customerType);
		}else{
			alert("本行无该客户信息！");
		}
	}
	function importData(){
		var pageURL = "/AppConfig/FileImport/FileSelector.jsp";
		var parameter = "LISTTYPE=<%=listType%>&clazz=jbo.import.excel.SPECIAL_IMPORT"; 
		var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
		var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
	    reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
