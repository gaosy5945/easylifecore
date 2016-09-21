<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String PG_TITLE = "贷款申请关联额度列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	
	//将空值转化成空字符串
	if(objectType == null) objectType = "";
	if(objectNo == null) objectNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("CreditApplyRelaCLList","");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.setParameter("ObjectNo", objectNo);
	
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","详情","详情","view()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf" %>
<script type="text/javascript">
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	
	function view(){
		var objectType = getItemValue(0,getRow(),"ObjectType");
		var clSerialNo = getItemValue(0,getRow(),"CLSerialNo");
		if(objectType!="jbo.app.BUSINESS_APPLY") return;
		var result=AsControl.OpenComp("/CreditManage/CreditApply/CreditApplyRelaCLInfo.jsp","CLSerialNo="+clSerialNo,"","");
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "";//表名
		var sColumnName = "";//字段名
		var sPrefix = "";//前缀
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){

    }

	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>