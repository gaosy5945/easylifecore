<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@page import="com.amarsoft.are.jbo.JBOTransaction"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@page import="com.amarsoft.are.lang.DateX"%>
<%@page import="com.amarsoft.app.bizmethod.*"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>


<style>
	.modify_div{
		position: absolute;
		top:10px;
		right:15px;
	}
</style>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	String PG_TITLE = "主体资格分析";
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	String customerID = "";
	if(taskSerialNo != null){
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
		BusinessObject flow = bom.loadBusinessObjects("jbo.flow.FLOW_TASK", "SerialNo=:TaskSerialNo",
				"TaskSerialNo="+taskSerialNo, ",").get(0);
		String objectNo = flow.getString("ObjectNo");
		String objectType = flow.getString("ObjectType");
		if(!"CreditApply".equals(objectType)) throw new Exception("流程类型错误！");
		BusinessObject apply = bom.loadBusinessObject("jbo.app.BUSINESS_APPLY", objectNo);
		if(apply == null) throw new Exception("未加载到编号为 "+objectNo+" 的申请对象！");
		customerID = apply.getString("CustomerID");
	}
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%	
	ASObjectModel doTemp = new ASObjectModel("ICRPKeyInfo","");

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="2";   
	dwTemp.setParameter("CustomerID", customerID);
	dwTemp.genHTMLObjectWindow("");
	
	
	String sButtons[][] = {
		{"true","All","Button","征信报告查看","征信报告查看","view()","","","",""},
	};

	%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>

<script type="text/javascript">
	function view(){
		
	}
	
	</script>
<%/*~END~*/%>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
