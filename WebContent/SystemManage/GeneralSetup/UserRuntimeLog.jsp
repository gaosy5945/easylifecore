<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "页面访问时间日志"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String sHeaders[][] = {
										{"UserName","用户名称"},
										{"JspName","用户访问的页面"},
										{"BeginTime","开始访问时间"},
										{"EndTime","退出系统时间"},
										{"TimeConsuming","页面运行时间"},
									}; 
 	String sSql = "select SessionID,RuntimeID,Userid,getUserName(Userid) as UserName,JspName, BeginTime,EndTime,TimeConsuming from user_runtime where 1=1 ";
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.UpdateTable = "USER_RUNTIME";
	doTemp.setHeader(sHeaders);	
    doTemp.setKey("SessionID",true);
	doTemp.setVisible("SessionID,RuntimeID,UserID",false);	
	
	doTemp.setHTMLStyle("UserName,TimeConsuming"," style={width:80px} ");
	doTemp.setHTMLStyle("JspName"," style={width:300px} ");
	//设置对齐方式
	doTemp.setAlign("TimeConsuming","3");
	doTemp.setAlign("UserName,BeginTime,EndTime","2");
	doTemp.setAlign("JspName","1");
	doTemp.setCheckFormat("TimeConsuming","2");
	//生成查询框
	doTemp.setColumnAttribute("UserName,BeginTime,EndTime","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	
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