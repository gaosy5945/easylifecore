<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%CurPage.setAttribute("HideMinButton", "true");%>
<%@include file="/Resources/CodeParts/Frame03.jsp"%>
<style>
.leftright #Border {
	border-left-width: 0;
}
</style>
<script type="text/javascript">
	myleft.width=500;
	OpenMenuTree();
	
	function OpenMenuTree(sDefaultNode){
		var sPara = "";
		if(sDefaultNode) sPara = "DefaultNode="+sDefaultNode;
		AsControl.OpenView("/AppConfig/MenuManage/MenuTree.jsp", sPara, "frameleft");
	}
	
	function OpenMenuInfo(sMenuID){
		var sPara = "";
		if(sMenuID) sPara = "MenuID="+sMenuID;
		AsControl.OpenView("/AppConfig/MenuManage/MenuInfo.jsp", sPara, "frameright");
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>