<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   lzq  2015/1/21
		Tester:
  	Content: ѡ�񸽼��� 
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
<title>��ѡ���ļ�</title>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>

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
			alert("��ѡ��һ��Excel.xls�ļ�!");
			return false;
		}else if("xls" ==vFileNameLast  || "xlsx" ==vFileNameLast  || "xlsm" ==vFileNameLast){
				//ֻ֧��  ���ļ�
				self.returnValue =sFileName1;
				return true;
		}else{
			alert("��ѡ��һ��Excel.xls�ļ�!");
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
		<td class="black9pt" align="left"><font size="2">��ѡ��һ��Excel�ļ�����:</font>
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
		<input type="button" style="width: 50px" name="ok" value="ȷ��"
			onclick="javascript:if(checkItems()) { self.SelectAttachment.submit();} ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" style="width: 50px" name="Cancel" value="ȡ��"
			onclick="javascript:self.returnValue='_none_';self.close()">
		</td>
	</tr>
</table>
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>