<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%@
 page import="com.amarsoft.are.jbo.*" %><%
 	String DefaultNode =  CurPage.getParameter("DefaultNode");
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView("JBO类","right");
	tviTemp.TriggerClickEvent = true;
	//定义树图结构
	JBOFactory f = JBOFactory.getFactory();
	String[] pkgNames=f.getPackages();
 	for(int i = 0;i<pkgNames.length;i++){
		if(pkgNames[i].contains("jbo.ui") || pkgNames[i].contains("jbo.oti")) continue; //剔除UI部分的jbo配置

		String pkgLabel = f.getPackage(pkgNames[i]).getLabel();
		tviTemp.insertFolder(pkgNames[i], "root", pkgLabel, pkgNames[i], "", i); //package节点
		
		String[] classes=f.getClasses(pkgNames[i]);
	 	//存储class中label的名字
	 	for(int j=0;j<classes.length;j++){
	 		BizObjectClass clazz = f.getClass(classes[j]);
	 		String clsName = clazz.getName();
	 		String clsLabel = clazz.getLabel();
	 		tviTemp.insertPage(classes[j], pkgNames[i], clsLabel+"["+classes[j]+"]", clsLabel, "", j); //class节点
	 	}
	}
 	String sButtons[][] = {
 		{"true","","Button","选择","返回选择项","doConfig()","","","",""},
 		{"true","","Button","查询","","showTVSearch()","","","",""}
 	};
%><%@include file="/Resources/CodeParts/View07.jsp"%>
<script type="text/javascript">
	setDialogTitle("选择JBO对象类");
	function doConfig(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemValue = getCurTVItem().value;
		var sCurItemType = getCurTVItem().type;
		if(sCurItemType == 'page'){
			top.returnValue = sCurItemID+"@"+sCurItemValue;
			top.close();
		}else{
			return;
		}
	}
	function TreeViewOnClick(){}
	function TreeViewOnDBLClick(){
		doConfig();
	}
	<%/*~[Describe=生成treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		var DefaultNode = "<%=DefaultNode%>";
		if( DefaultNode!= null){
			selectItemByName(DefaultNode); //默认打开节点
		}
	}
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>