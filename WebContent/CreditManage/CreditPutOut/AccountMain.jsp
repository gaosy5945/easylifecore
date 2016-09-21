<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "放还款主界面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;放还款主界面&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//定义变量
	String sSqlTreeView = "",sBusinessType = "",sTypesortNo = "";
	String sSql="";
	//获得组件参数	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"放还款管理","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
	
	//获取合同所对应的业务品种
	sSql="select BusinessType from BUSINESS_CONTRACT where SerialNo=:SerialNo";
	sBusinessType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
	//获取业务品种所对应的是否联机处理标志
	sSql="select TypesortNo from BUSINESS_TYPE where TypeNo=:TypeNo";
	sTypesortNo = Sqlca.getString(new SqlObject(sSql).setParameter("TypeNo",sBusinessType));
	if(sTypesortNo == null) sTypesortNo = "";
	//定义树图结构
	if(sTypesortNo.equals("1")) //是否联机处理标志（1：是；2：否）
	{
		sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'AccountMain' and IsInUse = '1' ";
	}else if(sTypesortNo.equals("2")) //是否联机处理标志（1：是；2：否）
	{
		sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'AccountMain' and ItemNo in ('0030','0040')  and IsInUse = '1' ";
	}
	
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
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		var sCurItemDescribe3=sCurItemDescribe[2];
		sSerialNo = "<%=sSerialNo%>";
		if(typeof(sCurItemDescribe3)!="undefined" && sCurItemDescribe3.length > 0){
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&AccountType="+sCurItemDescribe3+"&ObjectNo="+sSerialNo,"right");
		}
		setTitle(getCurTVItem().name);
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');
</script>
<%@ include file="/IncludeEnd.jsp"%>