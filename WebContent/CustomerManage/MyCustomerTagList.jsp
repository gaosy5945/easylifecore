 <%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";

	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("MyCustomerTagList",BusinessObject.createBusinessObject(),CurPage);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request);
	
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.MultiSelect = true; //允许多选
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow(serialNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","分组维护","分组维护","alterTag()","","","","",""},
			{"true","All","Button","调整分组","调整分组","adjustTag()","","","","",""},
			{"true","","Button","客户详情","客户详情","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","引入客户","引入客户","importCustomer()","","","","",""},
			{"true","All","Button","删除客户","删除客户","del()","","","","btn_icon_delete",""},
			{"true","","Button","刷新客户","刷新客户","reloadCustomer()","","","","",""},
			{"true","All","Button","导出","导出","exportPage('"+sWebRootPath+"',0,'excel','')","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script><script type="text/javascript">
	function alterTag(){
		OpenPage("/CustomerManage/MyCustomerInfo.jsp?SerialNo="+"<%=serialNo%>","frameright","");
	}
	
	function adjustTag(){
		var relaCustomerIDs = '';
		var relaSerialNos = '';
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
			var serialNo = getItemValue(0,recordArray[i-1],"OTLSERIALNO");
			relaSerialNos += serialNo+"@";
		}
		var result = CustomerManage.adjustTag(recordArray, relaCustomerIDs, userID, relaSerialNos, inputDate, inputOrgID);
		if(result == "SUCCEED"){
			alert("分组调整成功！");
			reloadSelf();
		}else{
			alert("分组调整失败！");
		}
	}
	
	function edit(){
		var customerID = getItemValue(0,getRow(0),"CUSTOMERID");
		var customerType = getItemValue(0,getRow(0),"CUSTOMERTYPE");
 		if(typeof(customerID)=="undefined" || customerID.length==0){
			alert("请选择一条信息！");
			return;
		} 

		CustomerManage.editCustomer(customerID,customerType);
	}
	
	function del(){
		var deleteCustomerIDs = '';
		var recordArray = getCheckedRows(0); //获取勾选的行
		if (typeof(recordArray)=="undefined" || recordArray.length==0){
			alert("请至少选择一条所要删除记录！");
			return;
		}
		for(var i = 1;i <= recordArray.length;i++){ //通过循环获取customerID
			var customerID = getItemValue(0,recordArray[i-1],"CUSTOMERID");
			deleteCustomerIDs += customerID+"@";
		}
		if(confirm('确定要将所选客户从该分组中删除吗？')){
			var sReturn = CustomerManage.deleteTagCustomer(deleteCustomerIDs);
			if(sReturn == "SUCCEED"){
				alert("删除成功！");
				reloadSelf();
			}else{
				alert("删除失败！");
				reloadSelf();
			}
		}
	}
	function importCustomer(){
		 var sStyle = "dialogWidth:800px;dialogHeight:680px;resizable:yes;scrollbars:no;status:no;help:no";
         var returnValue = AsDialog.SelectGridValue('MyImportCustomer',"<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,03,<%=serialNo%>",'CUSTOMERID','',true,sStyle);
         if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
 			return ;
 		var OTCSerialNo = "<%=serialNo%>";
 		var InputUserID = "<%=CurUser.getUserID()%>";
 		var InputOrgID = "<%=CurOrg.getOrgID()%>";
 		var InputDate = "<%=StringFunction.getToday()%>";
 		var result = CustomerManage.importCustomerToTag(returnValue,OTCSerialNo,InputUserID,InputOrgID,InputDate);
 		if(result == "SUCCEED"){
 			alert("客户引入成功！");
 		}else{
 			alert("客户引入失败！");
 		}
        reloadSelf();
	}
	
	function reloadCustomer(){
		OpenPage("/CustomerManage/MyCustomerTagList.jsp?SerialNo="+"<%=serialNo%>", "frameright"); 
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
