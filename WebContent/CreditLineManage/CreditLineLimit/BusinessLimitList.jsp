<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
  String sOrgID = CurPage.getParameter("OrgID");
  if(sOrgID==null)sOrgID="";
  
  String sTempletNo = "BusinessLimitList";
  
  ASObjectModel doTemp = new ASObjectModel(sTempletNo);
  
  ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
  dwTemp.Style="1";
  dwTemp.setPageSize(20);
  dwTemp.genHTMLObjectWindow(sOrgID);
  
  String sButtons[][]={
		  {"true","","Button","新增","新增","new()","","","","",""},
		  {"true","","Button","详情","详情","info()","","","","",""},
		  {"true","","Button","删除","删除","delete()","","","","",""},
  };

%>

<%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
<!--

//-->
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>