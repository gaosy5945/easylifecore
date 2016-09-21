<%@ page contentType="text/html; charset=GBK"%>
<%@include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	//获得参数：显示模板、客户编号
	String templateNo = CurPage.getParameter("TemplateNo");
	String customerID = CurPage.getParameter("CustomerID");

	//将空值转化成空字符串
	if(templateNo == null) templateNo = "";	
	

	ASObjectModel doTemp = new ASObjectModel(templateNo,"");
	
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	dwTemp.genHTMLObjectWindow(customerID);
	
	String sButtons[][] = {
	};
	
%><%@include file="/Frame/resources/include/ui/include_list.jspf" %>
<script type="text/javascript">
	function getValue(){
		return getItemValue(0,getRow(0),"SerialNo");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>