<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String authorizeType = CurPage.getParameter("AuthorizeType");
	if(authorizeType == null || authorizeType == "undefined") authorizeType = "01";
	String orgID = CurUser.getOrgID();
	ASObjectModel doTemp = new ASObjectModel("RuleSceneGroupList");
	if("01".equals(authorizeType)){
		doTemp.setJboWhere("STATUS='1' and AuthorizeType = '01' and InputOrgID = :InputOrgID");
	}else{
		doTemp.setJboWhere("STATUS='1' and AuthorizeType = '02' and InputOrgID = :InputOrgID");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("InputOrgID", orgID);
	dwTemp.genHTMLObjectWindow(orgID);
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","",""},
			{"true","","Button","详情","详情","edit()","","","","",""},
			{"true","All","Button","删除","删除","deleteSceneGroup()","","","","",""},
			{"true","All","Button","复制","复制","copySceneGroup()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 var authorizeType = "<%=authorizeType%>";
		 AsControl.PopView("/Common/Configurator/Authorization/RuleSceneGroupInfo.jsp","AuthorizeType="+authorizeType,"dialogWidth:400px;dialogHeight:320px;resizable:yes;scrollbars:no;status:no;help:no");
		 reloadSelf();
	}
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'SerialNo');
		 var authorizeType = "<%=authorizeType%>";
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("请选择一条记录！");
			return ;
		 }
		 AsControl.PopView("/Common/Configurator/Authorization/RuleSceneGroupInfo.jsp","SerialNo="+serialNo+"&authorizeType ="+authorizeType,"dialogWidth:400px;dialogHeight:320px;resizable:yes;scrollbars:no;status:no;help:no");
		 reloadSelf();
	}
	function deleteSceneGroup(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var sceneName = getItemValue(0, getRow(), "SceneName");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.flow.util.QueryRuleIsInuseForUser", "query", "SerialNo="+serialNo);
			if(returnValue.split("@")[0] == "true"){
				if(!confirm("删除该模板会影响 "+returnValue.split("@")[1]+" 位审批岗的系统内授权，确认删除？")) return;
			}else{
				if(!confirm("将同时删除其项下的授权模板,确认删除授权方案组【"+sceneName+"】吗?")) return;
			}
			as_delete('myiframe0');
			AsCredit.RunJavaMethodTrans("com.amarsoft.app.flow.util.RuleDelete","RuleDelete","SerialNo="+serialNo); 
		}
		reloadSelf();
	}
	/*复制模板*/
	function copySceneGroup(){
		var authorizeType = "<%=authorizeType%>";
		AsControl.PopView("/Common/Configurator/Authorization/SelectCanCopyRuleList.jsp","AuthorizeType="+authorizeType,"dialogWidth:800px;dialogHeight:620px;resizable:yes;scrollbars:no;status:no;help:no");
		reloadSelf();
	}
	/*记录被选中时触发事件*/
	function mySelectRow(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var authorizeType = "<%=authorizeType%>";
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			return;
		}else{
			AsControl.OpenView("/Common/Configurator/Authorization/RuleSceneInfo.jsp","AuthSerialNo="+serialNo+"&AuthorizeType="+authorizeType,"rightdown","");
		}
	}
	mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
