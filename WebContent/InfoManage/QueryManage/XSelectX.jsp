<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.xquery.*,org.w3c.dom.*"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: ѡ���ѯ�ֶ�Ҫ��ʾ��������
		Input Param:
			--sSelectCol  :�ֶ���
			--sSelectedCol������
		Output Param:
			

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ѡ���ѯ�ֶ�Ҫ��ʾ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//���ҳ��������ֶ��С�����
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
<title>�ֶ�ѡ����</title>
</head>
<body leftmargin="0" topmargin="0" bgcolor='#DDDDDD'>
<form method='POST' align='center' name='customize'>
<table width='100%' border='1' align='center' cellpadding='0' cellspacing='8' bgcolor='#DDDDDD'>
<tr>
	<td bgcolor='#DDDDDD'>
		<span class='dialog-label'>&nbsp;��ѡȡ�ֶ��б�</span>
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
      		<input type="button" style="width:70px"  value="ȷ ��" onclick="javascript:doQuery();">
      		<input type="button" style="width:70px"  value="�� ��" onclick="javascript:doBack();">
      		<input type="button" style="width:70px"  value="ȡ ��" onclick="javascript:doCancel();">
    	</td>
</tr>
</table>
</form>
</body>
</html>
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>

<script language=javascript>

       //---------------------���尴ť�¼�--------------------------//
	/*~[Describe=ȡ��;InputParam=��;OutPutParam=��;]~*/
	function doCancel(){
		self.returnValue="XXXXXXXXXXXXXXX";
		self.close();
	}
	/*~[Describe=ȷ��;InputParam=��;OutPutParam=��;]~*/
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
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function doBack(){
		for (i=0; i < customize.select1.length; i++){
			if(customize.select1.item(i).selected){
				customize.select1.item(i).selected=false;
			}
		}
	}
	/*~[Describe=ȱʡ;InputParam=��;OutPutParam=��;]~*/
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