<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 流程模型参数列表
		Input Param:
             FlowNo：流程编号     
             PhaseNo：阶段编号
             FlowVersion：流程版本     
	 */
	String PG_TITLE = "流程模型参数列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
    //获得页面参数	
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sFlowVersion = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowVersion"));
	if (sFlowNo == null) sFlowNo = "";
	if (sPhaseNo == null) sPhaseNo = "";
	if (sFlowVersion == null) sFlowVersion = "";
	
	String sTempletNo = "FlowParameterList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);
    
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sFlowNo+","+sFlowVersion+","+sPhaseNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()","","","",""},
		{"true","","Button","保存","保存","save()","","","",""},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()","","","",""},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		as_add("myiframe0");
		setItemValue(0,getRow(),"FlowNo","<%=sFlowNo%>");
		setItemValue(0,getRow(),"PhaseNo","<%=sPhaseNo%>");
		setItemValue(0,getRow(),"FlowVersion","<%=sFlowVersion%>");
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
	

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>