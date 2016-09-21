<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_multi.jspf"%>
 <%
	String FunctionID = CurPage.getAttribute("FunctionID");
	if(FunctionID==null)FunctionID="";
	String Type = CurPage.getAttribute("Type");
	if(Type==null) Type="";
 %>
 <!-- <input type="button" name="submit" value="Ìá½»" onclick="as_save('frame_info,frame_list')"> -->
<iframe name="frame_button" width="100%" height="30" frameborder="0" align="middle"></iframe>
<!-- <hr class="list_hr"> -->
<iframe name="frame_info" width="100%" height="750" frameborder="0"></iframe>
<%@include file="/Frame/resources/include/ui/include_multi.jspf"%>
<script>
var sUrl = "/ProjectManage/ProjectAlterNewApply/ProjectAlterBasicOrAssociateButton.jsp";
OpenPage(sUrl,'frame_button','');
sUrl = "/ProjectManage/ProjectAlterNewApply/ProjectAlterBasicOrAssociateInfo.jsp?FunctionID=<%=FunctionID%>";
OpenPage(sUrl,'frame_info','');
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>