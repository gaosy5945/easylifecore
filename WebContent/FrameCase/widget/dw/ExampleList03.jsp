<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例汇总列表页面
	 */
	String PG_TITLE = "示例汇总列表页面";

	//通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("ExampleList",Sqlca);
	//设置哪些字段进行小记合计
	doTemp.setColumnType("ApplySum","2");//也可以可以在DW模型里配置
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);
	dwTemp.ShowSummary = "1";//设置汇总
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
			{"true","","Button","新增","新增一条记录","newRecord()","","","",""},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()","","","",""},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()","","","",""},
			{"true","","Button","使用ObjectViewer打开","使用ObjectViewer打开","openWithObjectViewer()","","","",""},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/FrameCase/widget/dw/ExampleInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sExampleId=getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			var sReturn = AsControl.RunJavaMethodSqlca("demo.Example4RJM","deleteExample","ExampleId="+sExampleId);
			if(sReturn=="SUCCESS"){
				alert("删除成功!");
				reloadSelf();
			}			
		}
	}
	
	function viewAndEdit(){
		var sExampleId=getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/FrameCase/widget/dw/ExampleInfo.jsp","ExampleId="+sExampleId,"_self","");
	}
	
	<%/*~[Describe=使用ObjectViewer打开;]~*/%>
	function openWithObjectViewer(){
		var sExampleId=getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//使用ObjectViewer以视图001打开Example，
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init_show();
		my_load_show(2,0,'myiframe0');
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>