<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String orgID = CurPage.getParameter("OrgID");
	if(orgID == null || orgID == "undefined") orgID = "";
	ASObjectModel doTemp = new ASObjectModel("TeamList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setParameter("OrgID", orgID);
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function mySelectRow(){
		var teamID = getItemValue(0,getRow(),"TeamID");
		if(typeof(teamID)=="undefined" || teamID.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=请先选择相应的信息!","rightdown","");
		}else{
			AsControl.OpenView("/Common/Configurator/Authorization/TeamRuleList.jsp","TeamID="+teamID,"rightdown","");
		}
	}
	
	mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
