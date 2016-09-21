<%@page import="com.amarsoft.are.util.json.JSONEncoder"%>
<%@page import="com.amarsoft.awe.ui.widget.TreeStory"%>
<%@page import="com.amarsoft.awe.ui.widget.ObjectTree"%>
<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/chart/json2.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/jquery/plugins/jquery.mousewheel.min.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/FrameCase/widget/resources/js/CLASS_FORMAT.js"></script>
<%--
<script src="<%=sWebRootPath%>/FrameCase/widget/resources/js/jquery.ui.core.js"></script>
<script src="<%=sWebRootPath%>/FrameCase/widget/resources/js/jquery.ui.widget.js"></script>
<script src="<%=sWebRootPath%>/FrameCase/widget/resources/js/jquery.ui.mouse.js"></script>
<script src="<%=sWebRootPath%>/FrameCase/widget/resources/js/jquery.ui.draggable.js"></script>
<script src="<%=sWebRootPath%>/FrameCase/widget/resources/js/jquery.ui.sortable.js"></script>
--%>
<script type="text/javascript" src="<%=sWebRootPath%>/FrameCase/widget/resources/js/jquery-ui.js"></script>
<%--临时引用，暂不提供应用使用---%>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/widget/objecttree.css">
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/js/widget/objecttree.js"></script>
<%--------------------------%>
<%
	boolean special = true;

	ObjectTree tree = new ObjectTree("测试树图");
	tree.setMultiselect(special);
	if(special){
		/*
		tree.procureAppendHtml().append(new Button("前增", "", "newRecord(this, 1)", "", "noicon").getHtmlText());
		tree.procureAppendHtml().append(new Button("后增", "", "newRecord(this, 2)", "", "noicon").getHtmlText());
		tree.procureAppendHtml().append(new Button("子增", "", "newRecord(this, 3)", "", "noicon").getHtmlText());
		tree.procureAppendHtml().append(new Button("详情", "", "viewRecord(this)", "", "noicon").getHtmlText());
		tree.procureAppendHtml().append(new Button("删除", "", "delRecord(this)", "", "noicon").getHtmlText());
		*/
		tree.procureAppendHtml().append("&nbsp;<a style=\"color:#0f0;\" href=\"javascript:void(0);\" onclick=\"newRecord(this, 1);AsLink.stopEvent(event);return false;\">前增</a>");
		tree.procureAppendHtml().append("&nbsp;<a style=\"color:#0f0;\" href=\"javascript:void(0);\" onclick=\"newRecord(this, 2);AsLink.stopEvent(event);return false;\">后增</a>");
		tree.procureAppendHtml().append("&nbsp;<a style=\"color:#0f0;\" href=\"javascript:void(0);\" onclick=\"newRecord(this, 3);AsLink.stopEvent(event);return false;\">子增</a>");
		tree.procureAppendHtml().append("&nbsp;<a style=\"color:#00f;\" href=\"javascript:void(0);\" onclick=\"viewRecord(this);AsLink.stopEvent(event);return false;\">详情</a>");
		tree.procureAppendHtml().append("&nbsp;<a style=\"color:#f00;\" href=\"javascript:void(0);\" onclick=\"delRecord(this);AsLink.stopEvent(event);return false;\">删除</a>");
	}
	int I = 2, J = 2, K = 0, M = 2, N = 2;
	for(int i = 0; i < I; i++){
		String iconi = null;
		if(special && i == 0) iconi = "moveicon";
		if(special && i == 1) iconi = "ordericon";
		TreeStory node = new TreeStory(iconi, "节点"+i, "解释性文字");
		tree.getStorys().add(node);

		node.getAttributes().put("CustomerName", "某某某公司"+i);
		if(special && (i == 1 || i == 2)) continue;
		if(special && i == 3) node.setExpand(true);
		
		for(int j = 0; j < J; j++){
			TreeStory node1 = new TreeStory(null, "节点"+i+"."+j, null);
			node.getStorys().add(node1);
		
			node1.getAttributes().put("CustomerName", "某某某公司"+i+"."+j);
			
			for(int k = 0; k < K; k++){
				String icon = null;
				if(special && k == 0) icon = "ordericon";
				TreeStory node2 = new TreeStory(icon, "节点"+i+"."+j+"."+k, null);
				node1.getStorys().add(node2);
				if(j == 0 && k == 0){
					if(tree.isMultiselect()) node2.setCheck(true);
					if(special && i == 4) node2.setBeclick(true);
				}
				
				node2.getAttributes().put("CustomerName", "某某某公司"+i+"."+j+"."+k);
				
				for(int m = 0; m < M; m++){
					TreeStory node3 = new TreeStory(null, "节点"+i+"."+j+"."+k+"."+m, null);
					node2.getStorys().add(node3);
					for(int n = 0; n < N; n++){
						TreeStory node4 = new TreeStory(null, "节点"+i+"."+j+"."+k+"."+m+"."+n, null);
						node3.getStorys().add(node4);
					}	
				}
			}
		}
	}
