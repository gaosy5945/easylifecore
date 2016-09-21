<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBegin.jsp"%><%
	/*
		Content: 选择树型对话框页面
		Input Param:
			SelName：查询名称
			ParaString：参数字符串
	 */
	//获取参数：查询名称和参数
	String selectedValues = CurPage.getParameter("SelectedValues");
	if(selectedValues == null) selectedValues = "";
	String sSelName  = CurPage.getParameter("SelName");
	String multipleFlag  = CurPage.getParameter("MultipleFlag");
	if(multipleFlag == null) multipleFlag="N";
	String folderSelectFlag  = CurPage.getParameter("FolderSelectFlag");
 	if(StringX.isEmpty(folderSelectFlag)) folderSelectFlag="N";
 	String selectLevel  = CurPage.getParameter("SelectLevel");
 	if(selectLevel==null) selectLevel="Top";
	
	String sParaString = CurPage.getParameter("ParaString");
	sParaString = (sParaString == null)?"":java.net.URLDecoder.decode(sParaString, "UTF-8");
	//将空值转化为空字符串
	if(sSelName == null) sSelName = "";
	if(sParaString == null) sParaString = "";
		
	//定义变量：查询类型、展现方式、参数、隐藏域
	String sSelType = "",sSelBrowseMode = "",sSelArgs = "",sSelHideField = "";
	//定义变量：代码、字段显示中文名称、表名、主键
	String sSelCode = "",sSelFieldName = "",sSelTableName = "",sSelPrimaryKey = "";
	//定义变量：字段显示风格、返回值、过滤字段、选择方式
	String sSelFieldDisp = "",sSelReturnValue = "",sSelFilterField = "";
	//定义变量：属性1、属性2、属性3、属性4、属性5
	String sAttribute1 = "",sAttribute2 = "",sAttribute3 = "",sAttribute4 = "",sAttribute5 = "";

	String sSql = " select SelType,SelTableName,SelPrimaryKey,SelBrowseMode,SelArgs,SelHideField,SelCode, "+
			" SelFieldName,SelFieldDisp,SelReturnValue,SelFilterField,MutilOrSingle,Attribute1, "+
			" Attribute2,Attribute3,Attribute4,Attribute5 "+
			" from SELECT_CATALOG "+
			" where SelName =:SelName and IsInUse = '1' ";
	ASResultSet rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("SelName",sSelName));
	if(rs.next()){
		sSelType = rs.getString("SelType");
		sSelTableName = rs.getString("SelTableName");
		sSelPrimaryKey = rs.getString("SelPrimaryKey");
		sSelBrowseMode = rs.getString("SelBrowseMode");
		sSelArgs = rs.getString("SelArgs");
		sSelHideField = rs.getString("SelHideField");
		sSelCode = rs.getString("SelCode");
		sSelFieldName = rs.getString("SelFieldName");
		sSelFieldDisp = rs.getString("SelFieldDisp");
		sSelReturnValue = rs.getString("SelReturnValue");
		sSelFilterField = rs.getString("SelFilterField");
		sAttribute1 = rs.getString("Attribute1");
		sAttribute2 = rs.getString("Attribute2");
		sAttribute3 = rs.getString("Attribute3");
		sAttribute4 = rs.getString("Attribute4");
		sAttribute5 = rs.getString("Attribute5");
	}
	rs.getStatement().close();

	//将空值转化为空字符串
	if(sSelType == null) sSelType = "";
	if(sSelTableName == null) sSelTableName = "";
	if(sSelPrimaryKey == null) sSelPrimaryKey = "";
	if(sSelBrowseMode == null) sSelBrowseMode = "";
	if(sSelArgs == null) sSelArgs = "";
	else sSelArgs = sSelArgs.trim();
	if(sSelHideField == null) sSelHideField = "";
	else sSelHideField = sSelHideField.trim();
	if(sSelCode == null) sSelCode = "";
	else sSelCode = sSelCode.trim();	
	if(sSelFieldName == null) sSelFieldName = "";
	else sSelFieldName = sSelFieldName.trim();
	if(sSelFieldDisp == null) sSelFieldDisp = "";
	else sSelFieldDisp = sSelFieldDisp.trim();
	if(sSelReturnValue == null) sSelReturnValue = "";
	else sSelReturnValue = sSelReturnValue.trim();
	if(sSelFilterField == null) sSelFilterField = "";
	else sSelFilterField = sSelFilterField.trim();
	if(sAttribute1 == null) sAttribute1 = "";
	if(sAttribute2 == null) sAttribute2 = "";
	if(sAttribute3 == null) sAttribute3 = "";
	if(sAttribute4 == null) sAttribute4 = "";
	if(sAttribute5 == null) sAttribute5 = "";
	
	//获取返回值
	StringTokenizer st = new StringTokenizer(sSelReturnValue,"@");
	String [] sReturnValue = new String[st.countTokens()];
	int l = 0;
	while (st.hasMoreTokens()) {
		sReturnValue[l] = st.nextToken();                
		l ++;
	}
	//设置显示标题
	String sHeaders = sSelFieldName;
	
	//将Sql中的变量用相对应的值替换	
	//StringTokenizer stArgs = new StringTokenizer(sParaString,",");
	String[] stArgs=sParaString.split(",");
	int jj=0;
	while (jj<stArgs.length) {
		try{
			String sArgName  = stArgs[jj].trim();
			jj++;
			
			String sArgValue ="";
			if(jj<stArgs.length)
			   sArgValue  = stArgs[jj].trim();
			jj++;
			int i = sSelCode.indexOf("#"+sArgName);
			if(i > 2 && sSelCode.substring(0,i-2).trim().toUpperCase().endsWith("IN"))
				sSelCode = StringFunction.replace(sSelCode,"#"+sArgName,sArgValue.replaceAll("@","','"));	
			else
			sSelCode = StringFunction.replace(sSelCode,"#"+sArgName,sArgValue );		
		}catch(NoSuchElementException ex){
			throw new Exception("输入参数格式错误！");
		}
	}
