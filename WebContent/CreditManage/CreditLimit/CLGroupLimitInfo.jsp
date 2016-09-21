<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String SerialNo = CurPage.getParameter("SerialNo");
	if(SerialNo == null || SerialNo == "undefined") SerialNo = "";
	
	String sTempletNo = "CLGroupLimitInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setJboWhere("O.SerialNo=:SerialNo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("SerialNo", SerialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","save()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function save(){
		if(!iV_all("myiframe0")) return;
		initRow();
		var sSerialNo = getItemValue(0,getRow(0),"SerialNo");
		var sOrgID = getItemValue(0,getRow(0),"OrgID");
		var LIMITAMOUNT = getItemValue(0,getRow(0),"LIMITAMOUNT");
		var PARAMETERID1 = getItemValue(0,getRow(0),"PARAMETERID1");
		var returnValue = AsControl.RunASMethod("BusinessManage","CLGroupLimitCheck",sSerialNo+","+sOrgID+","+LIMITAMOUNT+","+PARAMETERID1);
		if(returnValue!="true"){
			alert(returnValue);
		}
		as_save("myiframe0","self.close()");
	}
	function SelectAllOrg(){
		//AsCredit.setMultipleTreeValue("SelectAllOrg", "", "","","0",getRow(0),"OrgID","OrgName");
		AsCredit.setTreeValue("SelectLevelDownOrg", "CurOrgID,<%=CurUser.getOrgID()%>", "","0",getRow(0),"OrgID","OrgName","FolderSelectFlag=Y");
	}
	function SelectBusinessType(){
		AsCredit.setMultipleTreeValue("SelectAllBusinessType", "", "", "","0",getRow(0),"PARAMETERID1","PARAMETERVALUE1");
	}
	function initRow(){
		setItemValue(0,getRow(0),"STATUS","1");
		setItemValue(0,getRow(0),"INPUTUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(0),"INPUTORGID","<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(0),"INPUTDATE","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
