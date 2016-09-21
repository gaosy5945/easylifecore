<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	/*
		Content: 流程模型列表
	 */
	String PG_TITLE = "流程模型列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	 
	String sTempletNo = "FlowCatalogList";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);

	//定义后续事件
// 	dwTemp.setEvent("BeforeDelete","!Configurator.DelFlowModel(#FlowNo,#FlowVersion)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()","","","",""},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()","","","",""},
		{"true","","Button","流程模型列表","查看/修改流程模型列表","viewAndEdit2()","","","",""},
		{"true","","Button","流程参数列表","查看/修改流程参数列表","viewAndEdit3()","","","",""},
		{"true","","Button","设为默认","设为默认","setDefault()","","","",""},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/Common/Configurator/FlowManage/FlowCatalogInfo.jsp","Flag=N","_self","");
	}
	
    /*~[Describe=查看及修改详情;]~*/
	function viewAndEdit(){
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sFlowVersion = getItemValue(0,getRow(),"FlowVersion");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
       popComp("FlowCatalogInfo","/Common/Configurator/FlowManage/FlowCatalogInfo.jsp","FlowNo="+sFlowNo+"&FlowVersion="+sFlowVersion+"&Flag=Y&ItemID=0010","");
	}
    
    /*~[Describe=查看/修改流程模型列表;]~*/
	function viewAndEdit2(){
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sFlowVersion = getItemValue(0,getRow(),"FlowVersion");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
       popComp("FlowModelList","/Common/Configurator/FlowManage/FlowModelList.jsp","FlowNo="+sFlowNo+"&FlowVersion="+sFlowVersion+"&ItemID=0020","");  
	}
    
	/*~[Describe=设为默认;]~*/
	function setDefault(){
		var flowNo = getItemValue(0,getRow(),"FlowNo");
		var flowVersion = getItemValue(0,getRow(),"FlowVersion");
		if(typeof(flowNo)=="undefined" || flowNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var i = AsControl.RunASMethod("WorkFlowEngine","setDefault",flowNo+","+flowVersion);
		if(parseInt(i) > 0)
		{
			alert("设置成功！");
		}
		else
			alert("设置失败！");
	}
	
	/*~[Describe=查看/修改流程参数列表;]~*/
	function viewAndEdit3(){
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sFlowVersion = getItemValue(0,getRow(),"FlowVersion");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
       popComp("查看/修改流程参数列表","/Common/Configurator/FlowManage/FlowParameterList.jsp","FlowNo="+sFlowNo+"&FlowVersion="+sFlowVersion+"&PhaseNo=init0010","");  
	}

	/*~[Describe=删除记录;]~*/
	function deleteRecord(){
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sFlowVersion = getItemValue(0,getRow(),"FlowVersion");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0 || typeof(sFlowVersion)=="undefined" || sFlowVersion.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm(getHtmlMessage('49'))){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>