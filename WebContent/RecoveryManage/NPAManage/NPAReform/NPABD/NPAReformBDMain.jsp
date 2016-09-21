<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "重组管理主界面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;重组管理主界面&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "1";//默认的treeview宽度

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"重组管理主界面","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	String sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'NPAReformBDList' and IsInUse = '1' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;

		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];  //代码表描述字段中用@分隔的第1个串:url
		sCurItemDescribe2=sCurItemDescribe[1];  //代码表描述字段中用@分隔的第2个串:name
		sCurItemDescribe3=sCurItemDescribe[2];  //代码表描述字段中用@分隔的第3个串，根据情况，还可以很多:parameter
		//重组方案信息列表
		if (sCurItemDescribe2=="NPAReformBDList1"){
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName=重组方案信息列表","right");
			setTitle(sCurItemName);
		}
		//goback
		if (sCurItemDescribe2=="goBack"){
			OpenPage("/Main.jsp","_self","");
		}
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	startMenu();
	expandNode('root');
	OpenComp("NPAReformBDList1","/RecoveryManage/NPAManage/NPAReform/NPABD/NPAReformBDList1.jsp","ComponentName=重组方案信息列表","right");
</script>
<%@ include file="/IncludeEnd.jsp"%>