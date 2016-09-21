<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
/*
	Content: 不良资产台帐管理
	Input Param:
		ObjectType:对象类型															
		ObjectNo  :合同编号															
	Output param:
		ObjectType:对象类型															
		ObjectNo  :合同编号
		NoteType  :工作笔记类型	
		WhereType :抵质押物管理类型为020
		AccountType:传AccountWasteBookList的类型参数														
*/
	String PG_TITLE = "不良资产台帐管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;不良资产台帐管理&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	
	//获得组件参数		
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")); 
	String sViewID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewID"));
	//将空值转化成空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sViewID == null) sViewID = ""; 
	//获得终结类型
	String sSql = " select FinishType from BUSINESS_CONTRACT where SerialNo =:SerialNo ";	
	String sFinishType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(sFinishType == null) sFinishType = "";
		
	//设置对象类型
	String sObjectType = "BusinessContract"; //对象类型

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"不良资产台帐管理","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
		
	//定义树图结构
	String sSqlTreeView="";
	if(sFinishType.equals("0601") || sFinishType.equals("0602"))	//已核销的不良资产进入
		sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'NPABookView' and IsInUse = '1' ";
	else		//非核销的不良资产进入
		sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'NPABookView' and ItemNo <> '065'  and IsInUse = '1' ";

	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	//从TreeView的code_library库属性获取事件codeno = NPABookView
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
		var sCurItemDescribe = sCurItemDescribe.split("@");
		var sCurItemDescribe1=sCurItemDescribe[0];
		var sCurItemDescribe2=sCurItemDescribe[1];
		var sCurItemDescribe3=sCurItemDescribe[2];
		var sCurItemDescribe4=sCurItemDescribe[3];
		if(sCurItemID!="root"){
			if(sCurItemDescribe2 == "Back"){
				self.close();
			}else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root"){
				if(sCurItemDescribe4 == "BusinessContract" || sCurItemDescribe4 == "BusinessDueBill"){
					openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&ObjectType="+sCurItemDescribe4+"&ObjectNo=<%=sObjectNo%>&ViewID=<%=sViewID%>&FinishType=<%=sFinishType%>&Flag=010&NoteType=NPAWorkType&ClassifyType="+sCurItemDescribe3+"&CurItemID="+sCurItemID,OpenStyle);
					setTitle(sCurItemName);
				}else{
					openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ViewID=<%=sViewID%>&FinishType=<%=sFinishType%>&Flag=010&NoteType=NPAWorkType&AccountType="+sCurItemDescribe3+"&CurItemID="+sCurItemID,OpenStyle);
					setTitle(sCurItemName);
				}
			}
		}
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
	
	startMenu();
	expandNode('root');
	expandNode('025');
	expandNode('060');		
	expandNode('070');	
	expandNode('075');
	selectItem('010');	
</script>
<%@ include file="/IncludeEnd.jsp"%>