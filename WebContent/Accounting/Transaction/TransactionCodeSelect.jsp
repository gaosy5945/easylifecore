<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sParaString = CurPage.getParameter("ParaString");
	if(sParaString == null) sParaString = "";
%>
<html>
<head> 
<!-- Ϊ��ҳ������,�벻Ҫɾ������ TITLE �еĿո� -->
<title>��ѡ��������Ϣ
 ���������������������������������� ���������������������������������� ����������������������������������
 ���������������������������������� ���������������������������������� ����������������������������������
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
			<%=new Button("ȷ��", "", "returnSelection()").getHtmlText()%>
			<%=new Button("���", "", "clearAll()").getHtmlText()%>
			<%=new Button("ȡ��", "", "doCancel()").getHtmlText()%>
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
			if(confirm("����δ����ѡ��ȷ��Ҫ������")){
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

	/*~[Describe=֧��ESC�ر�ҳ��;InputParam=��;OutPutParam=��;]~*/
	document.onkeydown = function(e){
		e = e || window.event;
		if(e.keyCode==27){
			doCancel();
		}
	};
		OpenComp("SelectTreeViewDialog","/Accounting/Transaction/SelectTransactionCodeDialog.jsp","ParaString=<%=sParaString%>","ObjectList","");
</script>
<%@ include file="/IncludeEnd.jsp"%>