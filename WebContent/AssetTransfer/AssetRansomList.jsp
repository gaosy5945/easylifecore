<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//接收参数
	String relaSerialNos = DataConvert.toString(CurPage.getParameter("relaSerialNos"));
	
	if(relaSerialNos.endsWith("@")){
		relaSerialNos = relaSerialNos.substring(0, relaSerialNos.length() - 1);
	}
	relaSerialNos = relaSerialNos.replaceAll("@", "','");
	
	ASObjectModel doTemp = new ASObjectModel("AssetRansomList");
	doTemp.setJboWhere("serialNo in('"+relaSerialNos+"')");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.MultiSelect = false;	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		};
%> 
<script type="text/javascript">
	
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
