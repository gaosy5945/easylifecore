<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		Content:    预警场景信息详情
		Input Param:
                    ScenarioID：    预警场景编号
	 */
	//获得组件参数	
	String sScenarioID =  CurPage.getParameter("ScenarioID");
	if(sScenarioID==null) sScenarioID="";

	ASObjectModel doTemp = new ASObjectModel("AlarmScenarioInfo");
	//如果为详情页面，不允许修改场景编号
	if(!sScenarioID.equals("")){
		doTemp.setReadOnly("ScenarioID",true);
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.genHTMLObjectWindow(sScenarioID);
	
	String sButtons[][] = {
		{"true","","Button","保存","保存修改","saveRecord()","","","",""},
		{"true","","Button","返回","关闭本页面","back()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	setDialogTitle("预警场景信息详情");
	function saveRecord(){
        as_save("myiframe0","");
	}
	
	function back(){
		top.close();
	}
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>