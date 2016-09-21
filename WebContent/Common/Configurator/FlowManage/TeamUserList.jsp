<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.flow.util.TeamUserUpload"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String teamID = CurPage.getParameter("TeamID");
	String userID = CurPage.getParameter("UserID");
	String orgID = CurPage.getParameter("OrgID");
	if(orgID == null || orgID == "undefined") orgID = "";
	if(teamID == null || teamID == "undefined") teamID = "";
	if(userID == null || userID == "undefined") userID = "";

	ASObjectModel doTemp = new ASObjectModel("TeamUserList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.MultiSelect = true; //允许多选
	dwTemp.setPageSize(10);
	dwTemp.setParameter("UserID", userID);
	dwTemp.setParameter("TeamID", teamID);
	dwTemp.setParameter("OrgID", orgID);
	dwTemp.genHTMLObjectWindow("");
	
	TeamUserUpload myTeamUserUpload = new TeamUserUpload();
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增团队成员","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","团队成员详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","","Button","删除团队成员","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var returnValue =AsDialog.SelectGridValue("SelectUser", "<%=orgID%>,<%=teamID%>", "UserID", "", true);
		if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
		returnValue = returnValue.split("~");
		for(var i in returnValue){
			if(typeof returnValue[i] ==  "string" && returnValue[i].length > 0 ){
				var parameter = returnValue[i].split("@");
				AsCredit.RunJavaMethodTrans("com.amarsoft.app.flow.util.TeamUserUpload","addUser",
						"UserID="+parameter+",TeamID=<%=teamID%>,InputUserID=<%=CurUser.getUserID()%>,InputOrgID=<%=CurUser.getOrgID()%>");
			}
		}
		reloadSelf();
	}
	function edit(){
		 var sUrl = "/Common/Configurator/FlowManage/TeamUserInfo.jsp";
		 var teamID = getItemValue(0,getRow(0),'TeamID');
		 var userID = getItemValue(0,getRow(0),'UserID');
		 if(typeof(teamID)=="undefined" || teamID.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		AsControl.PopView(sUrl,'UserID='+userID+'&TeamID='+teamID,'dialogWidth:400px;dialogHeight:300px;','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
