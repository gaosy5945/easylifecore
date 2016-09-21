<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sTempletNo = "ProjectNewZeroStarInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	doTemp.setDefaultValue("ProjectType", "0110");
	doTemp.setDefaultValue("EFFECTDATE", DateHelper.getBusinessDate());
	doTemp.setDefaultValue("EXPIRYDATE", "2999/12/31");
	doTemp.setDefaultValue("PARTICIPATEORG", CurUser.getOrgID());
	doTemp.setReadOnly("ProjectType", true);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","All","Button","返回","返回","top.close()","","","",""},
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<HEAD>
<title>新建零星期房项目</title>
</HEAD>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
function selectCustomer(){
	var InputUserID = "<%=CurUser.getUserID()%>";
	AsDialog.SetGridValue("SelectPartnerCustomer", InputUserID, "CustomerID=CustomerID@CustomerName=CustomerName@CertType=CertType@CertID=CertID@ListType=ListType", "");

}
function saveRecord(){
	as_save("myiframe0","OpenView()");	
}
function OpenView(){
	var serialNo =  getItemValue(0,getRow(0),"SERIALNO");
	var customerID =  getItemValue(0,getRow(0),"CUSTOMERID");
	ProjectManage.updateAgreementNo(serialNo);
    AsCredit.openFunction("ProjectInfoTab", "SerialNo="+serialNo+"&ReadFlag="+"ReadOnly"+"&CustomerID="+customerID);
    top.close();
}
function edit(){
	var SerialNo = getItemValue(0,getRow(0),"SerialNo");
	var ProjectType = getItemValue(0,getRow(0),"ProjectType");
    AsCredit.openFunction("ProjectInfoTab", "SerialNo="+SerialNo+"&ProjectType="+ProjectType);
    top.close();
}


</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
