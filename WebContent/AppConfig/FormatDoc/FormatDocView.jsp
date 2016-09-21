<%@page import="com.amarsoft.biz.formatdoc.model.*"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String sDocID    = CurPage.getParameter("DocID");    		//调查报告文档类别
	String sObjectNo = CurPage.getParameter("ObjectNo"); 		//业务流水号
	String sObjectType = CurPage.getParameter("ObjectType"); 	//对象类型
	String sMethod = CurPage.getParameter("Method");
	if(sDocID==null) sDocID="";
	if(sMethod==null) sMethod="";

	String PG_TITLE = "格式化报告"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;格式化报告信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
    String firstNodeID = "";
	
	String sExcludeDirIds =CurPage.getParameter("ExcludeDirIds"); 		//排除的节点
	IFormatTool formatTool = FormatToolManager.getFormatTool(sDocID,sExcludeDirIds);
	firstNodeID = formatTool.getFirstNodeID(CurUser,sObjectType,sObjectNo,sDocID); //默认打开页面
	
  	//定义Treeview
  	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"格式化报告","right");
  	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	String sSqlTreeView = " from AWE_ERPT_DATA where RelativeSerialNo in "+
			" (select SerialNo from AWE_ERPT_RECORD where ObjectType='"+sObjectType+"' and ObjectNo='"+sObjectNo+"' and DocID='"+sDocID+"')" ;
	tviTemp.initWithSql("TreeNo","DirName","SerialNo","","",sSqlTreeView,"Order By SerialNo",Sqlca);
	
%><%@ include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript">
	function TreeViewOnClick(){
		var sCurItemText = getCurTVItem().name;
		var sCurItemValue = getCurTVItem().value;
		if(getCurTVItem().type=="page"){
			setTitle(sCurItemText);
			AsControl.OpenView("/AppConfig/FormatDoc/InvokeTemplate.jsp","Method=<%=sMethod%>&DataSerialNo="+sCurItemValue,"right","");
		}
	}

	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItem('<%=firstNodeID%>');
	}

	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>