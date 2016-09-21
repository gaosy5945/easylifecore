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
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(serialNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","楼盘新建","楼盘新建","buildingNew()","","","","btn_icon_add",""},
			{"true","All","Button","楼盘详情","楼盘详情","viewBuilding()","","","","",""},
			{"true","","Button","取消新建","取消新建","self.close()","","","","",""},
		};
%>
<HEAD>
<title>疑似楼盘信息查询</title>
</HEAD>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
	function buildingNew(){
		var result = ProjectManage.createBuilding("<%=buildingName%>", "<%=areaCode%>", "<%=locationC1%>", "<%=inputOrgID%>", "<%=inputUserID%>");
		result = result.split("@");
		if(result[0]=="true"){
			//ProjectManage.editBuilding(result[1]);
			alert("楼盘新建成功！");
			AsControl.PopPage("/ProjectManage/BuildingManage/BuildingManageInfo.jsp", "SerialNo="+result[1], "");
			top.close();
		}else{
			alert("楼盘新建失败！");
			return;
		}
	}
	function viewBuilding(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0 ){
			alert("请选择一条信息！");
			return;
		}
		AsControl.PopPage("/ProjectManage/BuildingManage/BuildingManageInfo.jsp", "SerialNo="+serialNo+"&RightType=ReadOnly", "resizable=yes;dialogWidth=900px;dialogHeight=460px;center:yes;status:no;statusbar:no");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
