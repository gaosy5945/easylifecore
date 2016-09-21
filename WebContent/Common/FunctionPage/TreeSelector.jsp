<%@page import="com.amarsoft.app.als.ui.treeview.TreeGenerator"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
 	String selectorName = CurPage.getParameter("SelectClassName");
	//����Treeview
	TreeGenerator treeGenerator = TreeGenerator.createTreeGenerator(selectorName);
	HTMLTreeView tviTemp = treeGenerator.generateTree(CurPage, request);
	String extendItemID="";
	String folderSelectFlag  = CurPage.getParameter("FolderSelectFlag");
 	if(StringX.isEmpty(folderSelectFlag)) folderSelectFlag="N";
	String multipleFlag  = CurPage.getParameter("MultipleFlag");
	if(multipleFlag == null) multipleFlag="N";
	if("Y".equals(multipleFlag)) tviTemp.MultiSelect = true;
	String selectedValues = (String)treeGenerator.getInputParameter("SelectedValues");
 	if(selectedValues==null)selectedValues="";
 	
 	String rightType = (String)treeGenerator.getInputParameter("RightType");
 	if(StringX.isEmpty(rightType)){
 		rightType=CurPage.getParameter("RightType");
 	}
 	
 	String clearButtonFlag = (String)treeGenerator.getInputParameter("ClearButtonFlag");
 	
 	String selectLevel  = (String)treeGenerator.getInputParameter("SelectLevel");
 	if(selectLevel==null) selectLevel="Top";
 	
 	String splitChar  = (String)treeGenerator.getInputParameter("SplitChar");
 	if(splitChar==null) splitChar=",";
%>
<html>
<head> 
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
<!-- Ϊ��ҳ������,�벻Ҫɾ������ TITLE �еĿո� -->
<title>��ѡ��������Ϣ
 ���������������������������������� ���������������������������������� ����������������������������������
 ���������������������������������� ���������������������������������� ����������������������������������
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
			<%
			if(StringX.isEmpty(rightType)||!"ReadOnly".equals(rightType)){
				out.println(new Button("ȷ��", "", "returnSelection()").getHtmlText());
				if(!StringX.isEmpty(clearButtonFlag)&&"1".equals(clearButtonFlag)){
					out.println(new Button("���", "", "clearAll()").getHtmlText());
				}
			}
			%>
			
			<%=new Button("ȡ��", "", "doCancel()").getHtmlText()%>
		</td>
	</tr>
</form>
</table>
</body>
</html>
<script type="text/javascript">
	function returnSelection(){
		var sType = getCurTVItem().type;
		if(sType != "page" && "<%=folderSelectFlag%>"=="N" && "<%=multipleFlag%>" == "N"){
			alert("Ŀ¼�ڵ���Ϣ����ѡ��������ѡ��");
			return;
		}
		var selectedValueID = "";
		var selectedValueName = "";
		var selectedValue="";
		if(<%=tviTemp.MultiSelect%>){
			var nodes = getCheckedTVItems("root","<%=selectLevel%>");
			for(var i = 0; i < nodes.length; i++){
				selectedValueID += nodes[i].value+"<%=splitChar%>";
				selectedValueName += nodes[i].name +"<%=splitChar%>";
			}
			selectedValue=selectedValueID+"@"+selectedValueName;
		}else{
			var node = getCurTVItem();
			if(!node) return;
			var sType = node.type;
			selectedValue = node.value+"@"+node.name;
		}
		
		if(selectedValue == ""){
			if(confirm("����δ����ѡ��ȷ��Ҫ������")){
				selectedValue = "~";
			}else{
				return;
			}
		}
		selectedValue+="";
		top.returnValue = selectedValue;
		top.close();
	}
	
	function clearAll(){
		top.returnValue="_NONE_";
		top.close();
	}

	function doCancel(){
		top.returnValue='_CANCEL_';
		top.close();
	}

	//������ͼ˫���¼���Ӧ���� add by hwang 20090601
	function TreeViewOnDBLClick(){
		returnSelection();
	}
	
	//������ͼ˫���¼���Ӧ���� add by hwang 20090601
	function TreeViewOnClick(){
		var sType = getCurTVItem().type;
		if(sType != "page" && "<%=folderSelectFlag%>"=="N" && "<%=multipleFlag%>" == "N"){
			alert("Ŀ¼�ڵ���Ϣ����ѡ��������ѡ��");
		}
	}
	
	function startMenu(){
		selectedTreeNodeIDs="<%=selectedValues%>".split(",");
	<%
		out.println(tviTemp.generateHTMLTreeView());
	%>
		expandAll();
		if(<%=tviTemp.MultiSelect%> && typeof(selectedTreeNodeIDs) != "undefined" && selectedTreeNodeIDs !=""){
			for(var i = 0; i < selectedTreeNodeIDs.length;i++)
			{
				setCheckTVItem(selectedTreeNodeIDs[i],true);
			}
		}
	}

	startMenu();	
</script>
<%@ include file="/IncludeEnd.jsp"%>