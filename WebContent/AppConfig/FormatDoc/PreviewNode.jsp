<%@page import="com.amarsoft.biz.formatdoc.model.*"%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String sSerialNo = CurPage.getParameter("DataSerialNo");
	String sMethod = CurPage.getParameter("Method");
	if(sMethod == null || sMethod.equals("")) sMethod = IFormatDocData.FDDATA_PREVIEW;
	FormatDocConfig fconfig = new FormatDocConfig(request);
	FormatDocData oData = (FormatDocData)FormatDocHelp.getFDDataObject(sSerialNo,"com.amarsoft.app",fconfig);
%>
<style>
	body {
		height: 100%;
		overflow: auto;
	}
	.textarea ol, .textarea ul {
		padding-left: 20px;
		_margin-left: auto;
		_padding-left: 0;
	}
	@media print { input[type='button'] {	display: none } }
</style>
<body style='word-break: break-all'>
<%
/*
<div id=div1 style="display: none">
	<object ID='WebBrowser1' WIDTH=0 HEIGHT=0 border=1 style="display: none" CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2'> </object> 
	<input type=button value='��ӡ����' onclick="WebBrowser1.ExecWB(8,1)"> 
	<input type=button value='��ӡԤ��' onclick="WebBrowser1.ExecWB(7,1)"> 
	<input type=button value='��ӡ' onclick="WebBrowser1.ExecWB(6,1)"> 
	<input type=button value='���Ϊ' onclick="WebBrowser1.ExecWB(4,1)"> 
	<input type=button style="display: none" value='������word' onclick="ExportToWord()">
	<input type=button value='�ر�' onclick="WebBrowser1.ExecWB(45, 1)">
</div>
*/
/*
<div id=div1 style="display:none" > 
	<object ID='WebBrowser1' WIDTH=0 HEIGHT=0 border=1  style="display:none" 
		codeBase="PrintControl/smsx.cab#Version=6,5,439,12" CLASSID='CLSID:1663ed61-23eb-11d2-b92f-008048fdd814' > </object> 
	<input type=button style="display: none" value='��ӡ����' onclick="WebBrowser1.printing.PageSetup()"> 
	<input type=button style="display: none" value='��ӡԤ��' onclick="WebBrowser1.printing.Preview()"> 
	<input type=button style="display: none" value='��ӡ' onclick="WebBrowser1.printing.Print()">
	<input type=button value='���Ƶ�ճ����' onclick="autocopy()">
	<input type=button style="display: none" value='�ر�' onclick="top.close()">
</div>
*/
 %>
 <div id=div1 style="display:none" > 
	<table border="0" cellspacing="0" cellpadding="0" >  
	<tr>
	  <td width="10px"></td> 	
	  <td width="90px"><%=new Button("���Ƶ�ճ����","AutoCopy","autoCopy()","","").getHtmlText()%></td>
	  <td width="78px"><%=new Button("������Word","ExportToWord","exportToWord()","","").getHtmlText()%></td>
	  <td width="65px"><%=new Button("�ر�","Close","top.close();","","").getHtmlText()%></td>
	</tr>
	</table>
</div>
<br/><br/>
<div id=reportContent>
<%
out.println("<table align=\"center\" style=\"width:660px;table-layout:fixed;background:url("+fconfig.getHttpRootPath() + oData.getWatermark() +")\"><tr><td style=\"white-space:nowrap;overflow:hidden;\">" + oData.getHtml(sMethod,"GBK") + "</td></tr></table>");//���HTML
%>
</div>
</body>
<script type="text/javascript">
	function amarCopy(){
		try {
			var sel = document.body.createTextRange(); 
			var oTblExport = document.getElementById('reportContent'); 
			if (oTblExport != null) {
				sel.moveToElementText(oTblExport); 
				sel.execCommand('Copy');//alert(sel.htmlText.replace(/<\s*[Ss][Cc][Rr][Ii][Pp][Tt][\w\W]+?<\s*\/\s*[Ss][Cc][Rr][Ii][Pp][Tt]\s*>/g,'')); 
			}
		} catch (e) {}
	}
	function mykd(){
		//F3:F5:F11:FullScreen
		if(event.keyCode==114 || event.keyCode==116 || event.keyCode==122 || (event.keyCode==78 && event.ctrlKey)){
			event.keyCode=0; 
			event.returnValue=false; 
			return false;
		} 
	} 

	try { document.body.onkeydown=mykd; } catch(e) {var a=1;}
	try { document.onkeydown=mykd; } catch(e) {var a=1;}
	try { document.oncontextmenu = Function("return false;");} catch (e) {	var a = 1; }

	if (window.dialogArguments == "not_show_toolbar")
		div1.style.cssText = "display:none";
	else
		div1.style.cssText = "display:block";
</script>
<%@ include file="/IncludeEnd.jsp"%>