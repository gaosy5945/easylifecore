<%@page import="com.amarsoft.app.als.filter.AlarmSignalFilter"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("AlarmGatherList");
	doTemp.setFilter("6","INPUTDATE","Operators=BigEqualsThan");
	doTemp.setFilter("7","FINISHDATE","Operators=LessEqualsThan");
	doTemp.setFilterCustomWhereClauses(new AlarmSignalFilter());
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(CurUser.getOrgSortNo() + "%");
	
	String sButtons[][] = {
		};
%> 
<script type="text/javascript">
	function initFilter(){
		setFilterAreaOption(0,"INPUTDATE","BigEqualsThan");
		setFilterAreaOption(0,"FINISHDATE","LessEqualsThan");
	}
	window.onload= initFilter;
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
