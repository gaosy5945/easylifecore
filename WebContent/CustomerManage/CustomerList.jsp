<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	//获取组件参数
	String customerType = CurComp.getParameter("CustomerType");
	if(customerType == null) customerType = "";
	String templetNo = CurComp.getParameter("CustomerListTemplet");
	if(templetNo == null) templetNo = "";

	ASObjectModel doTemp = new ASObjectModel(templetNo);
	//doTemp.setHtmlEvent("", "ondblclick", "viewAndEdit");//添加双击查看详情功能 */
	doTemp.setJboWhere(doTemp.getJboWhere()+" and CB.InputOrgID = '"+CurOrg.getOrgID()+"' and CB.InputUserID = '"+CurUser.getUserID()+"'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.MultiSelect = true; //允许多选
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
   	dwTemp.setParameter("CustomerType", customerType+"%");
	dwTemp.genHTMLObjectWindow(customerType+"%");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","客户信息新建","客户信息新建","newCustomer()","","","","btn_icon_add",""},
			{"true","","Button","客户信息详情","客户信息详情","viewAndEdit()","","","","btn_icon_detail",""},
			{"true","All","Button","删除","删除","del()","","","","btn_icon_delete",""},
// 			{"03".equals(customerType)? "true":"false","All","Button","加入我的客户","加入我的客户","joinMyCustomer()","","","","",""},
			{"false","All","Button","查询ECIF","查询ECIF","ecifQuery()","","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
//客户信息新增
function newCustomer(){
	var customerType = "<%=customerType%>";
	var result = CustomerManage.newCustomer1(customerType);
 	if(result){
		result = result.split("@");
		if(result[0]=="true"){
			CustomerManage.editCustomer(result[1],result[3]);
		}
	}
    reloadSelf();
}

//客户信息详情
function viewAndEdit(){
	var customerID = getItemValue(0,getRow(0),"CUSTOMERID");
	var customerType = getItemValue(0,getRow(0),"CUSTOMERTYPE");
	if(typeof(customerID)=="undefined" || customerID.length==0){
		alert("请选择一条信息！");
		return;
	}
	 CustomerManage.editCustomer(customerID,customerType);
	 reloadSelf();
}

function del(){
	var deleteCustomerIDs = '';
	var userID = "<%=CurUser.getUserID()%>";
	var inputOrgID = "<%=CurOrg.getOrgID()%>";
	var recordArray = getCheckedRows(0); //获取勾选的行
	if (typeof(recordArray)=="undefined" || recordArray.length==0){
		alert("请至少选择一条所要删除记录！");
		return;
	}
	for(var i = 1;i <= recordArray.length;i++){ //通过循环获取customerID
		var customerID = getItemValue(0,recordArray[i-1],"CUSTOMERID");
		deleteCustomerIDs += customerID+"@";
	}
	if(confirm('确定要删除所选客户吗？')){
		var sReturn = CustomerManage.deleteCustomer(deleteCustomerIDs, userID, inputOrgID);
		if(sReturn == "SUCCEED"){
			alert("删除成功！");
			reloadSelf();
		}else{
			alert("删除失败！");
			reloadSelf();
		}

	}
}
//加入我的客户
function joinMyCustomer(){
	var relaCustomerIDs = '';
	var recordArray = getCheckedRows(0);//获取勾选的行
	var userID = "<%=CurUser.getUserID()%>";
	var inputDate = "<%=StringFunction.getToday()%>";
	var inputOrgID = "<%=CurOrg.getOrgID()%>";
	if (typeof(recordArray)=="undefined" || recordArray.length==0){
		alert("请至少选择一条记录！");
		return;
	}
	for(var i = 1;i <= recordArray.length;i++){//通过循环获取customerID
		var customerID = getItemValue(0,recordArray[i-1],"CUSTOMERID");
		relaCustomerIDs += customerID+"@";
	}
	var result = CustomerManage.importCustomer(recordArray, relaCustomerIDs, userID, inputDate, inputOrgID);
	if(result == "SUCCEED"){
		alert("加入我的客户成功！");
	}else{
		alert("加入我的客户失败！");
	}
}


//查询ECIF客户号
function ecifQuery(){
	var sCustomerType = getItemValue(0,getRow(0),"CUSTOMERTYPE");
	var sCustomerID = getItemValue(0,getRow(0),"CUSTOMERID");
	var sCtfID = getItemValue(0,getRow(0),"CERTID");
	var sCtfType = getItemValue(0,getRow(0),"CERTTYPE");
	var sClientCHNName = getItemValue(0,getRow(0),"CUSTOMERNAME");
	
	//个人客户查询ECIF
	if(sCustomerType == "03"){
		if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("请选择一条信息！");
			return;
		}
		var temp = CustomerManage.getECIFCustomer1(sCustomerID, sCtfType, sCtfID, sClientCHNName);
		if(temp == 'success')
			alert("查询成功，数据库已更新完成！");
		else
			alert("查询失败，请联系管理员！！！");
		reloadSelf();
	//公司客户查询ECIF
	}else if(sCustomerType.indexOf("01") == "0"){
		if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("请选择一条信息！");
			return;
		}
		var temp = CustomerManage.getECIFCustomer2(sCustomerID, sCtfID, sClientCHNName);
		if(temp == 'success')
			alert("查询成功，数据库已更新完成！");
		else
			alert("查询失败，请联系管理员！！！");
		reloadSelf();
	}
	
}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
