<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	
	String rightType = CurPage.getParameter("RightType");
	if(rightType==null)rightType="";
	String templetNo = "RiskWarningCancelOpinionInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(templetNo);
	if("ReadOnly".equals(rightType)){
		doTemp.setReadOnly("*", true);
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	String sButtons[][] = {
		{"ReadOnly".equals(rightType)?"false":"true","All","Button","����","���������޸�","as_save(0)","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
