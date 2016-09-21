<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList"); //借用显示模板
	doTemp.setDataQueryClass("com.amarsoft.app.awe.framecase.dw.DemoListForCustomData");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","详情","详情","view()","","","","btn_icon_detail",""},
		{"true","","Button","导出Txt","导出Txt","exportPage('"+sWebRootPath+"',0,'txt','"+dwTemp.getArgsValue()+"')","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function view(){
		 var sUrl = "/FrameCase/widget/ow/DemoInfoCustomDataSource.jsp";
		 OpenPage(sUrl+'?SerialNo=' + getItemValue(0,getRow(0),'SerialNo'),'_self','');
	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>