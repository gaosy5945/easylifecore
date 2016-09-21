<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "项目管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;详细信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//定义变量
	String sSql = "";	
	String sProjectTemplet = "";
	String sProjectInfoTemplet = "";
	String sProjectType= "";
	ASResultSet rs = null;
	//获得组件参数	
	String sProjectNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));

	sSql="select ProjectType  from PROJECT_INFO where ProjectNo=:ProjectNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ProjectNo",sProjectNo));
	if(rs.next()){
	   sProjectType=DataConvert.toString(rs.getString("ProjectType"));
	}
	rs.getStatement().close(); 

	if(sProjectType == null ) sProjectType = "";
	
	//取得视图模板类型	
	sProjectTemplet = "ProjectDetail";
	sProjectInfoTemplet = "";
	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"项目管理列表","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= '"+sProjectTemplet+"' and RelativeCode like '%"+sProjectType+"%' and IsInUse='1' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	//treeview单击选中事件
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		if(sCurItemDescribe2 == "Back"){
			top.close();
		}else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root"){
			openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&ProjectNo=<%=sProjectNo%>&ProjectInfoTemplet=<%=sProjectInfoTemplet%>&ObjectType=<%=sObjectType%>","right");
			setTitle(getCurTVItem().name);
		}
	}

	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');
	expandNode('10');
	selectItem('01');
</script>
<%@ include file="/IncludeEnd.jsp"%>