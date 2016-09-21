<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
 	String sDoNo = CurPage.getParameter("DONO");
	if(sDoNo==null) sDoNo = "";
 	//定义strip数组：
 	//参数：0.是否显示, 1.标题，2.高度，3.组件ID，4.URL，5，参数串，6.事件
	String sStrips[][] = {
		{"true","模板目录信息" ,"300","","/AppConfig/PageMode/DWConfig/DataObjectCatalogInfo.jsp","DONO="+sDoNo,""},
		{"true","模板定义信息" ,"600","","/AppConfig/PageMode/DWConfig/DataObjectLibraryList.jsp","DONO="+sDoNo,""},
	};
 	String sButtons[][] = {};
%><%@include file="/Resources/CodeParts/Strip05.jsp"%>
<script type="text/javascript">	
	setDialogTitle("DataWindow显示模板配置");
	setSelectedStrip(1); //默认打开项
</script>
<%@ include file="/IncludeEnd.jsp"%>