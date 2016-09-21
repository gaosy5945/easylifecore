<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String projectNo = CurPage.getParameter("ProjectNo");

	String templetNo = "BuildingInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(templetNo);
	if(projectNo != null){
		doTemp.setBusinessProcess("com.amarsoft.app.als.customer.partner.handler.BuildingInfoHandler");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","All","Button","暂存","暂存","saveTempRecord()","","","",""},
		{"true","All","Button","楼盘下楼号信息","楼盘下楼号信息","BuildingNumDetail()","","","",""}
	};
	//sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	/*~~暂存*/
	function saveTempRecord(){
		setItemValue(0,0,"TempSaveFlag","1");
		as_saveTmp("myiframe0");
	}
	/*~保存*/
	function  saveRecord(){
		initCubagerate();
		setItemValue(0,0,"TempSaveFlag","0");
		as_save(0);
	}
	/**/
	function BuildingNumDetail(){
		popComp("","/CustomerManage/PartnerManage/BuildingDetailFrame.jsp","EstateNo=<%=serialNo%>","");
	}
	/*初始化容积率*/
	function initCubagerate(){
		var TotalBuildingArea = getItemValue(0,0,"TotalBuildingArea");
		var TotalGroundArea = getItemValue(0,0,"TotalGroundArea");
		if(TotalBuildingArea!="" && TotalGroundArea!=""){
			setItemValue(0,0,"Cubagerate",TotalBuildingArea/TotalGroundArea)
		}
	}
	
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode()
	{
		var areaCode = getItemValue(0,getRow(),"RegionCode");
		var	areaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+areaCode,"dialogWidth=650px;dialogHeight=500px;center:yes;status:no;statusbar:no","");
		//清空
		if(areaCodeInfo  == "NO" || areaCodeInfo  == '_CLEAR_'){
			setItemValue(0,getRow(),"REGION","");
			setItemValue(0,getRow(),"REGIONName","");
		}else{
			 if(typeof(areaCodeInfo ) != "undefined" && areaCodeInfo  != ""){
				 	areaCodeInfo  = areaCodeInfo .split('@');
					areaCodeValue = areaCodeInfo[0];//-- 行政区划代码
					areaCodeName = areaCodeInfo[1];//--行政区划名称
					setItemValue(0,getRow(),"REGION",areaCodeValue);
					setItemValue(0,getRow(),"REGIONName",areaCodeName);				
			}
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
