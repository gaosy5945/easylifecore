<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
 	String sDefaultNode = CurPage.getParameter("DefaultNode"); //默认打开节点
	String sClassifyID = CurPage.getParameter("ClassifyID");
	if(sClassifyID == null) sClassifyID = "";
	if(sDefaultNode == null) sDefaultNode = "";
	//widget.setDefaultClickNodeId(sClassifyID);
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构	
	String sSqlTreeView = " from AWE_GROUP_CLASSIFY where IsInUse = '1'";
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	tviTemp.initWithSql("SortNo", "ClassifyName", "ClassifyID","","",sSqlTreeView,"Order By SortNo",Sqlca);
	
	String[][] sButtons = {
		{"true","","Button","新增","新增组合页面类别","newTreeGroup()","","","",""},
		{"true","","Button","编辑","编辑组合页面类别","viewTreeGroup()","","","",""},
		{"true","","Button","删除","删除组合页面类别","deleteTreeGroup()","","","",""},
		{"true","","Button","查询","","showTVSearch()","","","",""},
	};
%><%@include file="/Resources/CodeParts/View07.jsp"%>
<script type="text/javascript">
	initTreeView();
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		//expandNode('root');
		expandAll();
		selectItem('<%=sDefaultNode%>');
	}
	<%/*节点点击事件*/%>
	function TreeViewOnClick(){
		var sSortNo = getCurTVItem().id;
		var sClassifyID = getCurTVItem().value;
		if(!sClassifyID){
			OpenPage("/AppMain/Blank.jsp?TextToShow=请选择左边树图节点!", "frameright");
		}else{
	      	OpenPage("/AppConfig/PageMode/GroupPage/GroupPageFrame.jsp?SearchType=SortNo&Search="+sSortNo+"&ClassifyID="+sClassifyID, "frameright"); 
		}
	}
	<%/*新增树图类别*/%>
	function newTreeGroup(){
		var sReturn = AsControl.PopComp("/AppConfig/PageMode/GroupPage/GroupClassifyInfo.jsp", "",  "dialogWidth=600px;dialogHeight=300px;resizable=yes;maximize:yes;help:no;status:no;");
		if(typeof sReturn == "undefined" || sReturn.length == 0) return;
		var sReturnInfo = sReturn.split("@");
		AsControl.OpenPage("/AppConfig/PageMode/GroupPage/GroupPageView.jsp", "ClassifyID="+sReturnInfo[0]+"&DefaultNode="+sReturnInfo[1], '_self');
	}
	<%/*编辑树图类别*/%>
	function viewTreeGroup(){
		var sClassifyID = getCurTVItem().value;
		if(!sClassifyID){
			alert("请选择树图类别！");
			return;
		}
		var sArgs = "ClassifyID=" + sClassifyID;
		if(!hasChild(sClassifyID)){
			sArgs += "&ParentSelectReadOnly=true";
		}
		var sClassifyID = AsControl.PopComp("/AppConfig/PageMode/GroupPage/GroupClassifyInfo.jsp", sArgs,  "dialogWidth=600px;dialogHeight=300px;resizable=yes;maximize:yes;help:no;status:no;");
		if(typeof sClassifyID == "undefined" || sClassifyID.length == 0) return;
		AsControl.OpenPage("/AppConfig/PageMode/GroupPage/GroupPageView.jsp", "ClassifyID="+sClassifyID, "_self");
	}
	<%/*删除树图类别*/%>
	function deleteTreeGroup(){
		var sClassifyID = getCurTVItem().value;
		if(!sClassifyID){
			alert("请选择树图类别！");
			return;
		}
		if(!hasChild(sClassifyID)){
			alert("该节点下存在子节点，请先处理子节点！");
			return;
		}
		if(!confirm("请确认删除该类及其以下的具体树图记录？")) return;
		var sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.grouppage.action.GroupTreeAction", "deleteTreeNode", "ClassifyID="+sClassifyID);
		if(!sReturn || sReturn != "SUCCESS") return;
		//AsControl.OpenPage("/AppConfig/PageMode/GroupPage/GroupPageView.jsp", "", "_self");
		top.reloadSelf();
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>