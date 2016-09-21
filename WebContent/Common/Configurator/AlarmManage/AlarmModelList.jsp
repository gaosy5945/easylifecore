<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*
		Content: 预警模型列表
	 */
 	sASWizardHtml = "<div><font size=\"2pt\" color=\"#930055\">预警模型列表</font></div>";
    //获得页面参数	
	String sScenarioID =  CurPage.getParameter("ScenarioID");
	if (sScenarioID == null) sScenarioID = "";

	ASObjectModel doTemp = new ASObjectModel("AlarmModelList");
	doTemp.appendHTMLStyle("","style=\"cursor: pointer;\" ondblclick=\"javascript:viewAndEdit()\"");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(200);
    dwTemp.genHTMLObjectWindow(sScenarioID);

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()","","","",""},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()","","","",""},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
		popComp("AlarmModelInfo","/Common/Configurator/AlarmManage/AlarmModelInfo.jsp","ScenarioID=<%=sScenarioID%>","");
		reloadSelf();
	}
	
	function viewAndEdit(){
		var sModelID = getItemValue(0,getRow(),"ModelID");
       	if(typeof(sModelID)=="undefined" || sModelID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
        	return ;
		}
       	popComp("AlarmModelInfo","/Common/Configurator/AlarmManage/AlarmModelInfo.jsp","ScenarioID=<%=sScenarioID%>&ModelID="+sModelID,"");
		reloadSelf();
	}

	function deleteRecord(){
		var sModelID = getItemValue(0,getRow(),"ModelID");
		if(typeof(sModelID)=="undefined" || sModelID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
        	return ;
		}
		if(confirm(getHtmlMessage('45'))){
			as_delete("myiframe0");
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>