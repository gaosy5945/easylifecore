<%@page import="com.amarsoft.are.util.json.JSONEncoder"%>
<%@page import="com.amarsoft.awe.util.ObjectTreeManager"%>
<%@page import="com.amarsoft.awe.ui.widget.ObjectTree"%>
<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%--��ʱ���ã��ݲ��ṩӦ��ʹ��---%>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/widget/objecttree.css">
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/js/widget/objecttree.js"></script>
<%--------------------------%>
<%
	String sClikItemNo = CurPage.getParameter("ClikItemNo");
	String sSelectItemNos = CurPage.getParameter("SelectItemNo");
	
	String[] aSelectItemNos = null;
	if(sSelectItemNos != null) aSelectItemNos = sSelectItemNos.split(",");

	ObjectTree tree = new ObjectTree("ģ����������");
	tree.setMultiselect(true);
	tree.setIcon(true);
	tree.procureAppendHtml().append("&nbsp;<a href=\"javascript:void(0);\" onclick=\"return viewRecord(this, event);\" style=\"color:#00f;\">��ť</a>");
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
<%=new Button("����", "", "searchRecord()").getHtmlText()%>
<%=new Button("��ȡ��ѡ�ڵ�", "", "showChecked()").getHtmlText()%>
</div>
<div id="test" style="width:600px;height:500px;overflow:auto;"></div>
</body>
<script type="text/javascript">
	var tree = new ObjectTree("test", <%=JSONEncoder.encode(tree)%>);
	tree.NodeOnClick = function(node){
		if(node.getData()["beclick"] == true){
			if(!confirm("��ǰ��Ϊ����ڵ㣬�Ƿ���������")) return;
		}
		alert(node.getAttribute("ItemNo"));
	};
	tree.draw();
	
	function viewRecord(btn, e){
		var node = tree.getNode(btn);
		if(node) alert(node.getAttribute("Text"));
		AsLink.stopEvent(e); // ��ֹð��
		return false; // ��ֹShift+���
	}
	
	function searchRecord(){
		tree.showSearch(function(node){
			node.focus();
		});
	}
	
	function showChecked(){
		if(!tree.isMultiselect()){
			alert("���Ƕ�ѡ��");
			return;
		}
		var nodes = tree.getChecked(confirm("������ѡ�ڵ㣿"));
		var str = "ѡ����"+nodes.length+"���ڵ㣺";
		for(var i = 0; i < nodes.length; i++){
			str += "\n"+nodes[i].getAttribute("ItemName");
		}
		alert(str);
	}
	
	// ��λ��ǰ����ڵ�
	AsLink.setShortcut("Ctrl+Shift+P", function(){
		var node = tree.getClick();
		if(!node) return;
		node.focus();
	});
	// ��ݶ�λ
	// �Ϸ�����ƶ���λ�ڵ�
	AsLink.setShortcut("UP", function(){
		var node = tree.getHover();
		if(!node) return;
		var upnode = node.getUp();
		if(!upnode) return;
		upnode.focus();
	});
	// �·�����ƶ���λ�ڵ�
	AsLink.setShortcut("DOWN", function(){
		var node = tree.getHover();
		if(!node) return;
		var downnode = node.getDown();
		if(!downnode) return;
		downnode.focus();
	});
	// Enter���ƶ������λ�ڵ�
	AsLink.setShortcut("ENTER", function(){
		var node = tree.getHover();
		if(!node) return;
		node.click();
	});
	// ���������λ�ڵ�
	AsLink.setShortcut("LEFT", function(){
		var node = tree.getHover();
		if(!node) return;
		node.collapse();
	});
	// �ҷ�����򿪶�λ�ڵ�
	AsLink.setShortcut("RIGHT", function(){
		var node = tree.getHover();
		if(!node) return;
		node.expand();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>