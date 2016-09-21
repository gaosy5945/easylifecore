<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String teamID = CurPage.getParameter("TeamID");
	if(teamID == null || teamID == "undefined") teamID = "";
	String teamType = CurPage.getParameter("TeamType");
	if(teamType == null || teamType == "undefined") teamType = "";
	ASObjectModel doTemp = new ASObjectModel("FlowTeamList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	//dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("TeamID", teamID);
	dwTemp.setParameter("OrgID", CurOrg.getOrgID());
	dwTemp.setParameter("TeamType", teamType);
	dwTemp.genHTMLObjectWindow("");
	String flag = teamType.equals("01") ? "false" : "true";
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增团队","新增","add()","","","",""},
			{"true","All","Button","团队详情","详情","view()","","","",""},
			{"true","","Button","删除团队","删除","deleteTeam()","","","","",""},
			{flag,"","Button","业务授权","授权","addRule()","","","","",""},
		};
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		AsControl.PopView("/Common/Configurator/FlowManage/FlowTeamInfo.jsp","","dialogWidth:500px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no","");
		reloadSelf();
	}
	function view(){
		var teamID = getItemValue(0,getRow(),"TeamID");
		var orgID = getItemValue(0,getRow(),"OrgID");
		AsControl.PopView("/Common/Configurator/FlowManage/FlowTeamInfo.jsp","TeamID="+teamID+"&OrgID="+orgID,"dialogWidth:500px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no","");
		reloadSelf();
	}
	function deleteTeam(){
		var teamID = getItemValue(0,getRow(),"TeamID");
		var teamName = getItemValue(0,getRow(),"TeamName");
		if(typeof(teamID)=="undefined" || teamID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			if(!confirm("确认删除团队【"+teamName+"】吗?")) return;
			as_delete('myiframe0');
			var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.flow.util.RuleDelete","TeamDelete","TeamID="+teamID); 
		}
		reloadSelf();
	}
	function addRule(){
		var teamID = getItemValue(0,getRow(),"TeamID");
		var orgID = getItemValue(0,getRow(),"OrgID");
		AsControl.PopView("/Common/Configurator/Authorization/TeamRuleList.jsp","TeamID="+teamID+"&OrgID="+orgID,"dialogWidth:750px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no","");
	}
	/*记录被选中时触发事件*/
	function mySelectRow(){
		var teamID = getItemValue(0,getRow(),"TeamID");
		var orgID = getItemValue(0,getRow(),"OrgID");
		if(typeof(teamID)=="undefined" || teamID.length==0) {
			return;
		}else{
			AsControl.OpenView("/Common/Configurator/FlowManage/TeamUserList.jsp","TeamID="+teamID+"&OrgID="+orgID,"rightdown","");
		}
	}
	mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
