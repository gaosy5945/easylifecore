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
	
	String sRight = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Right"));//影像类型
	if(sRight == null) sRight = "All";
	
	if( sObjectNo == null ) sObjectNo = null;
	if( sObjectType == null ) sObjectType = null;
	if(typeNo==null) typeNo ="";
	if(sType==null) sType ="";
	if(sApplyType==null) sApplyType = "";
	if(sImageType==null) sImageType = "";
	
	//进行获取客户名称 add by lyi 2014/06/20
	String sCustomerName = "";
	
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
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"影像资料","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//TODO 影像类型过滤，需要详细设计，暂时从简
	String sFilter =  "";
	String sAppend = " ";
	if( sObjectType.equals( "Customer" ) ){
		String sCustomerType = "";
		sCustomerType = Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID = '"+sObjectNo+"' ");
		if( sCustomerType != null ){
			if( sCustomerType.startsWith( "01" ) ) sFilter = "1020";
			else if( sCustomerType.startsWith( "02" ) ) sFilter = "1020";
			else if( sCustomerType.startsWith( "03" ) ) sFilter = "1010";
		}
		sAppend = " and ECM_IMAGE_TYPE.TypeNo Like '" + sFilter + "%' ";
	}else if( sObjectType.equals( "Business" ) ){
		String sBusinessType = Sqlca.getString("Select BusinessType From BUSINESS_APPLY "+
				" Where SerialNo = '"+sObjectNo+"' ");
		if( sBusinessType == null ) sBusinessType = " ";
		sFilter = "%";
		/* sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA Where ProductID = '"+ sBusinessType +"') "; */
		sAppend += " and TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA Where '"+ sBusinessType +"'  like ProductID||'%' ) ";
	}else if( sObjectType.equals( "AccountChangeType" ) ){//账号变更影像类型
		sObjectType="CBCreditApply";
		sAppend += " and TypeNo In ('40','4010' ) ";
		sFilter = "4010";
	}else if(sObjectType.equals("AheadType")){//提前还款扫描
		sObjectType="CBCreditApply";
		sAppend += " and TypeNo In ('41','4110' ) ";
		sFilter = "4110";
	}
	else if( sObjectType.equals( "FileManageView" ) ){//是通过文件管理打开的页面
		//获取客户类型，通过客户类型进行判断是哪个业务类型
		String sCustomerType = Sqlca.getString("Select CustomerType From Customer_Info Where CustomerID = '"+sObjectNo+"'" );
		if( sCustomerType == null ) sCustomerType = " ";
		if( sCustomerType != null ){
			if( sCustomerType.startsWith( "01" ) ) sFilter = "1020";
			else if( sCustomerType.startsWith( "02" ) ) {
				sFilter = "1020";
			}
			else if( sCustomerType.startsWith( "03" ) ) {
				sFilter = "1010";
			}else{
				sFilter = "1020";
			}
		}
		/* String sBusinessType = Sqlca.getString( new SqlObject("Select BusinessType From BUSINESS_APPLY "+
				" Where SerialNo = :SerialNo").setParameter( "SerialNo", sObjectNo ) );
		if( sBusinessType == null ) sBusinessType = " "; */
		
		if (sCustomerType.equals("0310")){//如果是个人客户
			
			if(CurUser.hasRole("482")){//支行小微客户经理下的个人客户是可以办理小微业务的
				if(sType.equals("0010")){//授信业务流程
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '4010%' or ImageTypeNo like '4020%' or ImageTypeNo like '6020010%') )  ";
				}else if(sType.equals("0020")){//担保资料
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '4010%' or ImageTypeNo like '4020%') )  "; */
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '6020020%' or ImageTypeNo like '6020030%' or ImageTypeNo like '6020040%' or ImageTypeNo like '6020050%') )  ";
				}else if(sType.equals("0030")){//贷后管理资料
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  ImageTypeNo like '4040%' or ImageTypeNo like '6030%'  )  ";
				}else if(sType.equals("0040")){//基础资料
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  ImageTypeNo like '4030%' or ImageTypeNo like '6010%' )  ";
				}else if(sType.equals("0050")){//诉讼资料
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo like '50%'  "; */
					sAppend += " and TypeNo is null ";
				}else if(sType.equals("0060")){//其他
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '4010%' or ImageTypeNo like '4020%') )  "; */
					sAppend = " and ECM_IMAGE_TYPE.TypeNo Like '" + sFilter + "%' ";
				}
			}else{//非小微客户经理办理的小微业务
				if(sType.equals("0010")){//授信业务流程
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '4010%' or ImageTypeNo like '4020%') )  ";
				}else if(sType.equals("0020")){//担保资料
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '4010%' or ImageTypeNo like '4020%') )  "; */
					sAppend += " and TypeNo is null ";
				}else if(sType.equals("0030")){//贷后管理资料
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  ImageTypeNo like '4040%'  )  ";
				}else if(sType.equals("0040")){//基础资料
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  ImageTypeNo like '4030%'  )  ";
				}else if(sType.equals("0050")){//诉讼资料
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo like '50%'  "; */
					sAppend += " and TypeNo is null ";
				}else if(sType.equals("0060")){//其他
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '4010%' or ImageTypeNo like '4020%') )  "; */
					sAppend = " and ECM_IMAGE_TYPE.TypeNo Like '" + sFilter + "%' ";
				}
			}
			
		}else{//非个人客户资料
			if(CurUser.hasRole("482")){//支行小微客户经理下的个人客户是可以办理小微业务的
				if(sType.equals("0010")){//授信业务流程
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '3010%' or ImageTypeNo like '6020010%') )  ";
				}else if(sType.equals("0020")){//担保资料
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '4010%' or ImageTypeNo like '4020%') )  "; */
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '6020020%' or ImageTypeNo like '6020030%' or ImageTypeNo like '6020040%' or ImageTypeNo like '6020050%') )  ";
				}else if(sType.equals("0030")){//贷后管理资料
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  ImageTypeNo like '3030%' or ImageTypeNo like '6030%'  )  ";
				}else if(sType.equals("0040")){//基础资料
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  ImageTypeNo like '6010%' )  ";
				}else if(sType.equals("0050")){//诉讼资料
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo like '50%'  "; */
					sAppend += " and TypeNo is null ";
				}else if(sType.equals("0060")){//其他
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '4010%' or ImageTypeNo like '4020%') )  "; */
					sAppend = " and ECM_IMAGE_TYPE.TypeNo Like '" + sFilter + "%' ";
				}
			}else{//非小微客户经理办理的公司业务
				if(sType.equals("0010")){//授信业务流程
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  ImageTypeNo like '3010%'  )  ";
				}else if(sType.equals("0020")){//担保资料
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  ImageTypeNo like '3020%'  )  ";
				}else if(sType.equals("0030")){//贷后管理资料
					sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  ImageTypeNo like '3030%'  )  ";
				}else if(sType.equals("0040")){//基础资料
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  ImageTypeNo like '4030%'  )  "; */
					sAppend += " and TypeNo is null ";
				}else if(sType.equals("0050")){//诉讼资料
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo like '50%'  "; */
					sAppend += " and TypeNo is null ";
				}else if(sType.equals("0060")){//其他
					/* sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA "+ 
							"Where  (ImageTypeNo like '4010%' or ImageTypeNo like '4020%') )  "; */
					sAppend = " and ECM_IMAGE_TYPE.TypeNo Like '" + sFilter + "%' ";
				}
			}
		}
		
		sFilter = "%";
	}
	
	//定义树图结构
	String sSqlTreeView = "from ECM_IMAGE_TYPE where  IsInUse = '1' " + sAppend;
	//tviTemp.initWithSql("TypeNo","case when (Select Count(*) FROM ECM_PAGE Where ECM_PAGE.ObjectNo = '"+sObjectNo+"' and ECM_PAGE.documentId is not null and ECM_PAGE.TypeNo Like ECM_IMAGE_TYPE.TypeNo || '%') > 0 then ( TypeName || '( <font color=\"red\">' || (Select Count(*) FROM ECM_PAGE Where ECM_PAGE.ObjectNo = '"+sObjectNo+"' and ECM_PAGE.TypeNo Like ECM_IMAGE_TYPE.TypeNo || '%') || '</font> 件)') else TypeName end as TypeName ","TypeName","","",sSqlTreeView,"Order By TypeNo",Sqlca);
		tviTemp.initWithSql("TypeNo","TypeName","","","",sSqlTreeView,"Order By TypeNo",Sqlca);
	//查询总数
	String querySumSql = "select count(*) as cc, typeNo from ECM_PAGE where ECM_PAGE.objectNo='"+sObjectNo+"' and  ECM_PAGE.documentId is not null and length(ECM_PAGE.documentId)>0 group  by ECM_PAGE.typeNo ";
	ASResultSet rs = Sqlca.getASResultSet(querySumSql);
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
		if( sCurItemID != "null" && sCurItemID != "root" && hasChild(getCurTVItem().id) ){
			var param = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&TypeNo="+sCurItemID;
			var sReadOnly = "<%=sRight%>";
			if(sReadOnly == "All"){
				openComp("ImagePageAc", "/ImageManage/ImagePageAc.jsp", param, "right" );
			}else{
				openComp("ImageTrans", "/ImageTrans/ImageTrans.jsp", param, "right" );	
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
			//if( !hasChild(nodes[i].id) ) expandNode( nodes[i].id );
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
		expandNode('root');
		selectItem(50);
	}
	
	initTreeView();
	expandAll();
</script>
<%@ include file="/IncludeEnd.jsp"%>
