<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String ObjectModel = CurPage.getParameter("ObjectModel");
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	if(ObjectModel == null) ObjectModel = "";

	//String sTempletNo = "UnionCustomerInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(ObjectModel);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(customerID);
	dwTemp.replaceColumn("MemberList","<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"450\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/UnionManage/UnionMemberlist.jsp?CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
			{"true","All","Button","����","���������޸�","as_save(0)","","","",""}
	};
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
