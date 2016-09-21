<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*
		Content: 预警参数列表
		Input Param:
                  ScenarioID：	场景ID
	 */
    //获得页面参数	
	String sScenarioID =  CurPage.getParameter("ScenarioID");
	if (sScenarioID == null) sScenarioID = "";

	ASObjectModel doTemp = new ASObjectModel("AlarmScenarioArgsList");
	doTemp.appendHTMLStyle("","style=\"cursor: pointer;\" ondblclick=\"javascript:viewAndEdit()\"");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(30);
    dwTemp.genHTMLObjectWindow(sScenarioID);
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()","","","",""},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()","","","",""},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	setDialogTitle("预警参数列表");
	function newRecord(){
		AsControl.PopComp("/Common/Configurator/AlarmManage/AlarmScenarioArgsInfo.jsp","ScenarioID=<%=sScenarioID%>","dialogWidth=750px;dialogHeight=650px;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		reloadSelf();
	}
	
	function viewAndEdit(){
		var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
		var sAlarmArgID = getItemValue(0,getRow(),"AlarmArgID");
       	if(typeof(sAlarmArgID)=="undefined" || sAlarmArgID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
       	AsControl.PopComp("/Common/Configurator/AlarmManage/AlarmScenarioArgsInfo.jsp","ScenarioID="+sScenarioID+"&AlarmArgID="+sAlarmArgID,"dialogWidth=750px;dialogHeight=650px;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		reloadSelf();
	}

	function deleteRecord(){
		var sAlarmArgID = getItemValue(0,getRow(),"AlarmArgID");
       	if(typeof(sAlarmArgID)=="undefined" || sAlarmArgID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		if(confirm(getHtmlMessage('2'))){
			as_delete("myiframe0");
		}
	}
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>