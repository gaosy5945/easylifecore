<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "保证金列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	String serialNo = CurPage.getParameter("GCSerialNo");
	if(serialNo == null) serialNo = "";
	BusinessObject inputParameter=BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectNo", serialNo);
	ASObjectWindow dwTemp  = ObjectWindowHelper.createObjectWindow_List("GuarantyCLRList", inputParameter, CurPage, request);
	ASDataObject doTemp = dwTemp.getDataObject();
	dwTemp.ReadOnly = "0";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","All","Button","新增保证金","新增保证金","newRecord()","","","",""},  
			{"true","","Button","详情","查看担保信息详情","viewAndEdit()","","","",""},
			{"true","All","Button","删除","删除担保信息","deleteRecord()","","","",""},
	};
	
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	function newRecord(){
		AsControl.PopView("/CreditManage/CreditApply/GuarantyCLRInfo.jsp", "SerialNo=&ObjectType=jbo.guaranty.GUARANTY_CONTRACT&ObjectNo=<%=serialNo%>", "resizable=yes;dialogWidth=800px;dialogHeight=380px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	
	function viewAndEdit(){
		serialNo=getItemValue(0,getRow(),"SerialNo");	
		if(typeof(serialNo)=="undefined" || serialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		AsControl.PopView("/CreditManage/CreditApply/GuarantyCLRInfo.jsp", "SerialNo="+serialNo+"&ObjectType=jbo.guaranty.GUARANTY_CONTRACT&ObjectNo=<%=serialNo%>", "resizable=yes;dialogWidth=800px;dialogHeight=380px;center:yes;status:no;statusbar:no");
	}
	
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		if(!confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			return ;
		}
		as_delete('0','');
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 