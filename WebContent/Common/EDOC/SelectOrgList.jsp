<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
		//获得页面参数 
		String selectedOrg = CurPage.getParameter("selectedOrg"); //机构编号
	 	if (selectedOrg == null) selectedOrg = "";
		
%>
<body leftmargin="0" topmargin="0" style="overflow: hidden;">
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" >

<tr>
    <td valign="top" >
    	<table width='100%' cellpadding='0' cellspacing='0'>
			<tr>
				<td id="myleft" colspan='3' align=center width=100%>
					<div style="positition:absolute;align:left;height:430px;overflow-y: hide;">
						<iframe name="left" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0 scrolling=no ></iframe>
					</div>
				</td>
			</tr>
		</table>
    </td>
</tr>
<tr valign=top >
    <td>
    	<table>
	    	<tr>
	    		<td><%=new Button("确定","保存适用机构信息","saveConfig()","","").getHtmlText()%></td>
	    		<td><%=new Button("全选","全选","checkAll()","","").getHtmlText()%></td>
	    		<td><%=new Button("反选","反选","inverseCheck()","","").getHtmlText()%></td>
    		</tr>
    	</table>
    </td>
</tr>
</table>
</body>
<script type="text/javascript">
	setDialogTitle("选择适用机构");
	function saveConfig(){
		var nodes = getCheckedTVItems(); //树图已选择的节点
		var orgs ="";
		var orgname="";
		for(var i=0;i<nodes.length;i++){
				if(nodes[i].type!='page')continue;
				orgs += nodes[i].id + ",";
				orgname += nodes[i].name+",";
		}
		
		top.returnValue = ","+orgs+"@"+orgname;
			top.close();
		
	}
	
	function checkAll(){
		for(var i=0;i<nodes.length;i++){
			if(!hasChild(nodes[i].id))
				continue;
			setCheckTVItem(nodes[i].id,true);
		}
	}
	
	function inverseCheck(){
		for(var i=0;i<nodes.length;i++){
			if(!hasChild(nodes[i].id))
				continue;
			if(nodes[i].checked==1)
				setCheckTVItem(nodes[i].id,false);
			else if(nodes[i].checked==0)
				setCheckTVItem(nodes[i].id,true);
		}
	}
	function startMenu(){
		<%
			//HTMLTreeView tviTemp = new HTMLTreeView("选择适用机构","right");
			HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"选择适用机构","right");
			tviTemp.TriggerClickEvent=false;
			tviTemp.MultiSelect = true;
			tviTemp.initWithSql("OrgID","OrgName","","","","from ORG_INFO","Order By SortNo",Sqlca);
			out.println(tviTemp.generateHTMLTreeView());
			
			if(selectedOrg.length()>1){
				String[] orgArray = selectedOrg.split(",");
			for(int i = 1;i<orgArray.length;i++){
		%>
		
		setCheckTVItem("<%=orgArray[i]%>", true);
		<%  }
		 }%> 
		}
		startMenu();
		//expandNode('root');
		expandAll();
	<%//=dataTree.getWidgetId()%>
</script>
<%@ include file="/IncludeEnd.jsp"%>