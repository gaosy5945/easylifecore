<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

<%
	String SerialNo = CurPage.getParameter("SerialNo");
	if(SerialNo == null) SerialNo = "";
	String ProjectSerialNo = CurPage.getParameter("ProjectSerialNo");
	if(ProjectSerialNo == null) ProjectSerialNo = "";
	String AccountNo = CurPage.getParameter("AccountNo");
	if(AccountNo == null) AccountNo = "";
	String ProjectType = CurPage.getParameter("ProjectType");
	if(ProjectType == null) ProjectType = "";
	String CustomerID = CurPage.getParameter("CustomerID");
	if(CustomerID == null) CustomerID = "";

	String sTempletNo = "ProjectMarginDetailInfo1";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	if(!"0107".equals(ProjectType)){
		doTemp.setVisible("CustomerName", false);
		doTemp.setDefaultValue("ObjectNo", CustomerID);
		doTemp.setRequired("CustomerName", false);
	}
	dwTemp.setParameter("SerialNo", SerialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{"true","All","Button","返回","返回列表","returnBack()","","","",""}
	};
%>
<HEAD>
<title>缴纳详情</title>
</HEAD>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">


	function selectAccountNo(){
		AsDialog.SetGridValue("SelectAccountNo", "<%=CurUser.getUserID()%>", "RELATIVECUSTOMERNAME=CUSTOMERNAME@CertType=CERTTYPE@CertID=CERTID@@IssueCountry=ISSUECOUNTRY", "");
	}
	function initRow(){
		var SerialNo = getItemValue(0,getRow(0),"SerialNo");
		var projectType = "<%=ProjectType%>";
		if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
			setItemValue(0,0,"AccountNo","<%=AccountNo%>");
		}
		if(projectType == "0107"){//共赢联盟
			setItemValue(0,0,"OBJECTTYPE","jbo.customer.CUSTOMER_INFO");
		}
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
