<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String transferType = CurPage.getParameter("TransferType"); 
	String rightType = CurPage.getParameter("RightType");  
	String customerId = CurPage.getParameter("CustomerID"); 
	if(rightType == null) rightType = "10";
	if(customerId==null) customerId="";
	ASObjectModel doTemp = new ASObjectModel("TransferCustomerList");
	String userID = CurUser.getUserID();
	String orgID = CurUser.getOrgID();
	
	if("10".equals(transferType)){//转出时,显示当前用户下所有管护的客户
		doTemp.setVisible("UserName", false);
		doTemp.setVisible("OrgName", false);
		doTemp.appendJboWhere(" and cb.UserID='"+userID+"' and Cb.BelongAttribute='1'");
	}else if("20".equals(transferType)){//转入时,显示当前机构下所有非自己管护的客户
		//需要转入管护权时,过滤自己拥有管护权的客户
		if(!customerId.equals("")){//指定客户申请时
			doTemp.appendJboWhere(" and cb.CustomerID='"+customerId+"' and cb.UserID='"+userID+"'");
		}else{ 
			//转入维护权时,过滤自己已拥有管护权与维护权的客户
			doTemp.appendJboWhere("and cb.BelongAttribute='1' and cb.CustomerID not in "+
				"(select cb2.CustomerID from jbo.app.CUSTOMER_BELONG cb2 where cb2.UserID='"+userID+"' and cb2.BelongAttribute='1')");
			doTemp.appendJboWhere(" and cb.OrgID like '"+orgID+"%'");

		}
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(15);
	dwTemp.MultiSelect = true;
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
	};
%> 
<script type="text/javascript">

	/*~[Describe=获取选中客户编号(供上级页面调用);InputParam=无;OutPutParam=无;]~*/
	function returnCustomers(){
		var returnValue = "";
		var recordArray = getCheckedRows("myiframe0");
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
			for(var i=1;i<=recordArray.length;i++){
				vCustomerId = getItemValue(0,recordArray[i-1],"CustomerID");
				vCustomerName = getItemValue(0,recordArray[i-1],"CustomerName");
				//检查客户是否存在未结清的在途业务申请
				var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.common.action.CustomerBusinessCheck","checkBusinessApply","customerID="+vCustomerId);
				if(sReturn == "true"){
					alert("客户 "+vCustomerName+" 存在在途的业务申请，请重新选择！");
					return "error";
				}
		     	//检查客户是否存未审批完成的批复
				sReturn = RunJavaMethod("com.amarsoft.app.als.customer.common.action.CustomerBusinessCheck","checkBusinessApprove","customerID="+vCustomerId);
				if(sReturn == "true"){
					alert("客户 "+vCustomerName+" 存在未审批完成的批复，请重新选择！");
					return "error";
				}
		     	//检查客户是否存在未“登记完成”的合同
				sReturn = RunJavaMethod("com.amarsoft.app.als.customer.common.action.CustomerBusinessCheck","checkBusinessContract","customerID="+vCustomerId);
				if(sReturn == "true"){
					alert("客户 "+vCustomerName+" 存在未“登记完成”的合同，请重新选择！");
					return "error";
				}
				returnValue += vCustomerId+"@";
			}
		}
		return returnValue;
	}

	function reformat(rightType){
		AsControl.OpenPage("/CustomerManage/TransferManage/TransferCustomerList.jsp","TransferType=<%=transferType%>&RightType="+rightType, "_self");
	}
	
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
