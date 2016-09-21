<%@page import="com.amarsoft.are.jbo.*"%>
<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBegin.jsp"%><%
 	String bizObjClass =  CurPage.getParameter("BizObjClass");
 	if(bizObjClass == null) bizObjClass="";
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView("JBO类","right");
	tviTemp.TriggerClickEvent=false;
 	tviTemp.MultiSelect = true;
	BizObjectClass bc = JBOFactory.getBizObjectClass(bizObjClass);
	//TODO 获取主对象的关联对象，包括class、alias、relation等属性
	String[] relatedObjects = new String[]{"jbo.xquery.ENT_INFO","jbo.xquery.CUSTOMER_RELATIVE"};
 	for(int i = 0;i<relatedObjects.length;i++){
 		BizObjectClass clazz = JBOFactory.getBizObjectClass(relatedObjects[i]);
 		String clsName = clazz.getName();
 		String clsLabel = clazz.getLabel();
 		//TODO 这里作为示例暂时定义，后续需调整
 		String nodeJSONValue = relatedObjects[i]+"@"+clsName+"@";
 		if(relatedObjects[i].equals("jbo.xquery.ENT_INFO")) nodeJSONValue += "O.CustomerID=ENT_INFO.CustomerID";
 		else if(relatedObjects[i].equals("jbo.xquery.CUSTOMER_RELATIVE")) nodeJSONValue += "O.CustomerID=CUSTOMER_RELATIVE.CustomerID";
 		
 		tviTemp.insertPage(clsName, "root", clsLabel, nodeJSONValue, "", i); //class节点
	}
 	
 	String sButtons[][] = {
 		{"true","","Button","选择","返回选择项","doConfig()","","","",""},
 	};
%><%@include file="/Resources/CodeParts/View07.jsp"%>
<script type="text/javascript">
	setDialogTitle("选择JBO关联对象");
	function doConfig(){
		var nodes = getCheckedTVItems(); //关联对象节点
   		if(nodes == null || nodes.length == 0){
   			alert("请选择关联对象节点！");
   			return;
   		}
		
   		var relatedClasses = new Array();
   		var relatedClassName="";
   		for(var i=0;i<nodes.length;i++){
			if(nodes[i].type != "page") continue;
			relatedClasses.push(nodes[i].value);
			relatedClassName += ","+nodes[i].name;
   		}
   		top.returnValue = JSON.stringify(relatedClasses)+"@@"+relatedClassName.substring(1);
		top.close();
	}
	<%/*~[Describe=生成treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandAll();
	}
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>