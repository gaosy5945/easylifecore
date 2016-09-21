<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
    //资料补扫，未完结的合同列表
	ASObjectModel doTemp = new ASObjectModel("CreditContractList1");    
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.setParameter("InputOrgID", CurOrg.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		{"true","All","Button","补扫","补扫","scan()","","","","",""}
	};

%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	function scan(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var contractArtificialNo = getItemValue(0,getRow(),"ContractArtificialNo");	
		AsControl.PopComp("/ImageManage/ImagePage.jsp","ImageCodeNo="+contractArtificialNo+"&QueryType=02","");
	}


</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
