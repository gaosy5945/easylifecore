<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "查封资产详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;查封资产基本信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	
	//获得组件参数(查封资产流水号、查封资产名称)	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType",3));
	if(sFinishType == null) sFinishType = "";
	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"查封资产详情列表","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	String sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'NPALawsuitList' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	//从TreeView的code_library库属性获取事件codeno = CaseInfoList
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
		sSerialNo = "<%=sSerialNo%>";
		
		if(sCurItemID=="010"){
			var sObjectType="LawCase_Info";
		}
		if(sCurItemID=="060"){
			var sObjectType="Asset_Info";
		}
		if(sCurItemID=="030"){
			var sObjectType="AssetInfo";
		}
		if(sCurItemID!="root"){
			if(sCurItemDescribe2 == "Back"){
				self.close();
				opener.location.reload();
			}else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root"){
				openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&FinishType=<%=sFinishType%>&SerialNo="+sSerialNo+"&ObjectNo="+sSerialNo+"&ObjectType="+sObjectType+"&ItemID="+sCurItemID+"",OpenStyle);
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
</script>
<%@ include file="/IncludeEnd.jsp"%>