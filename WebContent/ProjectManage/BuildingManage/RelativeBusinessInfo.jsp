<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";

	String sTempletNo = "RelativeBusinessList";//--ģ���--
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", serialNo);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	doTemp.setBusinessProcess("com.amarsoft.app.als.awe.ow.ALSBusinessProcess");
	doTemp.setVisible("WJQ,YJQ,SPZ", true);
	
	
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	//dwTemp.replaceColumn("PAYINGBUSINESS", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"220\" frameborder=\"0\" src=\""+sWebRootPath+"/ProjectManage/BuildingManage/RelativePayingBusinessList.jsp?SerialNo="+serialNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	//dwTemp.replaceColumn("PAYEDBUSINESS", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"240\" frameborder=\"0\" src=\""+sWebRootPath+"/ProjectManage/BuildingManage/RelativePayedBusinessList.jsp?SerialNo="+serialNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	//dwTemp.replaceColumn("APPLYINGBUSINESS", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"240\" frameborder=\"0\" src=\""+sWebRootPath+"/ProjectManage/BuildingManage/RelativeApplyingBusinessList.jsp?SerialNo="+serialNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());

	String sButtons[][] = {
			{"false","All","Button","����","���������޸�","as_save(0)","","","",""},
	};
%>
<HEAD>
<title>����ҵ���ѯ</title>
</HEAD>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
