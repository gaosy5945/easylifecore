<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
 <%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>
 <style>
 /*页面小计样式*/
.list_div_pagecount{
	font-weight:bold;
}
/*总计样式*/
.list_div_totalcount{
	font-weight:bold;
}
 </style>
<%
	//接收参数
	String serialNo = DataConvert.toString(CurComp.getParameter("SerialNo"));//项目流水号
	if(serialNo == null) serialNo = "";
	String taskSerialNo = DataConvert.toString(CurComp.getParameter("TaskSerialNo"));//看能否传入任务流水号，与封包入池不一样
	String agreementNo = Sqlca.getString(new SqlObject("select AgreementNo from prj_basic_info where serialno = :SerialNo").setParameter("SerialNo", serialNo));
	if(agreementNo == null) agreementNo = "";
	String showExportButton = DataConvert.toString(CurComp.getParameter("ShowExportButton"));//控制其与普通流程中展示不一样
	ASObjectModel doTemp = new ASObjectModel("ProjectAssetCountList");
	doTemp.appendJboWhere(" and O.PROJECTSERIALNO = '"+serialNo+"'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ShowSummary = "1";
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("serialNo");
	
	String sButtons[][] = {
		{"true","All","Button","资产导入","资产导入","assetImport()","","","","",""},
		{"true","","Button","资产明细","资产明细","assetDetail()","","","","",""},
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

	/* //资产导入 */
	function assetImport(){
		if('<%=agreementNo%>' == ""){
			alert("请先保存项目基本信息！");
			return;
		}
	    var pageURL = "/AppConfig/FileImport/FileSelector.jsp";
	    var parameter = "clazz=jbo.import.excel.ASSET_IMPORT&ProjectSerialno="+'<%=serialNo%>';
	    var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
	    var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
	    reloadSelf();
	}
	
	//资产明细
	function assetDetail(){
		var serialNo = '<%=serialNo%>';
		var belongOrgID = getItemValue(0,getRow(),"BELONGORGID");
		var sUrl = "/AssetTransfer/ProjectAssetRelaSonList.jsp";
		AsControl.OpenPage(sUrl,"SerialNo="+serialNo+"&BelongOrgID="+belongOrgID,"_self");
	}
	
</script>
<%@
 include file="/Frame/resources/include/include_end.jspf"%>
