<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String productid = CurPage.getParameter("ProductID");
	if(productid == null) productid = "";
	
	ASObjectModel doTemp = new ASObjectModel("PRD_SpecificVersionList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.setPageSize(20);
	dwTemp.MultiSelect=true;
	dwTemp.genHTMLObjectWindow(productid+",000");
	
	String sButtons[][] = {
		{"true","","Button","查看产品详情","查看产品详情","viewProductParameter()","","","","",""},
		{"true","","Button","产品版本比较","查看产品版本参数详情","compareProductParameter()","","","","",""},
	};
%> 
<script type="text/javascript">
	function viewProduct(){
		var productID = getItemValue(0,getRow(),"ProductID");

	    if(typeof(productID)=="undefined" || productID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}
	    AsCredit.openFunction("PRD_ProductView","ProductID="+productID,"","_blank");
	}
	
	function viewProductParameter(){
		var productID = getItemValue(0,getRow(),"ProductID");
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
	    if(typeof(productID)=="undefined" || productID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}
	    
	    AsControl.OpenComp(
	    		"/AppMain/resources/widget/FunctionView.jsp",
	    		"SYS_FUNCTIONID=PRD_ProductView_BySFSerialNo&ProductID="+productID+"&SpecificSerialNo="+serialNo+"&AlwaysShowFlag=1&PageStyle=&RightType=ReadOnly",
	    		"_blank");
	}
	
	
	function compareProductParameter(){
		var ss = getCheckedRows(0);
		
		if(ss.length!=2)
		{
			alert("版本比较只能选择两条记录进行比较！");return;	
		}
		
		var versionIDList="";
		for(var i=1;i<=ss.length;i++)
		{
			var serialno = getItemValue(0, i-1, "SERIALNO");
			versionIDList += serialno+"@";
		}
		
	    AsControl.OpenComp(
	    		"/ProductManage/ProductConfig/CompareProductParameter.jsp",
	    		"CompareType=Version&VersionIDList="+versionIDList,
	    		"_blank"); 
	}
</script>

<%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
