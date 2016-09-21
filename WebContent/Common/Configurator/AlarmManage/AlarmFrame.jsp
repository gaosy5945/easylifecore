<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
/*
	Content: ÉÏÏÂ¿ò¼ÜÒ³Ãæ
 */
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">
	mytoptd.height=300;
	OpenScenarioList();
	
	function OpenScenarioList(){
		AsControl.OpenView("/Common/Configurator/AlarmManage/AlarmScenarioList.jsp","","rightup");
	}
	
	function OpenModelList(sScenarioID){
		AsControl.OpenView("/Common/Configurator/AlarmManage/AlarmModelList.jsp","ScenarioID="+sScenarioID,"rightdown");
	}
</script>	
<%@ include file="/IncludeEnd.jsp"%>