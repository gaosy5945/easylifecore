<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
   String sItemNo = CurPage.getParameter("ItemNo");
   if(sItemNo==null)sItemNo="";
   
   String sTempletNo = "IndustryLimitInfo";
   
   ASObjectModel doTemp = new ASObjectModel(sTempletNo);
   
   ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
   dwTemp.Style="2";
   
   dwTemp.genHTMLObjectWindow(sItemNo);
   
   String sButtons[][] = {
		   {"true","","Button","±£´æ","±£´æ","as_save(0)","","","","",""},
   };
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
<!--

//-->
</script>
<%@ include file="/Frame/resources/include/include_end.jspf" %>