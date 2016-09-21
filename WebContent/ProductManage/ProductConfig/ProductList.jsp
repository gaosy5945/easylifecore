<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String productCatalog = CurPage.getParameter("ProductCatalog");
	String productType = CurPage.getParameter("ProductType");
	if(productCatalog == null) productCatalog = "";
	if(productType == null) productType = "";
	
	ASObjectModel doTemp = new ASObjectModel("PRD_ProductList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.setPageSize(20);
	dwTemp.setParameter("ProductCatalog", productCatalog);
	dwTemp.setParameter("ProductType", productType+"%");
	dwTemp.MultiSelect=true;
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","�����Ʒ","�Ӳ�Ʒ���������Ʒ����ǰĿ¼","importProduct()","","","","",""},
		{"true","","Button","�鿴��Ʒ","�鿴��Ʒ��ϸ��Ϣ","viewProduct()","","","","",""},
		{"true","","Button","�Ƴ���Ʒ","�ӵ�ǰĿ¼���Ƴ�ѡ���Ʒ","removeProduct()","","","","",""},
		//{"true","","Button","�����ļ�","����XML��ʽ�ļ�","exportProductFile()","","","","",""},��ʱ����
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
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
	    AsCredit.openFunction("PRD_ProductView","ProductID="+productID,"","_blank");
	}
	
	function removeProduct(){
		var rows=getCheckedRows(0);

		if(typeof(rows)=="undefined" || rows.length==0) {
			alert("�빴ѡ��¼��");
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
			alert("�빴ѡ��¼��");
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
