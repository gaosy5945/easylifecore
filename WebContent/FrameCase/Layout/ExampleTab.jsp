<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%
	/* 
	页面说明： 通过数组定义生成Tab框架页面示例
	*/
	//定义tab数组：
	//参数：0.是否显示, 1.标题，2.URL，3，参数串, 4. Strip高度(默认600px)，5. 是否有关闭按钮(默认无) 6. 是否缓存(默认是)
	String sTabStrip[][] = {
		{"true", "List", "/FrameCase/widget/dw/ExampleList.jsp", ""},
		{"true", "Info", "/FrameCase/widget/dw/ExampleInfo.jsp", "ExampleId=2013012300000001", "", "true"},
		{"true", "Frame_1", "/FrameCase/Layout/ExampleFrame.jsp", ""},
		{"true", "Frame_2", "/FrameCase/Layout/ExampleFrame.jsp", ""},
		{"true", "Tab", "/FrameCase/Layout/ExampleTab03.jsp", ""},
		{"true", "Blank", "/Blank.jsp", ""},
	};

	CurPage.setAttribute("AfterTabHtml", ""+
		new Button("新增", "", "newTab()").getHtmlText()+
		new Button("按钮", "", "alert('你点到我啦！')").getHtmlText());
%>
<div style="z-index:9999;position:absolute;right:0;bottom:0;background:#fff;border:1px solid #aaa;font-size:12px;">
  	<pre>
  	
  	通过数组定义生成Tab框架页面示例
	1. 定义tab二维数组：
	参数：0.是否显示, 1.标题，2.URL，3，参数串
	示例: String sTabStrip[][] = {
		{"true", "演示页面标题", "/FrameCase/widget/dw/ExampleInfo.jsp", "ExampleId=2013012300000001"},
		};
	2. include 文件 /Resources/CodeParts/Tab01.jsp
	</pre>
	<a style="position:absolute;top:5px;left:5px;" href="javascript:void(0);" onclick="$(this).parent().slideUp();">X</a>
</div>
<%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<script type="text/javascript">
var n = 0;
function newTab(){
	addTabStripItem('新增窗口'+(++n), '/AppMain/Blank.jsp', '');
}
function closeTab(sName, sFrameName){
	if(!frames[sFrameName]) return true;
	if($("body", frames[sFrameName].document).html()){
		return confirm("页面已经加载，是否关闭？");
	}else{
		return true;
	}
}
</script>
<%@ include file="/IncludeEnd.jsp"%>