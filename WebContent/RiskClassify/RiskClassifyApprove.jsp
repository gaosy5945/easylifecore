<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明:手工生成树图示例页面
	 */
	String PG_TITLE = "分类调整审批"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;分类调整审批&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//获得页面参数
	String sExampleId = CurPage.getParameter("ObjectNo");

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"分类调整审批","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
	//通过insertFolder和insertPage生成树图                         
   tviTemp.insertPage("root","当前工作","",1);
   tviTemp.insertPage("root","已完成工作","",2);
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
		if(sCurItemname=="当前工作"){
			openChildComp("/RiskClassify/RiskClassifyApproveList.jsp","");
		}else if(sCurItemname=="已完成工作"){
			openChildComp("/RiskClassify/RiskClassifyApplyList1.jsp","");
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