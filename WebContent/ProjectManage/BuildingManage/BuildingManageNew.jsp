<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%

	String sTempletNo = "BuildingManageNew";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","ȷ��","ȷ��","saveRecord()","","","",""},
		{"true","All","Button","ȡ��","ȡ��","self.close()","","","",""},
	};
	sButtonPosition = "south";
%>
<HEAD>
<title>����¥��</title>
</HEAD>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
	function saveRecord(){		
		if(!iV_all("0")) return ;
		var buildingName = getItemValue(0,getRow(),"BUILDINGNAME");
		var areaCode = getItemValue(0,getRow(),"AREACODE");
		var locationC1 = getItemValue(0,getRow(),"LOCATIONC1");
		var inputOrgID = getItemValue(0,getRow(),"INPUTORGID");
		var inputUserID = getItemValue(0,getRow(),"INPUTUSERID");

		var result = ProjectManage.checkBuildingInfo(buildingName,areaCode,locationC1);
		top.returnValue = result+"@"+inputOrgID+"@"+inputUserID;
 		top.close();
	}
	function closeWindow(){
		var result = "false";
		top.returnValue = result;
 		top.close();
	}
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode()
	{
		var sCity = getItemValue(0,getRow(),"AREACODE");
		sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sCity,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"AREACODE","");
			setItemValue(0,getRow(),"AREACODEName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"AREACODE",sAreaCodeValue);
					setItemValue(0,getRow(),"AREACODEName",sAreaCodeName);				
			}
		}
	}	
	function initRow(){
		setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
