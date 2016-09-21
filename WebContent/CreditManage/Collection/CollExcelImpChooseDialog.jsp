<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   lzq  2015/1/21
		Tester:
  	Content: 选择附件框 
  	Input Param:
 			
  	Output param:
  	History Log:
			
	*/
	%>
<%/*~END~*/%>

<%
	String sPTISerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PTISerialNo"));
	if(sPTISerialNo==null) sPTISerialNo = "";
    String sCTSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CTSerialNo"));
    if(sCTSerialNo==null)sCTSerialNo="";
%>


<html>
<head>
<title>请选择文件</title>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>

<%/*~END~*/%>

<script language=javascript>
	function checkItems()
	{
		sFileName  = document.forms("SelectAttachment").AttachmentFileName.value;
		document.forms("SelectAttachment").FileName.value=sFileName;	
		var ss = sFileName.split("\\");				
		sFileName1 = ss[ss.length - 1];
		var ss2 = sFileName1.split(".");				
		var vFileNameLast = ss2[ss2.length - 1];
		if (sFileName=="") {
			alert("请选择一个Excel.xls文件!");
			return false;
		}else if("xls" ==vFileNameLast  || "xlsx" ==vFileNameLast  || "xlsm" ==vFileNameLast){
				//只支持  的文件
				self.returnValue =sFileName1;
				return true;
		}else{
			alert("请选择一个Excel.xls文件!");
			return false;
		}
	}	   
</script>
<style>
.black9pt {
	font-size: 9pt;
	color: #000000;
	text-decoration: none
}
</style>
</head>

<body bgcolor="#D3D3D3">
<form name="SelectAttachment" method="post"
	ENCTYPE="multipart/form-data"
	action="ExcelUpload.jsp?PTISerialNo=<%=sPTISerialNo%>&CTSerialNo=<%=sCTSerialNo%>&CompClientID=<%=CurComp.getClientID()%>"
	align="center">
<table align="center">
	<tr>
		<td class="black9pt" align="left"><font size="2">请选择一个Excel文件导入:</font>
		</td>
	</tr>
	<tr>
		<td><input type="file" size=60 name="AttachmentFileName">
		</td>
	</tr>
	<tr>
		<td>&nbsp;&nbsp; <input type=hidden name="FileName" value="">
		</td>
	</tr>
	<tr>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" style="width: 50px" name="ok" value="确认"
			onclick="javascript:if(checkItems()) { self.SelectAttachment.submit();} ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" style="width: 50px" name="Cancel" value="取消"
			onclick="javascript:self.returnValue='_none_';self.close()">
		</td>
	</tr>
</table>
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>