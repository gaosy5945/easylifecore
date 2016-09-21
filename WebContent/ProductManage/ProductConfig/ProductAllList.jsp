<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String productCatalog = CurPage.getParameter("ProductCatalog");
	String productType = CurPage.getParameter("ProductType");
	if(productCatalog == null) productCatalog = "";
	if(productType == null) productType = "";
	
	ASObjectModel doTemp = new ASObjectModel("PRD_ProductAllList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.setPageSize(20);
	dwTemp.MultiSelect=true;
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","查看产品目录","查看产品目录","selectProductType()","","","","",""},
		{"true","","Button","查看产品详情","查看产品详情","viewProduct()","","","","",""},
		{"true","","Button","产品比较","产品比较","compareProduct()","","","","",""},
	};
%> 
<script type="text/javascript">

	function viewProduct(){
		var productID = getItemValue(0,getRow(),"ProductID");

	    if(typeof(productID)=="undefined" || productID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}
	    AsCredit.openFunction("PRD_ProductView","ProductID="+productID+"&RightType=ReadOnly","","_blank");
	}
	
	function selectProductType(){
		var productID = getItemValue(0,getRow(),"ProductID");

	    if(typeof(productID)=="undefined" || productID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}
	    AsCredit.openFunction("PRD_ProductTypeView","ProductID="+productID,"","_blank");
	}
	
	function compareProduct(){
		var ss = getCheckedRows(0);
		
		if(ss.length!=2)
		{
			alert("产品版本比较只能选择两条记录进行比较！");return;	
		}
		
		var productIDList="";
		for(var i=1;i<=ss.length;i++)
		{
			var productid = getItemValue(0, i-1, "PRODUCTID");
			productIDList += productid+"@";
		}
		
	    AsControl.OpenComp(
	    		"/ProductManage/ProductConfig/CompareProductParameter.jsp",
	    		"CompareType=Product&ProductIDList="+productIDList,
	    		"_blank");
	}
</script>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
