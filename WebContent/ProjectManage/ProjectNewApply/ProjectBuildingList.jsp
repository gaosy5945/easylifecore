<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String ProjectSerialNo = CurPage.getParameter("SerialNo");
	if(ProjectSerialNo == null) ProjectSerialNo = "";
	String ReadFlag = CurPage.getParameter("ReadFlag");
	if(ReadFlag == null) ReadFlag = "";
	String ProjectType = CurPage.getParameter("ProjectType");
	if(ProjectType == null) ProjectType = "";
	String CustomerID = CurPage.getParameter("CustomerID");
	if(CustomerID == null) CustomerID = "";
	
	BusinessObject inputParameter =BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ProjectSerialNo", ProjectSerialNo);
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("BuildingList",inputParameter,CurPage);
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	
	dwTemp.setParameter("ProjectSerialNo", ProjectSerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","删除","删除","del()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
	function add(){	
		var ProjectSerialNo = "<%=ProjectSerialNo%>";
		var buildingSerialNo = getSerialNo("BUILDING_INFO","SerialNo","");
		AsControl.OpenView("/ProjectManage/ProjectNewApply/ProjectBuildingInfo.jsp","SerialNo=&ProjectSerialNo="+ProjectSerialNo+"&BuildingSerialNo="+buildingSerialNo+"&ProjectType=<%=ProjectType%>"+"&CustomerID=<%=CustomerID%>"+"&ReadFlag="+"<%=ReadFlag%>","_self");
		//reloadSelf();
	}
	
	function edit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var ProjectSerialNo = "<%=ProjectSerialNo%>";
		var buildingSerialNo = getItemValue(0,getRow(),"BISerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
		    return;
		}
		AsControl.OpenView("/ProjectManage/ProjectNewApply/ProjectBuildingInfo.jsp","SerialNo="+serialNo+"&BuildingSerialNo="+buildingSerialNo+"&ProjectSerialNo="+ProjectSerialNo+"&ReadFlag="+"<%=ReadFlag%>","_self");
		//reloadSelf();
	}
	function del(){
		var BuildingSerialNo = getItemValue(0,getRow(0),"BISerialNo");
		if (typeof(BuildingSerialNo) == "undefined" || BuildingSerialNo.length == 0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
		    return;
		}
		if(confirm('确实要删除该楼盘吗?')){
			var sReturn = ProjectManage.deleteProjectBuilding(BuildingSerialNo);
			if(sReturn == "SUCCEED"){
				alert("删除成功！");
			}
			reloadSelf();
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
