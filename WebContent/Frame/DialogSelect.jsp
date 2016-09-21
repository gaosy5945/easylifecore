<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	String sSelName  = CurPage.getParameter("SelName");
 	String multipleFlag  = CurPage.getParameter("MultipleFlag");
 	if(multipleFlag == null) multipleFlag="N";
 	String folderSelectFlag  = CurPage.getParameter("FolderSelectFlag");
 	if(StringX.isEmpty(folderSelectFlag)) folderSelectFlag="N";
 	String selectLevel  = CurPage.getParameter("SelectLevel");
 	if(StringX.isEmpty(selectLevel)) selectLevel="";
	String sParaString = CurPage.getParameter("ParaString");
	if(sParaString == null) sParaString = "";
	String selectedValues = CurPage.getParameter("SelectedValues");
	if(selectedValues == null) selectedValues = "";
	
	String sSelBrowseMode = "";
	String sAttribute4 = "";
	String sSql = " select SelBrowseMode,Attribute4 from SELECT_CATALOG where SelName = '"+sSelName+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sSelBrowseMode = rs.getString("SelBrowseMode");	
		sAttribute4 = rs.getString("Attribute4");
		if(sSelBrowseMode == null) sSelBrowseMode = "";
		if(sAttribute4 == null) sAttribute4 = "";
	}
	rs.getStatement().close();
%>
<html>
<head> 
<!-- 为了页面美观,请不要删除下面 TITLE 中的空格 -->
<title>请选择所需信息
 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　
 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　
</title>
</head>
<body class="pagebackground" style="overflow: auto;overflow-x:visible;overflow-y:visible">
<table width="100%" border='0' height="100%" cellspacing='0' align=center bordercolor='#999999' bordercolordark='#FFFFFF'>
<form  name="buff" align=center>
<%if(sSelBrowseMode.equals("")){%>
	<tr> 
		<td id="selectPage" valign=top>
			<p>没有定义对象选择窗口。请在"对象类型选择设置"模块定义 SelBrowseMode 属性。</p>
		</td>
	</tr>
<%}else{
	if(sAttribute4.equals("1")){ //需要根据检索条件进行查询，则进行提示。
%>
	<tr style='width:100%; height:1px'>
	<td><font style=' font-size: 9pt;FONT-FAMILY:宋体;color:red;'>请输入相应的查询条件，点击“查询”按钮获得查询结果！</font></td>
	</tr>
<%}%>
	<tr> 
			<td id="selectPage">
				<iframe name="ObjectList" width=100% height=100% frameborder=0 scrolling=no src="<%=sWebRootPath%>/Blank.jsp"></iframe>
			</td>
	</tr>
<%}%>
	<tr style="height:40px;">
		<td nowarp bgcolor="#e8e8e8" height="35" align=center valign="middle" colspan="2" style="border-top:1px solid #d8d8d8"> 
			<%=new Button("确认", "", "returnSelection()").getHtmlText()%>
			<%=new Button("清空", "", "clearAll()").getHtmlText()%>
			<%=new Button("取消", "", "doCancel()").getHtmlText()%>
		</td>
	</tr>
</form>
</table>
</body>
</html>
<script type="text/javascript">
	var sObjectInfo = "";
	function returnSelection(){
		frames["ObjectList"].returnValue();
		if(sObjectInfo == ""){
			if(confirm("您尚未进行选择，确认要返回吗？")){
				sObjectInfo = "_NONE_";
			}else{
				return;
			}
		}
		top.returnValue = sObjectInfo;
		top.close();
	}

	function clearAll(){
		top.returnValue='_CLEAR_';
		top.close();
	}

	function doCancel(){
		top.returnValue='_CANCEL_';
		top.close();
	}

	/*~[Describe=支持ESC关闭页面;InputParam=无;OutPutParam=无;]~*/
	document.onkeydown = function(){
		if(event.keyCode==27){
			top.returnValue = "_CANCEL_"; 
			top.close();
		}
	};
	
	<%
	if(sSelBrowseMode!=null && !sSelBrowseMode.equals("")){
		if(sSelBrowseMode.equals("Grid")){
		%>		
		OpenComp("SelectGridDialog","/Frame/SelectGridDialog.jsp","SelName=<%=sSelName%>&ParaString=<%=sParaString%>","ObjectList","");
		<%
		}else if(sSelBrowseMode.equals("TreeView")){
		%>
		OpenComp("SelectTreeViewDialog","/Frame/SelectTreeViewDialog.jsp","SelectedValues=<%=selectedValues%>&SelectLevel=<%=selectLevel%>&FolderSelectFlag=<%=folderSelectFlag%>&MultipleFlag=<%=multipleFlag%>&SelName=<%=sSelName%>&ParaString=<%=sParaString%>","ObjectList","");
		<%
		}
	}
	%>
</script>
<%@ include file="/IncludeEnd.jsp"%>