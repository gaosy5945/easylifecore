<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

	String sTempletNo = "ProjectAlterOthersNew";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","ȷ��","ȷ��","saveRecord()","","","",""},
		{"true","All","Button","ȡ��","ȡ��","top.close()","","","",""},
	};
	sButtonPosition = "south";
%>
<HEAD>
<title>�������</title>
</HEAD>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
	function saveRecord(){
		var ProjectName = getItemValue(0,getRow(),"PROJECTNAME");
		var RelativeType = getItemValue(0,getRow(),"RELATIVETYPE");
		var ProjectSerialNo = getItemValue(0,getRow(),"ProjectSerialNo");
		var CustomerID = getItemValue(0,getRow(),"CustomerID");
		var ObjectType = "jbo.prj.PRJ_BASIC_INFO";
		var UserID = "<%=CurUser.getUserID()%>";
		var OrgID = "<%=CurOrg.getOrgID()%>";
		var InputDate = "<%=com.amarsoft.app.base.util.DateHelper.getToday()%>";
		if(typeof(ProjectName) =="undefined" || ProjectName.length == 0){
			alert("��ѡ�񡾺�����Ŀ���ơ���");
			return;
		}
		if(typeof(RelativeType) == "undefined" || RelativeType.length == 0){
			alert("��ѡ����Ŀ������͡���");
			return;
		}
		
		AsCredit.openFunction("ProjectOthersAlterInfo","ProjectSerialNo="+ProjectSerialNo);
		//var result = ProjectManage.importOthersPrjRelative(ProjectSerialNo);
		//var sReturn = result.split("@");
		//if(sReturn[0] == "SUCCEED"){
		//	alert("��������ɹ���");
		//	top.returnValue = "true@"+sReturn[1]+"@"+sReturn[2]+"@"+CustomerID+"@"+sReturn[3]+"@"+RelativeType;
		//	top.close();
		//}else{
		//	alert("�������ʧ�ܣ�");
		//	return;
		//}
	}
	function selectPartnerProject(){
		var sParaString ="";	 
		setObjectValue("SelectPartnerProject",sParaString,"@ProjectSerialNo@0@ProjectType@1@CustomerID@2@ProjectName@3@PartnerName@4",0,0,"");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
