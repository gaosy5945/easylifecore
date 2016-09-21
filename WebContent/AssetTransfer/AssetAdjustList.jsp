<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sObjectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));//项目编号
	String sObjectType = DataConvert.toString(CurPage.getParameter("ObjectType"));//项目类型
	
	ASObjectModel doTemp = new ASObjectModel("AssetAdjustList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);
	
	String sButtons[][] = {
		};
%> 
<script type="text/javascript">
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
