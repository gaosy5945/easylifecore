<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TransferApproveList");
	doTemp.setVisible("REFUSEDATE", true);
	doTemp.appendJboWhere(" and TransferType='30'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.genHTMLObjectWindow(CurUser.getUserID());
	
	String sButtons[][] = {
			{"true","","Button","客户详情","查看客户详情","view()","","","",""}
		};
%> 
<script type="text/javascript">
	function view(){
		var customerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(customerID)=="undefined" || customerID.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
    	AsCredit.openFunction("CustomerDetail","CustomerID="+customerID,"");
		//AsControl.OpenObject("Customer",customerID,"001");
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
