<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_multi.jspf"%>
 <input type="button" name="submit" value="Ìá½»" onclick="as_save('frame_info,frame_list')">
<iframe name="frame_info" width="100%" height="270" frameborder="0"></iframe>
<hr class="list_hr">
<iframe name="frame_list" width="100%" height="350" frameborder="0"></iframe>
<%@include file="/Frame/resources/include/ui/include_multi.jspf"%>
<%
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
%>
<script>
var sUrl = "/CreditManage/CreditApply/QualificationAnalyseInfo.jsp";
OpenPage(sUrl+'?TaskSerialNo=<%=taskSerialNo%>','frame_info','');
/* sUrl = "/CreditManage/CreditApply/QualificationAnalyseOpinion.jsp"; */
OpenPage(sUrl+'?TaskSerialNo=<%=taskSerialNo%>','frame_list','');
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>