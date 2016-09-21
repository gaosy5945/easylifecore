<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
 	/* 
 		页面说明： 通过数组定义生成strip框架页面示例
 	*/
 	//定义strip数组：
 	//参数：0.是否显示, 1.标题，2.高度(px)，3.组件ID(可以为空)，4.URL，5，参数串，6.事件
	String sStrips[][] = {
		{"true","典型List" ,"500","","/FrameCase/widget/dw/ExampleList.jsp","",""},
		{"true","典型Info" ,"500","","/FrameCase/widget/dw/ExampleInfo.jsp","ExampleId=2012081700000001",""},
	};
 	String sButtons[][] = {
		{"true","","Button","按钮1","按钮1","aaa()","","","","btn_icon_edit"},
		{"true","","Button","按钮2","按钮2","bbb()","","","","btn_icon_help"},
 	};
%>
<div style="z-index:9999;position:absolute;right:0;top:0;background:#fff;border:1px solid #aaa;font-size:12px;">
  	<pre>
  	
  	通过数组定义生成Strip框架页面示例
	1. 定义strip二维数组：
	//参数：0.是否显示, 1.标题，2.高度(px)，3.组件ID(可以为空)，4.URL，5，参数串，6.事件
	示例: String sStrips[][] = {
		{"true","典型List" ,"500","","/FrameCase/widget/dw/ExampleList.jsp","",""},
		{"true","典型Info" ,"500","","/FrameCase/widget/dw/ExampleInfo.jsp","ExampleId=2012081700000001",""},
	};
	2. include 文件 /Resources/CodeParts/Strip05.jsp
	</pre>
	<a style="position:absolute;top:5px;left:5px;" href="javascript:void(0);" onclick="$(this).parent().slideUp();">X</a>
</div>
<%@include file="/Resources/CodeParts/Strip05.jsp"%>
<script type="text/javascript">
	function aaa(){
		alert(1);
	}
	
	function bbb(){
		alert(2);
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>