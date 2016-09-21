<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明:手工生成树图示例页面
	 */
	String PG_TITLE = "分类偏离度确认"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;分类偏离度确认&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//获得页面参数
	String sExampleId = CurPage.getParameter("ObjectNo");

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"分类偏离度确认","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
	//通过insertFolder和insertPage生成树图                         
   tviTemp.insertPage("root","待确认生效","",1);
   tviTemp.insertPage("root","已确认生效","",2);
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	function openChildComp(sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		/*
		 * ToInheritObj:是否将对象的权限状态相关变量复制至子组件
		 */
		sParaStringTmp += "ToInheritObj=y";
		AsControl.OpenView(sURL,sParaStringTmp,"right");
	}
	
	//treeview单击选中事件
	function TreeViewOnClick(){
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=="待确认生效"){
			openChildComp("/RiskClassify/ClassifyConfirmList.jsp","isused=0");
		}else if(sCurItemname=="已确认生效"){
			openChildComp("/RiskClassify/ClassifyConfirmList.jsp","isused=1");
			return;
		}else{}
		setTitle(getCurTVItem().name);
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("基本信息");
	}
		
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>