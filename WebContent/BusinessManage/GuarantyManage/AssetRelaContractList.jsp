<%@page import="com.amarsoft.app.als.guaranty.model.GuarantyFunctions"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "ѺƷ������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	String assetSerialNo = CurPage.getParameter("AssetSerialNo");
	if(assetSerialNo == null) assetSerialNo = "";
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("AssetSerialNo", assetSerialNo);
	
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("AssetRelaContractList",inputParameter,CurPage);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request);
	
	dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("AssetSerialNo", assetSerialNo);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","","Button","����","����","viewContract()","","","",""}
	};

%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	function viewContract(){
		var contractSerialNo = getItemValue(0,getRow(),"BCSerialNo");
		if(typeof(contractSerialNo)=="undefined" || contractSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		AsCredit.openFunction("ContractInfo","ObjectType=jbo.app.BUSINESS_CONTRACT&ObjectNo="+contractSerialNo, "");
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 