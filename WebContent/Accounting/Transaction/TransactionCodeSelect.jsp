<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sParaString = CurPage.getParameter("ParaString");
	if(sParaString == null) sParaString = "";
%>
<html>
<head> 
<!-- 为了页面美观,请不要删除下面 TITLE 中的空格 -->
<title>请选择所需信息
 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　
 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　
</title>
</head>
<body class="pagebackground" style="overflow: auto;overflow-x:visible;overflow-y:visible">
<table width="100%" border='0' height="100%" cellspacing='0' align=center bordercolor='#999999' bordercolordark='#FFFFFF'>
<form  name="buff" align=center>
	<tr> 
			<td id="selectPage">
				<iframe name="ObjectList" width=100% height=100% frameborder=0 scrolling=no src="<%=sWebRootPath%>/Blank.jsp"></iframe>
			</td>
	</tr>
	<tr style="height:40px;">
		<td nowarp bgcolor="#e8e8e8" height="35" align=center valign="middle" colspan="2" style="border-top:1px solid #d8d8d8"> 
			<%=new Button("确认", "", "returnSelection()").getHtmlText()%>
			<%=new Button("清空", "", "clearAll()").getHtmlText()%>
			<%=new Button("取消", "", "doCancel()").getHtmlText()%>
		</td>
	</tr>
</form>
</table>
</body>
</html>
<script type="text/javascript">
	var sObjectInfo = "";
	function returnSelection(){
		frames["ObjectList"].returnValue();
		if(sObjectInfo == ""){
			if(confirm("您尚未进行选择，确认要返回吗？")){
				sObjectInfo = "_NONE_";
			}else{
				return;
			}
		}
		top.returnValue = sObjectInfo;
		top.close();
	}

	function clearAll(){
		top.returnValue='_CLEAR_';
		top.close();
	}

	function doCancel(){
		top.returnValue = {}.UDF;
		top.close();
	}

	/*~[Describe=支持ESC关闭页面;InputParam=无;OutPutParam=无;]~*/
	document.onkeydown = function(e){
		e = e || window.event;
		if(e.keyCode==27){
			doCancel();
		}
	};
		OpenComp("SelectTreeViewDialog","/Accounting/Transaction/SelectTransactionCodeDialog.jsp","ParaString=<%=sParaString%>","ObjectList","");
</script>
<%@ include file="/IncludeEnd.jsp"%>