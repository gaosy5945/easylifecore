<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.XMLHelper,com.amarsoft.app.base.util.StringHelper,com.amarsoft.app.base.businessobject.BusinessObjectHelper,com.amarsoft.app.base.businessobject.BusinessObject"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String specificSerialNo = CurPage.getParameter("SpecificSerialNo");
	//产品组件类型文件
	String xmlFile = CurPage.getParameter("XMLFile");
	xmlFile = ARE.replaceARETags(xmlFile);
	//产品组件类型筛选条件
	String xmlTags = CurPage.getParameter("XMLTags");
	//产品组件类型关键字
	String keys = CurPage.getParameter("Keys");
	
	//产品组件文件
	String xmlComponentFile = CurPage.getParameter("XMLComponentFile");
	xmlComponentFile = ARE.replaceARETags(xmlComponentFile);
	//产品组件筛选条件
	String xmlComponentTags = CurPage.getParameter("XMLComponentTags");
	xmlComponentTags = StringHelper.replaceAllIgnoreCase(xmlComponentTags,"{$", "{#");
	//产品组件关键字
	String componentKeys = CurPage.getParameter("ComponentKeys");
	
	
	//产品组件规格文件
	String xmlSpecificFile = CurPage.getParameter("XMLSpecificFile");
	xmlSpecificFile = ARE.replaceARETags(xmlSpecificFile);
	//产品组件规格筛选条件
	String xmlSpecificTags = CurPage.getParameter("XMLSpecificTags");
	xmlSpecificTags = StringHelper.replaceAllIgnoreCase(xmlSpecificTags, "{$", "{#");
	//产品组件规格关键字
	String specificKeys = CurPage.getParameter("SpecificKeys");
	
	
%>
<html> 
<head>
<title></title>
</head>
<body class=pagebackground leftmargin="0" topmargin="0" >
<table align='center' width='100%'  cellspacing="4" cellpadding="0">

<%

	
	List<BusinessObject> boList = XMLHelper.getBusinessObjectList(xmlFile, xmlTags, keys);

	for(int i = 0; i < boList.size(); i ++){
		BusinessObject bo = boList.get(i);
		
		List<BusinessObject> boComponentList = XMLHelper.getBusinessObjectList(xmlComponentFile, StringHelper.replaceString(xmlComponentTags,bo), componentKeys);
		if(boComponentList == null || boComponentList.isEmpty()) continue;
%>

	<DIV id=A_Group_<%=i %>>
		<TABLE class="info_data_tablecommon info_group_table" width="100%">
			<TBODY>
				<TR>
				<TD class=info_group_backgourd_l width=10>&nbsp;</TD>
				<TD class="info_group_backgourd_2 info_group_backgourd_3" width=10><SPAN onclick=try{changeExpand(this)}catch(e){}; id=EXP_<%=i%> groupid="<%=i%>" type="EXPAND"></SPAN><SPAN onclick="showHideContent('<%=i%>')" id=imgexpand<%=i%> class=info_group_expand expand="1">&nbsp;</SPAN></TD>
				<TD onclick="showHideContent('<%=i%>')" class=info_group_backgourd_2 width="100%"><SPAN id=Group_<%=i%> class=info_group_title style="WIDTH: 100%"><SPAN id=Group_Title_<%=i%>><%=bo.getString("NAME")%></SPAN></SPAN></TD>
				<TD class=info_group_backgourd_r></TD></TR></TBODY></TABLE>
				<TABLE id=@SysSub<%=i%> cellSpacing=0 cellPadding=0 width="100%" border=0>
				<TBODY>
				<TR>
				<TD class=info_2side_border>
				<TABLE class=table_line cellSpacing=0 cellPadding=0 width="100%" bgColor=#ffffff border=0>
				<TBODY>
				
				
				<TR>
				
					
					<%
					
					xmlSpecificFile = StringHelper.replaceString(xmlSpecificFile,bo);
					specificKeys = StringHelper.replaceString(specificKeys,bo);
					List<BusinessObject> exists = XMLHelper.getBusinessObjectList(xmlSpecificFile, StringHelper.replaceString(xmlSpecificTags,bo), specificKeys);
					
					int cnt = 0;
					for(int j=0;j<boComponentList.size();j++){
						BusinessObject term = boComponentList.get(j);
						String termID = term.getString("ID");
						String termName = term.getString("Name");
						
						//修改，避免新增产品时无法取到
						List<BusinessObject> ls = BusinessObjectHelper.getBusinessObjectsBySql(exists, "ID=:ID", "ID",term.getString("ID"));
						boolean selected = (ls != null && !ls.isEmpty());
						cnt++;
					%>
					<TD width="20%">
						<DIV id=A_div_<%=i %>_<%=j %>>
							<input type="checkbox" name="<%=termID%>_CheckBox" value="<%=termID%>" <%= !selected ?"":"checked"%> onclick=doSelect("<%=termID%>")>
							<%=termName%>
							<a name="<%=termID%>_Link" onclick=editProductTermPara("<%=termID%>") style={display:<%= !selected ?"none":""%>}>
							<font color=blue><b>编辑参数</b></font></a>
							<td>
							<%
								if((cnt)%5==0 )
								{
									%>
										</tr>
										<tr> 
									<%
								}
							}
							%>
						</DIV>
					</TD></TR>
				
				</TBODY></TABLE></TD></TR>
				<TR>
				<TD height=13 vAlign=top>
				<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
				<TBODY>
				<TR>
				<TD class=info_bottom_line_left vAlign=top width="50%" align=left></TD>
				<TD class=info_bottom_line_right vAlign=top width="50%" align=right></TD></TR></TBODY></TABLE></TD></TR>
			</TBODY>
		</TABLE>
	</DIV>

<%
	}
%>

</table>
</body>
</html>
<script type="text/javascript" src="<%=sWebRootPath%>/ProductManage/ComponentConfig/js/BusinessComponent.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/ProductManage/ProductConfig/js/Product.js"></script>
<script language="javascript">
//用以控制几个条件区的显示或隐藏
	function showHideContent(id)
	{
		
		var obj = document.all("imgexpand"+id);
		var tableid = "@SysSub"+id;
		if(obj.expand=="1"){
			obj.expand = "0";
			obj.className = "info_group_collapse";
			if(document.getElementById(tableid))
				document.getElementById(tableid).style.display = "none";
		}
		else{
			obj.expand = "1";
			obj.className = "info_group_expand";
			if(document.getElementById(tableid))
				document.getElementById(tableid).style.display = "block";
		}
	
	}

	function doSelect(id){
		var isCheck = document.all(id+"_CheckBox").checked;
		if(isCheck){
			document.all(id+"_Link").style.display='';
			var result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.ProductSpecificManager", "importComponents",
					"SpecificSerialNo=<%=specificSerialNo %>,ComponentID="+id +",FromXMLFile=<%=xmlComponentFile%>,FromXMLTags=Component,Keys=ID");
		}else{
			document.all(id+"_Link").style.display='none';
			AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.ProductSpecificManager", "deleteComponents","SpecificSerialNo=<%=specificSerialNo%>,XMLTags=Component,Keys=ID,ComponentID="+id );
		}
	}
	
	
	function editProductTermPara(id){
		AsCredit.openFunction("PRD_ProductComponentInfo","ID="+id+"&SpecificSerialNo=<%=specificSerialNo%>","dialogWidth:900px;dialogHeight:400px;resizable=no;scrollbars=yes;status:yes;maximize:no;help:no;");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>