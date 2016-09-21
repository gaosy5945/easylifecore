<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	//获得参数	
	String sScenarioID =  CurPage.getParameter("ScenarioID");
	if (sScenarioID == null) sScenarioID = "";
    
	ASObjectModel doTemp = new ASObjectModel("AlarmGroupList");
	doTemp.setDefaultValue("ScenarioID", sScenarioID);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.genHTMLObjectWindow(sScenarioID);
    
	String sButtons[][] = {
		{"true", "All","Button","新增分组","当前页面新增","afterAdd()","","","","btn_icon_add"},
		{"true", "All","Button","保存","快速保存当前页面","saveRecord()","","","","btn_icon_save"},
		{"true","All","Button","删除","删除所选中的记录","deleteRecord()","","","","btn_icon_delete"},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function afterAdd(){
		as_add("myiframe0");
		AsControl.OpenPage("/AppMain/Blank.jsp", "TextToShow=请保存列表记录", "rightdown");
		//快速新增时候给定默认值
		setItemValue(0,getRow(),"ScenarioID","<%=sScenarioID%>");
	}
	
	function saveRecord(){
		as_save("myiframe0");
	}

	function deleteRecord(){
		var sScenarioID = "<%=sScenarioID%>";
		var sGroupID = getItemValue(0,getRow(),"GroupID");
        if(typeof(sGroupID)=="undefined" || sGroupID.length==0) {
			alert("删除记录的分组号不能为空！");
        	return ;
		}
		
        if(confirm(getHtmlMessage('45'))){
        	var sReturnMessage = RunJavaMethodTrans("com.amarsoft.app.alarm.action.AlarmConfigAction","delGroupItems","ScenarioID="+sScenarioID+",GroupID="+sGroupID);
    		if(sReturnMessage == "FAILED"){
    			alert("删除分组下检查项失败！");
    			return;
    		}else{
				as_delete("myiframe0");
    		}
		}
	}
	
	function mySelectRow(){
		var sScenarioID = "<%=sScenarioID%>";
		var sGroupID = getItemValue(0,getRow(),"GroupID");
		var sSortNo = getItemValue(0,getRow(),"SortNo");
		var sGroupName = getItemValue(0,getRow(),"GroupName");
        if(sGroupID && sSortNo && sGroupName){
			AsControl.OpenComp("/Common/Configurator/AlarmManage/AlarmGroupConfig.jsp", "ScenarioID="+sScenarioID+"&GroupID="+sGroupID, "rightdown");
		}
	}

    setDialogTitle("模型分组配置");
    mySelectRow();
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>