<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例可编辑列表
	 */
	String PG_TITLE = "示例可编辑列表";
	//通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("ExampleList",Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(15);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()","","","",""},
		{"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()","","","",""},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		as_add("myiframe0");
	}
	function saveRecord(){
		setItemValue(0,getRow(),"ExampleId",getSerialNo("EXAMPLE_INFO","ExampleId"));
		as_save("myiframe0");
	}
	function deleteRecord(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init_show();
		my_load_show(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>