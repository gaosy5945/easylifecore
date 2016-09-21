<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String sDocNo = CurPage.getParameter("DocNo");
	boolean isReadOnly = "ReadOnly".equals(CurPage.getParameter("RightType"));
	if(sDocNo == null||sDocNo.length()==0) sDocNo="";
	
	String[][] sButtons = {
		{(isReadOnly)?"false":"true","All","Button","上传","","importRecord()","","","",""},
		{"false","","Button","查看内容","","viewFile()","","","",""},
		{"false","All","Button","删除","","delRecord()","","","",""},
	};
%>
<body style="overflow:hidden;" onresize="javascript:changeStyle();">
<div id="ButtonsDiv" style="margin-left:5px;">
<table><tr><%if(!isReadOnly){%>
	<td><form name="Attachment" style="margin-bottom:0px;" enctype="multipart/form-data" action="<%=sWebRootPath%>/ActiveCreditManage/CustomerBaseManage/CustomerBaseAttachmentUpload.jsp?CompClientID=<%=CurComp.getClientID()%>" method="post">
		<input type="file" name="File" />
		<input type="hidden" name="DocNo" value="<%=sDocNo%>" >
		<input type="hidden" name="FileName" />
	</form></td><%}%>
	<td><%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%></td>
</tr></table>
</div>
<iframe name="AttachmentList" id="AttachmentList" style="width: 100%;" frameborder="0"></iframe>
</body>
<script type="text/javascript">
	//setDialogTitle("附件管理");

	$(document).ready(function(){
		changeStyle();
		//以list形式展示时，“查看内容”、“删除”这两个按钮才有效
		AsControl.OpenView("/AppConfig/Document/AttachmentFiles.jsp", "DocNo=<%=sDocNo%>"+"&RightType=<%=CurPage.getParameter("RightType")%>", "AttachmentList");
	});
	
	function changeStyle(){
		document.getElementById("AttachmentList").style.height = document.body.clientHeight - document.getElementById("ButtonsDiv").offsetHeight;
	}
	
	function importRecord(){
		var DocNo = "<%=sDocNo%>";
		var flag = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.activeCredit.customerBase.SelectCustomerBase", "selectDocs", "DocNo="+DocNo);
		if(flag == "More"){
			alert("该客群授信模板已存在，请确认！");
			return;
		}
		
		var o = document.forms["Attachment"];
		var sFileName = o.File.value;
		o.FileName.value = sFileName;
		if (typeof(sFileName) == "undefined" || sFileName==""){
			alert("请选择一个文件名!");
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
			alert("文件大于2048k，不能上传！");
			return false;
		}
		return o.submit();
	}
	
	function delRecord(){
		window.frames["AttachmentList"].deleteRecord();
	}
	
	function viewFile(){
		window.frames["AttachmentList"].viewFile();
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>