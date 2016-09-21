<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf" %>

<%
	String objectType = CurPage.getParameter("ObjectType");
	String[][] sButtons = {
			{"true","All","Button","导入","导入","import()","","","",""},
	};
%>
<body>
	<div id="ButtonsDiv" style="margin-left:5px;">
		<table><tr>
			<td><form name="Attachment" style="margin-bottom:0px;" enctype="multipart/form-data" action="<%=sWebRootPath%>/Common/BusinessObject/ImportBusinessObjectFromFile.jsp?CompClientID=<%=CurComp.getClientID()%>" method="post">
				<input id="file" type="file" name="File"/>
				<input type=hidden name="DocNo" value="20000000000" >
				<input type=hidden name="DocType" value="20" >
				<input type="hidden" name="FileName" />
				<input type="hidden" name="ObjectType" value="<%=objectType%>"/>
			</form></td>
			<td><input type="button"/ value="导入" style="height:19px" onclick="importFile()"></td>
		</tr></table>
</div> 
</body>

<script type="text/javascript">
	function importFile(){
		var o = document.forms["Attachment"];
		var sFileName = o.File.value;
		o.FileName.value = encodeURI(sFileName);
		if (typeof(sFileName) == "undefined" || sFileName==""){
			alert("请选择文件!");//请选择一个文件名!
			return false;
		}
		var sPath = document.getElementById("file").value;
		if(sPath.substring(sPath.length,sPath.length-4)!= '.xml'){
			alert("文件类型只能是'xml'格式,请重新选择...");
			return;
		}
		return o.submit();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf" %>
