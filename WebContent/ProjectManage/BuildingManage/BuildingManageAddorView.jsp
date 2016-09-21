<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	
    ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("BuildingsManageList",BusinessObject.createBusinessObject(),CurPage);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("InputUserID", CurUser.getUserID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增楼盘","新增楼盘","newBuilding()","","","","btn_icon_add",""},
			{"true","","Button","楼盘详情","楼盘详情","viewBuilding()","","","","btn_icon_detail",""},
			{"true","All","Button","确定","确定","OK()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<HEAD>
<title>查询楼盘信息</title>
</HEAD>
<script type="text/javascript">
	function newBuilding(){
		var result = AsControl.PopPage("/ProjectManage/BuildingManage/BuildingManageNew.jsp","DialogTitle=新建楼盘","resizable=yes;dialogWidth=500px;dialogHeight=180px;center:yes;status:no;statusbar:no");
		if(typeof(result) == "undefined" || result.length == 0){
			return;
		}
		result = result.split("@");
		var k=result.length;
		var j=result.length;
		if(result[0] == "true"){
			var serialNos = "";
			for(var i=1; i<result.length-5;i++){
				serialNos +=result[i]+",";
			}
			var buildingName = result[k-5];
			var areaCode = result[k-4];
			var locationC1 = result[k-3];
			var inputOrgID = result[k-2];	
			var inputUserID = result[k-1];
			AsControl.PopPage("/ProjectManage/BuildingManage/BuildingManageCheckList.jsp","SerialNo="+serialNos+"&buildingName="+buildingName+"&areaCode="+areaCode+"&locationC1="+locationC1+"&inputUserID="+inputUserID+"&inputOrgID="+inputOrgID,"resizable=yes;dialogWidth=650px;dialogHeight=500px;center:yes;status:no;statusbar:no");
			reloadSelf();
		}else if(result[0] == "listResultNull"){
			var buildingName = result[j-5];
			var areaCode = result[j-4];
			var locationC1 = result[j-3];
			var inputOrgID = result[j-2];
			var inputUserID = result[j-1];
			if(confirm("无疑似楼盘，是否继续新增楼盘？")){
				var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.CreateBuilding", "createBuilding", "buildingName="+buildingName+",areaCode="+areaCode+",locationC1="+locationC1+",inputOrgID="+inputOrgID+",inputUserID="+inputUserID);
				result = result.split("@");
				if(result[0]=="true"){
					alert("楼盘新建成功！");
					AsControl.PopPage("/ProjectManage/BuildingManage/BuildingManageInfo.jsp", "SerialNo="+result[1], "");
				}else{
					alert("楼盘新建失败！");
					return;
				}
			}
			reloadSelf();
		}else if(result[0] == "false"){
			alert("该楼盘已存在");
			return;
		}else{
			reloadSelf();
		}
	}
	
	function viewBuilding(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		AsControl.PopPage("/ProjectManage/BuildingManage/BuildingManageInfo.jsp", "SerialNo="+serialNo, "");
		reloadSelf();
	}

	function OK(){
		var REALESTATEID = getItemValue(0,getRow(),"SERIALNO");//楼盘编号
		var BUILDINGNAME = getItemValue(0,getRow(),"BUILDINGNAME");//楼盘名称
		top.returnValue = REALESTATEID+"@"+BUILDINGNAME;
 		top.close();

	}


</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
