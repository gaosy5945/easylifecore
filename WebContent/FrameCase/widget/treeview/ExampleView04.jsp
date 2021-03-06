<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
<div style="z-index:9999;position:absolute;right:0;top:0;background:#fff;border:1px solid #aaa;font-size:12px;">
 	<pre>
 	
 	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"多选测试","right");
 	...
 	tviTemp.MultiSelect = true;//设置树图为多选,树图变为多选
 	
 	JS方法：
 	var nodes = getCheckedTVItems();//获取已经选中节点的ID
 	setCheckTVItem('节点ID', true);//设置节点为选中状态
 	</pre>
	<a style="position:absolute;top:5px;left:5px;" href="javascript:void(0);" onclick="$(this).parent().slideUp();">X</a>
 </div>
 <%
	/*
		页面说明: 多选树图
	 */
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"多选测试","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
	tviTemp.MultiSelect = true;//设置树图为多选
	//通过insertFolder和insertPage生成树图
	tviTemp.insertFolder("1", "root", "节点1", "1", "", 1);
	tviTemp.insertFolder("2", "root", "节点2", "2", "", 2);
	tviTemp.insertFolder("21", "2", "节点3", "21", "", 1);
	tviTemp.insertPage("211", "21", "节点4", "211", "", 1);
	tviTemp.insertPage("212", "21", "节点5", "212", "", 2);
	tviTemp.insertPage("213", "21", "节点6", "213", "", 3);
	tviTemp.insertPage("22", "2", "节点7", "22", "", 2);
	tviTemp.insertPage("23", "2", "节点8", "23", "", 3);
	
	String sButtons[][] = {
		{"true","","Button","标记节点","","testChecked(getMarkedTVItems())","","","",""},
		{"true","","Button","选择节点","","testChecked(getCheckedTVItems())","","","",""},
		{"true","","Button","最上层选择节点","","testChecked(getTopCheckItems())","","","",""},
		{"true","","Button","最底层选择节点","","testChecked(getBottomCheckItems())","","","",""},
	};
%>
<html>
<body style="overflow: hidden;">
	<table width=100% height=100% cellspacing="0" cellpadding="0" border="0">
		<tr style="height: 30px;">
			<td><%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%></td>
		</tr>
		<tr> 
  			<td id="myleft"  align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
		</tr>
	</table>
</body>
</html>
<script type="text/javascript">
	function TreeViewOnClick(){
		var node = getCurTVItem();
		var str = "";
		for(var o in node){
			str += o + " = " + node[o] + "\n";
		}
		alert(str);
	}
	
	function testChecked(nodes){
		if(nodes.length < 1){
			alert("未选择节点");
			return;
		}
		var str = "";
		for(var i = 0; i < nodes.length; i++){
			if(i != 0) str += "，";
			str += nodes[i].name;
		}
		alert("您选择了节点【"+str+"】，共【"+nodes.length+"】个记录")
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		expandNode('1');
		expandNode('2');
	}
	
	initTreeView();
	setCheckTVItem('211', true);
</script>
<%@ include file="/IncludeEnd.jsp"%>