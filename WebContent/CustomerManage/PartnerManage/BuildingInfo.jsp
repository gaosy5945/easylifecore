<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String projectNo = CurPage.getParameter("ProjectNo");

	String templetNo = "BuildingInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(templetNo);
	if(projectNo != null){
		doTemp.setBusinessProcess("com.amarsoft.app.als.customer.partner.handler.BuildingInfoHandler");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","All","Button","�ݴ�","�ݴ�","saveTempRecord()","","","",""},
		{"true","All","Button","¥����¥����Ϣ","¥����¥����Ϣ","BuildingNumDetail()","","","",""}
	};
	//sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	/*~~�ݴ�*/
	function saveTempRecord(){
		setItemValue(0,0,"TempSaveFlag","1");
		as_saveTmp("myiframe0");
	}
	/*~����*/
	function  saveRecord(){
		initCubagerate();
		setItemValue(0,0,"TempSaveFlag","0");
		as_save(0);
	}
	/**/
	function BuildingNumDetail(){
		popComp("","/CustomerManage/PartnerManage/BuildingDetailFrame.jsp","EstateNo=<%=serialNo%>","");
	}
	/*��ʼ���ݻ���*/
	function initCubagerate(){
		var TotalBuildingArea = getItemValue(0,0,"TotalBuildingArea");
		var TotalGroundArea = getItemValue(0,0,"TotalGroundArea");
		if(TotalBuildingArea!="" && TotalGroundArea!=""){
			setItemValue(0,0,"Cubagerate",TotalBuildingArea/TotalGroundArea)
		}
	}
	
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode()
	{
		var areaCode = getItemValue(0,getRow(),"RegionCode");
		var	areaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+areaCode,"dialogWidth=650px;dialogHeight=500px;center:yes;status:no;statusbar:no","");
		//���
		if(areaCodeInfo  == "NO" || areaCodeInfo  == '_CLEAR_'){
			setItemValue(0,getRow(),"REGION","");
			setItemValue(0,getRow(),"REGIONName","");
		}else{
			 if(typeof(areaCodeInfo ) != "undefined" && areaCodeInfo  != ""){
				 	areaCodeInfo  = areaCodeInfo .split('@');
					areaCodeValue = areaCodeInfo[0];//-- ������������
					areaCodeName = areaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"REGION",areaCodeValue);
					setItemValue(0,getRow(),"REGIONName",areaCodeName);				
			}
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
