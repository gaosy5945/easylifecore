<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.workflow.manager.FlowManager"%>
<%@include file="/Frame/resources/include/include_begin.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/js/as_treeview.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/js/common.js"></script>
<%
	//获取参数：活动实例编号
	String flowSerialNo  = CurPage.getParameter("FlowSerialNo");
	String phaseNo  = CurPage.getParameter("PhaseNo");
	
%>
<html>
<head> 
<title>选择信息</title>
<script type="text/javascript">
	function TreeViewOnClick(){
		var sType = getCurTVItem().type;
		if(sType != "page"){
			alert("页节点信息不能选择，请重新选择！");
		}
		return;
	}
	
	//新增树图双击事件响应函数 add by hwang 20090601
	function TreeViewOnDBLClick(){
		var node = getCurTVItem();
		if(!node) return;
		var sType = node.type;
		if(sType != "page"){
			alert("页节点信息不能选择，请重新选择！");
			return;
		}
		top.returnValue = node.value+"@"+node.name;
		top.close();
	}	
	
	function startMenu(){
	<%
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"手工生成树图","right");
		tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
		//通过insertFolder和insertPage生成树图
	
		String root=tviTemp.insertFolder("root","任务参与者","",1);
	 	//调用获取任务接口
	 	BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
	 	FlowManager fm = FlowManager.getFlowManager(bomanager);
		List<BusinessObject> pcps = fm.queryAvyPcp(flowSerialNo, phaseNo);
		
		if(pcps!=null)
		{
			int m = 0;
			for(int i = 0; i < pcps.size() ; i ++)
			{
				BusinessObject pcp = pcps.get(i);
				tviTemp.insertPage(root,pcp.getString("UserName"),pcp.getString("UserID")+"@"+pcp.getString("BelongOrg"),"",i+2);
			}
		}
		
		out.println(tviTemp.generateHTMLTreeView());
	%>
		expandNode('1');
	}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>
<body class="pagebackground"><iframe name="left" width=100% height=100% frameborder=0 ></iframe></body>
<script>
	startMenu();
</script>
</html>
<%@include file="/Frame/resources/include/include_end.jspf"%>