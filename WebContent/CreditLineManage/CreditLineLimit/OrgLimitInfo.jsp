<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%  
   String sOrgID = CurPage.getParameter("OrgID");
   if(sOrgID == null) sOrgID = "";
   
   String sTempletNo = "OrgLimitInfo";
   ASObjectModel doTemp = new ASObjectModel(sTempletNo);
   
   ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
   dwTemp.Style = "2";
   dwTemp.genHTMLObjectWindow(sOrgID);
   
   String sButtons[][] = {
		   {"true","","Botton","±£´æ","±£´æ","as_save(0)","","","","",""},
   };
 
 %>
 
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
 <Script type="text/javascript">
 
 </Script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>