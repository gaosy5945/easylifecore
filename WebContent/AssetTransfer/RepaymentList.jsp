<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//还款清单
	ASObjectModel doTemp = new ASObjectModel("ReplaymentList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("SerialNo");
	
	String sButtons[][] = {
			{"true","","Button","导出","导出","asExport()","","","","btn_icon_add",""},
		};
%> 
<script type="text/javascript">
	function asExport(){
		 var sUrl = "";
		 OpenPage(sUrl,'_self','');
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
