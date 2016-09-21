<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
		/*
		Content:    预警模型详情
		Input Param:
					ScenarioID: 场景号 
					ModelID：    警示模型编号
	 */
	//获得组件参数	
	String sScenarioID = CurPage.getParameter("ScenarioID");
	String sModelID =  CurPage.getParameter("ModelID");
	if(sModelID==null) sModelID="";
	if(sScenarioID==null) sScenarioID="";

	String sSubTypeNo = Sqlca.getString(new SqlObject("select DefaultSubTypeNo from SCENARIO_CATALOG where ScenarioID=:ScenarioID").setParameter("ScenarioID",sScenarioID));
	if(sSubTypeNo == null) sSubTypeNo = null;

	ASObjectModel doTemp = new ASObjectModel("AlarmModelInfo");
	//设置默认值
	doTemp.setDefaultValue("ScenarioID",sScenarioID);
	doTemp.setDefaultValue("SubTypeNo",sSubTypeNo);
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.genHTMLObjectWindow(sScenarioID+","+sModelID);
	
	String sButtons[][] = {
		{"true","","Button","保存并返回","保存修改并返回","saveRecordAndReturn()","","","",""},
		{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	setDialogTitle("预警模型详情");
	function saveRecordAndReturn(){
		as_save("myiframe0","top.close();");
	}
    
	function saveRecordAndAdd(){
		as_save("myiframe0","newRecord()");
	}
    
	function newRecord(){
        AsControl.OpenComp("/Common/Configurator/AlarmManage/AlarmModelInfo.jsp","ScenarioID=<%=sScenarioID%>","_self","");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>