%>
<style>
#test {
	display: inline-block;
	float: left;
	width: 600px;
	height: 500px;
	overflow: hidden;
	background: url(<%=sWebRootPath%>/FrameCase/widget/resources/images/bg.png) #f1f1f1 right repeat-y;
}
.objecttree .folder .node.click,
.objecttree .page .node.click {
	background: #fff;
}
#msg {
	display: inline-block;
	float: left;
	height: 501px;
	width: 500px;
	left: 600px;
	overflow: auto;
	border: none;
	background: #fff;
	font-size: 12px;
	word-wrap: normal;
	resize: none;
}
#msg.now_msg {
	background: #fee;
}
.objecttree .folder.now_msg .node.click,
.objecttree .page.now_msg .node.click {
	background: #fee;
}
</style>
<body>
<div style="padding:10px;"><%
if(tree.isMultiselect()){
%><%=new Button("获取选择节点", "", "checked()").getHtmlText()%><%
}
%><%=new Button("搜索", "", "searchabc()").getHtmlText()%><%
%><%=new Button("新增", "", "newRecord(tree.getRoot().getDom())").getHtmlText()%><%
%><%=new Button("全树数据", "", "showData()").getHtmlText()%><%
%><%=new Button("后台处理", "", "saveTree()").getHtmlText()%><%
%></div>
<div style="width:1101px;height:502px;border:solid #aaa;border-width:1px 1px 1px 0;">
<div id="test"></div>
<textarea id="msg" readonly wrap="off"></textarea>
</div>
</body>
<script type="text/javascript">
	var tree = new ObjectTree("test", <%=JSONEncoder.encode(tree)%>);
	$("#test").bind("mousewheel", function(e, delta){
		$(this).scrollTop($(this).scrollTop()-delta*20);
	});
	// 在默认点击之前赋值，点击事件
	tree.NodeOnClick = function(node){
		/*
		if(node.getData()["beclick"] == true){
			if(!confirm(node.getData()["text"]+" has been clicked, do you want to click it another ones ?")) return false;
		}else{
			if(!confirm(node.getData()["text"]+" will be clicked, do you want to do that ?")) return false;
		}
		*/
		var msg = showData(node);
		$(node.getDom()).add(msg).addClass("now_msg");
		//if(node.getChildren().length > 0) return false;
	};
	tree.NodeAfterDrag = function(node, oldParent, oldIndex){
		node.focus();
		var parent = node.getParent();
		var nodes = node.getParent().getChildren();
		var index = nodes.indexOf(node);
		if(parent == oldParent){
			if(parent==tree.getRoot()){
				showMsg("在树图("+parent.getData()["name"]+"<"+nodes.length+">)根节点内移动节点("+node.getData()["text"]+")["+oldIndex+"-->"+index+"]");
			}else{
				showMsg("在节点("+parent.getData()["text"]+"<"+nodes.length+">)内移动节点("+node.getData()["text"]+")["+oldIndex+"-->"+index+"]");
			}
		}else{
			if(parent==tree.getRoot()){
				showMsg("节点("+node.getData()["text"]+")从节点("+oldParent.getData()["text"]+"<"+oldParent.getChildren().length+">)["+oldIndex+"]移到树图("+parent.getData()["name"]+"<"+nodes.length+">)根节点["+index+"]");
			}else{
				if(oldParent==tree.getRoot()){
					showMsg("节点("+node.getData()["text"]+")从树图("+oldParent.getData()["name"]+"<"+oldParent.getChildren().length+">)根节点["+oldIndex+"]移到节点("+parent.getData()["text"]+"<"+nodes.length+">)["+index+"]");
				}else{
					showMsg("节点("+node.getData()["text"]+")从节点("+oldParent.getData()["text"]+"<"+oldParent.getChildren().length+">)["+oldIndex+"]移到节点("+parent.getData()["text"]+"<"+nodes.length+">)["+index+"]");
				}
			}
		}
	};
	tree.NodeOnCheck = function(node, beinit){
		if(beinit != true && !confirm(node.getData()["text"]+" will be checked， do you want to do that ?")) return false;
	};
	tree.NodeOnUncheck = function(node){
		if(!confirm(node.getData()["text"]+" will be unchecked， do you want to do that ?")) return false;
	};
	tree.NodeOnDblclick = function(node){
		node.toggle();
	};
	// 描绘树图，同时完成默认事件
	tree.draw();
	
	function saveTree(){
		var node = tree.getRoot();
		//showData(node);
		var sResult = AsControl.RunJavaMethod("com.amarsoft.app.awe.framecase.widget.ExampleObjectTree", "saveTree", JSON.stringify({"Data":node.getData()}));
		alert(sResult);
	}
	
	function showData(node){
		if(!node) node = tree.getRoot();
		return showMsg(new CLASS_FORMAT(JSON.stringify(node.getData())).format());
	}
	
	function showMsg(str){
		return $("#msg").val(str).removeClass("now_msg");
	}
	
	function searchabc(){
		tree.showSearch(function(node){
			node.focus();
		});
	}
	
	function checked(){
		if(!tree.isMultiselect()){
			showMsg("不是多选树");
			return;
		}
		var nodes = tree.getChecked(confirm("包括半选节点？"));
		var str = "选择了"+nodes.length+"个节点：";
		for(var i = 0; i < nodes.length; i++){
			str += "\n\t"+nodes[i].getAttribute("CustomerName");
		}
		showMsg(str);
	}
	
	function newRecord(btn, point){
		var node = tree.getNode(btn);
		var data = <% // 从服务端获取数据，建议RunJavaMethod
			TreeStory newNode = new TreeStory(null, "新增节点", null);
			TreeStory newNode1 = new TreeStory(null, "新增节点的子节点1", null);
			//newNode1.beclick = true;
			if(tree.isMultiselect()) newNode1.setCheck(true);
			newNode.getStorys().add(newNode1);
			TreeStory newNode2 = new TreeStory(null, "新增节点的子节点2", null);
			newNode.getStorys().add(newNode2);
			newNode.getAttributes().put("CustomerName", "新增节点客户名称");
			out.print(JSONEncoder.encode(newNode));
		%>;
		var newNode;
		switch(point){
			case 1 :
				newNode = tree.addBefore(node, data);
				break;
			case 2 :
				newNode = tree.addAfter(node, data);
				break;
			default :
				newNode = tree.addChild(node, data);
		}
		if(!newNode){
			showMsg("客户端新增失败！"); // 此时建议刷新页面以保持与服务端一致
			return;
		}
		newNode.focus();
	}
	
	function viewRecord(btn){
		var node = tree.getNode(btn);
		showMsg(""+node.getAttribute("CustomerName"));
	}
	
	function delRecord(btn){
		var node = tree.getNode(btn);
		var str = getChildrenStr(node, 1);
		if(!confirm("删除节点：\n"+str)) return;
		//showData(node);
		var sResult = AsControl.RunJavaMethod("com.amarsoft.app.awe.framecase.widget.ExampleObjectTree", "deleteStory", JSON.stringify({"Data":node.getData()}));
		alert(sResult);
		tree.removeNode(node);
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
	/*
	// 快捷点击
	// 上方向键移动点击节点
	AsLink.setShortcut("UP", function(){
		var node = tree.getClick();
		if(!node) return;
		var upnode = node.getUp();
		if(!upnode) return;
		upnode.click();
	});
	// 下方向键移动点击节点
	AsLink.setShortcut("DOWN", function(){
		var node = tree.getClick();
		if(!node) return;
		var downnode = node.getDown();
		if(!downnode) return;
		downnode.click();
	});
	// 左方向键收起点击节点
	AsLink.setShortcut("LEFT", function(){
		var node = tree.getClick();
		if(!node) return;
		node.collapse();
	});
	// 右方向键打开点击节点
	AsLink.setShortcut("RIGHT", function(){
		var node = tree.getClick();
		if(!node) return;
		node.expand();
	});
	*/
	
	function getChildrenStr(node, leave){
		var str = "\n";
		for(var j = 0; j < leave; j++){
			str += "\t";
		}
		str += node.getAttribute("CustomerName");
		for(var i = 0; i < node.getChildren().length; i++){
			str += getChildrenStr(node.getChildren()[i], leave+1);
		}
		return str;
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>