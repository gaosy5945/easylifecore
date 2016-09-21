<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 流程模型列表
		Input Param:
             sFlowNo：流程编号     
	 */
	String PG_TITLE = "流程模型列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
    //获得页面参数	
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sFlowVersion = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowVersion"));
	if (sFlowNo == null) sFlowNo = "";
	if (sPhaseNo == null) sPhaseNo = "";
	if (sFlowVersion == null) sFlowVersion = "";
	
	String sTempletNo = "FlowModelList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);
    
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sFlowNo+","+sFlowVersion);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()","","","",""},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()","","","",""},
		{"true","","Button","参数列表","查看/修改参数列表","viewAndEdit2()","","","",""},
		//{"true","","Button","保存","保存","save()","","","",""},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()","","","",""},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("FlowModelInfo","/Common/Configurator/FlowManage/FlowModelInfo.jsp","FlowNo=<%=sFlowNo%>&FlowVersion=<%=sFlowVersion%>&PhaseNo=<%=sPhaseNo%>","");
        //修改数据后刷新列表
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				OpenPage("/Common/Configurator/FlowManage/FlowModelList.jsp?FlowNo="+sReturnValues[0],"_self","");           
            }
        }
	}
	
	function viewAndEdit(){
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sFlowVersion = getItemValue(0,getRow(),"FlowVersion");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		sReturn=popComp("FlowModelInfo","/Common/Configurator/FlowManage/FlowModelInfo.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&FlowVersion="+sFlowVersion,"");
        //修改数据后刷新列表
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				OpenPage("/Common/Configurator/FlowManage/FlowModelList.jsp?FlowNo="+sReturnValues[0],"_self","");           
            }
        }
	}
	
	/*~[Describe=查看/修改流程参数列表;]~*/
	function viewAndEdit2(){
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sFlowVersion = getItemValue(0,getRow(),"FlowVersion");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
       popComp("查看/修改流程参数列表","/Common/Configurator/FlowManage/FlowParameterList.jsp","FlowNo="+sFlowNo+"&FlowVersion="+sFlowVersion+"&PhaseNo="+sPhaseNo,"");  
	}

	function save(){
		as_save("myiframe0","");
	}

	function deleteRecord(){
		var sPhaseNo = getItemValue(0,getRow(),"FlowNo");
		if(typeof(sPhaseNo)=="undefined" || sPhaseNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm(getHtmlMessage('2'))){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"FlowNo");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>