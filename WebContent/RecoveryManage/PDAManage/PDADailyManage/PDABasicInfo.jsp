<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%

	String sAssetSerialNo =  CurPage.getParameter("AssetSerialNo");
	if(sAssetSerialNo == null) sAssetSerialNo = "";
	String sApplyType =  CurPage.getParameter("ApplyType");
	if(sApplyType == null) sApplyType = "";
	//定义变量
	String sAssetTypeUrl ="";
	//获得组件参数(抵债资产流水号、抵债资产类型、对象类型)
	String sSerialNo = (String)CurComp.getParameter("SerialNo");
	String sAssetType = (String)CurComp.getParameter("AssetType");//资产类型，否则无法定位模板
	String sObjectType = (String)CurComp.getParameter("ObjectType");
	String sAssetStatus = (String)CurComp.getParameter("AssetStatus");
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sAssetType == null) sAssetType = "";	
	if(sObjectType == null) sObjectType = "";
	if(sAssetStatus == null ) sAssetStatus = "";	
	
	String sTempletNo = "DAAssetInfo";//--模板号--
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", sSerialNo);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();	
	
	dwTemp.Style = "2";//freeform
	if("01".equals(sApplyType)){
		dwTemp.ReadOnly = "-2";//只读模式
	} 
	dwTemp.genHTMLObjectWindow("");
	
	//dwTemp.replaceColumn("DADEBTASSETINFO", "<iframe type='iframe' name=\"frame_list_DADebtAssetInfo\" width=\"100%\" height=\"220\" frameborder=\"0\" src=\""+sWebRootPath+"/RecoveryManage/PDAManage/PDADailyManage/DADebtAssetInfo.jsp?AssetSerialNo="+sAssetSerialNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	//dwTemp.replaceColumn("DAASSETTYPEINFO", "<iframe type='iframe' name=\"frame_list_DAAssetTypeInfo\" width=\"100%\" height=\"400%\" frameborder=\"0\" src=\""+sWebRootPath+sAssetTypeUrl+"?AssetSerialNo="+sAssetSerialNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","","",""},
		//{"true","All","Button","返回","返回列表","returnList()","","","",""}
	};
	 //业务资料管理模块查看押品信息时隐藏 保存按钮
	if("01".equals(sApplyType)){
		sButtons[0][0] = "false";
	} 
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		as_save("myiframe0");
	}
	function returnList(){
		self.close();
	}
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode()
	{
		var sCity = getItemValue(0,getRow(),"CITY");
		sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sCity,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"AREA","");
			setItemValue(0,getRow(),"AREANAME","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
				sAreaCodeInfo = sAreaCodeInfo.split('@');
				sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
				sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
				setItemValue(0,getRow(),"AREA",sAreaCodeValue);
				setItemValue(0,getRow(),"AREANAME",sAreaCodeName);				
			}
		}
	}
	function selectUser(type)
	{	
		sParaString = "BelongOrg"+","+"<%=CurUser.getOrgID()%>";
		setObjectValue("SelectUserBelongOrg",sParaString,"@MANAGEUSERNAME@0@MANAGEUSERNAME@1@MANAGEORGID@2@MANAGEORGNAME@3",0,0,"");
	}
	
	function hideCertificate(){
		var sTransferStatus = getItemValue(0,getRow(),"TRANSFERSTATUS");
		if(sTransferStatus == "0310"){
			showItem(0,"CERTIFICATESERIALNO");
		} else {
			setItemValue(0,0,"CERTIFICATESERIALNO","");
			hideItem(0,"CERTIFICATESERIALNO");
		}
	}
	
	function initRow() {
		setItemValue(0,0,"MANAGEUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"MANAGEUSERNAME","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"MANAGEORGID","<%=CurOrg.getOrgID()%>");		
		setItemValue(0,0,"MANAGEORGNAME","<%=CurOrg.getOrgName()%>");	
		setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputOrgName","<%=CurUser.getOrgName()%>");
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	initRow();
	hideCertificate();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
