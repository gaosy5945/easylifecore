<%@page import="com.amarsoft.app.als.image.service.ImageSevice"%>
<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@page import="com.amarsoft.app.als.product.PRDTreeViewNodeGenerator"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.app.bizmethod.*"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   jytian  2004-12-10
			Tester:
			Content: 业务申请主界面
			Input Param:
		 	SerialNo：业务申请流水号
			Output param:
		      
			History Log: 
			2005.08.09 王业罡 整理代码，去掉window.open打开方法,删除无用代码，整合逻辑
			2009.06.30 hwang 修改额度项下业务树图获取方式
			2011.06.03 qfang 增加流动资金贷款需求量测算模型
			2013.05.25 yzheng 修改树图节点生成方式, 针对CreditView
			2013.06.14 yzheng 合并CreditLineView
			2013.06.27 yzheng 合并InputCreditView
		 */
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "业务申请"; // 浏览器窗口标题 <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;基本信息&nbsp;&nbsp;"; //默认的内容区标题
		String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
		String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/
%>
	<%
		// 	//定义变量
	// 	String sBusinessType = "";
		String sCustomerID = "";
	 	String sOccurType = "";  //发生类型—仅针对额度项下/单笔
	// 	String sApplyType="";  //申请类型 —仅针对额度项下/单笔
	// 	String sTable="";
	 	String sCreditLineID = "";  //主综合授信编号—针对授信额度申请
	 	int schemeType = 0;  //授信方案类型  0:授信额度申请 1: 额度项下/单笔授信申请
		
		//获得组件参数
		String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
		String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
		
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		//获取参数：一笔业务申请后，是否需要经过审批到合同阶段—针对额度项下/单笔授信
		String sApproveNeed =  CurConfig.getConfigure("ApproveNeed");
	%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
	<%
// 	//根据sObjectType的不同，得到不同的关联表名和模版名
// 	String sSql="select ObjectTable from OBJECTTYPE_CATALOG where ObjectType=:ObjectType";
// 	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",sObjectType));
// 	if(rs.next()){ 
// 		sTable=DataConvert.toString(rs.getString("ObjectTable"));
// 	}
// 	rs.getStatement().close(); 
	
// 	sSql="select CustomerID,OccurType,ApplyType,BusinessType from "+sTable+" where SerialNo=:SerialNo";
// 	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
// 	if(rs.next()){
// 		sCustomerID=DataConvert.toString(rs.getString("CustomerID"));
// 		sBusinessType=DataConvert.toString(rs.getString("BusinessType"));
// 		sOccurType=DataConvert.toString(rs.getString("OccurType"));  //针对额度项下/单笔
// 		sApplyType=DataConvert.toString(rs.getString("ApplyType"));  //针对额度项下/单笔
// 	}
// 	rs.getStatement().close(); 
	
	CreditObjectAction creditObjectAction = new CreditObjectAction(sObjectNo,sObjectType);
	sCustomerID = creditObjectAction.getCreditObjectBO().getAttribute("CustomerID").toString();
	sOccurType = creditObjectAction.getCreditObjectBO().getAttribute("OccurType").toString();
	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"业务详情","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
	
	//add by qfang 2011-06-03
	//String sSqlTreeView = "";
	//BizSort bs = new BizSort(Sqlca,sObjectType,sObjectNo,sApproveNeed,sBusinessType);
	
	/**added and modified by yzheng  2013/06/19**/
	PRDTreeViewNodeGenerator nodeGen = new PRDTreeViewNodeGenerator(sApproveNeed);
	String sSqlTreeView = nodeGen.generateSQLClause(Sqlca, sObjectType, sObjectNo);
	schemeType = nodeGen.getSchemeType();
	sCreditLineID = nodeGen.getCreditLineID();

	//参数从左至右依次为: ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	tviTemp.initWithSql("PRD_NODEINFO.NodeID as NodeID","PRD_NODECONFIG.NodeName as NodeName","ItemDescribe||'$'||(case when FAC5 is null then '' else FAC5 end) as ItemDescribe","","",sSqlTreeView,"Order By PRD_NODEINFO.SortNo",Sqlca);
	
	ArrayList<TreeViewItem> lst=tviTemp.Items;
	String defaultClickItemId="";
	for(TreeViewItem treeItem:lst){
		if(treeItem.getType().equalsIgnoreCase("page") && defaultClickItemId.equals("")){
			defaultClickItemId=treeItem.getId();
		}
		
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View05;]~*/%>
	<script type="text/javascript"> 
	function openChildComp(sCompID,sURL,sParameterString){
		//alert(sParameterString);
		sParaStringTmp = "";
		
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		sParaStringTmp=sParaStringTmp.replace("#ObjectType","<%=sObjectType%>");
		sParaStringTmp=sParaStringTmp.replace("#ObjectNo","<%=sObjectNo%>");
		sParaStringTmp=sParaStringTmp.replace("#CustomerID","<%=sCustomerID%>");
		
		if (<%=schemeType%> == 0){  //授信额度申请
			sParaStringTmp=sParaStringTmp.replace("#ParentLineID","<%=sCreditLineID%>");
			//sParaStringTmp=sParaStringTmp.replace("#ModelType","030");
		}
		else if(<%=schemeType%> == 1){  //额度项下/单笔授信申请
			sParaStringTmp=sParaStringTmp.replace("#OccurType", "<%=sOccurType%>");
		}
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}

	//treeview单击选中事件
	function TreeViewOnClick(){
		var sSerialNo = getCurTVItem().id;
		if (sSerialNo == "root" || !hasChild(sSerialNo))	return;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value.split("$")[0];
		var sortNo = trim(getCurTVItem().value.split("$")[1]);
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe0=sCurItemDescribe[0];
		sCurItemDescribe1=sCurItemDescribe[1];
		sCurItemDescribe2=trim(sCurItemDescribe[2]);
		
		AsCredit.imageLocate(sortNo);
		
		if(sCurItemDescribe1 == "GuarantyList"){
			openChildComp("GuarantyList","/CreditManage/GuarantyManage/GuarantyList.jsp","ObjectType=<%=sObjectType%>&WhereType=Business_Guaranty&ObjectNo=<%=sObjectNo%>");
			setTitle(getCurTVItem().name);
		}else if(sCurItemDescribe1 == "LiquidForcast"){
			openChildComp("EvaluateList","/Common/Evaluate/EvaluateList.jsp","ModelType=070&ObjectType=Customer&ObjectNo=<%=sCustomerID%>&CustomerID=<%=sCustomerID%>");
		}else if(sCurItemDescribe0 != "null"){
			openChildComp(sCurItemDescribe1,sCurItemDescribe0,"AccountType=ALL&"+sCurItemDescribe2+"&CustomerID=<%=sCustomerID%>");
			setTitle(getCurTVItem().name);
		}
	}

	function startMenu() {
		<%=tviTemp.generateHTMLTreeView()%>
	}
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View06;Describe=在页面装载时执行,初始化]~*/%>
	<script type="text/javascript">
	myleft.width=170;
	startMenu();
	expandNode('root');
	expandNode('01');
	<%if(sObjectType.equals("CreditApply")){%>
	selectItem('011');
	<% }else if(sObjectType.equals("ApproveApply")){%>
	selectItem('012');
	<%}else{%>
	selectItem('013');
	<%}%>
	expandNode('040');
	expandNode('041');	
//	setTitle("基本信息");
	selectItem('<%=defaultClickItemId%>');
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>