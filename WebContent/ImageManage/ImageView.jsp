<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 
 <%-- <%@page import="com.amarsoft.app.als.image.HTMLTreeViewYX"%> --%>
 <%
 
	/*
		页面说明:影像操作页面
	 */
	 
	//获得页面参数   typeNo:影像类型 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String typeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	String sType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));//通过它进行判断是哪个节点，如该节点是授信业务
	String sApplyType = CurComp.getParameter("ApplyType");
	
	String sImageType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ImageType"));//影像类型
	
	if( sObjectNo == null ) sObjectNo = null;
	if( sObjectType == null ) sObjectType = null;
	if(typeNo==null) typeNo ="";
	if(sType==null) sType ="";
	if(sApplyType==null) sApplyType = "";
	if(sImageType==null) sImageType = "";
	
	//进行获取客户名称 add by lyi 2014/06/20
	ASResultSet rs1 = null;
	//SqlObject so1 = null;
	String sCustomerName = "";
	
	if("Customer".equals(sObjectType)){
		/* so1 = new SqlObject("select CustomerName from Customer_Info where CustomerID = :CustomerID ");
		so1.setParameter("CustomerID", sObjectNo);
		rs1 = Sqlca.getASResultSet(so1); */
		rs1 = Sqlca.getASResultSet("select CustomerName from Customer_Info where CustomerID = '"+sObjectNo+"'");
		if(rs1.next()){
			sCustomerName = rs1.getString("CustomerName");
		}
		rs1.close();
	}
	//end
	
	String sGlobalType = sObjectType.equals("Customer") ? "客户" : "业务";
	
	String PG_TITLE = sGlobalType+"影像资料"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "";
	if("Customer".equals(sObjectType)){
		PG_CONTENT_TITLE = sGlobalType +"["+ sCustomerName + "]项下影像资料&nbsp;&nbsp;"; //默认的内容区标题
	}else{
		PG_CONTENT_TITLE = sGlobalType +"["+ sObjectNo + "]项下影像资料&nbsp;&nbsp;"; //默认的内容区标题
	}
	
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "300";//默认的treeview宽度
	/* if(typeNo.length()>0){
		PG_LEFT_WIDTH = "1";
	} */
	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"影像","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//TODO 影像类型过滤，需要详细设计，暂时从简
	String sFilter =  "";
	String sAppend = " ";
	if( sObjectType.equals( "Customer" ) ){
		String sCustomerType = "";
		/* String sSql = "select CustomerType from CUSTOMER_INFO where CustomerID = :CustomerID ";
		sCustomerType = Sqlca.getString(new SqlObject(sSql).setParameter("CustomerID",sObjectNo)); */
		sCustomerType = Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID = '"+sObjectNo+"' ");
		sAppend = " and ECM_IMAGE_TYPE.TypeNo Like '10%' ";
	}
	
	
	/* String sTypeName = Sqlca.getString(new SqlObject("Select TypeName From ECM_IMAGE_TYPE Where TypeNo = :TypeNo").setParameter("TypeNo",sTypeNo));
	String sCount = Sqlca.getString( new SqlObject( "(Select Count(*) FROM ECM_PAGE Where ECM_PAGE.ObjectNo = '"+sObjectNo+"' and ECM_PAGE.TypeNo Like :TypeNo )" ).setParameter("TypeNo",sTypeNo+"%"));
	if( sTypeName == null ) sTypeName = "";
	if( sCount == null ) sCount = "";
	String sTitle = sGlobalType + "【" + sObjectNo +"】项下的影像资料：" +  "【" + sTypeName +"】(" + sCount + "件)"; */
	
	//定义树图结构
	String sSqlTreeView = "from ECM_IMAGE_TYPE where  IsInUse = '1' " ; //+ sAppend
	//tviTemp.initWithSql("TypeNo","case when (Select Count(*) FROM ECM_PAGE Where ECM_PAGE.ObjectNo = '"+sObjectNo+"' and ECM_PAGE.documentId is not null and ECM_PAGE.TypeNo Like ECM_IMAGE_TYPE.TypeNo || '%') > 0 then ( TypeName || '( <font color=\"red\">' || (Select Count(*) FROM ECM_PAGE Where ECM_PAGE.ObjectNo = '"+sObjectNo+"' and ECM_PAGE.TypeNo Like ECM_IMAGE_TYPE.TypeNo || '%') || '</font> 件)') else TypeName end as TypeName ","TypeName","","",sSqlTreeView,"Order By TypeNo",Sqlca);
	tviTemp.initWithSql("TypeNo","TypeName","","","",sSqlTreeView,"Order By TypeNo",Sqlca);
	 //查询总数
	String querySumSql = "select count(*) as cc, typeNo from ECM_PAGE where ECM_PAGE.objectNo='"+sObjectNo+"' and  ECM_PAGE.documentId is not null and length(ECM_PAGE.documentId)>0 group  by ECM_PAGE.typeNo ";
	ASResultSet rs = Sqlca.getASResultSet( querySumSql);
	StringBuffer sbuf = new StringBuffer();
	while(rs.next()){
		int cc = rs.getInt("cc");
		String my_typeNo = rs.getString("typeNo");
		sbuf.append("setItemName('"+my_typeNo+"', getItemName('"+my_typeNo+"')+' ( " + cc + " 件)" +"');");
	}
	if(rs!=null) {
		rs.close();
	}

%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	/*影像类型 */
	var sTypeNo="<%=typeNo%>"; 
	//treeview单击选中事件
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;//--获得树图的节点号码
		//alert(sCurItemID);
		if( sCurItemID != "null" && sCurItemID != "root" && hasChild(getCurTVItem().id) ){
			var param = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&TypeNo="+sCurItemID;
			var sReadOnly = "All";//All可查看、上传及删除图片，ReadOnly仅展示图片
			if(sReadOnly == "All"){
				OpenComp("Page111", "/ImageManage/ImagePage.jsp", param, "right" );
			}else{
				OpenComp("Page222", "/ImageTrans/ImageTrans.jsp", param, "right" );	
			}
			
			//AsControl.OpenView( "/ImageTrans/ImageTrans.jsp", param, "right" );
			if("Customer"== "<%=sObjectType%>"){
				setTitle( "<%=sGlobalType%>【<%=sCustomerName%>】项下的影像资料：【" + getCurTVItem().name + "】" );
			}else{
				setTitle( "<%=sGlobalType%>【<%=sObjectNo%>】项下的影像资料：【" + getCurTVItem().name + "】" );
			}
		}
	}
	
	function expandAll(){
		for( var i = 0; i < nodes.length; i++ ){
			if( !hasChild(nodes[i].id) ) expandNode( nodes[i].id );
		}
		if(sTypeNo.length>0){
			selectItem(sTypeNo);
		}
		//用于显示各个项的数目信息
		<%=sbuf.toString()%> 
	}
	
	function initTreeView(){
		<%-- <%=tviTemp.generateHTMLTreeView().replaceAll( "addItem", "addItemYX" )%> --%>
		<%=tviTemp.generateHTMLTreeView()%>
	}
	
	initTreeView();
	expandAll();
</script>
<%@ include file="/IncludeEnd.jsp"%>
