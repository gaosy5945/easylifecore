<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%><%@ include file="uploadCommon.jsp"%>
<%
//文件上传
UploadManager manager = new UploadManager();
manager.setAllowdFiles("jpg,jpeg,png,gif,swf");
try{
	manager.setSmallWidth(150);
	manager.upload(pageContext);
	//返回处理
	String sFileName = manager.getSmallFilePath();
	String sFileLink = manager.getFilePath();
%>
	<script>
	if(parent.document.getElementById('cke_103_textInput')){//图片src
		parent.document.getElementById('cke_103_textInput').value = '<%=sFileName%>';
	}
	if(parent.document.getElementById('cke_142_textInput')){//图片链接
		parent.document.getElementById('cke_142_textInput').value = '<%=sFileLink%>';
		parent.document.getElementById('cke_147_select').value="_blank";
	}
	if(parent.document.getElementById('cke_99_previewImage')){//图片预览
		parent.document.getElementById('cke_99_previewImage').src = '<%=sFileName%>';
		parent.document.getElementById('cke_99_previewImage').style.display = '';
		
	}
	
	</script>
<%
}
catch(Exception e){
	out.println("<script>alert('上传文件出现错误："+e.getMessage()+"');</script>"); 
}
 %>