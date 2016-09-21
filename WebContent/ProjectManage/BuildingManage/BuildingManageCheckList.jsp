<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String buildingName = CurComp.getParameter("buildingName");
	if(buildingName == null) buildingName = "";
	String areaCode = CurComp.getParameter("areaCode");
	if(areaCode == null) areaCode = "";
	String locationC1 = CurComp.getParameter("locationC1");
	if(locationC1 == null) locationC1 = "";
	String inputOrgID = CurComp.getParameter("inputOrgID");
	if(inputOrgID == null) inputOrgID = "";
	String inputUserID = CurComp.getParameter("inputUserID");
	if(inputUserID == null) inputUserID = "";

	ASObjectModel doTemp = new ASObjectModel("BuildingManageCheckList");
	doTemp.setJboWhere("O.SerialNo in('"+serialNo.replaceAll("'", "''").replaceAll(",", "','")+"') ");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(serialNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","¥���½�","¥���½�","buildingNew()","","","","btn_icon_add",""},
			{"true","All","Button","¥������","¥������","viewBuilding()","","","","",""},
			{"true","","Button","ȡ���½�","ȡ���½�","self.close()","","","","",""},
		};
%>
<HEAD>
<title>����¥����Ϣ��ѯ</title>
</HEAD>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
	function buildingNew(){
		var result = ProjectManage.createBuilding("<%=buildingName%>", "<%=areaCode%>", "<%=locationC1%>", "<%=inputOrgID%>", "<%=inputUserID%>");
		result = result.split("@");
		if(result[0]=="true"){
			//ProjectManage.editBuilding(result[1]);
			alert("¥���½��ɹ���");
			AsControl.PopPage("/ProjectManage/BuildingManage/BuildingManageInfo.jsp", "SerialNo="+result[1], "");
			top.close();
		}else{
			alert("¥���½�ʧ�ܣ�");
			return;
		}
	}
	function viewBuilding(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0 ){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		AsControl.PopPage("/ProjectManage/BuildingManage/BuildingManageInfo.jsp", "SerialNo="+serialNo+"&RightType=ReadOnly", "resizable=yes;dialogWidth=900px;dialogHeight=460px;center:yes;status:no;statusbar:no");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
