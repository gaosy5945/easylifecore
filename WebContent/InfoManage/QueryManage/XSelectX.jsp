<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.xquery.*,org.w3c.dom.*"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 选择查询字段要显示的数据项
		Input Param:
			--sSelectCol  :字段列
			--sSelectedCol：条件
		Output Param:
			

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "选择查询字段要显示的数据项"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//获得页面参数，字段列、条件
	String sSelectedCol   = DataConvert.toRealString(iPostChange,CurPage.getParameter("SelectedCol"));
	String colAlias = DataConvert.toRealString(iPostChange,CurPage.getParameter("ColName"));
	String sSelectCol="";
	
	XQuery xquery = new XQuery(request.getRealPath("")+"/InfoManage/QueryManage/",(String)session.getValue("queryType"));
	String colName=xquery.getColumnDefinition(colAlias)[3];
	String as1[] = xquery.getCodeItemDefinition(colAlias);
	String as2[][] = {
						{ "CodeItemName", as1[0].trim(), "" },
						{ "ColumnName", colName, "" },
						{ "ColumnNameWithoutID",
								StringFunction.replace(colName, "ID", "Name"), "" },
						{ "RelatedDataObjectName", "", "" },
						{ "LeftEmbrace", "<", "" },
						{ "RightEmbrace", ">", "" },
						{ "EnvironmentOrgID", CurUser.getOrgID(), "" } ,
						{ "QueryType", xquery.querytype, "" } 
	};
	
	Vector vector = xquery.convertStringArrayToParameterVector(as2);
	String sSql = xquery.getStringWithParameterReplaced(as1[1], vector);
	
	String options=""; 
	ASResultSet rs1=Sqlca.getASResultSet(sSql);
	while(rs1.next()){
		options+="<option value='"+rs1.getString(1)+"'>"+rs1.getString(2)+"</option>";
	}
	rs1.getStatement().close();
%>
<%/*~END~*/%>


<html>
<head>
<title>字段选择器</title>
</head>
<body leftmargin="0" topmargin="0" bgcolor='#DDDDDD'>
<form method='POST' align='center' name='customize'>
<table width='100%' border='1' align='center' cellpadding='0' cellspacing='8' bgcolor='#DDDDDD'>
<tr>
	<td bgcolor='#DDDDDD'>
		<span class='dialog-label'>&nbsp;可选取字段列表</span>
	</td>
</tr>
<tr>
	<td align='center'>
		<select name='select1'  size='17'  style='width:100%;' width='100%' multiple='true'>
		<%=options%>
		</select>
	</td>
</tr>
<tr>
    	<td align='center'>
      		<input type="button" style="width:70px"  value="确 定" onclick="javascript:doQuery();">
      		<input type="button" style="width:70px"  value="清 空" onclick="javascript:doBack();">
      		<input type="button" style="width:70px"  value="取 消" onclick="javascript:doCancel();">
    	</td>
</tr>
</table>
</form>
</body>
</html>
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>

<script language=javascript>

       //---------------------定义按钮事件--------------------------//
	/*~[Describe=取消;InputParam=无;OutPutParam=无;]~*/
	function doCancel(){
		self.returnValue="XXXXXXXXXXXXXXX";
		self.close();
	}
	/*~[Describe=确定;InputParam=无;OutPutParam=无;]~*/
	function doQuery(){
		var selText="";
		var selValue="";
		for (i=0; i < customize.select1.length; i++){
			if(customize.select1.item(i).selected){
				if(selText.length==0){
					selText=customize.select1.options[i].text;
					selValue=customize.select1.options[i].value;
				}
				else{
					selText+="@"+customize.select1.options[i].text;
					selValue+="@"+customize.select1.options[i].value;
				}
			}
		}
		self.returnValue=selValue+"@@"+selText;
		self.close();
	}
	/*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function doBack(){
		for (i=0; i < customize.select1.length; i++){
			if(customize.select1.item(i).selected){
				customize.select1.item(i).selected=false;
			}
		}
	}
	/*~[Describe=缺省;InputParam=无;OutPutParam=无;]~*/
	function doDefault(selectedCol){
		var sTemp=selectedCol.split("@");
		for(f=0;f<customize.select1.options.length;f++){
			for(d=0;d<sTemp.length;d++){
				if(sTemp[d]==customize.select1.item(f).value){
					customize.select1.options[f].selected=true;
				}
			}
		}
	}
	doDefault("<%=sSelectedCol%>");
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>