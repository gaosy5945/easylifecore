<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObjectManager" %><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "已有的抵质押物列表"; // 浏览器窗口标题 <title> PG_TITLE </title>

	String sno = "";
	String serialNos = CurPage.getParameter("SerialNos");
	if(serialNos == null) serialNos = "";
	String collNo[] = serialNos.split(",");//押品系统押品编号
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
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","All","Button","返回","返回","closePage()","","","",""},
			{"true","All","Button","引入","引入","importColl()","","","",""}
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
 