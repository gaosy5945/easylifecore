<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerType = CurPage.getParameter("CustomerType");
	String multiSelect = CurPage.getParameter("MultiSelect");
	String customer = CurPage.getParameter("CustomerIDs");
	if(customerType == null) customerType = "";
	if(multiSelect == null) multiSelect = "";
		
	ASObjectModel doTemp = new ASObjectModel("UnionImpMemberList");
	if(customer != null && !"".equals(customer)){
		String sTempSql = "";
		String[] sTempCustomerID = customer.split("@");
		if(sTempCustomerID.length>0){
			for(int i=0;i<sTempCustomerID.length;i++){
				if(sTempCustomerID[i] != null && !"".equals(sTempCustomerID[i])){
					sTempSql += "'"+sTempCustomerID[i]+"',";
				}
			}
			sTempSql = sTempSql.substring(0,sTempSql.length()-1);
			doTemp.appendJboWhere(" and O.CustomerID not in ("+sTempSql+")");
		}
	}

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	if("true".equals(multiSelect)){
		dwTemp.MultiSelect = true;
	}
	
	String param = "";
	if(customerType.equals("0110")){//对公联保体
		param = "01%,01%";
	}else if(customerType.equals("0120")){//个人联保体
		param = "03%,03%";
	}else{//其它客户群
		param = "01%,03%";
	}
	dwTemp.genHTMLObjectWindow(param+","+CurUser.getUserID());
	
	String sButtons[][] = {
			{"true","","Button","确认","确认","doSure()","","","","",""},
			{"true","","Button","取消","取消","cancel()","","","","",""}
		};
	//sButtonPosition = "south";
%> 
<script type="text/javascript">
	/*~[Describe=确认;InputParam=无;OutPutParam=无;]~*/
	function doSure(){
		if(<%="true".equals(multiSelect)%>){
			var recordArray = getCheckedRows("myiframe0");
			var vCustomerId = "";
			var vCustomerName = "";
			var vCustomer = "";
			if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
				for(var i=1;i<=recordArray.length;i++){
						vCustomerId = getItemValue(0,recordArray[i-1],"CustomerID");
						vCustomerName = getItemValue(0,recordArray[i-1],"CustomerName");
					if(i != recordArray.length){
						vCustomer += vCustomerId+"~"+vCustomerName+"@";
					}else{
						vCustomer += vCustomerId+"~"+vCustomerName;
					}
				}
				top.returnValue = vCustomer+'$<%=customer%>';
				top.close();
			}else{
				alert("请至少选择一条客户记录！");
				return;
			}	
		}else{
			var customerID = getItemValue(0,getRow(),"CustomerID");
			var customerName = getItemValue(0,getRow(),"CustomerName");
			if(typeof(customerID) == "undefined" || customerID.length == 0){
				alert("请至少选择一条客户记录！");
				return;
			}
			top.returnValue = customerID+"@"+customerName;
			top.close();
		}
	}
	
	/*~[Describe=取消;InputParam=无;OutPutParam=无;]~*/
	function cancel(){
		top.close();
	}
	
	/*使得按钮居中*/
	$(document).ready(function(){
	  //$("#ButtonTR").attr("align","center");
	  //$("#ListButtonArea").attr("align","center");
	});
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
