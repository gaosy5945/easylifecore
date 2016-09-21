<%@ page contentType="text/html; charset=GBK"%><%@ include file="/Frame/resources/include/include_begin.jspf"%>
<html>
<head>
<META HTTP-EQUIV="expires" CONTENT="-1">
<title>公积金资金划拨凭证</title></head><style type="text/css"><!--
td {font-size: 9pt}
.unnamed1 {padding-left: 10pt}
input {border: #666666; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px}
textarea {border: #666666; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px}--></style>

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

  <IFRAME FRAMEBORDER=0 ALIGN=CENTER width="100%" HEIGHT="0" SCROLLING=no SRC="<%=sWebRootPath%>/BillPrint/SpecialTransferPrint.jsp?CompClientID=<%=CurComp.getClientID()%>&SerialNo=<%=CurPage.getParameter("SerialNo")%>" NAME="main"></IFRAME>
  <table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" style="font-size: 9pt">
	  <tr>
	    <td colspan="1" valign="top"><hr></td>
	  </tr>
	  <tr>	    <td colspan="1"><%=HTMLControls.generateButton("打印", "打印", "btnPrint_onClick()", "") %></td>	  </tr>
      <tr>
        <td height="100%" colspan="1" width="100%">        <IFRAME FRAMEBORDER=0 ALIGN=CENTER width="100%" HEIGHT="95%" SCROLLING=YES SRC="<%=sWebRootPath%>/BillPrint/SpecialTransfer.jsp?CompClientID=<%=CurComp.getClientID()%>&SerialNo=<%=CurPage.getParameter("SerialNo")%>" NAME="displayMain"></IFRAME>        </td>
      </tr>  </table>

  </form>
  </center>
</div>
</body>

<script language="JavaScript">	
function btnPrint_onClick(button){  
	window.main.focus();
	window.main.print();
}
function btnClose_onClick(button){  
    window.close();
}
</script>

</html>
<%@ include file="/Frame/resources/include/include_end.jspf"%>