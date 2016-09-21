<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "客户信用信息管理"; //-- 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;详细信息&nbsp;&nbsp;"; //--默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//--默认的内容区文字
	String PG_LEFT_WIDTH = "200";//--默认的treeview宽度
	//定义变量
	String sSql = "";	//--存放sql语句
	String sCustomerType = "";//--客户类型	
	String sCustomerTemplet = "";//--存放custmerview页面树图的CodeNo
	String sCustomerInfoTemplet = "";//--存放调用的模板
	String sModelType = "";//--存放评估模型类型
	ASResultSet rs = null;//--存放结果集
	//获得组件参数	,客户代码
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
		
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"客户信用信息管理","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'CustomerCreditView' and isinuse = '1' ";
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
		var sCurItemID = getCurTVItem().id;//--获得树图的节点号码
		var sCurItemName = getCurTVItem().name;//--获得树图的节点名称
		var sCurItemDescribe = getCurTVItem().value;//--获得连接下个页面的路径及相关的参数
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];//--获得连接下个页面的路径
		sCurItemDescribe2=sCurItemDescribe[1];//--存放下个页面的的页面名称		
		sCustomerID = "<%=sCustomerID%>";//--获得客户代码
				
		if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root"){
			openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ObjectNo="+sCustomerID+"&ComponentName="+sCurItemName+"&CustomerID="+sCustomerID+"&ObjectType=Customer");
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