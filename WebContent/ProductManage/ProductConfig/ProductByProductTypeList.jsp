<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sTempletNo = CurPage.getParameter("TempletNo");
	String productType = CurPage.getParameter("ProductType");
	if(sTempletNo == null) sTempletNo = "";
	if(productType == null) productType = "";
	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.setPageSize(20);
	dwTemp.setParameter("ProductType", productType);
	//dwTemp.MultiSelect=true;
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"false","All","Button","�鿴��Ʒ����","�鿴��Ʒ����","viewProduct()","","","","",""},
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
	
</script>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
