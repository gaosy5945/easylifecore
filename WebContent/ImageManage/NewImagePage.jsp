<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%

	/*
        Author: undefined 2015-12-28
        Tester:
        Content: 
        Input Param:
        Output param:
        History Log: 
    */
	String PG_TITLE = "影像文件目录"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;影像文件&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//获得页面参数
	String sExampleId =  CurComp.getParameter("ObjectNo");
	String sViewId =  CurComp.getParameter("ViewId");

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"影像文件","right");
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	
	String sSqlTreeView = "FROM doc_file_info dfi,doc_file_config dfc where dfi.fileid=dfc.fileid and dfc.status='1' and dfi.objectno ="+"97022015100030112601" ;
	//sSqlTreeView += "and (RelativeCode like '%"+sViewId+"%' or RelativeCode='All') ";//视图filter

	tviTemp.initWithSql("dfi.fileid","dfc.filename","","","",sSqlTreeView,"Order By dfi.fileid",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	function openChildComp(sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		/*
		 * 附加两个参数
		 * ToInheritObj:是否将对象的权限状态相关变量复制至子组件
		 * OpenerFunctionName:用于自动注册组件关联（REG_FUNCTION_DEF.TargetComp）
		 */
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		AsControl.OpenView(sURL,sParaStringTmp,"right");
	}
	
	//treeview单击选中事件
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		openChildComp("/ImageManage/ImagePage.jsp","ListType="+sCurItemID+"&Flag=2");
		/* var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=="基本信息"){
			openChildComp("/FrameCase/ExampleList.jsp","");
		}else if(sCurItemname=="其他信息1"){
			openChildComp("/FrameCase/ExampleList.jsp","");
		}else if(sCurItemname=="其他信息2"){
			openChildComp("/FrameCase/ExampleList.jsp","");
		}else if(sCurItemname=="其他的信息"){
			openChildComp("/FrameCase/ExampleList.jsp","");
		}else if(sCurItemname=="另外的信息"){
			openChildComp("/FrameCase/ExampleList.jsp","");
		}
		setTitle(getCurTVItem().name); */
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("身份证明");
	}
		
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>