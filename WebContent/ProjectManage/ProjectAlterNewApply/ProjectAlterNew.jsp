<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

	String sTempletNo = "ProjectAlterNew";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","确定","确定","saveRecord()","","","",""},
		{"true","All","Button","取消","取消","top.close()","","","",""},
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
	function saveRecord(){
		if(!iV_all("0")) return ;
		var ProjectName = getItemValue(0,getRow(),"PROJECTNAME");
		var RelativeType = getItemValue(0,getRow(),"RELATIVETYPE");
		var ProjectSerialNo = getItemValue(0,getRow(),"ProjectSerialNo");
		var CustomerID = getItemValue(0,getRow(),"CustomerID");
		var ProjectType = getItemValue(0,getRow(),"PROJECTTYPE");
		var ObjectType = "jbo.prj.PRJ_BASIC_INFO";
		var UserID = "<%=CurUser.getUserID()%>";
		var OrgID = "<%=CurOrg.getOrgID()%>";
		var InputDate = "<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>";
		
		var result = ProjectManage.importPrjRelative(ProjectSerialNo,ObjectType,RelativeType,UserID,OrgID,InputDate);
		var sReturn = result.split("@");
		if(sReturn[1] == "true"){
			alert("新增变更成功！");
			var functionID = sReturn[2];
			var flowSerialNo = sReturn[3];
			var taskSerialNo = sReturn[4];
			var phaseNo = sReturn[5];

			top.returnValue = "true@"+taskSerialNo+"@"+flowSerialNo+"@"+phaseNo+"@"+functionID;
			top.close();
		}else{
			alert("新增变更失败！");
			return;
		}
	}
	function selectPartnerProject(){
		AsDialog.SetGridValue("SelectProjectList", "<%=CurUser.getUserID()%>", "ProjectSerialNo=SERIALNO@ProjectType=PROJECTTYPE@CustomerID=CUSTOMERID@ProjectName=PROJECTNAME@PartnerName=CUSTOMERNAME", "");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
