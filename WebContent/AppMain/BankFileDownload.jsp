<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/IncludeBegin.jsp"%>
<html>
<head>
<title>公告信息</title>
<link rel="stylesheet" href="<%=sWebRootPath%>/AppMain/resources/css/notice.css">
<script type="text/javascript">
function openFile(url){
	popComp("DownFile","/AppMain/DownFile.jsp","FileName="+url.substring(url.lastIndexOf("/")+1)+"&FileUrl="+url.substring(0,url.lastIndexOf("/")));
}


$(function(){
	return; // 若不要滚动，请打开这段注释
	var time = null;
	var container = $(".container").mouseover(function(){
		clearTimeout(time);
	}).mouseleave(function(){
		notice();
	});
	$(".space", container).height("100%");
	notice();
	
	function notice(){
		var top = container.scrollTop();
		container.scrollTop(top+1);
		if(container.scrollTop() == top)
			container.scrollTop(0);
		time = setTimeout(notice, 15);
	}
});
</script>
</head>
<body>
<div class="container">
<div class="space"></div>
<div><%
ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select O.SerialNo,O.Actionparam from AWE_TASK_INFO O where O.StartUserID = :StartUserID order by O.SerialNo desc").setParameter("StartUserID", CurUser.getUserID()));
int i = 0;
while(rs.next() && i < 10){
%><a onclick="openFile('<%=rs.getString("ActionParam")%>')" hidefocus href="javascript:void(0)">
<span><%=rs.getString("SerialNo")%>：</span><%=rs.getString("ActionParam")%>
</a><%
i++;
}rs.close();%></div>
<div class="space"></div>
</div>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>