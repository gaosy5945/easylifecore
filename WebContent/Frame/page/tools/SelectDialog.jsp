<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf" %>
<%if(CurPage.getParameter("SelectDialogTitle")!=null){%>
<title><%=CurPage.getParameter("SelectDialogTitle")%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</title><%}

//���ֻѡ������ֵ�����ô˱��������Ƿ���ʾ��հ�ť
String setFlag = CurPage.getParameter("SetFlag");
%>
<body style="overflow-y:hidden;" onload="javascript:changeStyle();" onresize="javascript:changeStyle();">
<iframe id="SelectDialog" name="SelectDialog" style="height:100%;width:100%;" src="<%=sWebRootPath+CurPage.getParameter("SelectDialogUrl")%>?CompClientID=<%=sCompClientID%>" frameborder="0"></iframe>
<div id="ButtonsDiv" align="center"><table><tr>
	<td></td>
	<td align="center"><%=new Button("ȷ��","","javascript:doSure()","","","").getHtmlText() %></td>
	<%--
	<%if("true".equals(CurPage.getParameter("append"))){%><td align="center"><%=new Button("���","","javascript:window.frames['SelectDialog'].doAppend();","","","high2").getHtmlText() %></td><%}%>
	 --%>
	 <%if("Y".equalsIgnoreCase(setFlag)){ %>
	 	<td align="center"><%=new Button("���","","javascript:doClear();","","","").getHtmlText() %></td>
		<td align="center"><%=new Button("ȡ��","","javascript:doCancel();","","","").getHtmlText() %></td>
	 <%
	 }
	 else
	 {
	 %>
		<td align="center"></td>
	 	<td align="center"><%=new Button("ȡ��","","javascript:doCancel();","","","").getHtmlText() %></td>
	 <%} %>
</tr></table></div>
</body>
<script type="text/javascript">

	function doSure(){
		<%if("true".equals(CurPage.getParameter("append"))){%>
		//if(confirm("�˲����Ḳ��ԭ�������ݣ�ȷʵҪ������")==false)
		//	return;
		<%}%>
		window.frames['SelectDialog'].doSure();
	}
	function doAppend(){
		window.frames['SelectDialog'].doAppend();
	}

	function doClear(){
		if(typeof window.frames['SelectDialog'].doClear != "function"){
			closeDialog("_CLEAR_");
		}else{
			window.frames['SelectDialog'].doClear();
		}
	}
	
	function doCancel(){
		if(typeof window.frames['SelectDialog'].doCancel != "function"){
			closeDialog();
		}else{
			window.frames['SelectDialog'].doCancel();
		}
	}

	function closeDialog(sStr){
		top.returnValue = sStr;
		top.close();
	}
	
	document.onkeydown = function(e){
		var e = e || window.event;
		if(e.keyCode==27){
			doCancel();
		}
	}
	
	function changeStyle(){
		document.getElementById("SelectDialog").style.height = document.body.clientHeight - document.getElementById("ButtonsDiv").offsetHeight - 24;
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf" %>