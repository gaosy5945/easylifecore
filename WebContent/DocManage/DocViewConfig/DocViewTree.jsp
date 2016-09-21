<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明:示例对象信息查看页面--
	 */
	String PG_TITLE = "SQL生成树图"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;SQL生成树图&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//获得页面参数
	String sExampleId = CurComp.getParameter("ObjectNo");
	String sViewId = CurComp.getParameter("ViewId");

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"SQL生成树图","right");
	tviTemp.ImageDirectory = ""; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	//添加一个 返回业务资料类型配置 菜单
	//tviTemp.insertPage("000", "root", "业务资料类型配置", "GoDocCDConfig", "", 3);
	//tviTemp.initWithSql("FOLDERID","FOLDERNAME","FOLDERNAME","","",sSqlTreeView,"Order By FOLDERID",Sqlca);
	String sSqlTreeView = "select dvc.folderid,dvc.parentfolder,dvc.foldername,dvc.viewid from doc_view_catalog dvc where 1=1 order by dvc.viewid,dvc.folderid";
	try{
		ASResultSet rs = Sqlca.getASResultSet(sSqlTreeView);
		while(rs.next()){
			String root = rs.getString(2);
			if(root.equals("")) root="root";
			tviTemp.insertFolder(rs.getString(1), root, rs.getString(3), rs.getString(3)+","+rs.getString(1)+","+rs.getString(4), "", 3);
		}
	}catch(Exception e){
		e.fillInStackTrace();
	}
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	String sButtons[][] = {
			{"true","All","Button","新增","新增一条记录","newRecord()","","","","btn_icon_add"},
			{"false","All","Button","启用","启用该条记录","changeMenuState('1')","","","",""},
			{"false","All","Button","停用","停用该条记录","changeMenuState('2')","","","",""},
			{"true","All","Button","删除","删除所选中的记录","deleteRecord()","","","","btn_icon_delete"},
			{"true","","Button","刷新","刷新当前页面","reloadSelf()","","","",""},
	};
	
%><%@include file="/Resources/CodeParts/View07.jsp"%>
<script type="text/javascript"> 	
	
	<%/*[Describe=新增记录;]*/%>
	function newRecord(){
		//获取单击节点的编号	 
		var sSortNo = getCurTVItem().id; //根据菜单的生成，这里取得是菜单排序号
		var sMenuValue = getCurTVItem().value;
		var sParentViewId = sMenuValue.split(",")[2];
		var sParentFolder = sMenuValue.split(",")[1];
		if("undefined" == sParentFolder || "null"==sParentFolder || typeof(sParentFolder)=="undefined" || sParentFolder.length==0){
			sParentFolder = "root";
		}
		var sPara = "";
		if("GoDocCDConfig"==sMenuValue || !sMenuValue){
			if(confirm("是否在"+getCurTVItem().name+"下新增")){
				sPara = "ParentFolder="+sFolderId;
			} else {
				sPara = "ParentFolder=root";
			}
		}
		 var sViewId = getSerialNo("DOC_VIEW_CATALOG","VIEWID","");
		 var sFolderId  = getSerialNo("DOC_VIEW_CATALOG","FOLDERID","");
		 var sUrl = "/DocManage/DocViewConfig/DocViewInfo.jsp";
		 sPara = sPara + "&GoBackType=1";
		 sPara = sPara + "&ViewId="+sViewId+"&FolderId="+sFolderId+"&ParentFolder="+sParentFolder;
		 AsControl.OpenPage(sUrl,sPara,'right','');
	}
	
	function changeMenuState(sChange){ // 启用 1，停用 2
		var sSortNo = getCurTVItem().id; //根据菜单的生成，这里取得是菜单排序号
		var sMenuValue = getCurTVItem().value;
		var sViewId = sMenuValue.split(",")[2];
		var sFolderId = sMenuValue.split(",")[1];
		if("GoDocCDConfig"==sMenuValue || !sMenuValue){
			alert(getMessageText('AWEW1001'));//请选择一条信息！
			return ;
		}
		var sAction = "";
		if(sChange == "1") sAction = "启用";
		else if(sChange == "2") sAction = "停用";
		else sAction = "操作";
		var sSql = "update doc_view_catalog set status='"+sChange+"' where viewid='"+sViewId+"' and folderid='"+sFolderId+"'";
		var sReturn = RunMethod("PublicMethod","RunSql",sSql);
		if(sReturn != 1){
			alert(sAction+"该菜单项失败！");
		}else{
		    alert("该项目已"+sAction+"成功！");
		}
	}

	<%/*[Describe=删除记录;]*/%>
	function deleteRecord(){
		var sSortNo = getCurTVItem().id; //根据菜单的生成，这里取得是菜单排序号
		var sMenuValue = getCurTVItem().value;
		var sViewId = sMenuValue.split(",")[2];
		var sFolderId = sMenuValue.split(",")[1];
		if("GoDocCDConfig"==sMenuValue || !sMenuValue){
			alert(getMessageText('AWEW1001'));//请选择一条信息！
			return ;
		}
		
		if(confirm("您确定删除吗？")){
			var sReturn = RunJavaMethodTrans("com.amarsoft.app.bizmethod.DeleteDocCatalog","deleteDocCatalog","viewID="+sViewId+",folderID="+sFolderId);
			if(sReturn != 1){
				alert("删除该菜单项失败！");
			}else{
			    alert("该菜单已删除成功！");
			    reloadSelf();
			}
		}
	}
	
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
		AsControl.OpenView(sURL,sParaStringTmp,"frameright");
	}
	
	//treeview单击选中事件
	function TreeViewOnClick(){
		var sSortNo = getCurTVItem().id; //根据菜单的生成，这里取得是菜单排序号
		var sMenuValue = getCurTVItem().value;
		var sViewId = sMenuValue.split(",")[2];
		var sFolderId = sMenuValue.split(",")[1];
		var sCurItemname = getCurTVItem().name;
		var sReturnValue = PopPageAjax("/DocManage/DocViewConfig/SelectParentfolderAjax.jsp?FolderId="+sFolderId,"","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
		if("GoDocCDConfig"==sMenuValue || !sMenuValue){
			//openChildComp("/DocManage/DocViewConfig/DocViewFileList.jsp","FolderId=root&ViewId=root");
		}else{
			openChildComp("/DocManage/DocViewConfig/DocViewFileList.jsp","FolderId="+sFolderId+"&ViewId="+sViewId);
		} 
		setTitle(getCurTVItem().name);  
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("业务资料类型配置");
	}
		
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
