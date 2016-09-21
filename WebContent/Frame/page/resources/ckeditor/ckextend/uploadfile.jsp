<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<style>
	* {
		font-size: 12px;
	}
</style>
<%@ include file="uploadCommon.jsp"%>
<%
//文件上传
UploadManager manager = new UploadManager();
manager.setAllowdFiles(".jpg,.jpeg,.png,.gif,.bmp");
try{
	manager.upload(pageContext);
	//返回处理
	String callback = request.getParameter("CKEditorFuncNum");//获取回调JS的函数Num
	out.println("<script>parent.CKEDITOR.tools.callFunction("+callback+",'"+manager.getFilePath()+"');</script>"); 
}
catch(Exception e){
	out.print(e.getMessage()); 
}
%>