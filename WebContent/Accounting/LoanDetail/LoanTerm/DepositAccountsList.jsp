<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@page import="com.amarsoft.app.als.businessobject.*"%> 
  
<%
	String PG_TITLE = "账户信息管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String sObjectNo = CurPage.getParameter("OBJECTNO");
	String sObjectType = CurPage.getParameter("OBJECTTYPE");
	String accountIndicator =CurPage.getParameter("ACCOUNTINDICATOR");
	String status = CurPage.getParameter("STATUS");
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(status == null) status = "";

	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectNo", sObjectNo);
	inputParameter.setAttributeValue("ObjectType", sObjectType);
	
	//显示模版编号	
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("DepositAccountsList", inputParameter,CurPage);
	doTemp.appendJboWhere(" and Status in('"+status.replaceAll("@","','")+"')");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	if(accountIndicator != null && !"".equals(accountIndicator)) 
		doTemp.appendJboWhere(" and AccountIndicator in('"+accountIndicator.replaceAll("@","','")+"')");
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request);
	
	dwTemp.Style = "1"; //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);

	String sButtons[][] = {
			{"true", "All", "Button", "新增", "新增一条账户信息","createRecord()",""},
			{"true", "", "Button", "详情", "详情","view()",""},
			{"true", "All", "Button", "删除", "删除一条信息","deleteRecord()",""},
	};

%>
<%@include file="/Frame/resources/include/ui/include_list.jspf" %>
<script language=javascript>
	function createRecord(){
		AsControl.PopView("/Accounting/LoanDetail/LoanTerm/DepositAccountsInfo.jsp","STATUS=<%=status%>&OBJECTNO=<%=sObjectNo%>&OBJECTTYPE=<%=sObjectType%>&ACCOUNTINDICATOR=<%=accountIndicator%>","dialogWidth:400px;dialogHeight:300px;","");
		reloadSelf();
	}
	
	function view(){
		var SerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(SerialNo)=="undefined"||SerialNo.length==0){
			alert("请选择一条记录");
			return;
		}
		OpenPage("/Accounting/LoanDetail/LoanTerm/DepositAccountsInfo.jsp?STATUS=<%=status%>&OBJECTNO=<%=sObjectNo%>&OBJECTTYPE=<%=sObjectType%>&ACCOUNTINDICATOR=<%=accountIndicator%>&SERIALNO="+SerialNo,"_self","");
	}
	
	/*~[Describe=删除;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		//setNoCheckRequired(0);  //先设置所有必输项都不检查
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("确定删除该信息吗？")){
			as_delete("0");
			as_save("0");  
			/* as_delete(0,'','delete');
			as_do(0,'','save'); */
		}
		reloadSelf();
	}
</script>
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>