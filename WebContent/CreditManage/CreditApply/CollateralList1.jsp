<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObjectManager" %><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "���еĵ���Ѻ���б�"; // ��������ڱ��� <title> PG_TITLE </title>

	String sno = "";
	String serialNos = CurPage.getParameter("SerialNos");
	if(serialNos == null) serialNos = "";
	String collNo[] = serialNos.split(",");//ѺƷϵͳѺƷ���
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
	for(int i = 0;i < collNo.length;i++){
		List<BusinessObject>list = bom.loadBusinessObjects("jbo.app.ASSET_INFO", "CLRSerialNo=:CLRSerialNo", "CLRSerialNo="+collNo[i]);
		for(BusinessObject o : list){
			sno += "'";
			sno += o.getObjectNo();
			sno += "',";
		}
	}
	
	ASObjectModel doTemp = new ASObjectModel("CollateralList1");
	if(sno.length() > 0){
		sno = sno.substring(0, sno.length()-1);
		doTemp.appendJboWhere(" SerialNo in (" + sno + ")");
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","All","Button","����","����","closePage()","","","",""},
			{"true","All","Button","����","����","importColl()","","","",""}
	};
	sButtonPosition = "south";
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function closePage(){
		self.close();
	}
	
	function importColl(){
		var assetSerialNo = getItemValue(0,getRow(),"SerialNo"); 
		parent.returnValue = assetSerialNo;
		parent.assetNo = assetSerialNo;
		self.close();
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 