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
		  {"true","","Button","����","����","new()","","","","",""},
		  {"true","","Button","����","����","info()","","","","",""},
		  {"true","","Button","ɾ��","ɾ��","delete()","","","","",""},
  };

%>

<%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
<!--

//-->
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>