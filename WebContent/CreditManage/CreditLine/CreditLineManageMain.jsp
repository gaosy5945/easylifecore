<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "授信额度调整主页面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;授信额度调整主页面&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"授信额度调整","right");
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	String sSqlTreeView = " from CODE_LIBRARY where CodeNo ='CreditLineManage' and Isinuse='1' ";
	tviTemp.initWithSql("SortNo","ItemName as ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	
	//另外两种定义树图结构的方法：SQL生成和代码生成   参见View的生成 ExampleView.jsp和ExampleView01.jsp
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	//treeview单击选中事件
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;//--获得树图的节点号码
		var sCurItemName = getCurTVItem().name;//--获得树图的节点名称
		var sCurItemDescribe = getCurTVItem().value;//--获得连接下个页面的路径及相关的参数
	
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];//--获得连接下个页面的路径
		sCurItemDescribe2=sCurItemDescribe[1];//--存放下个页面的的页面名称
		sCurItemDescribe3=sCurItemDescribe[2];//--获得要传递的参数
		sCurItemDescribe4=sCurItemDescribe[3];//--现在没有
		if(sCurItemDescribe1 != "null" && sCurItemID != "root"){
			openChildComp(sCurItemDescribe2,sCurItemDescribe1,sCurItemDescribe3);
			setTitle(getCurTVItem().name);
		}
	}
	function openChildComp(sCompID,sURL,sParameterString){
		paraStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") paraStringTmp=sParameterString;
		else paraStringTmp=sParameterString+"&";
		paraStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,paraStringTmp,"right");
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');
	selectItem('0010');
</script>
<%@ include file="/IncludeEnd.jsp"%>