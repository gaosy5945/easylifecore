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
<%--��ʱ���ã��ݲ��ṩӦ��ʹ��---%>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/widget/objecttree.css">
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/js/widget/objecttree.js"></script>
<%--------------------------%>
<%
	boolean special = true;

	ObjectTree tree = new ObjectTree("������ͼ");
	tree.setMultiselect(special);
	if(special){
		/*
		tree.procureAppendHtml().append(new Button("ǰ��", "", "newRecord(this, 1)", "", "noicon").getHtmlText());
		tree.procureAppendHtml().append(new Button("����", "", "newRecord(this, 2)", "", "noicon").getHtmlText());
		tree.procureAppendHtml().append(new Button("����", "", "newRecord(this, 3)", "", "noicon").getHtmlText());
		tree.procureAppendHtml().append(new Button("����", "", "viewRecord(this)", "", "noicon").getHtmlText());
		tree.procureAppendHtml().append(new Button("ɾ��", "", "delRecord(this)", "", "noicon").getHtmlText());
		*/
		tree.procureAppendHtml().append("&nbsp;<a style=\"color:#0f0;\" href=\"javascript:void(0);\" onclick=\"newRecord(this, 1);AsLink.stopEvent(event);return false;\">ǰ��</a>");
		tree.procureAppendHtml().append("&nbsp;<a style=\"color:#0f0;\" href=\"javascript:void(0);\" onclick=\"newRecord(this, 2);AsLink.stopEvent(event);return false;\">����</a>");
		tree.procureAppendHtml().append("&nbsp;<a style=\"color:#0f0;\" href=\"javascript:void(0);\" onclick=\"newRecord(this, 3);AsLink.stopEvent(event);return false;\">����</a>");
		tree.procureAppendHtml().append("&nbsp;<a style=\"color:#00f;\" href=\"javascript:void(0);\" onclick=\"viewRecord(this);AsLink.stopEvent(event);return false;\">����</a>");
		tree.procureAppendHtml().append("&nbsp;<a style=\"color:#f00;\" href=\"javascript:void(0);\" onclick=\"delRecord(this);AsLink.stopEvent(event);return false;\">ɾ��</a>");
	}
	int I = 2, J = 2, K = 0, M = 2, N = 2;
	for(int i = 0; i < I; i++){
		String iconi = null;
		if(special && i == 0) iconi = "moveicon";
		if(special && i == 1) iconi = "ordericon";
		TreeStory node = new TreeStory(iconi, "�ڵ�"+i, "����������");
		tree.getStorys().add(node);

		node.getAttributes().put("CustomerName", "ĳĳĳ��˾"+i);
		if(special && (i == 1 || i == 2)) continue;
		if(special && i == 3) node.setExpand(true);
		
		for(int j = 0; j < J; j++){
			TreeStory node1 = new TreeStory(null, "�ڵ�"+i+"."+j, null);
			node.getStorys().add(node1);
		
			node1.getAttributes().put("CustomerName", "ĳĳĳ��˾"+i+"."+j);
			
			for(int k = 0; k < K; k++){
				String icon = null;
				if(special && k == 0) icon = "ordericon";
				TreeStory node2 = new TreeStory(icon, "�ڵ�"+i+"."+j+"."+k, null);
				node1.getStorys().add(node2);
				if(j == 0 && k == 0){
					if(tree.isMultiselect()) node2.setCheck(true);
					if(special && i == 4) node2.setBeclick(true);
				}
				
				node2.getAttributes().put("CustomerName", "ĳĳĳ��˾"+i+"."+j+"."+k);
				
				for(int m = 0; m < M; m++){
					TreeStory node3 = new TreeStory(null, "�ڵ�"+i+"."+j+"."+k+"."+m, null);
					node2.getStorys().add(node3);
					for(int n = 0; n < N; n++){
						TreeStory node4 = new TreeStory(null, "�ڵ�"+i+"."+j+"."+k+"."+m+"."+n, null);
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
%><%=new Button("��ȡѡ��ڵ�", "", "checked()").getHtmlText()%><%
}
%><%=new Button("����", "", "searchabc()").getHtmlText()%><%
%><%=new Button("����", "", "newRecord(tree.getRoot().getDom())").getHtmlText()%><%
%><%=new Button("ȫ������", "", "showData()").getHtmlText()%><%
%><%=new Button("��̨����", "", "saveTree()").getHtmlText()%><%
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
	// ��Ĭ�ϵ��֮ǰ��ֵ������¼�
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
				showMsg("����ͼ("+parent.getData()["name"]+"<"+nodes.length+">)���ڵ����ƶ��ڵ�("+node.getData()["text"]+")["+oldIndex+"-->"+index+"]");
			}else{
				showMsg("�ڽڵ�("+parent.getData()["text"]+"<"+nodes.length+">)���ƶ��ڵ�("+node.getData()["text"]+")["+oldIndex+"-->"+index+"]");
			}
		}else{
			if(parent==tree.getRoot()){
				showMsg("�ڵ�("+node.getData()["text"]+")�ӽڵ�("+oldParent.getData()["text"]+"<"+oldParent.getChildren().length+">)["+oldIndex+"]�Ƶ���ͼ("+parent.getData()["name"]+"<"+nodes.length+">)���ڵ�["+index+"]");
			}else{
				if(oldParent==tree.getRoot()){
					showMsg("�ڵ�("+node.getData()["text"]+")����ͼ("+oldParent.getData()["name"]+"<"+oldParent.getChildren().length+">)���ڵ�["+oldIndex+"]�Ƶ��ڵ�("+parent.getData()["text"]+"<"+nodes.length+">)["+index+"]");
				}else{
					showMsg("�ڵ�("+node.getData()["text"]+")�ӽڵ�("+oldParent.getData()["text"]+"<"+oldParent.getChildren().length+">)["+oldIndex+"]�Ƶ��ڵ�("+parent.getData()["text"]+"<"+nodes.length+">)["+index+"]");
				}
			}
		}
	};
	tree.NodeOnCheck = function(node, beinit){
		if(beinit != true && !confirm(node.getData()["text"]+" will be checked�� do you want to do that ?")) return false;
	};
	tree.NodeOnUncheck = function(node){
		if(!confirm(node.getData()["text"]+" will be unchecked�� do you want to do that ?")) return false;
	};
	tree.NodeOnDblclick = function(node){
		node.toggle();
	};
	// �����ͼ��ͬʱ���Ĭ���¼�
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
			showMsg("���Ƕ�ѡ��");
			return;
		}
		var nodes = tree.getChecked(confirm("������ѡ�ڵ㣿"));
		var str = "ѡ����"+nodes.length+"���ڵ㣺";
		for(var i = 0; i < nodes.length; i++){
			str += "\n\t"+nodes[i].getAttribute("CustomerName");
		}
		showMsg(str);
	}
	
	function newRecord(btn, point){
		var node = tree.getNode(btn);
		var data = <% // �ӷ���˻�ȡ���ݣ�����RunJavaMethod
			TreeStory newNode = new TreeStory(null, "�����ڵ�", null);
			TreeStory newNode1 = new TreeStory(null, "�����ڵ���ӽڵ�1", null);
			//newNode1.beclick = true;
			if(tree.isMultiselect()) newNode1.setCheck(true);
			newNode.getStorys().add(newNode1);
			TreeStory newNode2 = new TreeStory(null, "�����ڵ���ӽڵ�2", null);
			newNode.getStorys().add(newNode2);
			newNode.getAttributes().put("CustomerName", "�����ڵ�ͻ�����");
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
			showMsg("�ͻ�������ʧ�ܣ�"); // ��ʱ����ˢ��ҳ���Ա���������һ��
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
		if(!confirm("ɾ���ڵ㣺\n"+str)) return;
		//showData(node);
		var sResult = AsControl.RunJavaMethod("com.amarsoft.app.awe.framecase.widget.ExampleObjectTree", "deleteStory", JSON.stringify({"Data":node.getData()}));
		alert(sResult);
		tree.removeNode(node);
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
	/*
	// ��ݵ��
	// �Ϸ�����ƶ�����ڵ�
	AsLink.setShortcut("UP", function(){
		var node = tree.getClick();
		if(!node) return;
		var upnode = node.getUp();
		if(!upnode) return;
		upnode.click();
	});
	// �·�����ƶ�����ڵ�
	AsLink.setShortcut("DOWN", function(){
		var node = tree.getClick();
		if(!node) return;
		var downnode = node.getDown();
		if(!downnode) return;
		downnode.click();
	});
	// ������������ڵ�
	AsLink.setShortcut("LEFT", function(){
		var node = tree.getClick();
		if(!node) return;
		node.collapse();
	});
	// �ҷ�����򿪵���ڵ�
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