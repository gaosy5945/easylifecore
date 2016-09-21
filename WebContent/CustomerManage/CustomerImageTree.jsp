<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%>
 

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	String sSql = "";	//--存放sql语句
	String sCustomerType = "";//--客户类型	
	ASResultSet rs = null;//--存放结果
	//获得组件参数	,客户代码
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
	<%	
	//取得客户类型
	sSql = "select CustomerType from CUSTOMER_INFO where CustomerID = :CustomerID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sObjectNo));
	if(rs.next()){
		sCustomerType = rs.getString("CustomerType");
	}
	rs.getStatement().close();
	if(sCustomerType == null) sCustomerType = "";

	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"客户影像信息","right");
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//TODO 影像类型过滤，需要详细设计，暂时从简
	String sFilter = "";
	if( sCustomerType.startsWith( "01" ) ) sFilter = "1020";
	else if( sCustomerType.startsWith( "02" ) ) sFilter = "1020";
	else if( sCustomerType.startsWith( "03" ) ) sFilter = "1010";
	String sAppend = " and TypeNo Like '" + sFilter + "%' ";

	//定义树图结构
	String sSqlTreeView = "from ECM_IMAGE_TYPE where IsInUse = '1' " + sAppend;
	tviTemp.initWithSql("TypeNo","case when (Select Count(*) FROM ECM_PAGE Where ECM_PAGE.ObjectNo = '"+sObjectNo+"' and ECM_PAGE.TypeNo Like ECM_IMAGE_TYPE.TypeNo || '%') > 0 then ( TypeName || '( <font color=\"red\">' || (Select Count(*) FROM ECM_PAGE Where ECM_PAGE.ObjectNo = '"+sObjectNo+"' and ECM_PAGE.TypeNo Like ECM_IMAGE_TYPE.TypeNo || '%') || '</font> 件)') else TypeName end as TypeName ","TypeName","","",sSqlTreeView,"Order By TypeNo",Sqlca);
	%>
<%/*~END~*/%>

<html>
<head>
<title>影像信息</title>
<style type="text/css">
	.no_select {
		-moz-user-select:none;
	}
</style>
</head>
<body style="overflow: hidden;width:100%;height:100%;margin:0;">
		<iframe name="left" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0  ></iframe>
</body>
</html>

<script type="text/javascript">
	//treeview单击选中事件
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;//--获得树图的节点号码
		if( sCurItemID != "null" && sCurItemID != "root" && hasChild(getCurTVItem().id) ){
			var param = "ObjectType=Customer&ObjectNo=<%=sObjectNo%>&TypeNo="+sCurItemID;
			AsControl.OpenView( "/ImageManage/ImagePage.jsp", param, "frameright" );
		}
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView().replaceAll( "addItem", "addItemYX" )%>
	}
	
	function expandAll(){
		for( var i = 0; i < nodes.length; i++ ){
			if( !hasChild(nodes[i].id) ) expandNode( nodes[i].id );
		}
	}
		
	startMenu();
	expandAll();
</script>
<%@ include file="/IncludeEnd.jsp"%>