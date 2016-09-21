<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";

	//通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("ExampleList",Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	<%/*记录被选中时触发事件*/%>
	function mySelectRow(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if(!sExampleId) return;
		parent.OpenInfo(sExampleId);
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bHighlightFirst = true;
		my_load(2,0,'myiframe0');
		mySelectRow();
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>