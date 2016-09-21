<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%
 	/* 
 		页面说明： 通过数组定义生成strip框架页面示例
 	*/
 	//定义strip数组：
 	//参数：0.是否显示, 1.标题，2.URL，3.参数串，4.高度(单位：px，默认600)
	String sTabStrip[][] = {
		{"true", "典型List", "/FrameCase/widget/dw/ExampleList.jsp", "", "400"},
		{"true", "典型Info", "/FrameCase/widget/dw/ExampleInfo.jsp", "ExampleId=2012081700000001", "500"},
		{"true", "其他List", "/FrameCase/widget/dw/ExampleList.jsp", "", "400"},
	};
%>
<div style="z-index:9999;position:absolute;right:0;top:0;background:#fff;border:1px solid #aaa;font-size:12px;">
  	<pre>
  	
  	通过数组定义生成strip框架页面示例
	1. 定义strip二维数组：
	参数：0.是否显示, 1.标题，2.URL，3，参数串，4.高度(单位：px，默认600)
	示例: String sTabStrip[][] = {
		{"true", "典型Info", "/FrameCase/widget/dw/ExampleInfo.jsp", "ExampleId=2012081700000001"},
		};
	2. include 文件 /Resources/CodeParts/Strip01.jsp
	</pre>
	<a style="position:absolute;top:5px;left:5px;" href="javascript:void(0);" onclick="$(this).parent().slideUp();">X</a>
</div>
<%@include file="/Resources/CodeParts/Strip01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>