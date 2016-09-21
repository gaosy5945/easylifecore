<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

	<%
	String PG_TITLE = "分账信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sObjectType = CurPage.getParameter("ObjectType");
	if(sObjectNo==null) sObjectNo = "";
	if(sObjectType==null) sObjectType = "";

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "SubsidiaryledgerList";

	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(20);
	
	
	//增加过滤器	
	
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(20);
    dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);
	//生成HTMLDataWindow
	
	String sButtons[][] = {
		};
	%> 


<%@include file="/Frame/resources/include/ui/include_list.jspf"%>


<script type="text/javascript">	
// 	AsOne.AsInit();
// 	init();
// 	my_load(2,0,'myiframe0');
</script>	

<%@ include file="/Frame/resources/include/include_end.jspf"%>
