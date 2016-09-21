<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		Content:    预警参数详情
		Input Param:
                    ScenarioID：    场景编号
                    AlarmArgID：    参数编号
	 */
	//获得组件参数	
	String sScenarioID =  CurPage.getParameter("ScenarioID");
	String sAlarmArgID =  CurPage.getParameter("AlarmArgID");
	if(sScenarioID==null) sScenarioID="";
	if(sAlarmArgID==null) sAlarmArgID="";

	ASObjectModel doTemp = new ASObjectModel("AlarmScenarioArgsInfo");
 	//如果不为新增页面，则参数地ID不可修改
	if( sAlarmArgID.length() != 0 ){
		doTemp.setReadOnly("AlarmArgID",true);
	}
	doTemp.setDefaultValue("ScenarioID",sScenarioID);

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.genHTMLObjectWindow(sScenarioID+","+sAlarmArgID);
	
	String sButtons[][] = {
		{"true","","Button","保存并返回","保存修改并返回","saveRecordAndReturn()","","","",""},
		{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	setDialogTitle("预警参数详情");
	function saveRecordAndReturn(){
		as_save("myiframe0","top.close();");
	}
    
	function saveRecordAndAdd(){
		as_save("myiframe0","newRecord()");
	}
    
	function newRecord(){
        var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
        AsControl.OpenComp("/Common/Configurator/AlarmManage/AlarmScenarioArgsInfo.jsp","ScenarioID="+sScenarioID,"_self","");
	}
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>