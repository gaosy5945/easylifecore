<%@page import="com.amarsoft.are.util.json.JSONEncoder"%>
<%@page import="com.amarsoft.awe.util.ObjectTreeManager"%>
<%@page import="com.amarsoft.awe.ui.widget.ObjectTree"%>
<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%--临时引用，暂不提供应用使用---%>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/widget/objecttree.css">
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/js/widget/objecttree.js"></script>
<%--------------------------%>
<%
	String sClikItemNo = CurPage.getParameter("ClikItemNo");
	String sSelectItemNos = CurPage.getParameter("SelectItemNo");
	
	String[] aSelectItemNos = null;
	if(sSelectItemNos != null) aSelectItemNos = sSelectItemNos.split(",");

	ObjectTree tree = new ObjectTree("模拟行政区域");
	tree.setMultiselect(true);
	tree.setIcon(true);
	tree.procureAppendHtml().append("&nbsp;<a href=\"javascript:void(0);\" onclick=\"return viewRecord(this, event);\" style=\"color:#00f;\">按钮</a>");
	/*
	tree.storys.addAll(ObjectTreeManager.genTreeNodes(
			Sqlca, new SqlObject("SELECT ItemNo, ItemName, SortNo, ItemName || '(' || ItemNo || ')' as Text FROM CODE_LIBRARY WHERE CodeNo = 'TestObjectTree'"),
			"Text", "SortNo"));
	*/
	tree.getStorys().addAll(ObjectTreeManager.genTreeNodes(
			Sqlca, new SqlObject("SELECT ItemNo, ItemName, SortNo, ItemName || '(' || ItemNo || ')' as Text FROM CODE_LIBRARY WHERE CodeNo = 'TestObjectTree'"),
			// icon text tips sort
			null, "Text", "ItemName", "SortNo",
			// click
			"ItemNo", sClikItemNo,
			// expand
			"ItemNo", new String[]{"540100"},
			// check
			"ItemNo", aSelectItemNos));
%>
<body>
<div style="width:600px;">
<%=new Button("搜索", "", "searchRecord()").getHtmlText()%>
<%=new Button("获取勾选节点", "", "showChecked()").getHtmlText()%>
</div>
<div id="test" style="width:600px;height:500px;overflow:auto;"></div>
</body>
<script type="text/javascript">
	var tree = new ObjectTree("test", <%=JSONEncoder.encode(tree)%>);
	tree.NodeOnClick = function(node){
		if(node.getData()["beclick"] == true){
			if(!confirm("当前已为点击节点，是否继续点击？")) return;
		}
		alert(node.getAttribute("ItemNo"));
	};
	tree.draw();
	
	function viewRecord(btn, e){
		var node = tree.getNode(btn);
		if(node) alert(node.getAttribute("Text"));
		AsLink.stopEvent(e); // 阻止冒泡
		return false; // 阻止Shift+左键
	}
	
	function searchRecord(){
		tree.showSearch(function(node){
			node.focus();
		});
	}
	
	function showChecked(){
		if(!tree.isMultiselect()){
			alert("不是多选树");
			return;
		}
		var nodes = tree.getChecked(confirm("包括半选节点？"));
		var str = "选择了"+nodes.length+"个节点：";
		for(var i = 0; i < nodes.length; i++){
			str += "\n"+nodes[i].getAttribute("ItemName");
		}
		alert(str);
	}
	
	// 定位当前点击节点
	AsLink.setShortcut("Ctrl+Shift+P", function(){
		var node = tree.getClick();
		if(!node) return;
		node.focus();
	});
	// 快捷定位
	// 上方向键移动定位节点
	AsLink.setShortcut("UP", function(){
		var node = tree.getHover();
		if(!node) return;
		var upnode = node.getUp();
		if(!upnode) return;
		upnode.focus();
	});
	// 下方向键移动定位节点
	AsLink.setShortcut("DOWN", function(){
		var node = tree.getHover();
		if(!node) return;
		var downnode = node.getDown();
		if(!downnode) return;
		downnode.focus();
	});
	// Enter键移动点击定位节点
	AsLink.setShortcut("ENTER", function(){
		var node = tree.getHover();
		if(!node) return;
		node.click();
	});
	// 左方向键收起定位节点
	AsLink.setShortcut("LEFT", function(){
		var node = tree.getHover();
		if(!node) return;
		node.collapse();
	});
	// 右方向键打开定位节点
	AsLink.setShortcut("RIGHT", function(){
		var node = tree.getHover();
		if(!node) return;
		node.expand();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>