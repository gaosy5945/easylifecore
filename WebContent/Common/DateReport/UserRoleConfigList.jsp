<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("UserRoleConfigList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow(CurUser.getOrgID());

	String sButtons[][] = {
			{"true","","Button","����","����Excel","as_defaultExport()","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
