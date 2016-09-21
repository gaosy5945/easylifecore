<%@ page contentType="text/html; charset=GBK"%>
<div style="z-index:9999;position:absolute;right:0;top:0;background:#fff;border:1px solid #aaa;font-size:12px;">
	<pre>
	
	单击选中列表一条记录，会触发函数mySelectRow()
	function mySelectRow(){
		viewAndEdit();//选中某记录自动展现详情
    	}
    </pre>
	<a style="position:absolute;top:5px;left:5px;" href="javascript:void(0);" onclick="$(this).parent().slideUp();">X</a>
</div>
<%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: DW单击事件示例页面
	 */
	String PG_TITLE = "DW单击事件示例页面";

	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("ExampleList",Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(15);
 
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function viewAndEdit(){
		var sExampleId=getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.PopView("/FrameCase/widget/dw/ExampleInfo.jsp","ExampleId="+sExampleId+"&PrevUrl=/FrameCase/widget/dw/ExampleList04.jsp","");
	}

	<%/*选中列表一条记录，会触发函数mySelectRow()*/%>
	function mySelectRow(){
		viewAndEdit();//选中某记录自动展现详情
    }

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>