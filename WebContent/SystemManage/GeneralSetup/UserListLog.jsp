<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "用户访问时间日志";
	String sHeaders[][] = {
										{"ListID","序号"},
										{"UserName","用户名称"},
										{"OrgName","机构名称"},
										{"BeginTime","开始访问时间"},
										{"EndTime","退出系统时间"},
									}; 
 	String sSql = "select SessionID,ListID,UserID,UserName,OrgID,OrgName,BeginTime,EndTime from user_list where 1=1 order by ListID";
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.UpdateTable = "USER_LIST";
	doTemp.setHeader(sHeaders);	
    doTemp.setKey("SessionID",true);
	doTemp.setVisible("SessionID,UserID,OrgID",false);	
	
	//doTemp.setCheckFormat("BeginTime,EndTime","3");
	//生成查询框
	doTemp.setColumnAttribute("UserName,OrgName,BeginTime,EndTime","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20); 	//服务器分页
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				
	String sButtons[][] = {};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%@include file="/IncludeEnd.jsp"%>