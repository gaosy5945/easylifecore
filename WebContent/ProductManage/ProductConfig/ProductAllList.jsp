<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String productCatalog = CurPage.getParameter("ProductCatalog");
	String productType = CurPage.getParameter("ProductType");
	if(productCatalog == null) productCatalog = "";
	if(productType == null) productType = "";
	
	ASObjectModel doTemp = new ASObjectModel("PRD_ProductAllList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.setPageSize(20);
	dwTemp.MultiSelect=true;
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","�鿴��ƷĿ¼","�鿴��ƷĿ¼","selectProductType()","","","","",""},
		{"true","","Button","�鿴��Ʒ����","�鿴��Ʒ����","viewProduct()","","","","",""},
		{"true","","Button","��Ʒ�Ƚ�","��Ʒ�Ƚ�","compareProduct()","","","","",""},
	};
%> 
<script type="text/javascript">

	function viewProduct(){
		var productID = getItemValue(0,getRow(),"ProductID");

	    if(typeof(productID)=="undefined" || productID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
	    AsCredit.openFunction("PRD_ProductView","ProductID="+productID+"&RightType=ReadOnly","","_blank");
	}
	
	function selectProductType(){
		var productID = getItemValue(0,getRow(),"ProductID");

	    if(typeof(productID)=="undefined" || productID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
	    AsCredit.openFunction("PRD_ProductTypeView","ProductID="+productID,"","_blank");
	}
	
	function compareProduct(){
		var ss = getCheckedRows(0);
		
		if(ss.length!=2)
		{
			alert("��Ʒ�汾�Ƚ�ֻ��ѡ��������¼���бȽϣ�");return;	
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