%>
<html>
<head> 
<title>选择信息</title>
<script type="text/javascript">
	function TreeViewOnClick(){
		var sType = getCurTVItem().type;
		if(sType != "page" && "<%=folderSelectFlag%>"=="N"){
			alert("目录节点信息不能选择，请重新选择！");
		}
	}
	
	function returnValue(){
		if(<%=multipleFlag.equals("Y")%>){
			var nodes = getCheckedTVItems("root","<%=selectLevel%>");
			if(nodes.length < 1) return;
			var sReturn = "";
			for(var i = 0; i < nodes.length; i++){
				sReturn += nodes[i].value+"@"+nodes[i].name+"~";
			}
			parent.sObjectInfo = sReturn;
		}else{
			var node = getCurTVItem();
			if(!node) return;
			var sType = node.type;
			if(sType != "page" && "<%=folderSelectFlag%>"=="N"){
				alert("目录节点信息不能选择，请重新选择！");
				return;
			}
			if("root"==node.value){
				return;
			}
			parent.sObjectInfo = node.value+"@"+node.name;
		}
	}
	
	//新增树图双击事件响应函数 add by hwang 20090601
	function TreeViewOnDBLClick(){
		parent.returnSelection();
	}	
	
	function startMenu(){
		selectedTreeNodeIDs="<%=selectedValues%>".split(",");
	<%
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"选择信息列表","right");
		if(multipleFlag.equals("Y")) tviTemp.MultiSelect = true;
		else tviTemp.TriggerClickEvent=true;		
		//参数从左至右依次为：
		//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
		tviTemp.initWithSql(sSelHideField,sSelFieldDisp,sSelFieldName,"","",sSelCode,sSelFilterField,Sqlca);
		out.println(tviTemp.generateHTMLTreeView());
		if(tviTemp.getItemCount()==0){
			out.println("alert('系统未找到可选择的结果集，请联系系统管理用户！')");
		}

	%>
		expandNode('root');
		<%
		int j = sAttribute1.split("@").length;
		String[] sExportNode = sAttribute1.split("@");
		for(int i=0;i<j;i++){
		%>
			try{
				expandNode('<%=sExportNode[i]%>');		
			}catch(e){ }
		<%
		}
		%>
	}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>
<body class="pagebackground"><iframe name="left" width=100% height=100% frameborder=0 ></iframe></body>
<script>
	startMenu();	
</script>
</html>
<%@ include file="/IncludeEnd.jsp"%>