<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*
		Describe: 流转记录列表
		Input Param:
			ObjectNo：  	流程业务申请号
			ObjectType:	流程对象类型
	 */
	//获得参数	
  	String sObjectNo =  CurPage.getParameter("ObjectNo");
	String sObjectType =  CurPage.getParameter("ObjectType");
  	String sFlowStatus =  CurPage.getParameter("FlowStatus");
	if(sFlowStatus == null) sFlowStatus = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";

	ASObjectModel doTemp = new ASObjectModel("FlowChangeList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);
	
	String sButtons[][] = {
		{"true","","Button","流程调整","流程调整","FlowAdjust()","","","",""}
	};

	if(sFlowStatus.equals("02")){
		sButtons[0][0] = "false";
	}
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	setDialogTitle("流转记录");
	function FlowAdjust(){
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sPhaseName = getItemValue(0,getRow(),"PhaseName");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择你要调整到的阶段！");//请选择一条信息！
		}else{
			var sCurPhaseName = RunMethod("WorkFlowEngine","GetMaxPhaseName",sSerialNo);
			if(sPhaseName == sCurPhaseName){
				alert("流程正处于"+sPhaseName+"，请重新选择！");
			}else{
				if(confirm("你确定要将流程调整到"+sPhaseName+"吗?")){
					sReturn = RunMethod("WorkFlowEngine","ChangeFlowPhase",sSerialNo+","+sObjectNo+","+sObjectType);
					if(typeof(sReturn) != "undefined" && sReturn == "success"){
						alert("流程调整成功！");
					}else{
						alert("流程调整失败！");
					}
					reloadSelf();
				}
			}
		}
	}
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>