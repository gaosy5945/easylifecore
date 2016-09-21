<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String PG_TITLE = "额度信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数	：申请流水号、对象类型、对象编号、业务类型、客户类型、客户ID
	
	String clSerialNo = CurPage.getParameter("CLSerialNo");
	
	//将空值转化成空字符串
	if(clSerialNo == null) clSerialNo = "";	
	

	ASObjectModel doTemp = new ASObjectModel("CreditApplyRelaCLInfo","");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setParameter("SerialNo", clSerialNo);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"false","","Button","保存","保存","saveRecord()","","","",""},	
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(){
		
	}

	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>