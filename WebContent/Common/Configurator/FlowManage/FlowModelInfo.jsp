<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    流程模型信息详情
		Input Param:
                    FlowNo：    流程编号
                    PhaseNo：   阶段编号
	 */
	String PG_TITLE = "流程模型信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得组件参数	
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sFlowVersion =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowVersion"));
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	if(sFlowVersion == null) sFlowVersion = "";

	String sTempletNo = "FlowModelInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sFlowNo+","+sPhaseNo+","+sFlowVersion);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","保存并返回","保存修改并返回","saveRecordAndReturn()","","","",""},
	//	{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()","","","",""}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	
	function saveRecordAndReturn(){
		as_save("myiframe0","doReturn('Y');");
	}
    
	function saveRecordAndAdd(){	
       as_save("myiframe0","newRecord()");
	}

    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"FlowNo");
       parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
		reloadSelf();
	}
    
	function newRecord(){
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sFlowVersion = getItemValue(0,getRow(),"FlowVersion");
		OpenComp("FlowModelInfo","/Common/Configurator/FlowManage/FlowModelInfo.jsp","FlowNo="+sFlowNo+"&FlowVersion="+sFlowVersion,"_self","");

	}
	
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputDate","<%=com.amarsoft.app.base.util.DateHelper.getToday()%>");
			if ("<%=sFlowNo%>" !=""){
				setItemValue(0,0,"FlowNo","<%=sFlowNo%>");
				setItemValue(0,0,"FlowVersion","<%=sFlowVersion%>");
			}
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>