<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
	Author:   lzq  2015/1/21
	Tester:
  	Content: ѡ�񵼳�����
  	Input Param:
  	Output param:
  	History Log:
	*/
	%>
<%/*~END~*/%>
<html>
<head>
<title>��ѡ�񵼳�����</title>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>

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
			alert("��ѡ��һ��Excel.xls�ļ�!");
			return false;
		}else if("xls" ==vFileNameLast  || "xlsx" ==vFileNameLast  || "xlsm" ==vFileNameLast){
				//ֻ֧��  ���ļ�
				self.returnValue =sFileName1;
				return true;
		}else{
			alert("��ѡ��һ��Excel.xls�ļ�!");
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
		<td class="black9pt" align="left"><font size="2">��ѡ�񵼳��ļ�����:</font>
		</td>
	</tr>
	<tr>
		<td>
		<input type="button" style="width: 80px" name="txt" value="����txt"
			onclick="javascript:setChoose(1)">
		<input type="button" style="width: 80px" name="html" value="����html"
			onclick="javascript:setChoose(2)">
		<input type="button" style="width: 80px" name="excel" value="����excel"
			onclick="javascript:setChoose(3)">
		<input type="button" style="width: 80px" name="pdf" value="����pdf"
			onclick="javascript:setChoose(4)">
		<!-- <input type="button" style="width: 80px" name="word" value="����word" onclick="javascript:setChoose(5)"> -->
		</td>
	</tr>
</table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>