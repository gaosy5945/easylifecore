<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String PG_TITLE = "关键信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数	：申请流水号、对象类型、对象编号、业务类型、客户类型、客户ID
	
	String templateNo = CurPage.getParameter("TemplateNo");
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	String businessType = CurPage.getParameter("BusinessType");
	
	//将空值转化成空字符串
	if(templateNo == null) templateNo = "";	
	if(objectType == null) objectType = "";
	if(objectNo == null) objectNo = "";
	if(businessType == null) businessType = "";
	
	ASObjectModel doTemp = new ASObjectModel(templateNo,"");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.setParameter("ObjectNo", objectNo);
	
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","新增","新增","add()","","","",""},	
		{"true","","Button","保存","保存","saveRecord()","","","",""},	
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf" %>
<script type="text/javascript">
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(){
			as_save("myiframe0");
	}
	
	function add(){
		
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