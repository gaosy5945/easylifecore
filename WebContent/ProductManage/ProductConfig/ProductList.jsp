<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String productCatalog = CurPage.getParameter("ProductCatalog");
	String productType = CurPage.getParameter("ProductType");
	if(productCatalog == null) productCatalog = "";
	if(productType == null) productType = "";
	
	ASObjectModel doTemp = new ASObjectModel("PRD_ProductList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.setPageSize(20);
	dwTemp.setParameter("ProductCatalog", productCatalog);
	dwTemp.setParameter("ProductType", productType+"%");
	dwTemp.MultiSelect=true;
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","引入产品","从产品库中引入产品到当前目录","importProduct()","","","","",""},
		{"true","","Button","查看产品","查看产品详细信息","viewProduct()","","","","",""},
		{"true","","Button","移除产品","从当前目录中移除选择产品","removeProduct()","","","","",""},
		//{"true","","Button","导出文件","导出XML格式文件","exportProductFile()","","","","",""},暂时屏蔽
	};
%> 
<script type="text/javascript">
	function importProduct(){
		var result = AsCredit.selectGrid("PRD_SelectProductList4Import", "<%=productCatalog%>", "PRODUCTID", "", true,"@");
		if(!result||!result["PRODUCTID"]) return ;
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.ProductCatalogManager", "importProduct"
				, "ProductIDString="+result["PRODUCTID"]+ ",ProductCatalog=<%=productCatalog%>,ProductType=<%=productType%>");
		if(returnValue=="1")reloadSelf();
	}

	function viewProduct(){
		var productID = getItemValue(0,getRow(),"ProductID");

	    if(typeof(productID)=="undefined" || productID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}
	    AsCredit.openFunction("PRD_ProductView","ProductID="+productID,"","_blank");
	}
	
	function removeProduct(){
		var rows=getCheckedRows(0);

		if(typeof(rows)=="undefined" || rows.length==0) {
			alert("请勾选记录！");
			return;
		}
		var productID = "";
		for(var i=0;i<rows.length;i++){
			productID+="@"+getItemValue(0,rows[i],"PRODUCTID");
		}
		if(productID.length>0)productID=productID.substring(1);
		
		AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.ProductCatalogManager", "removeProduct"
				, "ProductIDString="+productID+ ",ProductCatalog=<%=productCatalog%>,ProductType=<%=productType%>");
		reloadSelf();
	}
	
	function exportProductFile(){
		var rows=getCheckedRows(0);
		if(typeof(rows)=="undefined" || rows.length==0) {
			alert("请勾选记录！");
			return;
		}
		var productID = "";
		for(var i=0;i<rows.length;i++){
			productID+="@"+getItemValue(0,rows[i],"PRODUCTID");
		}
		if(productID.length>0)productID=productID.substring(1);
		AsControl.PopView("/Common/BusinessObject/ExportBusinessObjectToFile.jsp",
				"FileFormat=xml&ObjectType=jbo.prd.PRD_PRODUCT_LIBRARY&ObjectNo="+productID,"resizable=yes;dialogWidth=300px;dialogHeight=200px;center:yes;status:no;statusbar:no");
	}
	
	
</script>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
