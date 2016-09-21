<%@page import="com.amarsoft.app.als.common.util.StringHelper"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String customerID = CurPage.getParameter("customerID");
	String partnerType = CurPage.getParameter("partnerType");
	
	String sTempletNo = "NewProjectInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//根据合作方类型来决定可以合作的项目类型
	BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.CODE_LIBRARY");
	String whereIn = bm.createQuery("codeno='PartnerType' and itemno='"+partnerType+"'").getSingleResult(false).getAttribute("itemDescribe").getString();
	doTemp.setDDDWJbo("ProjectType", "jbo.sys.CODE_LIBRARY,itemno,ItemName,Isinuse='1' and CodeNo='CPProjectType' and ItemNo in ("+StringHelper.getSqlFormatOfIn(whereIn, ",")+")");
	
	//doTemp.setColTips("", "测试");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","确定","确定","saveAndReturn()","","","",""},
		{"true","All","Button","取消","取消","returnList()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveAndReturn(){
		
		as_save(0,'afterSave()');
	}
	function afterSave(){
		top.returnValue = getItemValue(0,0,"SerialNo");
		top.close();
	}
	function returnList(){
		top.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
