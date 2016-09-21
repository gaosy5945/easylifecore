<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "业务信息提醒"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;详细信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"业务信息提醒","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//生成本次搜索的Sql语句
	String sSql = "select SortNo,ItemName,ItemNo from CODE_LIBRARY where CodeNo= 'BusinessAlert' Order By SortNo";
	ASResultSet rs=Sqlca.getASResultSet(sSql);
	String sSortNo="";
	String sItemName="";
	String sItemNo="";
	while(rs.next()){
		sSortNo = rs.getString("SortNo");
		sItemName = rs.getString("ItemName");
		sItemNo = rs.getString("ItemNo");
		sSql = "select count(*) from WORK_REMIND  where RemindType=:RemindType and InputUserID=:InputUserID";
		ASResultSet rs1=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("RemindType",sSortNo).setParameter("InputUserID",CurUser.getUserID()));
		rs1.next();
		sItemName += "("+rs1.getInt(1)+")件"; 
		rs1.getStatement().close();
		tviTemp.insertPage(sSortNo,"root",sItemName,sItemNo,"",0);
	}
	rs.getStatement().close();
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	//treeview单击选中事件
	function TreeViewOnClick(){
		var sCurItemNo = getCurTVItem().value;
		if(sCurItemNo != "root"){
			OpenComp("BusinessAlertList","/DeskTop/BusinessAlertList.jsp","RemindType="+sCurItemNo,"right");
			setTitle(getCurTVItem().name);
		}
	}

	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
	
	startMenu();
	expandNode('root');
</script>
<%@ include file="/IncludeEnd.jsp"%>