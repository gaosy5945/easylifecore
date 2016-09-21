<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%@
 page import="com.amarsoft.are.jbo.*" %><%
	String jbopackage = CurPage.getParameter("jbopackage");
 	String DefaultNode =  CurPage.getParameter("DefaultNode");
 	if(jbopackage == null) jbopackage = "";
 	
	String PG_TITLE = "JBO Class树图"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"大类","right");
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数
	
	//定义树图结构
	JBOFactory f = JBOFactory.getFactory();
	String[] pkgNames=f.getPackages();
 	for(int i = 0;i<pkgNames.length;i++){
		if(!StringX.isEmpty(jbopackage) && !pkgNames[i].startsWith(jbopackage)) continue;

		String pkgLabel = f.getPackage(pkgNames[i]).getLabel();
		tviTemp.insertFolder(pkgNames[i], "root", pkgLabel, pkgNames[i], "", i); //package节点
		
		String[] classes=f.getClasses(pkgNames[i]);
	 	//存储class中label的名字
	 	for(int j=0;j<classes.length;j++){
	 		BizObjectClass clazz = f.getClass(classes[j]);
	 		String clsLabel = clazz.getLabel();
	 		tviTemp.insertFolder(classes[j], pkgNames[i], clsLabel, classes[j], "", j); //class节点
	 		
	 		DataElement[] attrs = clazz.getAttributes();
	 		for(int k=0;k<attrs.length;k++){
	 			DataElement element = attrs[k];
	 			tviTemp.insertPage(classes[j], element.getLabel(), element.getName(), "", k); //attribute节点
	 		}
	 	}
	}
 	
 	String sButtons[][] = {
 		{"true","","Button","查询","","showTVSearch()","","","",""},
	};
%><body style="overflow: hidden;">
	<table style="width: 100%;height: 100%;border: 0;">
		<tr style="height: 30px;">
			<td><%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%></td>
		</tr>
		<tr> 
  			<td id="myleft" align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
		</tr>
	</table>
</body>
<script type="text/javascript"> 
	<%/*~[Describe=生成treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		//设置默认打开节点
		var DefaultNode = "<%=DefaultNode%>";
		if(DefaultNode!= null){
			selectItemByName(DefaultNode);
		}
	}
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>