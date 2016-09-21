<%@page import="com.amarsoft.are.util.json.*"%>
<%@page import="com.amarsoft.are.jbo.*"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String majorClass = CurPage.getParameter("MajorClass"); //主对象
	String relatedClass = CurPage.getParameter("RelatedClasses"); //对象字符串
	String selectType = CurPage.getParameter("SelectType"); //选择类型
	String selectedAttrs = CurPage.getParameter("SelectedAttrs"); //已选择节点
	
	HTMLTreeView tviTemp = new HTMLTreeView("选取JBO对象属性");
	tviTemp.TriggerClickEvent=false;
	tviTemp.MultiSelect = true;

	Map map = new HashMap();
	map.put(majorClass, "O");
	if(!StringX.isEmpty(relatedClass)){
		JSONObject relaArray =  JSONDecoder.decode(relatedClass);
		for(int i=0;i<relaArray.size();i++){
			String je = relaArray.get(i).getValue().toString();
			String jboClass = je.split("\\@")[0];
			String sClassAlias = je.split("\\@")[1];
			map.put(jboClass, sClassAlias);
		}
	}
	
	//从参数中获取jbo对象类串，该串以逗号分隔
	String sKeys[] = (String[])map.keySet().toArray(new String[0]);
	for(int i=0;i<sKeys.length;i++){
		BizObjectClass bizClass = JBOFactory.getBizObjectClass(sKeys[i]);
		//设置类别名
		String sClassAlias = map.get(sKeys[i]).toString();
		//加入jbo class
		tviTemp.insertFolder(sClassAlias, "root", bizClass.getLabel(), bizClass.getAbsoluteName(), "", i);
		
		//加入 class attributes
		DataElement[] attrs = bizClass.getAttributes();
		for(int j=0;j<attrs.length;j++){
			String attrName = attrs[j].getName();
			tviTemp.insertPage(sClassAlias+"_"+attrName, sClassAlias, bizClass.getLabel()+"-"+attrs[j].getLabel(), sClassAlias+"."+attrName, "", j);
		}
	}
	String[][] sButtons = {
		{"true", "", "Button", "确定", "确认选择", "doConfig()", "", "", "", ""},
		{"true", "", "Button", "清空", "情况", "doClear()", "", "", "", ""},
	};
%><%@include file="/Resources/CodeParts/View07.jsp"%>
<script type="text/javascript">
	setDialogTitle("选取JBO对象类的属性");
	function doConfig(){
   		var nodes = getCheckedTVItems(); //主对象属性树图选择的节点
   		if(nodes == null || nodes.length == 0){
   			alert("请选择对象属性节点！");
   			return;
   		}
   		
   		var attrs ="",names="",j=1;
   		var selectType = "<%=selectType%>";
   		if(nodes.length > 5 && (selectType=="Order" || selectType=="Group" || selectType=="Summary")){
   			alert("选择项过多！");
   			return;
   		}
		for(var i=0;i<nodes.length;i++){
			if(nodes[i].type != "page") continue;
			//别名.属性
			attrs += ","+ nodes[i].value;
			names += j+". "+ nodes[i].name+"\r\n";
			j++;
		}
   		top.returnValue = attrs.substring(1)+"@"+names;
		top.close();
	}
	function doClear(){
		top.returnValue = "@";
		top.close();
	}
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandAll();
		<%
		String[] attArray = selectedAttrs.split(",");
		for(int i=0;i<attArray.length;i++){
			String nodeid = attArray[i].replace(".", "_");
		%>
			setCheckTVItem("<%=nodeid%>", true);
		<%
		}
		%>
	}
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>