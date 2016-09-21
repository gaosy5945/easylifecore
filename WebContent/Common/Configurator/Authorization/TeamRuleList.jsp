<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	String teamID = CurPage.getParameter("TeamID");
	if(teamID == null || teamID == "undefined") teamID = "";
	String orgID = CurPage.getParameter("OrgID");
	if(orgID == null || orgID == "undefined") orgID = "";
	ASObjectModel doTemp = new ASObjectModel("TeamRuleList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setParameter("TeamID", teamID);
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","",""},
			{"true","","Button","授权方案详情","详情","edit()","","","","",""},
			{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var returnValue =AsDialog.SelectGridValue("RuleSelect1", "<%=CurUser.getOrgID()%>", "SerialNo@SceneName","", true);
		if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
		var serialNo = "";
		var inputOrgID = "<%=CurUser.getOrgID()%>";
		var inputUserID = "<%=CurUser.getUserID()%>";
		returnValue = returnValue.split("~");
		for(var i in returnValue){
			if(typeof returnValue[i] ==  "string" && returnValue[i].length > 0 ){
				var parameter = returnValue[i].split("@");
				serialNo = parameter[0];
				AsCredit.RunJavaMethodTrans("com.amarsoft.app.flow.util.RuleUpload","addTeam",
				"SerialNo="+serialNo+",InputOrgID="+inputOrgID+",InputUserID="+inputUserID+",TeamID=<%=teamID%>"); 
			}
		}
		reloadSelf();
	}
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		AsControl.PopView('/Common/Configurator/Authorization/RuleInfo.jsp','SerialNo='+serialNo+"&AuthorizeType=02" ,'dialogWidth:750px;dialogHeight:500px;resizable:yes;scrollbars:no;status:no;help:no','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
