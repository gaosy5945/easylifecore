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


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	String PG_TITLE = "�����ʸ����";
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	String customerID = "";
	if(taskSerialNo != null){
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
		BusinessObject flow = bom.loadBusinessObjects("jbo.flow.FLOW_TASK", "SerialNo=:TaskSerialNo",
				"TaskSerialNo="+taskSerialNo, ",").get(0);
		String objectNo = flow.getString("ObjectNo");
		String objectType = flow.getString("ObjectType");
		if(!"CreditApply".equals(objectType)) throw new Exception("�������ʹ���");
		BusinessObject apply = bom.loadBusinessObject("jbo.app.BUSINESS_APPLY", objectNo);
		if(apply == null) throw new Exception("δ���ص����Ϊ "+objectNo+" ���������");
		customerID = apply.getString("CustomerID");
	}
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%	
	ASObjectModel doTemp = new ASObjectModel("ICRPKeyInfo","");

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="2";   
	dwTemp.setParameter("CustomerID", customerID);
	dwTemp.genHTMLObjectWindow("");
	
	
	String sButtons[][] = {
		{"true","All","Button","���ű���鿴","���ű���鿴","view()","","","",""},
	};

	%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>

<script type="text/javascript">
	function view(){
		
	}
	
	</script>
<%/*~END~*/%>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
