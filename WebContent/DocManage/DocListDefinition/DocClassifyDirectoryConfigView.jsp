<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明:示例对象信息查看页面--
	 */
	String PG_TITLE = "资料类型目录"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;资料类型目录列表&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//获得页面参数
	String sExampleId = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sViewId = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewId"));

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"资料类型目录","right");
	tviTemp.ImageDirectory = ""; //设置资源文件目录（图片、CSS） sResourcesPath
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	String sSqlTreeView = "from doc_view_catalog ";// where status='1' 
	//sSqlTreeView += "and (RelativeCode like '%"+sViewId+"%' or RelativeCode='All') ";//视图filter

	tviTemp.initWithSql("folderid","folderName","parentfolder","","",sSqlTreeView,"",Sqlca);
	//添加一个 返回业务资料类型配置 菜单
	tviTemp.insertPage("000", "root", "返回业务资料类型配置", "GoDocCDConfig", "", 3);
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
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=="返回业务资料类型配置"){
			openChildComp("/DocManage/DocListDefinition/DocClassifyDirectoryConfigList.jsp","");//GoDocCDConfig=TRUE
		}else {
			openChildComp("/DocManage/DocListDefinition/DocClassifyList.jsp","ParentFolderId="+sCurItemID);
		}
		setTitle(getCurTVItem().name);
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("返回业务资料类型配置");
	}
		
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
