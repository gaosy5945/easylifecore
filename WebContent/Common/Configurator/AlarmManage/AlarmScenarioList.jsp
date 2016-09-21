<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*
		Content: 预警场景列表
	 */
 
 	ASObjectModel doTemp = new ASObjectModel("AlarmScenarioList");
 	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()","","","",""},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()","","","",""},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()","","","",""},
		{"true","","Button","场景参数配置","查看/修改场景预处理参数","viewAndEditArg()","","","",""},
		{"true","","Button","模型分组配置","查看/修改场景下模型分组","viewAndEditGroup()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.PopComp("/Common/Configurator/AlarmManage/AlarmScenarioInfo.jsp","","dialogWidth=600px;dialogHeight=500px;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");//OpenStyle
		reloadSelf();
	}
	
	function viewAndEdit(){
		var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
       	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
	    }
       	AsControl.PopComp("/Common/Configurator/AlarmManage/AlarmScenarioInfo.jsp","ScenarioID="+sScenarioID,"dialogWidth=600px;dialogHeight=500px;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		reloadSelf();
	}
    
    /*~[Describe=查看及修改预警参数;InputParam=无;OutPutParam=无;]~*/
	function viewAndEditArg(){
      	var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
      	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
          	return ;
		}
      	AsControl.PopComp("/Common/Configurator/AlarmManage/AlarmScenarioArgsList.jsp","ScenarioID="+sScenarioID,"",OpenStyle);
	}

    /*~[Describe=查看及修改模型分组配置;InputParam=无;OutPutParam=无;]~*/
	function viewAndEditGroup(){
		var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
		if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
          	return ;
		}
		AsControl.PopComp("/Common/Configurator/AlarmManage/AlarmGroupFrame.jsp","ScenarioID="+sScenarioID,"",OpenStyle);
    }

	function deleteRecord(){
		var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
      	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
          	return ;
		}
		if(confirm(getHtmlMessage('45'))){
			as_delete("myiframe0");
		}
	}

	function mySelectRow(){
		var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
      	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			return;
		}
      	AsControl.OpenView("/Common/Configurator/AlarmManage/AlarmModelList.jsp","ScenarioID="+sScenarioID,"rightdown");
      	/* parent.OpenModelList(sScenarioID); */
	}
	/* mySelectRow(); */
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>