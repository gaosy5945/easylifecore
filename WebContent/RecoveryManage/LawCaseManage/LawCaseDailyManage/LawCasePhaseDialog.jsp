<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head> 
<title>选择转入阶段</title>
<%
	//转入阶段
	String sLawCasePhase="";
	ASResultSet rs = null;
	SqlObject so = null;
	String [] sValues ;
	String [] sNames ;
	int count = 0;
	String sSql = "select count(1) as cnt from code_library cl where cl.codeno='CasePhase' and isinuse='1' and itemno  not in('010','020','110')  ";
	try{
	    rs = Sqlca.getASResultSet(new SqlObject(sSql)); 		
	   	if(rs.next()){
			count = rs.getInt("cnt");
		}

		rs.getStatement().close();
	}catch(Exception e){
		e.fillInStackTrace();
	}
	sValues = new String[count];
   	sNames = new String[count];
	try{
	   	sSql = "select itemno,itemname from code_library cl where cl.codeno='CasePhase' and isinuse='1' and itemno  not in('010','020','110')  ";
	   	rs = Sqlca.getASResultSet(new SqlObject(sSql)); 	
	   	int i = 0;
	   	while(rs.next()){
	   		sValues[i] = rs.getString("itemno");
		   	sNames[i] = rs.getString("itemname");
		   	i++;
		}
		rs.getStatement().close();
	}catch(Exception e){
		e.fillInStackTrace();
	}
%>
<script type="text/javascript">

	function newLawCasePhase()
	{
		var sLawCasePhase ;
		
		//转入阶段
		sLawCasePhase = document.all("LawCasePhase").value;
	
		if(sLawCasePhase=="")
		{
			alert(getBusinessMessage("778"));//请选择转入阶段！
			return;
		}
		
		self.returnValue=sLawCasePhase;	//返回所选的转入阶段
		self.close();
	
	}
	
</script>

<style TYPE="text/css">
.changeColor{ background-color: #F0F1DE  }
</style>
</head>

<body bgcolor="#DCDCDC">
<br>
<form name="buff">
<table align="center" width="250" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
	<tr id="ListTitle" class="ListTitle">
		<td>
		</td>
	</tr>
	<tr> 
		<td nowarp align="center" class="black9pt" bgcolor="#F0F1DE" >选择转入阶段：</td>
		<td nowarp bgcolor="#F0F1DE" > 
			<select name="LawCasePhase" >
			<!-- generateDropDownSelectWithABlankOption(String[] sValues, String[] sNames, String sDefault) --> 
				<%-- <%=HTMLControls.generateDropDownSelect(Sqlca,"CasePhase",sLawCasePhase)%>  --%>
				<%=HTMLControls.generateDropDownSelectWithABlankOption(sValues,sNames,sLawCasePhase)%> 
			</select>
		</td>
	</tr>
	
</table>
<table align="center" width="250" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
	<tr>
		<td nowrap align="right" class="black9pt" bgcolor="#F0F1DE" ><%=new Button("确认","","newLawCasePhase()","","").getHtmlText()%></td>
		<td nowrap bgcolor="#F0F1DE" ><%=new Button("取消","","self.returnValue='';self.close()","","").getHtmlText()%></td>
	</tr>
</table>    
 
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>