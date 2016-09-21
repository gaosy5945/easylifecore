<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
	Author:   lzq  2015/1/21
	Tester:
  	Content: 选择导出类型
  	Input Param:
  	Output param:
  	History Log:
	*/
	%>
<%/*~END~*/%>
<html>
<head>
<title>请选择导出类型</title>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>

<%/*~END~*/%>

<script language=javascript>
	function setChoose(ChooseType)
	{
		self.returnValue = ChooseType;
		self.close();
		/* 
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
		} */
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
<table align="center">
	<tr>
		<td class="black9pt" align="left"><font size="2">请选择导出文件类型:</font>
		</td>
	</tr>
	<tr>
		<td>
		<input type="button" style="width: 80px" name="txt" value="导出txt"
			onclick="javascript:setChoose(1)">
		<input type="button" style="width: 80px" name="html" value="导出html"
			onclick="javascript:setChoose(2)">
		<input type="button" style="width: 80px" name="excel" value="导出excel"
			onclick="javascript:setChoose(3)">
		<input type="button" style="width: 80px" name="pdf" value="导出pdf"
			onclick="javascript:setChoose(4)">
		<!-- <input type="button" style="width: 80px" name="word" value="导出word" onclick="javascript:setChoose(5)"> -->
		</td>
	</tr>
</table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>