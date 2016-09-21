<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("RuleSceneGroupList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增模板","新增","add()","","","","",""},
			{"true","","Button","编辑模板","详情","edit()","","","","",""},
			{"true","","Button","删除模板","删除","delete()","","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 AsControl.OpenView("/Common/Configurator/Authorization/RuleSceneGroupInfo.jsp","","dialogWidth:400px;dialogHeight:320px;resizable:yes;scrollbars:no;status:no;help:no");
		 reloadSelf();
	}
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("请选择一条记录！");
			return ;
		 }
		 AsControl.PopView("/Common/Configurator/Authorization/RuleSceneGroupInfo.jsp","SerialNo="+serialNo,"dialogWidth:400px;dialogHeight:320px;resizable:yes;scrollbars:no;status:no;help:no");
		 reloadSelf();
	}
	function deleteSceneGroup(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var sceneName = getItemValue(0, getRow(), "SceneName");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			if(!confirm("将同时删除其项下的授权模板,确认删除授权方案组【"+sceneName+"】吗?")) return;
			as_delete('myiframe0');
			var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.flow.util.RuleDelete","RuleDelete","SerialNo="+serialNo); 
		}
		reloadSelf();
	}
	/*记录被选中时触发事件*/
	function mySelectRow(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			return;
		}else{
			AsControl.OpenView("/Common/Configurator/Authorization/RuleSceneList.jsp","AuthSerialNo="+serialNo,"rightdown","");
		}
	}
	mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
