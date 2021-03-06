<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "授信额度详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;授信额度详情&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//定义变量
	String sSql = "";
	String sCustomerID = "";
	//主综合授信编号
	String sCreditLineID = "";
	String sBusinessType="";
	ASResultSet rs=null;
	//主更新表
	String sTable = "";
	int iOrder1 = 1;
	int iOrder2 = 1;
	
	//获得页面参数		
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";

	//根据sObjectType的不同，得到不同的关联表名和模版名
	sSql="select ObjectTable from OBJECTTYPE_CATALOG where ObjectType=:ObjectType";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",sObjectType));
	if(rs.next()){ 
		sTable=DataConvert.toString(rs.getString("ObjectTable"));
	}
	rs.getStatement().close();
	//根据申请编号获得客户代码,业务类型
	sSql = " select CustomerID,BusinessType from "+sTable+" where SerialNo =:SerialNo ";
	rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next()){
		sCustomerID=rs.getString("CustomerID");
		sBusinessType=rs.getString("BusinessType");
	}
	rs.getStatement().close();
	//将空值转化为空字符串
	if(sCustomerID == null) sCustomerID = "";
	if(sBusinessType == null) sBusinessType = "";
	//根据申请编号获得综合授信额度编号
	if(sObjectType.equals("CreditApply")){
		sSql = " select LineID from CL_INFO where ApplySerialNo =:ObjectNo and (Parentlineid is null or Parentlineid = ' ') order by LineID";
	}else if(sObjectType.equals("ApproveApply")){
		sSql = " select LineID from CL_INFO where ApproveSerialNo =:ObjectNo and (Parentlineid is null or Parentlineid = ' ') order by LineID";
	}else if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan")){
		sSql = " select LineID from CL_INFO where BCSerialNo =:ObjectNo and (Parentlineid is null or Parentlineid = ' ') order by LineID";
	}
	sCreditLineID = Sqlca.getString(new SqlObject(sSql).setParameter("ObjectNo",sObjectNo));
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"业务详情","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
	
	//定义树图结构,根据对象类型(RelativeCode)、业务品种(Attribute1生成不同的树图
	if(sBusinessType.startsWith("3020")){
		String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'CreditLineView' and RelativeCode like '%"+sObjectType+"%' and Attribute1 like '%"+sBusinessType+"%' and IsInUse = '1' and ItemNo<>'080'";
		tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	}else{
		String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'CreditLineView' and RelativeCode like '%"+sObjectType+"%' and Attribute1 like '%"+sBusinessType+"%' and IsInUse = '1' ";
		tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	}
	
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript">
	//打开右侧树图函数 
	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		sParaStringTmp=sParaStringTmp.replace("#ObjectType","<%=sObjectType%>");
		sParaStringTmp=sParaStringTmp.replace("#ObjectNo","<%=sObjectNo%>");
		sParaStringTmp=sParaStringTmp.replace("#CustomerID","<%=sCustomerID%>");
		sParaStringTmp=sParaStringTmp.replace("#ParentLineID","<%=sCreditLineID%>");
		sParaStringTmp=sParaStringTmp.replace("#ModelType","030");
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}

	//treeview单击选中事件
	function TreeViewOnClick(){
		var sSerialNo = getCurTVItem().id;
		if (sSerialNo == "root")	return;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe0=sCurItemDescribe[0];
		sCurItemDescribe1=sCurItemDescribe[1];
		sCurItemDescribe2=sCurItemDescribe[2];
		
		if(sCurItemDescribe0 != "null"){
			openChildComp(sCurItemDescribe1,sCurItemDescribe0,"ComponentName="+sCurItemName+"&"+sCurItemDescribe2);
			setTitle(getCurTVItem().name);
		}
	}
	
	function startMenu() {
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	myleft.width=170;
	startMenu();
	expandNode('root');
	expandNode('040');
	selectItem('010');
	setTitle("基本信息");
</script>
<%@ include file="/IncludeEnd.jsp"%>