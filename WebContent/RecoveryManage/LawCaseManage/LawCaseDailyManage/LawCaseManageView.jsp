<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "案件详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;案件基本信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//定义变量：Sql语句、案件类型
	String sSql = "";
	String sLawCaseType = "";
	String 	sPigeonholeDate ="";
	//获得组件参数(案件流水号)	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sSerialNo == null) sSerialNo = "";
	String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType",3));
	if(sFinishType == null) sFinishType = "";
	//获取案件类型
	sSql =  " select LawCaseType from LAWCASE_INFO where SerialNo =:SerialNo ";
   	sLawCaseType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sSerialNo)); 
	//获取归档日期
	sSql =  " select PigeonholeDate from LAWCASE_INFO where SerialNo =:SerialNo ";
	sPigeonholeDate = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sSerialNo)); 
	if(sPigeonholeDate ==null) sPigeonholeDate="";
   	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"案件详情列表","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	//根据不同的案件类型LawCaseType的不同，显示不同的树形菜单
	if(sLawCaseType.equals("01"))	//一般案件
	{
		String sSqlTreeView = " from CODE_LIBRARY where CodeNo = 'CaseInfoList1' and IsInUse = '1' ";
		tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
		//参数从左至右依次为：
		//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	}
	if(sLawCaseType.equals("02"))	//公正/仲裁案件
	{
		String sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'CaseInfoList2' and IsInUse = '1' ";
		tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	}
	//if(sLawCaseType.equals("05"))	//破产案件
	//{
	//	String sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'CaseInfoList5' and IsInUse = '1' ";
	//	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//}
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		var sBookType=sCurItemDescribe[2];	//台帐类型
		sSerialNo = "<%=sSerialNo%>";
		sLawCaseType = "<%=sLawCaseType%>";
		if(sCurItemID!="root"){
			if(sCurItemDescribe2 == "Back"){
				self.close();
				opener.location.reload();
			}else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root"){
				if(sCurItemDescribe2 == "DocumentList"){
					openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&PigeonholeDate=<%=sPigeonholeDate%>&FinishType=<%=sFinishType%>&ObjectType=LawcaseInfo&ObjectNo="+sSerialNo,OpenStyle);
				}else
					openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&PigeonholeDate=<%=sPigeonholeDate%>&FinishType=<%=sFinishType%>&BookType="+sBookType+"&SerialNo="+sSerialNo+"&LawCaseType="+sLawCaseType,OpenStyle);
				setTitle(sCurItemName);
			} 
		}
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');
	//expandNode('010');
	//expandNode('030001');	
	selectItem('010');
	//if("<%=sLawCaseType%>" == "01"){
    //            openChildComp("CaseFrame","/RecoveryManage/LawCaseManage/LawCaseDailyManage/CaseFrame.jsp","ComponentName=案件概览&SerialNo=<%=sSerialNo%>&LawCaseType=<%=sLawCaseType%>",OpenStyle);
    //            setTitle("案件概览");
   	// }

</script>
<%@ include file="/IncludeEnd.jsp"%>