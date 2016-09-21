<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	ASObjectModel doTemp = null;
	doTemp = new ASObjectModel("AssetRepeatCheck");
	doTemp.setJboWhereWhenNoFilter(" and 1=2");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(CurUser.getOrgID());
	
	String sButtons[][] = {
		{"true","","Button","详情","详情","check()","","","","btn_icon_detail",""},
	};
%> 
<script type="text/javascript">

	//项目详情
	function check(){
		
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
