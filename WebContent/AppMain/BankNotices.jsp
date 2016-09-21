<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/IncludeBegin.jsp"%>
<html>
<head>
<title>公告信息</title>
<link rel="stylesheet" href="<%=sWebRootPath%>/AppMain/resources/css/notice.css">
<script type="text/javascript">
/* function openFile(sDocNo){
    AsControl.PopView("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+sDocNo+"&RightType=ReadOnly", "dialogWidth=650px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
} */


function openFile(boardNo,docNo){
    AsControl.PopView("/AppConfig/BoardManage/BoardDetailInfo.jsp", "BoardNo="+boardNo+"&DocNo="+docNo+"&RightType=ReadOnly&type=1", "dialogWidth=650px;dialogHeight=700px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
com.amarsoft.are.jbo.BizObjectManager boardM = com.amarsoft.are.jbo.JBOFactory.getBizObjectManager("jbo.sys.BOARD_LIST");
boardM.getQueryProperties().setProperty("largeResultWarn", "2000");
com.amarsoft.are.jbo.BizObjectQuery boardQ = boardM.createQuery("select O.BoardNo, O.BoardTitle, O.IsNew, O.IsEject, O.DocNo from O where O.IsPublish = '1' and (O.ShowToRoles is null or O.ShowToRoles in (select UR.RoleID from jbo.sys.USER_ROLE UR where UR.UserID=:UserID)) order by O.BoardNo desc");
boardQ.setParameter("UserID", CurUser.getUserID());
List<com.amarsoft.are.jbo.BizObject> boardBos = boardQ.getResultList(false);
DecimalFormat format = new DecimalFormat(String.valueOf(boardBos.size()).replaceAll("\\d", "0"));
for(int i = 0; i < boardBos.size(); i++){
%><a onclick="openFile('<%=boardBos.get(i).getAttribute("BoardNo").getString()%>','<%=boardBos.get(i).getAttribute("DocNo").getString()%>')" hidefocus href="javascript:void(0)">
<span><%=format.format(i+1)%>、</span><%=boardBos.get(i).getAttribute("BoardTitle").getString()%>
<%if("1".equals(boardBos.get(i).getAttribute("IsNew").getString())){%><img src="<%=sWebRootPath%>/Frame/page/resources/images/common/new.gif"/><%}%></a><%
}%></div>
<div class="space"></div>
</div>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>