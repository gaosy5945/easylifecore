<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*
		页面说明: 以标签页形式打开
	 */
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
 	ASObjectWindow dwTemp = new ASObjectWindow(CurPage ,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","openRecord()","","","",""},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function openRecord(sSerialNo){
		var sParas = "";
		if(sSerialNo) sParas = "SerialNo="+sSerialNo;
		
		if(typeof parent.addTabItem == "function"){
			var text;
			if(sSerialNo) text = "详情【"+sSerialNo+"】";
			else text = "新增";
			parent.addTabItem(text, "/FrameCase/widget/ow/DemoInfoSimple.jsp", sParas);
		}else{
			AsControl.OpenView("/FrameCase/widget/ow/DemoInfoSimple.jsp", sParas, "_self","");
		}
	}
	
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		openRecord(sSerialNo);
	}
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>