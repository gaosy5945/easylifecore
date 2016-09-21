<%@page import="com.amarsoft.app.base.config.impl.BusinessComponentConfig"%>
<%@page import="com.amarsoft.app.base.businessobject.*"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	String parameterID = CurPage.getParameter("ParameterID");
 	String readOnlyFlag = CurPage.getParameter("ReadOnly");
 	String multiFlag = CurPage.getParameter("MultiFlag");
 	String selectedValues = CurPage.getParameter("SelectedValues");
 	if(selectedValues==null)selectedValues="";
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"选择","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
	BusinessObject parameter = BusinessComponentConfig.getParameterDefinition(parameterID);
	String codeType = parameter.getString("CodeSource");
	String code = parameter.getString("CodeScript");
	String selectSource = parameter.getString("SELECTSCRIPT");
	if("true".equalsIgnoreCase(multiFlag))
		tviTemp.MultiSelect = true;//设置树图为多选
	
	String idcol="ID";	
	String namecol="Name";	
	String sortNocol="SortNo";	
	List<BusinessObject> list = null;
	if(StringX.isEmpty(selectSource)){
		if(codeType.equals("JBO")){//JBO
			
			String[] s= code.split(",");
			idcol=s[1];
			namecol=s[2];
			list = bom.loadBusinessObjects(s[0],s[3]);
		}
		else if(codeType.equals("Code")){//Code_Library
			list = bom.loadBusinessObjects_SQL("select ItemNo as ID,ItemName as Name,SortNo as SortNo from CODE_LIBRARY where CodeNo='"+code+"' and IsInUse='1' ", BusinessObject.createBusinessObject());
		}else if("Java".equals(codeType)){//java
			String script = code;
			String args = script.substring(script.indexOf("(")+1);
			args = args.substring(0, args.lastIndexOf(")"));
			args = args.replaceAll("\"", "");
			args = args.replaceAll("'", "");
			String classMethodName = script.substring(0, script.indexOf("("));
			String className = classMethodName.substring(0, script.lastIndexOf("."));
			String methodName = classMethodName.substring(script.lastIndexOf(".")+1);
			
			Class<?>[] paras = new Class<?>[args.split(",").length];
			for(int i = 0; i < paras.length; i ++)
			{
				paras[i] = String.class;
			}
			Class<?> c = Class.forName(className);
			java.lang.reflect.Method method = c.getMethod(methodName, paras);  
			
			String codeTable = (String)method.invoke(null, args.split(","));
			list = new ArrayList<BusinessObject>();
			
			String[] codeArray = codeTable.split(",");
			
			for(int i=0; i < codeArray.length; i ++)
			{
				BusinessObject o = BusinessObject.createBusinessObject();
				o.setAttributeValue(idcol, codeArray[i]);
				o.setAttributeValue(namecol, codeArray[i+1]);
				list.add(o);
			}
		}else if("SQL".equals(codeType)){//SQL
			list = bom.loadBusinessObjects_SQL(selectSource, BusinessObject.createBusinessObject());
		}else if("CodeTable".equals(codeType)){//CodeTable
			String[] codeArray = code.split(",");
			
			for(int i=0; i < codeArray.length; i ++)
			{
				BusinessObject o = BusinessObject.createBusinessObject();
				o.setAttributeValue(idcol, codeArray[i]);
				o.setAttributeValue(namecol, codeArray[i+1]);
				list.add(o);
			}
		}else if("XML".equals(codeType)){//code_table
			
			String[] codeArray = code.split(",");
			list = com.amarsoft.app.base.util.XMLHelper.getBusinessObjectList(codeArray[0], codeArray[3], codeArray[1]);
			idcol = codeArray[1];
			namecol = codeArray[2];
		}
	}
	else{
		list = bom.loadBusinessObjects_SQL(selectSource, BusinessObject.createBusinessObject());
	}
	
	if(list!=null){
		int i=0;
		for(BusinessObject bo:list){
			String sortNo=bo.getString(sortNocol);
			String id = bo.getString(idcol);
			String name = bo.getString(namecol);
			if(sortNo==null||sortNo.length()==0)
				sortNo=id;
			tviTemp.insertPage(sortNo,"root", name , id, "", i++);
		}
	}
	tviTemp.packUpItems();
	
%>
<html>
<head> 
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
<!-- 为了页面美观,请不要删除下面 TITLE 中的空格 -->
<title>请选择所需信息
 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　
 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　
</title>
</head>
<body class="pagebackground" style="overflow: auto;overflow-x:visible;overflow-y:visible">
<table width="100%" border='0' height="100%" cellspacing='0' align=center bordercolor='#999999' bordercolordark='#FFFFFF'>
<form  name="buff" align=center>
	<tr> 
			<td id="selectPage">
				<iframe name="left" width=100% height=100% frameborder=0 ></iframe>
			</td>
	</tr>
	<tr style="height:40px;">
		<td nowarp bgcolor="#e8e8e8" height="35" align=center valign="middle" colspan="2" style="border-top:1px solid #d8d8d8"> 
			<%if(!"1".equals(readOnlyFlag)){out.println(new Button("确认", "", "returnSelection()").getHtmlText());}%>
			<%=new Button("取消", "", "doCancel()").getHtmlText()%>
		</td>
	</tr>
</form>
</table>
</body>
</html>
<script type="text/javascript">

	function returnSelection(){
		var selectedValue = "";
		if(<%=tviTemp.MultiSelect%>){
			var nodes = getCheckedTVItems("root","Top");
			//if(nodes.length < 1) return;
			for(var i = 0; i < nodes.length; i++){
				selectedValue += nodes[i].value+"@"+nodes[i].name+"~";
			}
		}else{
			var node = getCurTVItem();
			if(!node) return;
			var sType = node.type;
			selectedValue = node.value+"@"+node.name;
		}
		
		if(selectedValue == ""){
			if(confirm("您尚未进行选择，确认要返回吗？")){
				selectedValue = "~";
			}else{
				return;
			}
		}
		selectedValue+="";
		top.returnValue = selectedValue;
		top.close();
	}

	function doCancel(){
		top.returnValue='_CANCEL_';
		top.close();
	}

	//新增树图双击事件响应函数 add by hwang 20090601
	function TreeViewOnDBLClick(){
		returnSelection();
	}
	
	//新增树图双击事件响应函数 add by hwang 20090601
	function TreeViewOnClick(){
		
	}
	
	function startMenu(){
		selectedTreeNodeIDs="<%=selectedValues%>".split(",");
	<%
		out.println(tviTemp.generateHTMLTreeView());
	%>
		expandNode('root');
	}

	startMenu();	
</script>
<%@ include file="/IncludeEnd.jsp"%>