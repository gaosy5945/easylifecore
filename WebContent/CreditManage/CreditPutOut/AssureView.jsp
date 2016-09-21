<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "担保信息管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;担保合同信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	
	//需将对象类型AfterLoan、ReinforceContract转换为BusinessContract
	if(sObjectType.equals("AfterLoan") || sObjectType.equals("ReinforceContract")) 
		sObjectType = "BusinessContract";

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"担保信息管理","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构,根据阶段(RelativeCode)、发生类型(Attribute1)、业务品种(Attribute2)、排除的业务品种(Attribute3)生成不同的树图
	String sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'CreditView' "+
						  " and (RelativeCode like '%"+sObjectType+"%' "+
						  " or RelativeCode='All') "+
						  " and ItemNo like '04%' "+
						  " and IsInUse = '1' " ;
	
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
		var AccountType="";
		var sSerialNo = getCurTVItem().id;
		if (sSerialNo == "root") return;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		sCurItemDescribe4=sCurItemDescribe[3];
		
		if(sCurItemDescribe2 == "GuarantyList"){
			openChildComp("GuarantyList","/CreditManage/GuarantyManage/GuarantyList.jsp","ObjectType=<%=sObjectType%>&WhereType=Business_Guaranty&ObjectNo=<%=sObjectNo%>");
		    setTitle(getCurTVItem().name);
		}else if(sCurItemDescribe1 != "null"){
			openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&AccountType=ALL&ContractType="+sCurItemDescribe4);
			setTitle(getCurTVItem().name);
		}
	}

	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');
	expandNode('040');
	expandNode('041');
	selectItem('041050');
</script>
<%@ include file="/IncludeEnd.jsp"%>