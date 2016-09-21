<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String objectNo = CurPage.getParameter("ObjectNo");
%>
<title> 条形码 </title>
<div id="BarCodeNo" lang=3DEN-US style='font-size:22.0pt;font-family:C39HrP24DlTt' align = "center"><%=objectNo%></div>
<div id='PrintButton'> 
<table width=100%>
    <tr align="center">
        <td align="right" id="print">
            <%=HTMLControls.generateButton("打印","打印","javascript: my_Print()","")%>
        </td>
        <td align="left" id="back">
            <%=HTMLControls.generateButton("返回","返回","javascript: window.close();","")%>
        </td>
    </tr>
</table>
</div>
<script language=javascript>
		
		function my_Print()
		{
			var print=document.getElementById("PrintButton").innerHTML;
			document.getElementById("PrintButton").innerHTML="";
			window.print();
			document.getElementById("PrintButton").innerHTML=print;
		}
		
		function my_Cancle()
		{
			self.close();
		}		
		
		function beforePrint()
		{
			document.all('PrintButton').style.display='none';
		}
		
		function afterPrint()
		{
			document.all('PrintButton').style.display="";
		}
</script>
<%@	include file="/IncludeEnd.jsp"%>