<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObjectManager"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@page import="com.amarsoft.are.jbo.JBOTransaction"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.lang.DateX"%>
<%@page import="com.amarsoft.app.bizmethod.*"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>

<style>
	.modify_div{
		position: absolute;
		top:10px;
		right:15px;
	}
</style>
<%
	//获得页面参数	
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");

	//将空值转化成空字符串
	if(objectType == null) objectType = "";
	if(objectNo == null) objectNo = "";
	
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
	
	BusinessObject transaction = bom.loadBusinessObject("jbo.acct.ACCT_TRANSACTION","SerialNo",objectNo);
	
	objectType = transaction.getString("RelativeObjectType");
	objectNo = transaction.getString("RelativeObjectNo");
	
	
	String sTempletNo = "BatchPutOutInfo";//--模板号--
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType", objectType);
	inputParameter.setAttributeValue("ObjectNo", objectNo);
	inputParameter.setAttributeValue("SerialNo", objectNo);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	doTemp.setVisible("BAT", true);
	dwTemp.Style="2";
	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");

	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","All","Button","导入","导入","batchImport()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		as_save();
	}
	
	/*~[Describe=业务受理批量导入;]~*/
	function batchImport(){
		var pageURL = "/AppConfig/FileImport/FileSelector.jsp";
		var parameter = "clazz=jbo.import.excel.CREDIT_PUTOUT&UserID=<%=CurUser.getUserID()%>&OrgID=<%=CurOrg.getOrgID()%>&BatchSerialNo=<%=objectNo%>";
	    var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
	    
	    var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
	    
	    reload();
	}
	
	
	function reload()
	{
		AsControl.OpenPage("/CreditManage/CreditPutOut/BatchPutOutInfo.jsp","","_self")
	}
</script>


<script type="text/javascript">
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
