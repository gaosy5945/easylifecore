<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.workflow.manager.FlowManager"%>
<%@include file="/Frame/resources/include/include_begin.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/js/as_treeview.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/js/common.js"></script>
<%
	//��ȡ�������ʵ�����
	String flowSerialNo  = CurPage.getParameter("FlowSerialNo");
	String phaseNo  = CurPage.getParameter("PhaseNo");
	
%>
<html>
<head> 
<title>ѡ����Ϣ</title>
<script type="text/javascript">
	function TreeViewOnClick(){
		var sType = getCurTVItem().type;
		if(sType != "page"){
			alert("ҳ�ڵ���Ϣ����ѡ��������ѡ��");
		}
		return;
	}
	
	//������ͼ˫���¼���Ӧ���� add by hwang 20090601
	function TreeViewOnDBLClick(){
		var node = getCurTVItem();
		if(!node) return;
		var sType = node.type;
		if(sType != "page"){
			alert("ҳ�ڵ���Ϣ����ѡ��������ѡ��");
			return;
		}
		top.returnValue = node.value+"@"+node.name;
		top.close();
	}	
	
	function startMenu(){
	<%
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�ֹ�������ͼ","right");
		tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
		//ͨ��insertFolder��insertPage������ͼ
	
		String root=tviTemp.insertFolder("root","���������","",1);
	 	//���û�ȡ����ӿ�
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