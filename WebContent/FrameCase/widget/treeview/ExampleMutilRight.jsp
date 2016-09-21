<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/IncludeBegin.jsp"%>
<%@ include file="/Frame/page/jspf/include/jsp_frame_lrud.jspf"%>
<script type="text/javascript">
	changeLayout(true);
	AsControl.OpenView("/FrameCase/widget/treeview/ExampleMutilImage.jsp", "", Layout.getRegionName("SecondFrame"));
	
	parent.Layout.initRegionName("right", parent.name, Layout.getRegionName("FirstFrame"));
	parent.Layout.initRegionName("RightImage", parent.name, Layout.getRegionName("SecondFrame"));
	(function(){
		var first = parent.frames[parent.Layout.getRegionName("FirstFrame")];
		var time = null;
		time = setInterval(function(){
			if(typeof first.initTreeView != "function") return;
			
			first.initTreeView();
			clearInterval(time);
			
			var image = first.frames[first.Layout.getRegionName("SecondFrame")];
			time = setInterval(function(){
				if(typeof image.initTreeView != "function") return;
				
				image.initTreeView();
				clearInterval(time);
			}, 100);
		}, 100);
	})();
</script>
<%@ include file="/IncludeEnd.jsp"%>