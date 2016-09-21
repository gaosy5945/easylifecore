<%@page import="com.amarsoft.app.als.businesscomponent.config.BusinessComponentConfig"%>
<%@page import="com.amarsoft.app.base.businessobject.*"%>
<%@page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	String dono = CurPage.getParameter("DoNo");
	String colName = CurPage.getParameter("ColName");
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ѡ��","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
	
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(null);
	BusinessObject column = bom.loadBusinessObjects("jbo.ui.system.DATAOBJECT_LIBRARY", "DoNo=:DoNo and ColName=:ColName",
			"DoNo",dono,"ColName",colName).get(0);
	String codeType = column.getString("COLEDITSOURCETYPE");
	String codeNo = column.getString("COLEDITSOURCE");
	tviTemp.MultiSelect = true;//������ͼΪ��ѡ
	
	String idcol="ID";	
	String namecol="Name";	
	String sortNocol="SortNo";
	List<BusinessObject> list = null;
	if(!StringX.isEmpty(codeNo)){
		if(codeType.equals("JBO")){//JBO
			String[] s= codeNo.split(",");
			idcol=s[1];
			namecol=s[2];
			String whereString = codeNo.substring(codeNo.indexOf(namecol)+namecol.length());
			whereString=whereString.substring(whereString.indexOf(",")+1);
			list = bom.loadBusinessObjects(s[0],whereString);
		}
		else if(codeType.equals("Code")){//Code_Library
			list = bom.loadBusinessObjects_SQL("select ItemNo as ID,ItemName as Name,SortNo as SortNo from CODE_LIBRARY where CodeNo='"+codeNo+"' and IsInUse='1' ", BusinessObject.createBusinessObject());
		}
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
			<%=new Button("ȷ��", "", "returnSelection()").getHtmlText()%>
			<%=new Button("ȡ��", "", "doCancel()").getHtmlText()%>
		</td>
	</tr>
</form>
</table>
</body>
</html>
<script type="text/javascript">
	
	function returnSelection(){
		var selectedValue = {};
		selectedValue["ID"] = "";
		selectedValue["Name"] = "";
		if(<%=tviTemp.MultiSelect%>){
			var nodes = getCheckedTVItems();
			//if(nodes.length < 1) return;
			for(var i = 0; i < nodes.length; i++){
				if(selectedValue["ID"]=="") 	
					selectedValue["ID"] += nodes[i].value;
				else 
					selectedValue["ID"] += "|"+nodes[i].value;
				if(selectedValue["Name"]=="") 	
					selectedValue["Name"] += nodes[i].name;
				else
					selectedValue["Name"] += "|"+nodes[i].name;
			}
		}else{
			var node = getCurTVItem();
			if(node){
				selectedValue["ID"] = node.value;
				selectedValue["Name"] = node.name;
			}
		}
		
		if(selectedValue["ID"] == ""){
			if(!confirm("����δ����ѡ��ȷ��Ҫ������")){
				return;
			}
			else top.close();
		}
		top.returnValue = selectedValue;
		top.close();
	}

	function doCancel(){
		//top.returnValue='_CANCEL_';
		top.close();
	}

	//������ͼ˫���¼���Ӧ���� add by hwang 20090601
	function TreeViewOnDBLClick(){
		returnSelection();
	}
	
	//������ͼ˫���¼���Ӧ���� add by hwang 20090601
	function TreeViewOnClick(){
		
	}
	
	function startMenu(){
	<%
		out.println(tviTemp.generateHTMLTreeView());
	%>
		expandNode('root');
	}

	startMenu();	
</script>
<%@ include file="/IncludeEnd.jsp"%>