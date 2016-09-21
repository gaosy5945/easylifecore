<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
 	doTemp.appendJboWhere("SerialNo like :SerialNo and ISINUSE=:IsInUse");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	//新的设置参数方法 setParameter，可以多个连写
	dwTemp.setParameter("SerialNo", "20100426%").setParameter("IsInUse", "1");
	//兼容原来的以“,”分隔的参数格式
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
		{"true","","Button","导出EXCEL","导出EXCEL","exportPage('"+sWebRootPath+"',0,'excel','"+dwTemp.getArgsValue()+"')","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		var sUrl = "/FrameCase/widget/ow/DemoInfoSimple.jsp";
		OpenPage(sUrl+'?SerialNo='+sSerialNo,'_self','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>