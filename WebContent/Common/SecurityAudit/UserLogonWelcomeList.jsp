<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
 	/*用户登录信息一览*/
	sASWizardHtml = "<font color=red>本页面数据量较大，请通过查询条件查询</font>";
	ASObjectModel doTemp = new ASObjectModel("UserLogonWelcomeList");
	doTemp.setJboWhereWhenNoFilter(" and 1=2 ");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(40); //服务器分页
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	/*~[Describe=选中某个用户登陆信息,联动显示该用户登陆的详情信息;]~*/
	function mySelectRow(){
		var sUserID = getItemValue(0,getRow(),"UserID");
		if(typeof(sUserID)=="undefined" || sUserID.length==0) {
		}else{
			OpenPage("/Common/SecurityAudit/AuditUserLogonList.jsp?UserID="+sUserID,"rightdown","");
		}
	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>