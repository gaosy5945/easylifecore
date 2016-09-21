<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";	
	String projectType = CurPage.getParameter("ProjectType");
	if(projectType == null) projectType = "";
	String agreementNo = CurPage.getParameter("AgreementNo");
	if(agreementNo == null) agreementNo = "";
	String isNew = CurPage.getParameter("IsNew");
	if(isNew == null) isNew = "";
	String sTempletNo = "ProjectAlterInfo";
	String sTempletFilter = "1=1"; 
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDefaultValue("ProjectType", projectType);
	doTemp.setDDDWJbo("ProjectType","jbo.sys.CODE_LIBRARY,itemNo,ItemName,codeno = 'ProjectType'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存","asSave()","","","",""},
		{"true","All","Button","返回","返回","goBack()","","","",""}, 	
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<%@page import="com.amarsoft.app.als.customer.model.CustomerConst"%>

<script type="text/javascript">
	function goBack(){ 
		self.close();
	}
	function asSave(){
		if(!iV_all("myiframe0"))return;
		beforeSave();
		as_save("myiframe0",""); 
	}
	
	function beforeSave(){
		var serialNo = getItemValue(0,0,"SERIALNO");
		if(typeof(serialNo) == 'undefined' || serialNo.length == 0)
		{
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			return;
		}else{
			setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			return;
		}
	}
	
	function selectOrgMuti(){
		AsCredit.setMultipleTreeValue('SelectBelongOrg', "OrgID,<%=CurUser.getOrgID()%>", "", "", "myiframe0", getRow(), "PARTICIPATEORG", "OrgName");
	}
	function ChooseOrgs(){
		var ParticipateIndicator = getItemValue(0,0,"ParticipateIndicator");
		if(ParticipateIndicator == '01'){
			hideItem("myiframe0","OrgName");
		}else if (ParticipateIndicator == '02'){
			showItem("myiframe0","OrgName");
		}
	}
	var projectType = getItemValue(0,getRow(),"ProjectType");
	var sObjectType = "jbo.prj.PRJ_BASIC_INFO";
	//AsControl.OpenPage("/ProjectManage/ProjectAssetTransfer/ProjectAssetAcctFeeList.jsp","ObjectNo="+'<%=serialNo%>'+"&ObjectType="+sObjectType,"frame_list"); 
	
	function initRow(){
		var projectNo = '<%=serialNo%>';
		/* var sJavaClass = "com.amarsoft.app.als.assetTransfer.action.CalcuAssetTransOutSumAction";
		var sJavaMethod = "calcuAssetTransOutSumAction";
		var sParams = "projectNo="+projectNo;
		var assetTransOutSum = RunJavaMethodTrans(sJavaClass,sJavaMethod,sParams);
		setItemValue(0,0,"assetTransOutSum",assetTransOutSum); */
		setItemValue(0,0,"SerialNo","<%=serialNo%>");
		if('<%=isNew%>' == ""){
		}else{
			setItemValue(0,0,"AGREEMENTNO",'<%=agreementNo%>');
			setItemValue(0,0,"CreateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ORIGINATEORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"ORIGINATEORG","<%=CurOrg.getOrgName()%>");
		}
		ChooseOrgs();
		var ORIGINATEORGID = getItemValue(0, getRow(0), "ORIGINATEORGID");
		if(ORIGINATEORGID == '9900'){
			setItemValue(0,getRow(),"ISTOONELEVEL",'1');
			setItemDisabled(0, getRow(), "ISTOONELEVEL", true);
		}
	}
	
	initRow();
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
