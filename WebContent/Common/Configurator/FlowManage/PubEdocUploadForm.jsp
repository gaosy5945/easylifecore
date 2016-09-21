<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	boolean isReadOnly = "ReadOnly".equals(CurPage.getParameter("RightType"));
	
	String edocNo = CurPage.getParameter("EdocNo");
	if(edocNo == null || edocNo == "undefined") edocNo = "";

	String[][] sButtons = {
			{"true","All","Button","�ϴ�","","importRecord()","","","",""},
	};
%>
<body style="overflow:hidden;">
<div id="ButtonsDiv" style="margin-left:5px;">
<table><tr><%if(!isReadOnly){%>
	<td><form name="Attachment" style="margin-bottom:0px;" enctype="multipart/form-data" action="<%=sWebRootPath%>/Common/Configurator/FlowManage/UploadForm.jsp?CompClientID=<%=CurComp.getClientID()%>&EdocNo=<%=edocNo%>" method="post">
		<input type="file" name="File" />
		<input type=hidden name="EdocNo" value="" >
		<input type="hidden" name="FileName" />
	</form></td><%}%>
	<td><%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%></td>
</tr></table>
</div>
</body>
<script type="text/javascript">
	function importRecord(){
		var o = document.forms["Attachment"];
		var sFileName = o.File.value;
		o.FileName.value = encodeURI(sFileName);
		if (typeof(sFileName) == "undefined" || sFileName==""){
			alert("��ѡ��һ���ļ���!");
			return false;
		}
		var fileSize;
		if(typeof(ActiveXObject) == "function"){ // IE
			var fso = new ActiveXObject("Scripting.FileSystemObject");
			var f1 = fso.GetFile(sFileName);
			fileSize = f1.size;
		}else{
			fileSize = o.File.files[0].size;
		}
		if(fileSize > 2*1024*1024){
			alert("�ļ�����2048k�������ϴ���");
			return false;
		}
		return o.submit();
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>