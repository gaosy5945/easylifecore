<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	BusinessObject inputParameter = SystemHelper.getPageComponentParameters(CurPage);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("SHAccumulationReport", inputParameter, CurPage, request);
	
	ASDataObject doTemp = dwTemp.getDataObject();
	doTemp.setBusinessProcess("com.amarsoft.app.als.report.action.SHAccumulationReport");
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
	};
	sASWizardHtml = "<p><font color='red' size='3'>&nbsp;&nbsp;��ѡ��Ҫ��ѯ�·ݵ���ĩ����</font></p>";
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">


</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
