 
  <%@ page contentType="text/html; charset=GBK"%>
<!DOCTYPE>

<%@page import="com.amarsoft.app.als.sys.widget.TreeTable"%><script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/js/jquery/jquery.treeTable.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/js/jquery/jquery.treeTable.extends.js"></script>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/css/jquery.treeTable.css"></link>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/css/jquery.treeTable.extends.css"></link>
<style type="text/css">
 body{font-size:14px;}
 .treetable{font-size:12px;margin:10px;width:95%;border:none;}
 .treetable thead tr th{padding:6px 20px 6px auto;font-size:14px;font-weight: bold;border:none;border-top: 1px solid #369;border-bottom: 1px solid #369;}
 .treetable tbody tr td{padding:3px 20px 3px auto;border-bottom: 1px dotted #369;}
/*已移除*/
.treetable tbody tr.removed td{text-decoration:line-through;color: #F00;}
/*在被删除的行里，去除该单元格的删除线*/
.treetable tbody tr.removed .noremoved{text-decoration:none;}
/*修改过*/
.treetable tbody tr.changed td{color: #00F;}
/*新建立*/
.treetable tbody tr.new td{color:#008000;}
.newbutton{padding:2px;text-decoration: none;}
.newbutton:hover{color:#F00;}

/*-------------------------------------*/
.mydiv{font-size:14px;padding:3px;}
#normalAction,#revisionAction{text-decoration: none;padding:2px;}
#normalAction:hover,#revisionAction:hover{color:#DAA520;}
.actived{border:1px solid #B0C4DE;background-color: #FAFAD2;}
</style>
<body>
<div id="buttonBar">
<table>
	<tr height=1 id="ButtonTR"> 
		<td id="ListButtonArea" class="ListButtonArea" valign=top> 
			<%@ include file="/Frame/page/jspf/ui/widget/buttonset_dw.jspf"%>
		</td>
	</tr>
</table>
</div>
<script type="text/javascript">
	function getValue(obj,filedName){
		filedName=filedName.toUpperCase();
		var currentRow = $(obj).parents("tr");
		var nodeData=$(currentRow).attr("nodeData"); 
		nodeData=JSON.parse(nodeData);
		if(!nodeData[filedName]) return ""; 
		return nodeData[filedName];
	}

	function initTreeTable(tableid){
	    table = $("table."+tableid); 
	    //生成treeTable
	    table.treeTable({initialState:"expanded"});
	    //给表绑定移入改变背景，单击高亮事件
	    table.tableLight();
	}
	
	$(document).ready(function() {
	    table = $("table.treeTable1"); 
	    //生成treeTable
	    table.treeTable({initialState:"expanded"});
	    //给表绑定移入改变背景，单击高亮事件
	    //table.tableLight();
	    return;
	});
</script>


