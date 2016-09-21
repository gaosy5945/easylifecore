<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
 <%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>
<%
	//接收参数
	String serialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));//项目流水号
	if(serialNo == null) serialNo = "";
	String belongOrgID = DataConvert.toString(CurPage.getParameter("BelongOrgID"));//项目流水号
	if(belongOrgID == null) belongOrgID = "";
	ASObjectModel doTemp = new ASObjectModel("ProjectAssetList");
	doTemp.appendJboWhere(" and O.PROJECTSERIALNO = :serialNo and oi.BELONGORGID = :belongOrgID");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.MultiSelect = true;
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(serialNo+","+belongOrgID);
	
	String sButtons[][] = {
		{"true","","Button","资产导出","资产导出","exportAsset()","","","","",""},
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

	//资产转出
	function exportAsset(){
		var sExportUrl = "/AssetTransfer/ProjectExportExcelList.jsp";
		 var sPRISerialNoList = "";
		 var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("请选择至少一条资产信息！");
		 }else{
			for(var i=0;i<arr.length;i++){
				var sPRISerialNo = getItemValue(0,arr[i],'SERIALNO');
				if(sPRISerialNo == null) sPRISerialNo = "";

				sPRISerialNoList += sPRISerialNo + ",";
			 }
		 	AsControl.PopComp(sExportUrl,'PRISerialNoList=' +sPRISerialNoList,'');
		 }
		 reloadSelf();
	}
	
</script>
<%@
 include file="/Frame/resources/include/include_end.jspf"%>
