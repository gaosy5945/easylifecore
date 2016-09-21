 <%@page import="com.amarsoft.app.als.guaranty.model.GuarantyFunctions"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%	
	String PG_TITLE = "担保合同信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("CeilingGCInfo");
		
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      
	dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow(serialNo);
	
	String sButtons[][] = {
	};

%> 
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">


</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 