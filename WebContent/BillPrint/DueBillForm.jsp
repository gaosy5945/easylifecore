<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page import="java.util.*" %>
<%@ page import = "java.util.Enumeration"%>
<%@ page import = "java.util.HashMap"%>
<%@ page import = "java.text.DecimalFormat"%>

<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html>

<head>
<META HTTP-EQUIV="expires" CONTENT="-1">
<title>个人贷款借款凭证打印</title>
</head>
<style type="text/css">
<!--
td {font-size: 9pt}
.unnamed1 {padding-left: 10pt}
input {border: #666666; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px}
textarea {border: #666666; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px}
-->
</style>

<script language="JavaScript">
function CloseForm()
{
	window.self.close();
}
function showHint(tt)
{  	
	window.MessageHint.innerHTML=tt;
}
</script>


<body bgcolor="#FFFFFF" valign="top" topMargin="0" ><br><p align='center'>
<div align="center">
  <center>
  <form name="frm" method="post" target="main" action="/DispBill.jsp">
  <input type="hidden" name="BillText" value="">
  <input type="hidden" name="FormName" value="">
  
  <IFRAME FRAMEBORDER=0 ALIGN=CENTER width="100%" HEIGHT="0" SCROLLING=no SRC="<%=sWebRootPath%>/BillPrint/BillPrint.jsp?CompClientID=<%=CurComp.getClientID()%>&SerialNo=<%=CurPage.getParameter("SerialNo")%>" NAME="main"></IFRAME>
  <table border="0" width="100%" height="1000" cellspacing="0" cellpadding="0" style="font-size: 9pt">
 <!-- 
	  <tr>
	    <td colspan="3" class="location">&nbsp;&nbsp;主页 &gt; 查询打印及其它 &gt; 个人贷款借款凭证打印</td>
	  </tr>
	 
 -->
	   <tr>
	    <td colspan="1" valign="top"><hr></td>
	  </tr>

	  <tr>
	    <td colspan="1"><%=HTMLControls.generateButton("打印", "打印", "btnPrint_onClick()", "") %></td>
	  </tr>
	  
      <tr>
        <td height="100%" colspan="1" width="800">
        <IFRAME FRAMEBORDER=0 ALIGN=CENTER width="100%" HEIGHT="100%" SCROLLING=NO SRC="<%=sWebRootPath%>/BillPrint/DueBill.jsp?CompClientID=<%=CurComp.getClientID()%>&SerialNo=<%=CurPage.getParameter("SerialNo")%>" NAME="displayMain"></IFRAME>
        </td>
      </tr>
  </table>

  </form>
  </center>
</div>

</body>

<script language="JavaScript">
function btnPrintSetup_onClick(button){  
	window.main.focus();
	window.main.printsetup();
}	
function btnPrint_onClick(button){  
	window.main.focus();
	window.main.print();
}
function btnClose_onClick(button){  
    window.close();
}
function btnPrint2_onClick(button){  
	window.main2.focus();
	window.main2.print();
}
function btnClose2_onClick(button){  
    window.close();
}
</script>

</html>

<%@ include file="/Frame/resources/include/include_end.jspf"%>